class FetchProjects
  def call
    users.each do |user|
      puts user.display_name
      team_member = create_team_member(user)

      team_member.assignments.destroy_all

      tenk_assignments = current_tenk_assignments(user)
      tenk_assignments.each do |tenk_assignment|
        create_assignment(tenk_assignment, team_member)
      end
    end
  end

  private def tenk
    @tenk = Tenk.new(
      user_id: ENV.fetch('TENK_USER_ID'),
      password: ENV.fetch('TENK_PASSWORD'),
    )
  end

  private def users
    tenk.users.list(per_page: 100).data
  end

  private def projects
    Hash.new { |hash, project_id|
      hash[project_id] = tenk.projects.get(project_id)
    }
  end

  private def create_team_member(user)
    team_member = TeamMember.find_or_initialize_by(tenk_id: user.id)
    team_member.attributes = {
      first_name: user.first_name.strip,
      last_name: user.last_name&.strip,
      email: user.email&.downcase&.strip,
      discipline: user.discipline&.strip,
      thumbnail: user.thumbnail,
      billable: user.billable
    }
    team_member.save!
    team_member
  end

  private def create_assignment(tenk_assignment, team_member)
    puts "Assignable id: #{tenk_assignment.assignable_id}"

    tenk_project = projects[tenk_assignment.assignable_id]
    return unless tenk_project.id

    puts "Project #{tenk_project.name} (#{tenk_project.id})"

    while tenk_project.parent_id
      tenk_project = projects[tenk_project.parent_id]
      puts "\tis a phase of project #{tenk_project.name} (#{tenk_project.id})"
    end

    puts "Tags: #{tenk_project.tags.data.map(&:value)}"

    unless tenk_project.tags.data.any? { |custom_field| custom_field.has_value?("cyber")  }
      project = create_or_update_project(tenk_project)

      team_member.assignments.create(project: project) unless team_member.projects.include?(project)
    end
  end

  private def create_or_update_project(tenk_project)
    project = Project.find_or_initialize_by(tenk_id: tenk_project.id)

    project.attributes = {
      name: tenk_project.name,
      starts_at: tenk_project.starts_at,
      ends_at: tenk_project.ends_at,
      client: tenk_project.client,
      archived: tenk_project.archived
    }
    project.save!
    project
  end

  private def current_tenk_assignments(user)
    tenk.users.assignments.list(
      user.id,
      from: Date.yesterday,
      to: Date.tomorrow,
    ).data
  end
end
