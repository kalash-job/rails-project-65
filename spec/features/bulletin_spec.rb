# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Bulletins', type: :feature do
  fixtures :bulletins, :users

  let(:bulletin_params) do
    {
      title: Faker::Lorem.paragraph_by_chars(number: 40),
      description: Faker::Lorem.paragraph_by_chars(number: 200),
      file: 'test/fixtures/files/image1.jpg'
    }
  end

  scenario 'visitor can see bulletins' do
    visit root_path
    expect(page).to have_selector('h2', text: 'Объявления')
  end

  scenario 'visitor can see bulletin' do
    visit root_path
    find(:xpath, "//div [@class='card-body']/a").click
    expect(page).to have_selector('#bulletin_title')
  end

  scenario 'user can create bulletin' do
    sign_in_by_id users(:one).id
    visit root_path
    click_on 'Добавить'

    fill_in('bulletin_title', with: bulletin_params[:title])
    fill_in('bulletin_description', with: bulletin_params[:description])
    all('select#bulletin_category_id option').last.select_option
    attach_file('bulletin_image', bulletin_params[:file])
    click_on 'Добавить объявление'
    expect(page).to have_content('Объявление было создано успешно')
  end

  scenario 'user can update bulletin' do
    sign_in_by_id users(:one).id
    visit profile_path
    click_on 'Редактировать', match: :first

    fill_in('bulletin_title', with: bulletin_params[:title])
    fill_in('bulletin_description', with: bulletin_params[:description])
    all('select#bulletin_category_id option').last.select_option
    attach_file('bulletin_image', bulletin_params[:file])
    click_on 'Обновить объявление'
    expect(page).to have_content('Объявление было обновлено успешно')
  end

  scenario 'user can send to moderation bulletin' do
    sign_in_by_id users(:one).id
    visit profile_path
    click_on 'Модерировать', match: :first
    expect(page).to have_content('Объявление отправлено на модерацию')
  end

  context 'For scenarios with js using but Signing in without js using.' do
    before do
      sign_in_by_id users(:one).id
      visit profile_path
    end

    scenario 'user can archive bulletin', driver: :selenium_chrome_headless do
      accept_confirm('Подтвердить архивирование') do
        click_on 'Архивировать', match: :first
      end
      expect(page).to have_content('Объявление отправилось в архив')
    end
  end
end
