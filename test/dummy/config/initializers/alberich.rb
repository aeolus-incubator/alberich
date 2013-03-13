Alberich.user_class = "User"
Alberich.groups_for_user_method = "all_groups"
Alberich.user_group_class = "UserGroup"
Alberich.permissioned_object_classes = ["StandaloneResource",
                                        "ParentResource",
                                        "ChildResource"]
Alberich.additional_privilege_scopes = ["User", "GlobalResource"]

Alberich.require_user_method = "require_user"

ActiveSupport.on_load(:action_controller) do
  ActionController::Base.send(:include, Alberich::ApplicationControllerHelper)
end
