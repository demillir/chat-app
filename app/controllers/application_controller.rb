class ApplicationController < ActionController::Base
  before_action :require_sign_in

  def current_user
    find_current_user
  end

  private

  def require_sign_in
    puts '**************'
    pp cookies.signed[:user_name]
    unless cookies.signed[:user_name].present?
      flash[:notice] = "You must sign in to chat"
      redirect_to new_user_path
    end
  end

  def find_current_user
    puts '********** find_current_user'
    current_user_name = cookies.signed[:user_name]
    return nil unless current_user_name.present?
    pp current_user_name
    pp ActiveUserDB.instance.map(&:first)
    pp $redis.get "ActiveUserDB:development:hash"
    pp Redis.new.get "ActiveUserDB:development:hash"
    pp $redis.get "ActiveUserDB:development:hash"

    ActiveUserDB.instance[current_user_name]
  end
end
