# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  admin      :boolean          default(FALSE)
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :bulletins, inverse_of: :user, dependent: :destroy
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
