class UpdateAdminForUser < ActiveRecord::Migration[7.0]
  def change
    # Rollback this migration and then, after this user registration, migrate it again
    user = User.find_by(email: 'kalash-job@yandex.ru')
    user.update(admin: true) unless user.nil?
  end
end
