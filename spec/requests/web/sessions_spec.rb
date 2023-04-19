# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Sessions', type: :request do
  describe 'DELETE /destroy' do
    fixtures :users
    it 'signs out and redirects to root' do
      sign_in users(:one)
      delete session_url
      expect(signed_in?).to be_falsey
      expect(response).to redirect_to(root_url)
    end
  end
end
