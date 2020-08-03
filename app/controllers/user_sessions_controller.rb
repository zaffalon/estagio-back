class UserSessionsController < ApplicationController
  def index
    @user_session = UserSession.new
  end

  def create
    if current_user_session
      current_user_session.destroy
      @current_user = nil
    end
    user_token = UserToken.find_by_token(user_session_params['token'])
    @user_session = UserSession.new(user_token.try(:user), true)
    if @user_session.save
      # Bug do demo resolvido:
      # Solução em: http://railsblog.kieser.net/2010/03/authlogic-custom-logins-and-persisting.html
      @user_session.user.reset_persistence_token!
      @user_session.save
      redirect_to index_path
    else
      render :action => :index
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path
  end

  def user_session_params
    params.require(:user_session).permit(:token)
  end
end
