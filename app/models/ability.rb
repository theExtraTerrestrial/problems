class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new
    can :read, ActiveAdmin::Page, :page => 'Dashboard'

    if user.role.name.downcase == 'admin'
        can :manage, :all
    elsif user.role.name.downcase == 'darbinieks'
        can :read, :all
        cannot :manage, ActiveAdmin::Comment
        can :manage, ActiveAdmin::Comment, author_id: user.id
        can :manage, Task, creator_id: user.id
        can :manage, TaskImage
        can [:read, :update], AdminUser, id: user.id
        cannot [:create, :destroy], AdminUser
        cannot :manage, Category
        cannot :manage, Company
        cannot :manage, Setting
    else 
        cannot :manage, :all
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
