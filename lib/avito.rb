require 'rubygems'
require 'active_record'
require 'yaml'
require 'mechanize'

class Avito < ActiveRecord::Base
  def self.advert_links(page)
    # Находим ссылки на конкретные объявления
    links = page.links_with(href: /gotoviy_biznes/)
    # Удаляем первые 14 ссылок,
    # поскольку это ссылки на группы объявлений, сортировку и галерею
    links.slice!(0..13)

    links = links.reject do |link|
      link.node.attr('href').include?('?p=')
    end

    links
  end

  def self.get_info(adverts)
    agent = Mechanize.new do |agent|
      agent.user_agent = USER_AGENTS[:ff_android]
    end

    adverts.each_with_index do |link, _index|
      # Убираем повторные ссылки с изображений к объявлениям
      next if _index.odd?

      # Переходим на страницу конкретного объявления
      advert_page = link.click

      # Кликаем по "Показать номер"
      click_to_phone = agent.click advert_page.link_with text: /Показать номер/

      # Собираем данные со страницы
      # Изобаржение
      image      = advert_page.search('.photo-self').attr('src')
      image_name = advert_page.search('.photo-self').attr('src').value.split('/').last

      title         = advert_page.search('header').text
      ad_id         = advert_page.uri.to_s.split('_').last
      item_category = advert_page.search('.item-params').text.split(': ').last
      price         = advert_page.search('.price-value').text.scan(/\d/).join
      phone         = click_to_phone.link_with(href: /tel:/).href.sub('tel:', '').sub(/^8/, '+7')
      owner_name    = advert_page.search('.person-name').text
      desc          = advert_page.search('.description-preview-wrapper').text
      posted_ad     = advert_page.search('.item-add-date').text



      agent.get(image.attributes["src"]).save "public/images/" + image_name.to_s

      # Сохраняем данные в базу
      Advert.create do |advert|
        # Сравниваем категорию объявления. Если в базе нет, то создаём
        category = Category.find_or_create_by(title: item_category)

        advert.title       = title
        advert.ad_id       = ad_id
        advert.category_id = category.id
        advert.price      = price
        advert.phone      = phone
        advert.owner_name = owner_name
        advert.desc       = desc
        advert.posted_ad  = posted_ad
        advert.image_name = image_name

      end
      # sleep 1
    end
  end
end
