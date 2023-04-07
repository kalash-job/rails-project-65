# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @query = current_user.bulletins.ransack(params[:q])
    @bulletins = @query.result.by_creation_date_desc.page(params[:page])
  end
end
