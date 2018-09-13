class ChatsController < ApplicationController
  def show
    partner_name = CGI.unescape(params[:id])
    partner      = ActiveUserDB.instance.find { |user| user.name == partner_name }
    @chat        = Chat.new(initiator: current_user, partner: partner)
  end
end
