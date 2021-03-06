class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :batch_id
      t.integer :user_id
      t.string :user_type
      t.string :school
      t.string :first_name
      t.string :last_name
      t.string :picture
      t.string :city
      t.integer :year
      t.integer :credits
      t.float :real_average
      t.float :real_gpa
      t.float :average
      t.float :gpa
      t.string :linkedin_url
      t.string :linkedin_picture
      t.integer :linkedin_connections
      t.text :linkedin_description
      t.string :linkedin_locality
      t.string :linkedin_industry
      t.text :linkedin_summary
      t.boolean :linkedin_scraped, default: false
      t.boolean :linkedin_found, default: false

      t.timestamps
    end
  end
end
