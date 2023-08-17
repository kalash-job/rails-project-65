# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Bulletins', type: :request do
  fixtures :bulletins, :categories, :users

  let(:valid_attributes) do
    {
      title: Faker::Lorem.paragraph_by_chars(number: 50),
      description: Faker::Lorem.paragraph_by_chars(number: 1000),
      category_id: categories(:one).id,
      image: fixture_file_upload('image1.jpg', 'image/jpeg')
    }
  end

  let(:invalid_attributes) { valid_attributes.merge(title: nil) }

  let(:searching_attrs) { valid_attributes.except(:image) }

  let(:invalid_searching_attrs) { invalid_attributes.except(:image) }

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

    it 'redirects to root if bulletin is not published' do
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
      it 'creates a new Bulletin and redirects to the profile' do
        sign_in users(:one)
        post bulletins_url, params: { bulletin: valid_attributes }
        new_bulletin = users(:one).bulletins.find_by(searching_attrs)
        expect(new_bulletin).to be_present
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Bulletin and responds with :unprocessable_entity status code' do
        sign_in users(:one)
        post bulletins_url, params: { bulletin: invalid_attributes }
        new_bulletin = users(:one).bulletins.find_by(invalid_searching_attrs)
        expect(new_bulletin).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      context 'when bulletin belongs to current user' do
        it 'updates the requested bulletin and redirects to the profile' do
          user = users(:one)
          sign_in user
          patch bulletin_url(bulletins(:one)), params: { bulletin: valid_attributes }
          expect(user.bulletins.find_by(searching_attrs)).to be_present
          expect(response).to redirect_to(profile_url)
        end
      end

      context 'when bulletin does not belong to current user' do
        it 'does not update the Bulletin and redirects to root' do
          user = users(:one)
          sign_in user
          patch bulletin_url(bulletins(:published_bulletin)), params: { bulletin: valid_attributes }
          expect(user.bulletins.find_by(searching_attrs)).to be_nil
          expect(response).to redirect_to(root_url)
        end
      end

      context 'without sign in' do
        it 'does not update the Bulletin and redirects to root' do
          patch bulletin_url(bulletins(:one)), params: { bulletin: valid_attributes }
          expect(users(:one).bulletins.find_by(searching_attrs)).to be_nil
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not update the Bulletin and responds with :unprocessable_entity status code' do
        user = users(:one)
        sign_in user
        patch bulletin_url(bulletins(:one)), params: { bulletin: invalid_attributes }
        expect(user.bulletins.find_by(searching_attrs)).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /archive' do
    context 'when bulletin belongs to current user' do
      it 'archives the requested bulletin and redirects to profile' do
        sign_in users(:one)
        bulletin = bulletins(:one)
        patch archive_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.archived?).to eq(true)
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'when bulletin does not belong to current user' do
      it 'does not archive the Bulletin and redirects to root' do
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
      it 'sends on moderation the requested bulletin and redirects to profile' do
        sign_in users(:one)
        bulletin = bulletins(:one)
        patch moderate_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.under_moderation?).to eq(true)
        expect(response).to redirect_to(profile_url)
      end
    end

    context 'when bulletin does not belong to current user' do
      it 'does not send on moderation the Bulletin and redirects to root' do
        sign_in users(:one)
        bulletin = bulletins(:draft_bulletin)
        patch moderate_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.draft?).to eq(true)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
