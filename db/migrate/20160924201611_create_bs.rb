class CreateBs < ActiveRecord::Migration
  def change
    create_table :bs do |t|

      t.timestamps null: false
    end
  end
end
