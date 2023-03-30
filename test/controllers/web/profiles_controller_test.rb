# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get web_profiles_show_url
    assert_response :success
  end
end
