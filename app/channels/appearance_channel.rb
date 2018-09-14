class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    track_appearance(active_user)
    stream_from "#{channel_name}:active_users"
  end

  def unsubscribed
    track_disappearance(active_user)
  end

  def appear
    track_appearance(active_user)
  end

  def away
    track_disappearance(active_user)
  end

  private

  def track_appearance(user)
    ActiveUserDB.instance[user.name] = user
    broadcast_present_users
  end

  def track_disappearance(user)
    ActiveUserDB.instance.delete(user.name)
    broadcast_present_users
  end

  def broadcast_present_users
    chats = ActiveUserDB.instance
              .map { |name, user| Chat.new(initiator: active_user, partner: user) }

    partners_html = ApplicationController.render(
      assigns:    {current_user: active_user},
      partial:    'users/chat',
      collection: chats)
    AppearanceChannel.broadcast_to("active_users", html: partners_html)
  end
end
