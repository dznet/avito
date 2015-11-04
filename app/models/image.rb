# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  name       :string
#  advert_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Image < ActiveRecord::Base
  # Входит в одно объявление
  belongs_to :advert
end
