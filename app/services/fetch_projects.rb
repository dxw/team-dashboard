class FetchProjects
  def call
    users.each do |user|
      puts user.display_name
      team_member = create_team_member(user)

      assignments = get_user_assignment(user)

      assignments.each do |assignment|
        create_projects(assignment, team_member)
      end

      team_member.save!
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
    team_member
  end

  private def create_projects(assignment, team_member)
    puts "Assignable id: #{assignment.assignable_id}"

    assignable_project = projects[assignment.assignable_id]
    while assignable_project.parent_id
      puts "#{assignable_project.name} (#{assignable_project.id}), phase of #{assignable_project.parent_id}"
      assignable_project = projects[assignable_project.parent_id]
    end

    puts "#{projects[assignable_project.id].tags&.data&.map(&:value)};"

    if assignable_project.name
      unless assignable_project.tags.data.any? { |custom_field| custom_field.has_value?("cyber")  }
        project = Project.find_or_initialize_by(tenk_id: assignable_project.id)

        project.attributes = {
          name: assignable_project.name,
          starts_at: assignable_project.starts_at,
          ends_at: assignable_project.ends_at,
          client: assignable_project.client,
          archived: assignable_project.archived
        }
        project.save!

        team_member.projects << project unless team_member.projects.include?(project)
      end
    end
  end

  private def get_user_assignment(user)
    assignments = tenk.users.assignments.list(
      user.id,
      from: Date.yesterday,
      to: Date.tomorrow,
    ).data
  end
end
