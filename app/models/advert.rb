class Advert < ActiveRecord::Base
  # Помечаем поля :status и :premium как enum (используется гем simple_enum)
  as_enum :status,
          new: 1,        # => Новое
          competitor: 2, # => Конкурент
          taken: 3,      # => Взято
          agreed: 4,     # => Согласовано
          refusing: 5,   # => Отказ
          in_base: 6,    # => В базе
          published: 7   # => Опубликовано

  as_enum :premium, premium: 1, vip: 2, allocated: 3

  # Имеет одного рекламодателя
  belongs_to :user
end
