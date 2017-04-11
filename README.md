# Harvester

Simple Rails app used to consolidate timesheet reports for shared projects across multiple Harvest accounts.

## Installation

```sh
$ bundle install
$ rails db:migrate
```
Create local database `harvester_development`

Rename `config/application.yml.example` to `config/application.yml` and fill in Harvest account info.

Ex:
```yml
harvest_mycompany_subdomain: myharvestsubdomain
harvest_mycompany_username:
harvest_mycompany_password:
harvest_mycompany_project_id: '<grab id from project url>'

harvest_partner_subdomain: mypartnersharvestsubdomain
harvest_partner_username:
harvest_partner_password:
harvest_partner_project_id: '<grab id from partner project url>'

```

Make sure prefixes in `sync_service.rb` match your ENV var prefix names:
```rb
# app/services/sync_service.rb

ORGANIZATION_ENV_PREFIXES = %w(harvest_mycompany harvest_partner)

```

Seed you Organizations:
```sh
$ rails db:seed
```

Sync you Harvest data:
```sh
$ rails sync:all
```

Open your app: http://harvester.dev


# Deploying to Heroku

```sh
$ heroku create
$ heroku ps:scale web=1

# Import config vars from yml
$ figaro heroku:set -e production

# Verify config vars are set
$ heroku config

$ git push heroku master
$ heroku run rake db:migrate
$ heroku run rake db:seed
$ heroku run rake sync:all
$ heroku open
```
