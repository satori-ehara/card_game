class Game < ApplicationRecord
  serialize :deck,Array
  belongs_to :group
end
