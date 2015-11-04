class User < ActiveRecord::Base
  # Помечаем поле :role как enum (используется гем simple_enum)
  as_enum :role, admin: 1, broker: 2, copywriter: 3

  # Имеет множество объявлений
  has_many :adverts
end
