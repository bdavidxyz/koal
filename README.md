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
- Ruby > 3.3

## Installation

- git clone `git@github.com:bdavidxyz/koal.git`
- cd koal
- bundle install
- npm install
- VISUAL="code --wait" bin/rails credentials:edit
- create .env file (see below)
- RAILS_ENV=development bin/rails db:create db:migrate
- bin/dev

The app should be displayed at localhost:3000

## .env file

Content of .env:

```
DATABASE_URL=postgres://localhost:5432/koal_development

SMTP_SERVER=
SMTP_PORT=
SMTP_USERNAME=
SMTP_PASSWORD=
```
