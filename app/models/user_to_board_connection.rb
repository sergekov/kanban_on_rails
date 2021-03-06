class UserToBoardConnection < ActiveRecord::Base
  belongs_to :user

  belongs_to :board

  validates :role, :presence => true, :inclusion => ['owner', 'member', 'manager']
end
