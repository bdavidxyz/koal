# README

Minimalistic Rails 8 app.

- Responsive navbar
- Tailwind 4
- Sign in screen
- Sign up screen
- Debugbar locally
- Custom Google Font
- Cohesive design system
- Pre-built landing page
- Unpoly
- Build-in toast solution both for frontend and backend

## Prerequisites

- Git
- PostGre
- NodeJS >= 22
- Ruby >= 3.2.2

## Installation

- git clone `git@github.com:bdavidxyz/koal.git`
- cd koal
- rename "koal" to "myapp" in the whole application
- rename the "koal" files to "myapp"
- bundle install
- npm install
- create .env file (see below)
- RAILS_ENV=development bin/rails db:create db:migrate db:seed
- DATABASE_URL="postgres://localhost:5432/koal_test" RAILS_ENV=test bin/rails db:create
- bin/dev

The app should be displayed at localhost:3000

## Authorize a given controller's action

- A Rails controller action that is publicly available is written like this (example) :

```ruby
  grant_access action: :new
  # @route GET /sign_in (sign_in)
  def new
  end
```

- A Rails controller that is retricted to a certain group is written like this (example) :

```ruby
  require_auth action: new
  grant_access action: :new, roles: [ :members ]
  # @route GET /sign_in (sign_in)
  def new
  end
```

## .env file

Content of .env:

```
DATABASE_URL=postgres://localhost:5432/koal_development

SMTP_SERVER=
SMTP_PORT=
SMTP_USERNAME=
SMTP_PASSWORD=
```
