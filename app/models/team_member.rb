class TeamMember < ApplicationRecord
  has_many :assignments
  has_many :projects, through: :assignments

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
    "Product" => "Product Manager"
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
end
