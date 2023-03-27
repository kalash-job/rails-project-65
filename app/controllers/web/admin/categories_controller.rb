# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @categories = Category.by_id_asc
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find params[:id]
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash.now[:failure] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find params[:id]

    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash.now[:failure] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find params[:id]

    if @category.bulletins.present?
      return redirect_to admin_categories_path, alert: t('.contains_bulletins')
    end

    if @category.destroy
      redirect_to admin_categories_path, notice: t('.success')
    else
      redirect_to admin_categories_path, alert: t('.failure')
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
