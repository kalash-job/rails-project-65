# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get web_admin_bulletins_index_url
    assert_response :success
  end

  test 'should get archive' do
    get web_admin_bulletins_archive_url
    assert_response :success
  end

  test 'should get publish' do
    get web_admin_bulletins_publish_url
    assert_response :success
  end

  test 'should get reject' do
    get web_admin_bulletins_reject_url
    assert_response :success
  end
end
