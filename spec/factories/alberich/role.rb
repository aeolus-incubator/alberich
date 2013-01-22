#
#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

FactoryGirl.define do
  factory :role, :class => Alberich::Role do
    sequence(:name) { |n| "role#{n}" }
    scope 'Alberich::BasePermissionObject'
  end

  factory :admin_role, :parent => :role do
    name 'Site Admin'
    after(:create) do |role, evaluator|
      priv_data = [["Alberich::BasePermissionObject", "create"],
                   ["Alberich::BasePermissionObject", "modify"],
                   ["Alberich::BasePermissionObject", "use"],
                   ["Alberich::BasePermissionObject", "set_perms"],
                   ["Alberich::BasePermissionObject", "view_perms"],
                   ["Alberich::BasePermissionObject", "view"],
                   ["User", "view_perms"],
                   ["User", "set_perms"],
                   [ "User", "view"],
                   [ "User", "create"],
                   ["User", "modify"]]
      priv_data.each do |target_type, action|
        FactoryGirl.create(:privilege, :target_type => target_type,
                           :action => action, :role_id => role.id)
      end
    end
  end
end
