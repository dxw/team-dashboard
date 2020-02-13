dashboard = Project.create(name: "Dashboard_project")
TeamMember.create(name: "Joe", project: dashboard)

puts "Fake data created"
