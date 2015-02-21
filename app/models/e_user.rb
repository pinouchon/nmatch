class EUser < ActiveRecord::Base
  belongs_to :batch
  has_many :e_modules
  has_many :e_notes

  validates_presence_of :login
  validates_uniqueness_of :login, scope: :batch_id
  validates_presence_of :batch_id
end
