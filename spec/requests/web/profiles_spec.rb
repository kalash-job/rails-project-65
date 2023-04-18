# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Profiles', type: :request do
  describe 'GET /show' do
    fixtures :users
    it 'renders a successful response' do
      sign_in users(:one)
      get profile_url
      expect(response).to be_successful
    end

    it 'redirects to root_url without sign in' do
      get profile_url
      expect(response).to redirect_to(root_url)
    end
  end
end
