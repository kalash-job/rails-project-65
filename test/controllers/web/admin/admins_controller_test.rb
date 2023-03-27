# frozen_string_literal: true

require 'test_helper'

class Web::Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get web_admin_admins_index_url
    assert_response :success
  end
end
