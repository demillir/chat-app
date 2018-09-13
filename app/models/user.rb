class User
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: true
end
