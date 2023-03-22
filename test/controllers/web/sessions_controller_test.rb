# frozen_string_literal: true

require 'test_helper'

class Web::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should destroy session' do
    assert { signed_in? }

    delete session_url
    assert { !signed_in? }
    assert_response :redirect
  end
end
