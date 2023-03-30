# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    # TODO: add checking of admin access
    @query = Bulletin.ransack(params[:q])
    @bulletins = @query.result.by_creation_date_desc.page(params[:page])
  end

  def archive
    @bulletin = Bulletin.find params[:id]
    if @bulletin.archive!
      redirect_to request.referer, notice: t('.success')
    else
      redirect_to request.referer, alert: t('.failure')
    end
  end

  def publish
    @bulletin = Bulletin.find params[:id]
    if @bulletin.publish!
      redirect_to admin_root_path, notice: t('.success')
    else
      redirect_to admin_root_path, alert: t('.failure')
    end
  end

  def reject
    @bulletin = Bulletin.find params[:id]
    if @bulletin.reject!
      redirect_to admin_root_path, notice: t('.success')
    else
      redirect_to admin_root_path, alert: t('.failure')
    end
  end
end
