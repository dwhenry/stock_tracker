class AccountController < ApplicationController
  def edit
  end

  def update
    if !current_user.authenticate(params[:current_password])
      flash.now[:alert] = "Current password is incorrect."
      render :edit, status: :unprocessable_entity
      return
    end

    if params[:password].blank?
      flash.now[:alert] = "New password can't be blank."
      render :edit, status: :unprocessable_entity
      return
    end

    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = "New password and confirmation don't match."
      render :edit, status: :unprocessable_entity
      return
    end

    if params[:password].length < 8
      flash.now[:alert] = "New password must be at least 8 characters."
      render :edit, status: :unprocessable_entity
      return
    end

    if current_user.update(password: params[:password])
      redirect_to root_path, notice: "Your password has been updated successfully."
    else
      flash.now[:alert] = "Something went wrong. Please try again."
      render :edit, status: :unprocessable_entity
    end
  end
end
