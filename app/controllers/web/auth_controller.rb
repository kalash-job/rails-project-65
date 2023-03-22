# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    email = auth[:info][:email].downcase
    name = auth[:info][:name]
    user = User.find_or_initialize_by(email:, name:)
    if user.save
      sign_in(user)
      flash.now[:success] = t('.success')
    else
      flash.now[:failure] = t('.failure')
    end
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
