class ENote < ActiveRecord::Base
  belongs_to :batch
  belongs_to :e_user
  belongs_to :e_module

  validates_presence_of :batch_id
  validates_presence_of :e_user_id
  validates_presence_of :e_module_id
end
