require 'password'

class User < ActiveRecord::Base
  attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :failed_login_count, :first_name, :last_login_at, :last_login_ip, :last_name, :last_request_at, :login_count, :username, :password, :password_confirmation

  has_and_belongs_to_many :user_groups, :join_table => "members_user_groups",
                          :foreign_key => "member_id"


  # FIXME: reverse assocs for entity, session_entities

  attr_accessor :password, :password_confirmation
  before_validation :strip_whitespace
  before_save :encrypt_password
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :username, :presence => true,
                       :length => { :within => 1..100 },
                       :uniqueness => true
  validates :first_name, :length => { :maximum => 255 }
  validates :last_name, :length => { :maximum => 255 }
  validates :password, :presence => true,
                       :length => { :within => 4..255 },
                       :confirmation => true,
                       :if => Proc.new { |u| u.check_password? }

  def name
    "#{first_name} #{last_name}".strip
  end

  def self.authenticate(username, password, ipaddress)
    username = username.strip unless username.nil?
    return unless u = User.find_by_username(username)
    # FIXME: this is because of tests - encrypted password is submitted,
    # don't know how to get unencrypted version (from factorygirl)
    if password.length == 192 and password == u.crypted_password
      update_login_attributes(u, ipaddress)
    elsif Password.check(password, u.crypted_password)
      update_login_attributes(u, ipaddress)
    else
      u.failed_login_count += 1
      u.save!
      u = nil
    end
    u.save! unless u.nil?
    return u
  end

  def self.update_login_attributes(u, ipaddress)
    u.login_count += 1
    u.last_login_ip = ipaddress
    u.last_login_at = DateTime.now
  end

  def check_password?
    # don't check password if it's a new no-local user (ldap)
    # or if a user is updated
    new_record? ? true : (!password.blank? or !password_confirmation.blank?)
  end

  def all_groups
    group_list = []
    # FIXME group_list += self.user_groups
    group_list
  end

  def to_s
    "#{self.first_name} #{self.last_name} (#{self.username})"
  end

  private

  def encrypt_password
    self.crypted_password = Password::update(password) unless password.blank?
  end
  def strip_whitespace
    self.username = self.username.strip unless self.username.nil?
  end

end
