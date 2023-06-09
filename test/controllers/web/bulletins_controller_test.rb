# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @bulletin = bulletins(:one)
    title = Faker::Lorem.paragraph_by_chars(number: 50)
    description = Faker::Lorem.paragraph_by_chars(number: 1000)
    category_id = categories(:one).id
    @attrs = { title:, description:, category_id:, image: fixture_file_upload('image1.jpg', 'image/jpeg') }
    @searching_attrs = { title:, description:, category_id: }
    @another_user_bulletin = bulletins(:draft_bulletin)
  end

  test 'should get index' do
    get root_url
    assert_response :success
  end

  test 'should show bulletin' do
    get bulletin_url(bulletins(:published_bulletin))
    assert_response :success
  end

  test 'should not show unpublished bulletin' do
    get bulletin_url @bulletin
    assert_redirected_to root_url
  end

  test 'should show unpublished bulletin to owner' do
    sign_in @user
    get bulletin_url @bulletin
    assert_response :success
  end

  test 'should show unpublished bulletin to admin' do
    sign_in users(:admin)
    get bulletin_url @bulletin
    assert_response :success
  end

  test 'should get new' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'should create bulletin' do
    sign_in @user
    post bulletins_url, params: { bulletin: @attrs }
    bulletin = @user.bulletins.find_by(@searching_attrs)

    assert { bulletin }
    assert_redirected_to profile_url
  end

  test 'should get edit' do
    sign_in @user
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'should update bulletin' do
    sign_in @user
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    bulletin = Bulletin.find_by(@searching_attrs)
    assert { bulletin }
    assert_redirected_to profile_url
  end

  test 'should not update another user bulletin' do
    sign_in @user
    patch bulletin_url(@another_user_bulletin), params: { bulletin: @attrs }

    bulletin = Bulletin.find_by(@searching_attrs)
    assert { !bulletin }
    assert_redirected_to root_url
  end

  test 'should not update bulletin without login' do
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    bulletin = Bulletin.find_by(@searching_attrs)
    assert { !bulletin }
    assert_redirected_to root_url
  end

  test 'should archive bulletin' do
    sign_in @user
    patch archive_bulletin_url(@bulletin)
    @bulletin.reload

    assert_redirected_to profile_path
    assert { @bulletin.archived? }
  end

  test 'should not archive another user bulletin' do
    sign_in(@user)
    patch archive_bulletin_url(@another_user_bulletin)
    @another_user_bulletin.reload

    assert_redirected_to root_url
    assert { @another_user_bulletin.draft? }
  end

  test 'should moderate bulletin' do
    sign_in @user
    patch moderate_bulletin_url(@bulletin)
    @bulletin.reload

    assert_redirected_to profile_path
    assert { @bulletin.under_moderation? }
  end

  test 'should not moderate another user bulletin' do
    sign_in(@user)
    patch moderate_bulletin_url(@another_user_bulletin)
    @another_user_bulletin.reload

    assert_redirected_to root_url
    assert { @another_user_bulletin.draft? }
  end
end
