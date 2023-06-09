# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :bulletins, inverse_of: :category, dependent: :restrict_with_error

  validates :name, presence: true

  scope :by_id_asc, -> { order(id: :asc) }
end
