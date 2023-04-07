# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    record.published? || owner? || admin?
  end

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
    user&.id == record.user_id
  end
end
