class A < ActiveRecord::Base
  has_many :bs
  belongs_to :c

  def self.with_distinct_joins
    joins(:bs).distinct
  end
end
