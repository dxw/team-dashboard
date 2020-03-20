# Team Dashboard

A rails application which pulls the projects people are working on from 10,000ft
and displays them on a nice screen.

## Starting Developing

### Environment variables

Copy the`.env.example` file to `.env` and fill in the `TENK_USER_ID` and
`TENK_PASSWORD` credentials. You can find these in 1Password for the
`utilisation.dashboard@dxw.com` user.

### Prerequisites

To install prerequisites run `bundle install`

#### Github Personal Access Token

When you run `bundle install` for the first time you may be prompted for a
Github username and password.

Use your own username, and use a [Personal Access
Token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)
instead of your password.

### Database migrations

If this if your first time setting up the application, run `bin/rake db:setup`.

To bring your database up to the latest version if you already have one set up
run `bin/rake db:migrate`.

## Downloading the latest data

Once you've set up your `.env` file and run the necessary database migrations,
you can download the latest data with `bin/rake projects:fetch`.

All data within the database is recreated from 10,000ft as necessary. You can
return to an empty database if necessary with `bin/rake db:reset` and then
re-import the data.

## Running the server

Run `bin/rails s` and the server should be accessible at
`http://localhost:3000`.
