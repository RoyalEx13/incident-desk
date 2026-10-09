# Incident Desk

Support tickets and incidents for customers and agents. See `docs/README.md` for the docs index.

## Setup

```sh
bin/setup     # installs gems and JS packages, prepares the database, seeds demo accounts
bin/dev       # web, JS and CSS watchers
```

## Accounts

`bin/rails db:seed` creates two demo accounts, `customer@example.com` and `agent@example.com`.
Their passwords come from `SEED_CUSTOMER_PASSWORD` and `SEED_AGENT_PASSWORD`. In development and test
they default to the dev-only value `password`; in production seeding stops unless both are set.

Create other users from the command line, passing the password through the environment:

```sh
bin/rails users:create EMAIL=agent2@example.com PASSWORD="$NEW_USER_PASSWORD" ROLE=agent
```

`ROLE` is `customer` or `agent`.

## Tests

```sh
bin/rails test
bin/ci          # style, security audits, tests and seeds
```
