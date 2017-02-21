class Ability
  include CanCan::Ability

  def initialize(user)
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

    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
      can :manage, Role
      can :masquerade, User
      cannot :masquerade, User, :role_id => Role.where(name: ["admin","support"]).pluck(:id)
    elsif user.has_role? :support
      can :read, :admin
      can :manage, User
      can :masquerade, User
      cannot [:update, :destroy, :create], User, :role_id => Role.where(name: ["admin"]).pluck(:id)
      cannot :masquerade, User, :role_id => Role.where(name: ["admin","support"]).pluck(:id)
      can :manage, Role
      cannot :manage, Role, :name => 'admin'
      can :read, Role
      can :manage, EmailRedirectAccount
      can :manage, EmailSourceAccount
      can :manage, Alias
      can :manage, PostfixBlacklist
      can :manage, Ml::List
      can :manage, Ml::ListsUser
      can :manage, Ml::ExternalEmail
    end

    if user.persisted?
      can [:read, :setup, :manage_suscribtion, :create_google_apps], User, :id => user.id if user.is_gadz_cached?
      can :read_dashboard, User, :id => user.id if user.is_gadz_cached?
      can [:create, :read, :update, :destroy], EmailRedirectAccount, :user_id => user.id
      can :show, EmailSourceAccount, :user_id => user.id
      can :suscribe, Ml::List, :id => (user.lists_allowed(true).pluck(:id) + user.lists.pluck(:id))
      can :read, Ml::List, :id => (user.lists_allowed(true).pluck(:id) + user.lists.pluck(:id))
      can :admin_members, Ml::List, :id => user.ml_lists_users_admins.pluck(:list_id)
      can :destroy, Ml::ExternalEmail, :list_id => user.ml_lists_users_admins.pluck(:list_id)
      can :moderate_messages, Ml::List, :id => user.ml_lists_users_moderators.pluck(:list_id)
      can :destroy, Ml::ListsUser, :role => [1,2,3,4], :user_id => user.id
      can :destroy, Ml::ListsUser, :list_id => user.ml_lists_users_admins.pluck(:list_id)
    end

  end
end



    
