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

fail page.inspect
