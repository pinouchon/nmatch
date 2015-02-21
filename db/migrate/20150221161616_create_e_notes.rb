class CreateENotes < ActiveRecord::Migration
  def change
    create_table :e_notes do |t|
      t.integer :batch_id
      t.integer :e_user_id
      t.integer :e_module_id
      t.integer :schoolyear
      t.string :codemodule
      t.string :titlemodule
      t.string :codeinstance
      t.string :codeacti
      t.string :title
      t.datetime :date
      t.string :correcteur
      t.float :final_note
      t.string :comment

      t.timestamps
    end
  end
end
