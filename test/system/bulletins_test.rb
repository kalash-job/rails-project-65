# frozen_string_literal: true

require 'application_system_test_case'

class BulletinsTest < ApplicationSystemTestCase
  setup do
    @bulletin_params = {
      title: Faker::Lorem.paragraph_by_chars(number: 40),
      description: Faker::Lorem.paragraph_by_chars(number: 200),
      file: 'test/fixtures/files/image1.jpg'
    }
  end

  test 'visiting the index' do
    visit root_url

    assert_selector 'h2', text: 'Объявления'
  end

  test 'visiting the show' do
    visit root_url
    find(:xpath, "//div [@class='card-body']/a").click

    assert_selector '#bulletin_title'
  end

  test 'should create bulletin' do
    sign_in users(:one).id
    visit root_url

    click_on 'Добавить'

    fill_in('bulletin_title', with: @bulletin_params[:title])
    fill_in('bulletin_description', with: @bulletin_params[:description])
    all('select#bulletin_category_id option').last.select_option
    attach_file('bulletin_image', @bulletin_params[:file])

    click_on 'Добавить объявление'

    assert_text 'Объявление было создано успешно'
  end

  test 'should update bulletin' do
    sign_in users(:one).id
    visit profile_url

    click_on 'Редактировать', match: :first

    fill_in('bulletin_title', with: @bulletin_params[:title])
    fill_in('bulletin_description', with: @bulletin_params[:description])
    all('select#bulletin_category_id option').last.select_option
    attach_file('bulletin_image', @bulletin_params[:file])

    click_on 'Обновить объявление'

    assert_text 'Объявление было обновлено успешно'
  end

  test 'should send to moderation bulletin' do
    sign_in users(:one).id
    visit profile_url
    click_on 'Модерировать', match: :first

    assert_text 'Объявление отправлено на модерацию'
  end

  test 'should archive bulletin' do
    sign_in users(:one).id
    visit profile_url

    accept_confirm('Подтвердить архивирование') do
      click_on 'Архивировать', match: :first
    end

    assert_text 'Объявление отправилось в архив'
  end
end
