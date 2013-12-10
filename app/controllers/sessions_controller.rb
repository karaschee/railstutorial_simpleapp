class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by_email(session[:email])
    if( user && user.authenticate(session[:password]) )
      sign_in user
      # redirect_to user
      redirect_back_or(user)
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
