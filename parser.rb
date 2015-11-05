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


# Удаляем дубли ссылок, с текстом "Подробнее"
advert_links = advert_links.reject do |link|
  link.node.attr('href').include?('?p=')
end

fail advert_links.inspect
