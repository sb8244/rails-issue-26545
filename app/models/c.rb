class C < ActiveRecord::Base
  has_many :as, -> { with_distinct_joins }
end
