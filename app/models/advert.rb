# == Schema Information
#
# Table name: adverts
#
#  id           :integer          not null, primary key
#  title        :string
#  ad_id        :integer
#  category_id  :integer
#  price        :integer
#  owner_name   :string
#  phone        :string
#  metro        :string
#  desc         :text
#  status       :integer
#  source_link  :string
#  posted_ad    :datetime
#  premium_type :integer
#  discount     :integer
#  reason       :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Advert < ActiveRecord::Base
  # Помечаем поля :status, :premium_type и :reason как enum
  # Используется гем simple_enum
  as_enum :status,
          new: 1,        # => Новое
          competitor: 2, # => Конкурент
          taken: 3,      # => Взято
          agreed: 4,     # => Согласовано
          refusing: 5,   # => Отказ
          in_base: 6,    # => В базе
          published: 7   # => Опубликовано

  as_enum :premium_type, premium: 1, vip: 2, allocated: 3

  as_enum :reason,
          low_cost: 1,
          high_cost: 2,
          one_buyer: 3,
          many_buyers: 4,
          good_design: 5

  # Имеет одного рекламодателя
  belongs_to :user

  # Находится в одной категории
  belongs_to :category

  # Имеет множество изображений
  has_many :images
end
