# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    sign_in users(:one)
    get profile_url
    assert_response :success
  end

  test 'should not get show without login' do
    get profile_url
    assert_redirected_to root_url
  end
end
