require 'dotenv/tasks'
require 'support_rota_client'

namespace :support_rotations do
  desc "Fetch from dxw-support-rota directly into SupportDay"
  task fetch_all_support_lines: [:dotenv, :environment] do
    SupportDay.destroy_all
    FetchSupportRotations.new.call
  end
end
