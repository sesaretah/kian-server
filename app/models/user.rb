class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable#, :trackable
  has_one :profile

  #has_many :notifications, :dependent => :destroy
  #has_many :devices, :dependent => :destroy
  

  def assign(role_id)
    self.assignments = [] if self.assignments.blank?
    self.assignments << role_id
    self.save
  end

  def unassign(role_id)
    self.assignments -= [role_id] if !self.assignments.blank?
    self.save
  end

  def selected_role
    Role.find_by_id(self.current_role_id)
  end

  def ability
    self.selected_role.ability if self.selected_role
  end

  def has_ability(ab)
    flag = false
    if !self.selected_role.blank? && !self.selected_role.ability.blank?
      for a in self.selected_role.ability
        flag = true if a['title'] == ab
      end
    end
    return flag
  end

  def notify_user
    code = rand(10 ** 6).to_s.rjust(6,'0')  
    self.last_code = code
    self.last_code_datetime = DateTime.now
    self.last_login = DateTime.now
    self.save
    VerificationsMailer.notify_email(self.id, code).deliver_later
  end

  def self.verify(code)
    user = self.where('last_code = ? AND last_code_datetime > ?', code, 10.minutes.ago).first
  end


  
end
