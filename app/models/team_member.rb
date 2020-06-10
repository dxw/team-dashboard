class TeamMember < ApplicationRecord
  has_many :assignments
  has_many :projects, through: :assignments
  has_many :support_days

  validates_presence_of :first_name
  validates_uniqueness_of :tenk_id

  ROLES = {
    "Development" => "Developer",
    "Delivery" => "Delivery Lead",
    "Research" => "User Researcher",
    "Service Design" => "Service Designer",
    "Design" => "Designer",
    "Operations Engineering" => "Operations Engineer",
    "Strategy" => "Strategist",
    "Technical Architecture" => "Technical Architect",
    "Product" => "Product Manager",
    "Content" => "Creative Writer",
    "Hackers" => "Ethical Hacker",
  }.freeze

  def name
    return first_name if last_name.blank? || first_name_unique?

    disambiguated_name
  end

  def first_name_unique?
    TeamMember.where(first_name: first_name).count == 1
  end

  def disambiguated_name
    "#{first_name} #{last_name[0]}".strip
  end

  def job_title
    if ROLES.key?(discipline)
      ROLES[discipline]
    else
      discipline
    end
  end

  def delivery_first
    discipline == "Delivery" ? 0 : 1
  end

  def self.delivery_first(team_members)
    team_members.sort_by { |tm| [ tm.delivery_first, tm.name.downcase ] }
  end
end
