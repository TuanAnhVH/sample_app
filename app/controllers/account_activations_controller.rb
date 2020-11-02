class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "controllers.acount_activations.account_activated"
      redirect_to user
    else
      flash[:danger] = t "controllers.acount_activations.invalid_link"
      redirect_to root_path
    end
  end
end
