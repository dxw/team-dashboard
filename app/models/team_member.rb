class TeamMember < ApplicationRecord
  belongs_to :project, optional: true
  validates_presence_of :first_name
  validates_uniqueness_of :tenk_id

  def name
    first_name
  end

  def job_title
    if discipline == "Development"
      "Developer"
    elsif discipline == "Delivery"
      "Delivery Lead"
    elsif discipline == "Research"
      "Researcher"
    elsif discipline == "Service Design"
      "Service Designer"
    elsif discipline == "Design"
      "Designer"
    elsif discipline == "Operations Engineering"
      "Operations Engineer"
    elsif discipline == "Strategy"
      "Strategist"
    elsif discipline == "Technical Architecture"
      "Technical Architect"
    elsif discipline == "Product"
      "Product Manager"
    else
      discipline
    end
  end
end
