require 'rubygems'
require 'active_record'
require 'yaml'
require 'mechanize'

require_relative 'lib/advert'
require_relative 'lib/category'
require_relative 'lib/avito'

# Загружаем файл настройки соединения с базой данных
dbconfig = YAML.load_file(File.join(__dir__, 'database.yml'))

# Ошибки работы с БД направим в стандартный поток (консоль)
ActiveRecord::Base.logger = Logger.new(STDERR)

# Соединяемся с БД
ActiveRecord::Base.establish_connection(dbconfig['development'])

USER_AGENTS = { ff_android: 'Mozilla/5.0 (Android 5.1; Mobile; rv:41.0) Gecko/41.0 Firefox/41.0' }

# Получаем страницу с объявлениями (и пагинацией)
agent = Mechanize.new do |agent|
  agent.user_agent = USER_AGENTS[:ff_android]
end

page = agent.get('https://m.avito.ru/sankt-peterburg/gotoviy_biznes')

adverts = []

# Сами объявления
3.times do
  adverts     = Avito.advert_links(page)
  next_page   = page.search('.page-next').children
  second_page = agent.click(page.link_with text: /Следующие/)
  page        = second_page
end

# Первые 7 объявлений, для тестирования
# adverts = adverts[0..7]

# Собираем данные
Avito.get_info(adverts)
