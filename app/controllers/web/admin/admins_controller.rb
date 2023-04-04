# frozen_string_literal: true

class Web::Admin::AdminsController < Web::Admin::ApplicationController
  def index
    @bulletins = Bulletin.under_moderation.by_creation_date_desc.page(params[:page])
  end
end
