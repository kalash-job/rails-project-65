# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def admin?
    user&.admin?
  end
end
