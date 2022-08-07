server "ec2-16-170-170-154.eu-north-1.compute.amazonaws.com",
       user: "ubuntu",
       ssh_options: {
         forward_agent: true,
       }

namespace :deploy do
  desc "Update crontab with whenever"
  task :update_cron do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  after :finishing, 'deploy:update_cron'
end