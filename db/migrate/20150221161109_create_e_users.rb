class CreateEUsers < ActiveRecord::Migration
  def change
    create_table :e_users do |t|
      t.integer :batch_id
      t.string :title
      t.string :login
      t.string :nom
      t.string :prenom
      t.string :picture
      t.string :location
      t.string :uid
      t.string :gid
      t.string :promo
      t.integer :credits
      t.float :gpa_bachelor
      t.float :gpa_master
      t.float :gpa_average

      t.timestamps
    end
  end
end
