class Chat
  include ActiveModel::Model

  attr_accessor :initiator
  attr_accessor :partner

  validates :initiator, presence: true
  validates :partner,   presence: true

  def id
    [initiator.name, partner.name].sort
  end
end
