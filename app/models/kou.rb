class Kou < ApplicationRecord
  serialize :hand,Array
  serialize :discard,Array
  belongs_to :user
end
