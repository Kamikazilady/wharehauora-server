class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    owned_by_current_user?
  end

  def new?
    user.present?
  end

  def edit?
    owned_by_current_user?
  end

  def show?
    owned_by_current_user?
  end

  def update?
    owned_by_current_user?
  end

  def destroy?
    owned_by_current_user?
  end

  private

  class Scope
    attr_reader :user, :scope
    def resolve
      raise 'Policy Scope not defined'
      # scope.all if user && user.role?("janitor")
      # scope.where(owner_id: user.id)
    end

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
  end

  def owned_by_current_user?
    record.owner_id == user.id
  end
end
