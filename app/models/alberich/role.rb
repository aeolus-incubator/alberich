#
#   Copyright 2012 Red Hat, Inc.
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

module Alberich
  class Role < ActiveRecord::Base
    VALID_SCOPES = ["Alberich::BasePermissionObject"] + Alberich.permissioned_object_classes
    #FIXME has_many :permissions, :dependent => :destroy
    #FIXME has_many :derived_permissions, :dependent => :destroy
    has_many :privileges, :dependent => :destroy

    attr_accessible :name, :assign_to_owner, :scope

    validates_presence_of :scope
    validates_presence_of :name
    validates_uniqueness_of :name

    validates_associated :privileges

    validates_length_of :name, :maximum => 255
    validates_inclusion_of :scope, :in => VALID_SCOPES
    def privilege_target_types
      privileges.collect {|x| Kernel.const_get(x.target_type)}.uniq
    end
    def privilege_target_match(obj_type)
      (privilege_target_types & obj_type.active_privilege_target_types).any?
    end

    def self.all_by_scope
      roles = self.all
      role_hash = {}
      roles.each do |role|
        role_hash[role.scope] ||= []
        role_hash[role.scope] << role
      end
      role_hash
    end

  end

end
