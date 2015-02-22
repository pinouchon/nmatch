class AddLastBatchToEUsers < ActiveRecord::Migration
  def change
    add_column :e_users, :last_batch, :integer, default: 0
  end
end
