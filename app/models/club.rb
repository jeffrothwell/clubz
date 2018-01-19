class Club < ActiveRecord::Base
  belongs_to :user

  def self.allowed
    ["wizard", "hobbit"]
  end

  def self.banned
    ["droids", "gangster"]
  end
end
