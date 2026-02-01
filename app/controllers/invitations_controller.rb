class InvitationsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_user_by_token, only: %i[accept complete]

  def accept
    if @user.nil?
      redirect_to new_session_path, alert: "Invalid or expired invitation link."
    elsif !@user.invitation_valid?
      redirect_to new_session_path, alert: "This invitation has expired. Please contact an administrator."
    end
    # Otherwise, render the accept form
  end

  def complete
    if @user.nil? || !@user.invitation_valid?
      redirect_to new_session_path, alert: "Invalid or expired invitation link."
      return
    end

    if params[:password].blank?
      flash.now[:alert] = "Password can't be blank."
      render :accept, status: :unprocessable_entity
      return
    end

    if params[:password].length < 8
      flash.now[:alert] = "Password must be at least 8 characters."
      render :accept, status: :unprocessable_entity
      return
    end

    if @user.accept_invitation!(password: params[:password])
      start_new_session_for(@user)
      redirect_to root_path, notice: "Welcome to Stock Tracker! Your account is now active."
    else
      flash.now[:alert] = "Something went wrong. Please try again."
      render :accept, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by(invitation_token: params[:token])
  end
end
