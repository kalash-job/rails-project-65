# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern
  include Pundit::Authorization

  private

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, alert: t('.non_authenticated_user')
  end
end
