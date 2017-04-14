# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Build Organizations from secret ENV settings.
SyncService.organization_prefixes.each do |env_prefix|
  settings = SyncService.env_vars_from_prefix(env_prefix)
  puts "creating org from prefix: #{env_prefix.sub('harvest_','').titleize} settings: #{settings}"
  org = Organization.where(code: env_prefix).first_or_create( name: env_prefix.sub('harvest_','').titleize, code:env_prefix, harvest_project: settings[:project_id],
        harvest_subdomain: settings[:subdomain], harvest_username: settings[:username], harvest_password: settings[:password] )

end

# Create admins
email = 'admin@test.com'
user = Admin.where(email: email).first_or_create(email: email, password: 'password', password_confirmation: 'password')
