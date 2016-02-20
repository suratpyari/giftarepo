class Claim < ActiveRecord::Base
  belongs_to :repo
  belongs_to :user

  validates :repo, :user, presence: true
  validates :repo, uniqueness: {scope: :user}
end
