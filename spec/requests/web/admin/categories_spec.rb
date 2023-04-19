# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Admin::Categories', type: :request do
  fixtures :users, :categories

  let(:attrs) { { name: Faker::Lorem.paragraph_by_chars(number: 50) } }

  describe 'GET /index' do
    it 'renders a successful response' do
      sign_in users(:admin)
      get admin_categories_url
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      sign_in users(:admin)
      get new_admin_category_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      sign_in users(:admin)
      get edit_admin_category_url(categories(:one))
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'creates a new Category and redirects to the admin_categories' do
      sign_in users(:admin)
      expect { post admin_categories_url, params: { category: attrs } }.to change(Category, :count).by(1)
      expect(response).to redirect_to(admin_categories_url)
    end
  end

  describe 'PATCH /update' do
    context 'when user is admin' do
      it 'updates the requested category and redirects to the admin_categories' do
        sign_in users(:admin)
        category = categories(:one)
        patch admin_category_url(category), params: { category: attrs }
        category.reload
        expect(category.name).to eq(attrs[:name])
        expect(response).to redirect_to(admin_categories_url)
      end
    end

    context 'when user is not admin' do
      it 'does not update the category and redirects to root' do
        sign_in users(:one)
        category = categories(:one)
        patch admin_category_url(category), params: { category: attrs }
        category.reload
        expect(category.name).not_to eq(attrs[:name])
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when user is not signed in' do
      it 'does not update the category and redirects to root' do
        category = categories(:one)
        patch admin_category_url(category), params: { category: attrs }
        category.reload
        expect(category.name).not_to eq(attrs[:name])
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when category is without bulletins' do
      it 'destroys the requested category and redirects to the admin_categories' do
        sign_in users(:admin)
        category = categories(:without_bulletins)
        expect { delete admin_category_url(category) }.to change(Category, :count).by(-1)
        expect(response).to redirect_to(admin_categories_url)
      end
    end

    context 'when category is with bulletins' do
      it 'does not destroy the category and redirects to admin_categories' do
        sign_in users(:admin)
        category = categories(:one)
        expect { delete admin_category_url(category) }.not_to change(Category, :count)
        expect(response).to redirect_to(admin_categories_url)
      end
    end
  end
end
