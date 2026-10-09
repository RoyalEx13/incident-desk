# Incident Desk

## Setup

```sh
bin/setup          # installs gems, prepares the database and starts the dev server
bin/rails db:seed  # demo accounts: customer@example.com and agent@example.com
```

Seeded passwords come from `SEED_CUSTOMER_PASSWORD` and `SEED_AGENT_PASSWORD`. Outside
production they default to the dev-only value `password`.

## Creating users

```sh
PASSWORD=... bin/rails users:create EMAIL=agent@example.com ROLE=agent
```

`ROLE` must be `customer` or `agent`. Roles are managed with [rolify](https://github.com/RolifyCommunity/rolify).

## Tests

```sh
bin/rails test
```
