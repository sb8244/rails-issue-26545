class CreateAs < ActiveRecord::Migration
  def change
    create_table :as do |t|

      t.timestamps null: false
    end
  end
end
