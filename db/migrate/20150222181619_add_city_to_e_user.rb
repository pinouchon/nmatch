class AddCityToEUser < ActiveRecord::Migration
  def change
    add_column :e_users, :city, :string
  end
end
