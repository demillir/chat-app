class IntroduceUser
  include Interactor

  def call
    context.user_db ||= ActiveUserDB.instance
    context.user_db[context.user.name] = context.user
  end
end
