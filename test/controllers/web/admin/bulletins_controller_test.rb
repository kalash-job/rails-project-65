# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @under_moderation_bulletin = bulletins(:under_moderation_bulletin)
    @admin = users(:admin)
  end

  test 'should get index' do
    sign_in(@admin)
    get admin_bulletins_url
    assert_response :success
  end

  test 'should reject bulletin' do
    sign_in(@admin)
    patch reject_admin_bulletin_url(@under_moderation_bulletin)
    @under_moderation_bulletin.reload

    assert_redirected_to admin_root_url
    assert { @under_moderation_bulletin.rejected? }
  end

  test 'should not reject bulletin if not an admin' do
    sign_in(users(:one))
    patch reject_admin_bulletin_url(@under_moderation_bulletin)
    @under_moderation_bulletin.reload

    assert_redirected_to root_url
    assert { @under_moderation_bulletin.under_moderation? }
  end

  test 'should not reject bulletin without login' do
    patch reject_admin_bulletin_url(@under_moderation_bulletin)
    @under_moderation_bulletin.reload

    assert_redirected_to root_url
    assert { @under_moderation_bulletin.under_moderation? }
  end

  test 'should archive bulletin' do
    sign_in(@admin)
    patch archive_admin_bulletin_url(@under_moderation_bulletin)
    @under_moderation_bulletin.reload

    assert_redirected_to admin_bulletins_path
    assert { @under_moderation_bulletin.archived? }
  end

  test 'should publish bulletin' do
    sign_in(@admin)
    patch publish_admin_bulletin_url(@under_moderation_bulletin)
    @under_moderation_bulletin.reload

    assert_redirected_to admin_root_url
    assert { @under_moderation_bulletin.published? }
  end
end
