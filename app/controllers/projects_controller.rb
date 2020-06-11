class ProjectsController < ApplicationController
  def index
    @projects = Project.select(&:active?)
  end
end
