class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :e_users, :average, :float
    add_column :e_users, :year, :string
    add_column :e_users, :school, :string
  end
end