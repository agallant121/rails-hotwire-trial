# Clever's Rails + Hotwire Coding Interview

Photo Gallery is a Rails + Hotwire app where signed-in users can browse seeded photos and like or unlike them without a full page reload.

## What to Look For

- Devise gates access to the gallery.
- Photos are seeded from `photos.csv` into the database.
- Likes update with Turbo Frames/Streams.
- Pagination uses Turbo Streams when the photo count exceeds the page size.
- Like counts persist with a counter cache.
- Users can only like each photo once.
- The layout is mobile responsive.
- Meaningful model, request, and system specs are included with RSpec.

## Local Setup

This app uses:

- Ruby `3.4.2`
- Rails `8.0.5`
- SQLite
- Devise
- Hotwire
- RSpec


From the project root, run:

```bash
ruby -v
bundle install
bin/rails db:setup
```

`db:setup` creates the database, runs migrations, and seeds:

- the demo users from `db/seeds.rb`
- the 10 photos from `photos.csv`

Seeded users:

- Email: `demo@example.com`
- Password: `password`

- Email: `demo2@example.com`
- Password: `password`

Start the app:

```bash
bin/rails server
```

Then open:

```text
http://localhost:3000
```

Run the test suite:

```bash
bundle exec rspec
```

If you want to reset the local database from scratch:

```bash
bin/rails db:drop db:create db:migrate db:seed
```

## Implementation Notes

- Authentication uses Devise.
- Sign-up is intentionally not exposed; users are seeded in `db/seeds.rb`.
- Photos are imported from `photos.csv` during seeding and stored in the database.
- Likes use Rails routes/controllers with Turbo Frames and Turbo Streams.
- Like counts persist with a database-backed counter cache.
- Each user can like each photo only once, enforced by model validation and a database unique index.
- Pagination uses Pagy and updates the photo results with Turbo Streams for the reasonable assumption that the gallery would eventually grow beyond the provided 10 photos. This keeps each request focused on the current page of records instead of loading the full gallery into memory and rendering every card at once.
- Flash message dismissal uses a small Stimulus controller.

## Future Improvements

- Add an admin area for managing photos beyond the seed import workflow.
- Add authorization, such as Pundit, to separate regular user access from admin-only actions.
- Add search or filtering as the gallery grows.
- Add photographer profiles with scoped photo ownership.
- Add public/private publishing controls for photographer-owned photos.
- Add fragment caching for the static parts of photo cards while keeping the user-specific like button dynamic.
- Add background jobs for bulk photo imports or lightweight notifications as the app grows.
