# Technical Interview: WorkHours

## Overview

WorkHours is a web application designed to manage and visualize work metrics efficiently. Leveraging a technology stack that includes Ruby, Rails, RSpec, HTML5, TailwindCSS and more, WorkHours ensures a seamless experience for users tracking their work hours and administrators overseeing organization-wide metrics.

## Technologies Utilized

- Ruby
- Rails API for the backend web service
- RSpec for testing
- HTML5 for the UI app
- Rubocop for linting
- Prettier for formatting
- `fly` for deployment
- GitHub Actions for CI/CD

## Requirements

Ensure that the following versions are installed:

PostgreSQL: Version 15 and above.
Ruby: Version 3.2.2.
Rails: Version 7.1.
Additionally, refer to the specific versions mentioned in the `Gemfile.lock` for Ruby gems and package.json for JavaScript packages to ensure compatibility and a smooth development experience.

## Local Development Setup

1. **Clone the project:**

```bash
git clone git@github.com:bolah2009/work_hours.git
```

2. **Install Dependencies:**

```bash
bundle install
yarn install # for CSS packages, linters, and formatters
```

3. **Setup the Database:**

```bash
bundle exec rails db:setup
# This command creates the database, loads the schema, and initializes it with seed data.
```

4. **Run Migrations:**

```bash
bundle exec rails db:migrate
```

5. **Start the Server:**

```bash
rails server
bin/rails tailwindcss:watch # for Tailwind CSS
```

Or, start the server with TailwindCSS using:

```bash
./bin/dev
```

6. **Access the Web App at:** [http://localhost:3000](http://localhost:3000)

## Deployed Version

### Live Link

- [Web App Live Link](https://work_hours.bolabuari.com)

## Validation, associations and assumptions for the Coding Challenge

1. Users can create organizations.
2. Users can add other users to organizations with roles/permissions.
3. Users can create organization-level work-time metrics.
4. All users can view their metrics using the user dashboard.
5. Admin and Owner users can view aggregated organization-level user metrics in a table and organization-level individual user metrics in a timeline format.

## Metrics Specification

- Metric accepts `start_time`, `end_time`, and `date` (`user_id` and `organization_id`) where:
  - `start_time` must be earlier than `end_time`.
  - `date` must be unique for each user in an organization.

## User Metrics Display

- User metrics show:
  - User start times.
  - User end times.
  - User total work hours per day.

## Organization Metrics Display (for admin and owners)

- Organization metrics show:
  - Average user start times.
  - Average user end times.
  - Average user total hours.
  - Sum of user total hours.

#### QA

To run automated tests, use:

```bash
rspec --force-color --format documentation
```

To run Rubocop for linting:

```bash
rubocop
```

To automatically fix issues found (where possible):

```bash
rubocop -a
# or
rubocop -A
```

Check against Prettier:

```bash
yarn format:check
```

Auto-fix format issues:

```bash
yarn format
```

## Managing Application Credentials

Run:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Replace `code` with your preferred editor. This opens the decrypted credential file for direct management.

See [Environmental Security - Custom Credentials](https://edgeguides.rubyonrails.org/security.html#custom-credentials) for more details.

## Improvements

- Enhance organization metrics display for better insights.
- Refactor code for better maintainability.
- Consider additional user roles for finer-grained permissions.
- Optimize CI/CD workflows for faster deployment.
- Implement more comprehensive error handling.
- Enhance user authentication and authorization mechanisms.

## 👤 Author

- GitHub: [@bolah2009](https://github.com/bolah2009)
- Twitter: [@bolah2009](https://twitter.com/bolah2009)
- LinkedIn: [@bolah2009](https://www.linkedin.com/in/bolah2009/)

## 📝 License

[MIT licensed](./LICENSE).
