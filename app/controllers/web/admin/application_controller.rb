# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :authorize_admin

  private

  def authorize_admin
    authorize :admin, :admin?
  end
end
