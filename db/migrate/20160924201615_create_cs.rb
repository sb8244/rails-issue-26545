class CreateCs < ActiveRecord::Migration
  def change
    create_table :cs do |t|

      t.timestamps null: false
    end
  end
end
