# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Admin::Bulletins', type: :request do
  fixtures :users, :bulletins

  describe 'GET /index' do
    it 'renders a successful response' do
      sign_in users(:admin)
      get admin_bulletins_url
      expect(response).to be_successful
    end
  end

  describe 'PATCH /reject' do
    context 'when user is admin' do
      it 'rejects bulletin and redirects to admin_root' do
        sign_in users(:admin)
        bulletin = bulletins(:under_moderation_bulletin)
        patch reject_admin_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.rejected?).to be_truthy
        expect(response).to redirect_to(admin_root_url)
      end
    end

    context 'when user is not admin' do
      it 'redirects to root' do
        sign_in users(:one)
        bulletin = bulletins(:under_moderation_bulletin)
        patch reject_admin_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.under_moderation?).to be_truthy
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to root' do
        bulletin = bulletins(:under_moderation_bulletin)
        patch reject_admin_bulletin_url(bulletin)
        bulletin.reload
        expect(bulletin.under_moderation?).to be_truthy
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'PATCH /archive' do
    it 'archives bulletin and redirects to admin_bulletins' do
      sign_in users(:admin)
      bulletin = bulletins(:under_moderation_bulletin)
      patch archive_admin_bulletin_url(bulletin)
      bulletin.reload
      expect(bulletin.archived?).to be_truthy
      expect(response).to redirect_to(admin_bulletins_url)
    end
  end

  describe 'PATCH /publish' do
    it 'publishes bulletin and redirects to admin_root' do
      sign_in users(:admin)
      bulletin = bulletins(:under_moderation_bulletin)
      patch publish_admin_bulletin_url(bulletin)
      bulletin.reload
      expect(bulletin.published?).to be_truthy
      expect(response).to redirect_to(admin_root_url)
    end
  end
end
