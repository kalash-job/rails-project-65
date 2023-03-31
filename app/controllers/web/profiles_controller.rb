# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @query = Bulletin.ransack(params[:q])
    @bulletins = @query.result.for_user(current_user).by_creation_date_desc.page(params[:page])
  end
end
