class SetupBRelations < ActiveRecord::Migration
  def change
    add_belongs_to :bs, :a
    add_belongs_to :bs, :c
  end
end
