# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Bulletins', type: :request do
  fixtures :bulletins, :categories, :users
  before do
    @title = Faker::Lorem.paragraph_by_chars(number: 50)
    @long_title = Faker::Lorem.paragraph_by_chars(number: 55)
    @description = Faker::Lorem.paragraph_by_chars(number: 1000)
    @image = fixture_file_upload('image1.jpg', 'image/jpeg')
  end
  let(:valid_attributes) do
    { title: @title, description: @description, category_id: categories(:one).id, image: @image }
  end

  let(:invalid_attributes) do
    { title: @long_title, description: @description, category_id: categories(:one).id, image: @image }
  end

  let(:searching_attrs) do
    { title: @title, description: @description, category_id: categories(:one).id }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get root_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get bulletin_url(bulletins(:published_bulletin))
      expect(response).to be_successful
    end

    it 'redirects to root_url if bulletin is not published' do
      get bulletin_url(bulletins(:one))
      expect(response).to redirect_to(root_url)
    end

    it 'renders unpublished bulletin to owner' do
      sign_in users(:one)
      get bulletin_url(bulletins(:one))
      expect(response).to be_successful
    end

    it 'renders unpublished bulletin to admin' do
      sign_in users(:admin)
      get bulletin_url(bulletins(:one))
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      sign_in users(:one)
      get new_bulletin_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      sign_in users(:one)
      get edit_bulletin_url(bulletins(:one))
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Bulletin' do
        sign_in users(:one)
        expect { post bulletins_url, params: { bulletin: valid_attributes } }.to change(Bulletin, :count).by(1)
      end

      it 'redirects to the profile' do
        sign_in users(:one)
        post bulletins_url, params: { bulletin: valid_attributes }
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Bulletin' do
        sign_in users(:one)
        expect { post bulletins_url, params: { bulletin: invalid_attributes } }.to change(Bulletin, :count).by(0)
      end

      it 'responds with :unprocessable_entity status code' do
        sign_in users(:one)
        post bulletins_url, params: { bulletin: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      context 'when bulletin belongs to current user' do
        it 'updates the requested bulletin' do
          user = users(:one)
          sign_in user
          patch bulletin_url(bulletins(:one)), params: { bulletin: valid_attributes }
          expect(user.bulletins.find_by(searching_attrs)).to_not be_nil
        end

        it 'redirects to the profile' do
          sign_in users(:one)
          bulletin = bulletins(:one)
          patch bulletin_url(bulletin), params: { bulletin: valid_attributes }
          bulletin.reload
          expect(response).to redirect_to(profile_url)
        end
      end

      context 'when bulletin does not belong to current user' do
        it 'does not update the Bulletin' do
          user = users(:one)
          sign_in user
          patch bulletin_url(bulletins(:published_bulletin)), params: { bulletin: valid_attributes }
          expect(user.bulletins.find_by(searching_attrs)).to be_nil
        end

        it 'redirects to root_url' do
          sign_in users(:one)
          patch bulletin_url(bulletins(:published_bulletin)), params: { bulletin: valid_attributes }
          expect(response).to redirect_to(root_url)
        end
      end

      context 'without sign in' do
        it 'does not update the Bulletin' do
          patch bulletin_url(bulletins(:one)), params: { bulletin: valid_attributes }
          expect(users(:one).bulletins.find_by(searching_attrs)).to be_nil
        end

        it 'redirects to root_url' do
          patch bulletin_url(bulletins(:one)), params: { bulletin: valid_attributes }
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not update the Bulletin' do
        user = users(:one)
        sign_in user
        patch bulletin_url(bulletins(:one)), params: { bulletin: invalid_attributes }
        expect(user.bulletins.find_by(searching_attrs)).to be_nil
      end

      it 'responds with :unprocessable_entity status code' do
        sign_in users(:one)
        patch bulletin_url(bulletins(:one)), params: { bulletin: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /archive' do
    context 'when bulletin belongs to current user' do
      it 'archives the requested bulletin and redirects to profile_url' do
        sign_in users(:one)
        bulletin = bulletins(:one)
        patch archive_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.archived?).to be_truthy
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'when bulletin does not belong to current user' do
      it 'does not archive the Bulletin and redirects to root_url' do
        sign_in users(:one)
        bulletin = bulletins(:published_bulletin)
        patch archive_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.archived?).to be_falsey
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'PATCH /moderate' do
    context 'when bulletin belongs to current user' do
      it 'sends on moderation the requested bulletin and redirects to profile_url' do
        sign_in users(:one)
        bulletin = bulletins(:one)
        patch moderate_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.under_moderation?).to be_truthy
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'when bulletin does not belong to current user' do
      it 'does not send on moderation the Bulletin and redirects to root_url' do
        sign_in users(:one)
        bulletin = bulletins(:draft_bulletin)
        patch moderate_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.draft?).to be_truthy
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
