# frozen_string_literal: true

require 'test_helper'

class BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    title = Faker::Lorem.paragraph_by_chars(number: 50)
    description = Faker::Lorem.paragraph_by_chars(number: 1000)
    category_id = categories(:one).id
    @attrs = {
      title:,
      description:,
      category_id:,
      image: fixture_file_upload('auto/image1.jpg', 'image/jpeg')
    }
    @searching_attrs = { title:, description:, category_id: }
  end

  test 'should get index' do
    get root_url
    assert_response :success
  end

  test 'should get new' do
    sign_in users(:one)
    get new_bulletin_url
    assert_response :success
  end

  test 'should not get new without login' do
    get new_bulletin_url
    assert_redirected_to root_url
  end

  test 'should create bulletin' do
    sign_in users(:one)
    post bulletins_url, params: { bulletin: @attrs }
    bulletin = Bulletin.find_by(@searching_attrs.merge(user_id: current_user.id))

    assert { bulletin }
    assert_redirected_to root_url
  end

  test 'should not create bulletin without login' do
    post bulletins_url, params: { bulletin: @attrs }

    bulletin = Bulletin.find_by(@searching_attrs)

    assert { bulletin.nil? }
    assert_redirected_to root_url
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success
  end
end
