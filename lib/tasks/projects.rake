require 'dotenv/tasks'
require 'tenk/client'

namespace :projects do
  desc 'Fetch a list of users and their projects from 10,000ft'
  task fetch: [:dotenv, :environment] do
    FetchProjects.new.call
  end
end
