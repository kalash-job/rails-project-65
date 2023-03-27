class UpdateAdminForUser < ActiveRecord::Migration[7.0]
  def change
    User.find_by(email: 'kalash-job@yandex.ru').update(admin: true)
  end
end
