class CreateEModules < ActiveRecord::Migration
  def change
    create_table :e_modules do |t|
      t.integer :batch_id
      t.integer :e_user_id
      t.integer :school_year
      t.string :id_user_history
      t.string :code_module
      t.string :code_instance
      t.datetime :date_ins
      t.string :cycle
      t.string :grade
      t.integer :credits
      t.string :flags
      t.string :barrage
      t.string :instance_id
      t.integer :module_rating
      t.integer :semester

      t.timestamps
    end
  end
end
