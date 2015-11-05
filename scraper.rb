require 'rubygems'
require 'active_record'
require 'yaml'
require 'mechanize'

# Классы для работы с объектами базы данных
Advert = Class.new(ActiveRecord::Base)
User   = Class.new(ActiveRecord::Base)

# Загружаем файл настройки соединения с базой данных
dbconfig = YAML.load_file(File.join(__dir__, 'database.yml'))

# Ошибки работы с БД направим в стандартный поток (консоль)
ActiveRecord::Base.logger = Logger.new(STDERR)

# Соединяемся с БД
ActiveRecord::Base.establish_connection(dbconfig['development'])

# Получаем страницу с объявлениями (и пагинацией)
agent = Mechanize.new

page = agent.get('https://www.avito.ru/sankt-peterburg/gotoviy_biznes')

# Находим ссылки на конкретные объявления
advert_links = page.links_with(href: /gotoviy_biznes/)

# Удаляем первые 14 ссылок,
# поскольку это ссылки на группы объявлений, сортировку и галерею
advert_links.slice!(0..13)

# Первые пять страниц, для тестирования
advert_links = advert_links[0..4]

# Удаляем лишние ссылки (в даном случае это пагинация)
advert_links = advert_links.reject do |link|
  link.node.attr('href').include?('?p=')
end

# ========== Сохранение данных в базе =============

advert_links.each_with_index do |link, index|

  # Поскольку ссылки повторяются в изображениях к объявлению, то берём каждую вторую
  next index unless index.even?

  # Переходим на страницу конкретного объявления
  advert_page = link.click

  # Собираем данные со страницы
  title = advert_page.search('h1').text

  # Сохраняем данные в базу
  Advert.create do |advert|
    advert.title = title
  end
end
