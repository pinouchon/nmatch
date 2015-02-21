class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.boolean :active

      t.timestamps
    end
  end
end
