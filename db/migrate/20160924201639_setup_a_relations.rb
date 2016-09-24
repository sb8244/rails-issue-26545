class SetupARelations < ActiveRecord::Migration
  def change
    add_belongs_to :as, :c
  end
end
