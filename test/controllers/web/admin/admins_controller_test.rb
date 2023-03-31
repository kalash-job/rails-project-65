# frozen_string_literal: true

require 'test_helper'

class Web::Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_root_url
    assert_response :success
  end
end
