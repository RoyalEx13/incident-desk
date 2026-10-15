# Definition of Done

A change is done when every item below that applies to it is checked. Items come from
`docs/requirements.md`, `docs/user-stories.md` and `config/ci.rb`. Items marked **(optional)** are
team conventions we guessed at; drop or promote them when the team agrees.

## Functionality

- [ ] Every acceptance criterion of the story in `docs/user-stories.md` has a test that exercises it.
- [ ] The screen matches its mockup in `docs/design/` (same fields, labels, buttons and badges).
- [ ] New tickets save with status `Open`.
- [ ] Ticket severity accepts only `Low`, `Medium`, `High`, `Urgent`; status accepts only `Open`, `In Progress`, `Resolved`.
- [ ] Ticket form rejects a title shorter than 5 characters and a description shorter than 10 characters.
- [ ] Status changes and new comments reach another open browser tab without a reload (Turbo Streams over Action Cable).
- [ ] Every ticket status change records an audit event.
- [ ] Creating a `High` or `Urgent` ticket enqueues the escalation job on Solid Queue, and the job flags the ticket only if it is still `Open` and unassigned.
- [ ] Nothing from "Explicitly Out of Scope" in `docs/requirements.md` was added (SMTP password reset, attachments, extra roles, WYSIWYG editors).

## Access Control

- [ ] Every new controller action requires sign-in. `grep -rn allow_unauthenticated_access app/controllers` shows only `SessionsController` (`new`, `create`).
- [ ] A customer cannot view or edit another customer's ticket. A controller test asserts a 404 or redirect.
- [ ] Customer ticket queries are scoped to `Current.user` and never call `Ticket.find(params[:id])` unscoped.
- [ ] Only agents can change status or assignee. A controller test asserts a customer's attempt is rejected.
- [ ] Turbo Stream channels are scoped per ticket, so a customer never receives broadcasts for tickets they don't own.
- [ ] Roles stay `customer` and `agent` only (no new roles in `app/models/role.rb` or seeds).

## Code Quality

- [ ] `bin/rubocop` passes with no offenses.
- [ ] No `.rubocop.yml` rule was disabled, and no `# rubocop:disable` was added without a comment explaining why.
- [ ] New schema changes come as migrations, and `db/schema.rb` is committed in the same change.
- [ ] No leftover `debugger`, `binding.irb`, `puts` or `console.log` calls. `git diff main -- app | grep -nE 'debugger|binding\.irb|console\.log'` is empty.
- [ ] (optional) `/code-review` was run against `main` and its findings were fixed or answered.

## Testing

- [ ] `bin/rails test` passes.
- [ ] `env RAILS_ENV=test bin/rails db:seed:replant` passes.
- [ ] Every new model, controller, job and rake task has a test file under `test/` that mirrors its path.
- [ ] Every authorization rule in Access Control has a negative test (a wrong user or role is refused).
- [ ] Jobs are tested with `assert_enqueued_with` / `perform_enqueued_jobs`, covering both the escalate and the no-op path.
- [ ] (optional) Features with real-time behaviour have a system test, and `bin/rails test:system` passes.
- [ ] (optional) The test was written first and seen failing (`/tdd` workflow).

## Security

- [ ] `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` passes.
- [ ] `bin/bundler-audit` passes.
- [ ] `yarn audit` passes.
- [ ] No password, token or key is committed. Secrets come from ENV or Rails credentials (as `SEED_*_PASSWORD` and `RAILS_MASTER_KEY` do). `git diff main | grep -niE 'password\s*[:=]\s*["'\''][^"'\'']+|secret|api[_-]?key'` shows no literal values.
- [ ] If a secret was ever committed: it was rotated, and the history was purged before the change merged.
- [ ] Comments and descriptions render as escaped plain text (no `raw` or `html_safe` on user input).
- [ ] Strong parameters never permit `status`, `assignee_id` or `role` from customer requests.

## Operations

- [ ] `bin/setup --skip-server` runs cleanly on a fresh checkout.
- [ ] `bin/dev` starts web, JS and CSS watchers with no errors, and the changed page loads.
- [ ] Migrations are reversible: `bin/rails db:migrate && bin/rails db:rollback && bin/rails db:migrate` succeeds.
- [ ] Background jobs use Solid Queue (`config/queue.yml`) and run under `bin/jobs`.
- [ ] `GET /up` still returns 200.
- [ ] Each new ENV variable has a dev/test default or fails loudly in production, as `db/seeds.rb` does for `SEED_*_PASSWORD`.
- [ ] (optional) Each new ENV variable is listed in `.kamal/secrets` or `config/deploy.yml`.

## Documentation

- [ ] `README.md` is updated when setup, accounts, commands or ENV variables change.
- [ ] `docs/README.md` lists every new doc, mockup or skill, and drops the "created later" mark once a file exists.
- [ ] A story whose behaviour changed has its `docs/user-stories.md` acceptance criteria updated in the same change.
- [ ] (optional) Non-obvious decisions (job timing, broadcast scoping) have a short code comment explaining why.

## Delivery

- [ ] `bin/ci` passes locally (setup, rubocop, bundler-audit, yarn audit, brakeman, tests, seeds).
- [ ] Commits follow the existing `type: summary` style (`feat:`, `fix:`, `chore:`).
- [ ] Work is on a feature branch, not `main`: `git branch --show-current` is not `main`.
- [ ] (optional) `gh signoff` set a green commit status (see the commented step in `config/ci.rb`).

### Last step: open the pull request

Write the PR body by following `docs/pull-requests.md` *(created later)*. Fill in
`.github/pull_request_template.md`, then open the PR with
`gh pr create --base main --title "<type: summary>" --body-file <filled template>`.

- [ ] The PR targets `main`, and its title uses the same `type: summary` style as the commits.
- [ ] The body keeps every template heading: Summary, What Changed, Why, Test Plan, Risks / Notes.
- [ ] Hint comments are deleted: `gh pr view --json body -q .body | grep -c '<!--'` prints `0`.
- [ ] **Summary** says in 1–3 sentences what a user can do now that they could not before.
- [ ] **What Changed** bullets start with a bold label and are grouped by behaviour, not by file.
- [ ] **Why** names the user story from `docs/user-stories.md`, and `Closes #` links its issue (or the line is removed when there is no issue).
- [ ] **Test Plan** contains the pasted `bin/ci` result, lists each new or changed `test/...` file, and gives numbered manual steps, each with its expected result.
- [ ] **Risks / Notes** lists every item from the template's checklist that applies (migration, access control, new dependency, new env var, and so on), or says `None.`
- [ ] (optional) Another person or `/code-review` approved the PR before merge.
