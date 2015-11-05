require 'rubygems'
require 'active_record'
require 'yaml'

# Загружаем файл настройки соединения с базой данных
dbconfig = YAML.load(File.open('database.yml'))[ENV['db_env'] || 'development']

# Ошибки работы с БД направим в стандартный поток (консоль)
ActiveRecord::Base.logger = Logger.new(STDERR)

# Соединяемся с БД

namespace :db do
  desc 'Create the database'
  task :create do
    admin_connection = dbconfig.merge('database' => 'postgres', 'schema_search_path' => 'public')
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(dbconfig.fetch('database'))
  end

  desc 'Migrate the database'
  task :migrate do
    admin_connection = dbconfig.merge('database' => 'postgres', 'schema_search_path' => 'public')
    ActiveRecord::Base.establish_connection(dbconfig)
    ActiveRecord::Migrator.migrate('migrate/')
  end

  desc 'drop the db'
  task :drop do
    admin_connection = dbconfig.merge('database' => 'postgres', 'schema_search_path' => 'public')
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(dbconfig.fetch('database'))
  end
end
