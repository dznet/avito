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
    adverts.each_with_index do |link, index|
      # Todo: Убрать ссылки с картинок

      # Переходим на страницу конкретного объявления
      advert_page = link.click

      # Собираем данные со страницы
      title         = advert_page.search('h1').text
      ad_id         = advert_page.uri.to_s.split('_').last
      item_category = advert_page.search('.item-params').text.split(': ').last
      price         = advert_page.search('.p_i_price').text.scan(/\d/).join

      # Сохраняем данные в базу
      Advert.create do |advert|
        # Сравниваем категорию объявления. Если в базе нет, то создаём
        category = Category.find_or_create_by(title: item_category)

        advert.title       = title
        advert.ad_id       = ad_id
        advert.category_id = category.id
        advert.price       = price
      end
      # sleep 1
    end
  end
end
