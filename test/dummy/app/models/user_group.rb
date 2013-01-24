class UserGroup < ActiveRecord::Base
  attr_accessible :description, :name

  has_and_belongs_to_many :members, :join_table => "members_user_groups",
                                    :class_name => "User",
                                    :association_foreign_key => "member_id"


  def to_s
    self.name
  end
end
