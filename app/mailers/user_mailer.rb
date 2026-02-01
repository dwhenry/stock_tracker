class UserMailer < ApplicationMailer
  def invitation(user)
    @user = user
    @invitation_url = accept_invitation_url(token: user.invitation_token)

    mail(
      to: @user.email_address,
      subject: "You've been invited to Stock Tracker"
    )
  end
end
