server "ec2-16-170-170-154.eu-north-1.compute.amazonaws.com",
       user: "ubuntu",
       ssh_options: {
         forward_agent: true,
       }

# role :app, %w{deploy@16.170.170.154}
# set :ssh_options, {
#   keys: %w(~/.ssh/real_estate_ads_analyzer.pem),
#   forward_agent: true,
#   auth_methods: %w(publickey password)
# }
