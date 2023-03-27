# frozen_string_literal: true

class Web::Admin::AdminsController < Web::Admin::ApplicationController
  def index
    # TODO: add scope to get only bulletins on moderation
    @bulletins = Bulletin.with_attached_image.by_creation_date_desc.page(params[:page])
  end
end
