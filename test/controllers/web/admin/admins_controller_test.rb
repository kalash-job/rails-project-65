# frozen_string_literal: true

require 'test_helper'

class Web::Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in(users(:one))
    user_is_admin!(current_user)
    get admin_root_url
    assert_response :success
  end

  test 'should not get index if not an admin' do
    sign_in(users(:two))
    get admin_root_url
    assert_redirected_to root_url
  end

  test 'should not get index without login' do
    get admin_root_url
    assert_redirected_to root_url
  end
end
