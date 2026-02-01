class UsersController < ApplicationController
  include Authorization
  before_action :require_admin
  before_action :set_user, only: %i[edit update destroy resend_invitation]

  def index
    @users = User.ordered
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(16) # Temporary password, will be replaced on invitation acceptance

    if @user.save
      @user.generate_invitation_token!
      UserMailer.invitation(@user).deliver_later
      redirect_to users_path, notice: "User was created and invitation email sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params.except(:email_address))
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete yourself."
    else
      @user.destroy
      redirect_to users_path, notice: "User was successfully deleted."
    end
  end

  def resend_invitation
    if @user.invited?
      @user.generate_invitation_token!
      UserMailer.invitation(@user).deliver_later
      redirect_to users_path, notice: "Invitation email resent to #{@user.email_address}."
    else
      redirect_to users_path, alert: "This user has already accepted their invitation."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :role)
  end
end
