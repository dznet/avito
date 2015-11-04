# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  firstname  :string
#  secondname :string
#  email      :string
#  password   :string
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # Помечаем поле :role как enum (используется гем simple_enum)
  as_enum :role, admin: 1, broker: 2, copywriter: 3

  # Имеет множество объявлений
  has_many :adverts
end
