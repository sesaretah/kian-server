class Principal < ApplicationRecord
  validate :check_unique, :on => :save

  def check_unique
    if Principal.where(principal_id: self.principal_id).any?
      return false
    else
      return true
    end
  end
end
