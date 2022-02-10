# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :pundit_user, :record

  def initialize(pundit_user, record)
    @user = pundit_user.user
    @account = pundit_user.account
    @record = record
  end

  # Handled by authorization
  def index?
    false
  end

  def show?
    owner?
  end

  # Handled by authorization
  def create?
    false
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(pundit_user, scope)
      @user = pundit_user.user
      @account = pundit_user.account
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :pundit_user, :scope

  end

  private


  def owner?
    return @record == @account if @record.instance_of?(Account)
    return @record.account == @account if @record&.account

    false
  end
end
