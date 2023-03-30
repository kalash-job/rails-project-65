# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @query = Bulletin.ransack(params[:q])
    @bulletins = @query.result.with_attached_image.published.by_creation_date_desc.page(params[:page])
    @categories = Category.all
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
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

  def update
    @bulletin = Bulletin.find params[:id]

    if @bulletin.update(bulletin_params)
      redirect_to profile_path, notice: t('.success')
    else
      flash.now[:failure] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def moderate
    @bulletin = Bulletin.find params[:id]
    if @bulletin.moderate!
      redirect_to profile_path, notice: t('.success')
    else
      redirect_to profile_path, alert: t('.failure')
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
