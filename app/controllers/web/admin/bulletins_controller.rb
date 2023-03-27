# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    # TODO: add checking of admin access
    @query = Bulletin.ransack(params[:q])
    @bulletins = @query.result.by_creation_date_desc.page(params[:page])
    @categories = Category.all
  end

  def archive; end

  def publish; end

  def reject; end
end
