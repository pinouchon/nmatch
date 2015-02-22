class EModule < ActiveRecord::Base
  belongs_to :batch
  belongs_to :e_user
  has_many :e_notes

  validates_presence_of :batch_id
  validates_presence_of :e_user_id
  validates_uniqueness_of :codemodule, scope: [:batch_id, :e_user_id]
end
