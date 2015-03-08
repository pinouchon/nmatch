class CreateStudentTag < ActiveRecord::Migration
  def change
    create_table :student_tags do |t|
      t.integer :student_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
