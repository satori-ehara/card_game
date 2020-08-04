class Otu < ApplicationRecord
  serialize :hand,Array
  belongs_to :user
end
