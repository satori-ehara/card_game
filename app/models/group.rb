class Group < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :kou_user
    validates :otu_user
  end
end
