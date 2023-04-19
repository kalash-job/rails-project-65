# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Admin::Admins', type: :request do
  describe 'GET /index' do
    fixtures :users
    context 'when user is admin' do
      it 'renders a successful response' do
        sign_in users(:admin)
        get admin_root_url
        expect(response).to be_successful
      end
    end

    context 'when user is not admin' do
      it 'redirects to root' do
        sign_in users(:one)
        get admin_root_url
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to root' do
        get admin_root_url
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
