class User < ActiveRecord::Base
  has_many :tag_user
  has_many :tags, through: :tag_user
  belongs_to :special_user, polymorphic: true
end
