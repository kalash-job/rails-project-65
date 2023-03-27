# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @query = Bulletin.ransack(params[:q])
    @bulletins = @query.result.with_attached_image.by_creation_date_desc.page(params[:page])
    @categories = Category.all
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to profile_path, notice: t('.success')
    else
      flash.now[:failure] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, flash: { warning: t('.non_authenticated_user') }
  end
end
