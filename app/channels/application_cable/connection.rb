module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :active_user

    def connect
      self.active_user = find_verified_user
    end

    private

    def find_verified_user
      current_user_name = cookies.signed[:user_name]
      unless current_user_name.present?
        reject_unauthorized_connection
        return
      end

      User.new(name: current_user_name)
    end
  end
end
