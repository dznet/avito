# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  title       :string
#  ad_id       :integer
#  category_id :integer
#  price       :integer
#  owner_name  :string
#  phone       :string
#  metro       :string
#  desc        :text
#  status      :integer
#  source_link :string
#  posted_ad   :datetime
#  premium     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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

  # Находится в одной категории
  belongs_to :category

  # Имеет множество изображений
  has_many :images
end
