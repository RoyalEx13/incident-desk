# Docs index

Start here before working on Incident Desk. Find your task, read the files listed, then work.
Files marked *(created later)* don't exist yet. Create them at that path.

## Task → files to read

| Task | Read first | Then read / touch |
| --- | --- | --- |
| Any task | `docs/requirements.md`, `docs/definition-of-done.md` | `README.md` (setup, commands) |
| Sign in / log out (Story 1) | `docs/user-stories.md` §1, `docs/design/index.html` | `app/controllers/sessions_controller.rb`, `app/controllers/concerns/authentication.rb`, `app/views/sessions/new.html.erb`, `app/views/layouts/_topbar.html.erb`, `test/controllers/sessions_controller_test.rb` |
| Users, roles, seeds | `docs/requirements.md` §2, §3.1 | `app/models/user.rb`, `app/models/role.rb`, `db/seeds.rb`, `lib/tasks/users.rake`, `test/models/user_test.rb`, `test/tasks/users_rake_test.rb` |
| Customer dashboard | `docs/design/my-tickets.html` | `app/controllers/dashboards_controller.rb`, `app/views/dashboards/show.html.erb`, `test/controllers/dashboards_controller_test.rb` |
| Create a ticket (Story 2) | `docs/user-stories.md` §2, `docs/design/new-ticket.html` | `app/models/ticket.rb` *(created later)*, `app/controllers/tickets_controller.rb` *(created later)*, `app/views/tickets/` *(created later)*, `config/routes.rb` |
| Agent ticket list and filters (Story 3) | `docs/user-stories.md` §3, `docs/design/agent-tickets.html` | `app/controllers/tickets_controller.rb` *(created later)*, `app/views/tickets/` *(created later)* |
| Update ticket status (Story 4) | `docs/user-stories.md` §4, `docs/requirements.md` §3.3, §3.5, `docs/design/agent-ticket.html`, `docs/design/customer-ticket.html` | `app/models/ticket.rb` *(created later)*, `app/models/ticket_event.rb` *(created later)* |
| Comments (Story 5) | `docs/user-stories.md` §5, `docs/design/agent-ticket.html`, `docs/design/customer-ticket.html` | `app/models/comment.rb` *(created later)*, `app/controllers/comments_controller.rb` *(created later)*, `app/channels/application_cable/connection.rb` |
| Escalation job (Story 6) | `docs/user-stories.md` §6, `docs/requirements.md` §3.4 | `app/jobs/application_job.rb`, `app/jobs/escalate_ticket_job.rb` *(created later)*, `config/queue.yml` |
| Styling | `docs/design/styles.css` | `app/assets/stylesheets/application.tailwind.css`, `app/views/layouts/application.html.erb` |
| Build test-first | `.agents/skills/tdd/SKILL.md` | `test/test_helper.rb`, `test/test_helpers/session_test_helper.rb`, `test/fixtures/` |
| Implement a story end to end | `.agents/skills/implement/SKILL.md` | `docs/user-stories.md`, `docs/definition-of-done.md` |
| Review a branch | `.agents/skills/code-review/SKILL.md` | `docs/definition-of-done.md`, `.rubocop.yml` |
| Run CI / check before merge | `docs/definition-of-done.md` | `config/ci.rb`, `bin/ci` |
| Open a pull request | `docs/definition-of-done.md` (Delivery), `docs/pull-requests.md` *(created later)* | `.github/pull_request_template.md` |

## Documents

| File | What it holds |
| --- | --- |
| `docs/requirements.md` | Roles, ticket fields, live updates, background jobs, audit events, out-of-scope list |
| `docs/user-stories.md` | Stories 1–6 with acceptance criteria |
| `docs/definition-of-done.md` | Checkable done-list: functionality, access, quality, tests, security, ops, docs, delivery |
| `README.md` | Setup, demo accounts, user creation, test and CI commands |
| `.github/pull_request_template.md` | PR body sections: Summary, What Changed, Why, Test Plan, Risks / Notes |

## UI mockups

Static HTML in `docs/design/`. Open in a browser. All share `docs/design/styles.css`.

| File | Screen | Role | Story |
| --- | --- | --- | --- |
| `docs/design/index.html` | Sign in | Both | 1 |
| `docs/design/my-tickets.html` | My tickets (dashboard) | Customer | 2 |
| `docs/design/new-ticket.html` | New ticket form | Customer | 2 |
| `docs/design/customer-ticket.html` | Ticket detail and comments | Customer | 4, 5 |
| `docs/design/agent-tickets.html` | All tickets with filters | Agent | 3 |
| `docs/design/agent-ticket.html` | Ticket detail: status, assignee, replies | Agent | 4, 5 |

## Skills

Defined in `.agents/skills/` and symlinked into `.claude/skills/`. Pinned in `skills-lock.json`.

| Skill | File | Use when |
| --- | --- | --- |
| `implement` | `.agents/skills/implement/SKILL.md` | Building a story or ticket. Uses `tdd`, then `code-review`, then commits. Invoke manually only. |
| `tdd` | `.agents/skills/tdd/SKILL.md` (+ `tests.md`, `mocking.md`) | Writing features or fixes test-first |
| `code-review` | `.agents/skills/code-review/SKILL.md` | Reviewing changes since a commit or branch, against standards and spec
| `codebase-design` | `.agents/skills/codebase-design/SKILL.md` (+ `DEEPENING.md`, `DESIGN-IT-TWICE.md`) | Designing module interfaces and seams
