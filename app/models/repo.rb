class Repo < ActiveRecord::Base
  STATUS = ["gifted", "approved", "forked", "completed"]
  attr_accessor :tnc
  belongs_to :user
  belongs_to :gifted_to, class_name: "User"
  has_many :claims, dependent: :destroy

  validates :user, :title, :url, :description, :languages, presence: true
  validates :url, uniqueness: true
  validates :tnc, acceptance: true

  validate :check_git_user

  scope :my, -> (user) { where("repos.user_id = :user OR gifted_to_id = :user OR claims.user_id = :user", user: user.id).eager_load(:claims) }
  scope :gifted, -> {where(status: "gifted")}
  scope :not_complated, -> {where("status != 'completed'")}
  scope :not_mine, -> (user) { gifted.where("repos.user_id != :user AND gifted_to_id != :user AND claims.user_id = :user", user: user.id).eager_load(:claims) }

  STATUS.each do |s|
    define_method s+"?" do
      self.status == s
    end
  end


  def check_git_user
    repos = Github::Client::Repos.new.list user: user.username
    github_repo = repos.select{|x| x.html_url == self.url}.first
    self.errors.add(:base, "repository does not belongs to you") if github_repo.nil?
  end
end
