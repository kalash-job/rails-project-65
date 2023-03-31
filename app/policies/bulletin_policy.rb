# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def update?
    owner?
  end

  def moderate?
    owner?
  end

  def archive?
    owner?
  end

  private

  def owner?
    user&.id == record.user.id
  end
end
