class StudentTag < ActiveRecord::Base
  belongs_to :student
  belongs_to :tag
end
