class IntroduceUser
  include Interactor

  def call
    context.user_set ||= ActiveUserDB.instance
    context.user_set << context.user
  end
end
