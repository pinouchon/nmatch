class Batch < ActiveRecord::Base
  def self.current_or_create
    return find(ENV['BATCH_ID']) if ENV['BATCH_ID']
    self.where(active: true).first_or_create
  end

  def self.current
    where(active: true)
  end
end
