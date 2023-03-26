# frozen_string_literal: true

# == Schema Information
#
# Table name: bulletins
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_bulletins_on_category_id  (category_id)
#  index_bulletins_on_user_id      (user_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#  user_id      (user_id => users.id)
#
class Bulletin < ApplicationRecord
  belongs_to :category, inverse_of: :bulletins
  belongs_to :user, inverse_of: :bulletins
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validates :title, :description, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
  validates :image, attached: true, presence: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  scope :by_creation_date_desc, -> { order(created_at: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id title]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[by_creation_date_desc]
  end
end
