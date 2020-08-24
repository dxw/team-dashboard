class FetchProjects
  def call
    users.each do |user|
      puts user.display_name
      team_member = create_team_member(user)

      team_member.assignments.destroy_all

      assignments = current_user_assignments(user)
      assignments.each do |assignment|
        create_assignment(assignment, team_member)
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
      first_name: user.first_name,
      last_name: user.last_name,
      discipline: user.discipline,
      thumbnail: user.thumbnail,
      billable: user.billable
    }
    team_member.save!
    team_member
  end

  private def create_assignment(assignment, team_member)
    puts "Assignable id: #{assignment.assignable_id}"

    assignable_project = projects[assignment.assignable_id]
    return unless assignable_project.id

    puts "Project #{assignable_project.name} (#{assignable_project.id})"

    while assignable_project.parent_id
      assignable_project = projects[assignable_project.parent_id]
      puts "\tis a phase of project #{assignable_project.name} (#{assignable_project.id})"
    end

    puts "Tags: #{assignable_project.tags.data.map(&:value)}"

    unless assignable_project.tags.data.any? { |custom_field| custom_field.has_value?("cyber")  }
      project = create_or_update_project(assignable_project)

      team_member.assignments.create(project: project) unless team_member.projects.include?(project)
    end
  end

  private def create_or_update_project(assignable_project)
    project = Project.find_or_initialize_by(tenk_id: assignable_project.id)

    project.attributes = {
      name: assignable_project.name,
      starts_at: assignable_project.starts_at,
      ends_at: assignable_project.ends_at,
      client: assignable_project.client,
      archived: assignable_project.archived
    }
    project.save!
    project
  end

  private def current_user_assignments(user)
    tenk.users.assignments.list(
      user.id,
      from: Date.yesterday,
      to: Date.tomorrow,
    ).data
  end
end
