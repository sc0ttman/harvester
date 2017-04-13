# Harvester

Simple Rails app used to consolidate timesheet reports for shared projects across multiple Harvest accounts.

## Installation

```sh
$ bundle install
```
Create local database `harvester_development`
```sh
$ rails db:migrate
```

Rename `config/application.yml.example` to `config/application.yml` and fill in Harvest account info.
```yml
# Follow the naming convention: "harvest_<namewithoutspaces>_<config_var>"
harvest_mycompany_subdomain: myharvestsubdomain
harvest_mycompany_username:
harvest_mycompany_password:
harvest_mycompany_project_id: '<grab id from project url>'

harvest_partner_subdomain: mypartnersharvestsubdomain
harvest_partner_username:
harvest_partner_password:
harvest_partner_project_id: '<grab id from partner project url>'

harvest_anotherpartner_subdomain: ...

```
<sup>Note: Try restarting Spring if changes aren't taking effect: `$ spring stop`</sup>

Seed your Organizations and Admin users:
```sh
$ rails db:seed
```

Sync the Harvest data:
```sh
$ rails sync:all # This will create a job in Sidekiq but should be picked up right away
```

Open your app: http://harvester.dev


# Deploying to Heroku

You must first install the addons:
* [Redis add-on](https://elements.heroku.com/addons/heroku-redis)
* [Postgress add-on](https://elements.heroku.com/addons/heroku-postgresql) (This might be installed automaically)

```sh
$ heroku create
$ heroku ps:scale web=1

# Import config vars from yml
$ figaro heroku:set -e production

# Verify config vars are set (Harvest accounts, REDIS_URL, DATABASE_URL)
$ heroku config

$ git push heroku master
$ heroku run rake db:migrate
$ heroku run rake db:seed
$ heroku run rake sync:all
$ heroku open
```
