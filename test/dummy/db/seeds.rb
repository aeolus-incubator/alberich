# created admin user admin/password
user = User.find_by_username("admin")
unless user
  user = User.new(:username => "admin", :email => "admin@example.com",
                  :password => "password",
                  :password_confirmation => "password",
                  :first_name => "Admin",
                  :last_name  => "User")
  user.save!
end

# Create default roles
VIEW = "view"
USE  = "use"
MOD  = "modify"
CRE  = "create"
VPRM = "view_perms"
GPRM = "set_perms"
roles =
  {
    StandaloneResource =>
      {"StandaloneResource User" => [false, {StandaloneResource => [VIEW,USE]}],
       "StandaloneResource Owner"=> [true,  {StandaloneResource => [VIEW,USE,MOD,    VPRM,GPRM]}]},
   ChildResource =>
      {"ChildResource User" => [false, {ChildResource => [VIEW,USE]}],
       "ChildResource Owner"=> [true,  {ChildResource => [VIEW,USE,MOD,    VPRM,GPRM]}]},
   ParentResource =>
      {"ParentResource User" => [false, {ParentResource => [VIEW,USE],
                                         ChildResource  => [             CRE]}],
       "ParentResource Owner"=> [true,  {ParentResource => [VIEW,USE,MOD,    VPRM,GPRM],
                                         ChildResource  => [VIEW,USE,MOD,CRE,VPRM,GPRM]}]},
   Alberich::BasePermissionObject =>
    {"Site Admin" => [false, {User         => [VIEW,    MOD,CRE,VPRM,GPRM],
                              GlobalResource => [VIEW,    MOD,CRE,VPRM,GPRM],
                              StandaloneResource => [VIEW,USE,MOD,CRE,VPRM,GPRM],
                              ParentResource     => [VIEW,USE,MOD,CRE,VPRM,GPRM],
                              ChildResource      => [VIEW,USE,MOD,CRE,VPRM,GPRM],
        Alberich::BasePermissionObject    => [VIEW,USE,MOD,CRE,VPRM,GPRM]}]}}
Alberich::Role.transaction do
  roles.each do |role_scope, scoped_hash|
    scoped_hash.each do |role_name, role_def|
      role = Alberich::Role.find_or_initialize_by_name(role_name)
      role.update_attributes({:name => role_name, :scope => role_scope.name,
                               :assign_to_owner => role_def[0]})
      role.save!
      role_def[1].each do |priv_type, priv_actions|
        priv_actions.each do |action|
          Alberich::Privilege.create!(:role => role,
                                      :target_type => priv_type.name,
                                      :action => action)
        end
      end
    end
  end
end

#Assign global admin privileges to admin user
if Alberich::Permission.count == 0
  Alberich::Permission.create(:entity => Alberich::Entity.for_target(user),
                              :role =>
                                Alberich::Role.find_by_name("Site Admin"),
                              :permission_object =>
                                Alberich::BasePermissionObject.
                                general_permission_scope)
end
