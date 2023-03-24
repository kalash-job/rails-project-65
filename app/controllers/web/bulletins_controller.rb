# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  def index
    @bulletins = Bulletin.with_attached_image.by_creation_date_desc.page(params[:page])
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
      #  TODO: после нужно сделать редирект на profile
      redirect_to root_path, notice: t('.success')
    else
      flash.now[:failure] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
