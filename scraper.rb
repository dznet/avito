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

# Получаем страницу с объявлениями (и пагинацией)
agent = Mechanize.new
page  = agent.get('https://www.avito.ru/sankt-peterburg/gotoviy_biznes')

# Сами объявления
adverts = Avito.advert_links(page)

# Первые 7 объявлений, для тестирования
# adverts = adverts[0..7]

# Собираем данные
Avito.get_info(adverts)
