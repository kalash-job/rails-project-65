# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  PUBLISHED_STATE = 'published'
  UNDER_MODERATION_STATE = 'under_moderation'
  REJECTED_STATE = 'rejected'
  ARCHIVED_STATE = 'archived'

  setup do
    @under_moderation_bulletin = bulletins(:under_moderation_bulletin)
  end

  test 'should get index' do
    sign_in(users(:admin))
    get admin_bulletins_url
    assert_response :success
  end

  test 'should not get index if not an admin' do
    sign_in(users(:one))
    get admin_bulletins_url
    assert_redirected_to root_url
  end

  test 'should not get index without login' do
    get admin_bulletins_url
    assert_redirected_to root_url
  end

  test 'should reject bulletin' do
    sign_in(users(:admin))
    patch reject_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to admin_root_url
    rejected_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { rejected_bulletin.state == REJECTED_STATE }
  end

  test 'should not reject bulletin if not an admin' do
    sign_in(users(:one))
    patch reject_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    rejected_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { rejected_bulletin.state == UNDER_MODERATION_STATE }
  end

  test 'should not reject bulletin without login' do
    patch reject_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    rejected_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { rejected_bulletin.state == UNDER_MODERATION_STATE }
  end

  test 'should archive bulletin' do
    sign_in(users(:admin))
    patch archive_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to admin_bulletins_path
    archived_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { archived_bulletin.state == ARCHIVED_STATE }
  end

  test 'should not archive bulletin if not an admin' do
    sign_in(users(:one))
    patch archive_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    archived_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { archived_bulletin.state == UNDER_MODERATION_STATE }
  end

  test 'should not archive bulletin without login' do
    patch archive_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    archived_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { archived_bulletin.state == UNDER_MODERATION_STATE }
  end

  test 'should publish bulletin' do
    sign_in(users(:admin))
    patch publish_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to admin_root_url
    published_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { published_bulletin.state == PUBLISHED_STATE }
  end

  test 'should not publish bulletin if not an admin' do
    sign_in(users(:one))
    patch publish_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    published_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { published_bulletin.state == UNDER_MODERATION_STATE }
  end

  test 'should not publish bulletin without login' do
    patch publish_admin_bulletin_url(@under_moderation_bulletin)

    assert_redirected_to root_url
    published_bulletin = Bulletin.find(@under_moderation_bulletin.id)
    assert { published_bulletin.state == UNDER_MODERATION_STATE }
  end
end
