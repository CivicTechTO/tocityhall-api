# Toronto City Hall API

This repo aims to experiment with using the [Grape framework](https://github.com/ruby-grape/grape) to create an
API for Toronto City Hall data gathered via the [Open Civic Data
`scrapers-ca` project](http://github.com/opencivicdata/scrapers-ca).

**WARNING:** *I provide no guarantees on the docs being entirely
up-to-date. Please don't spend more than a few minutes getting it to
work without speaking with me. I'm on Freenode under username patcon.*

### Requirements

1. Set up the [`scrapers-ca`
   repo](https://github.com/opencivicdata/scrapers-ca#usage).

2. Run the Toronto scraper to populate the `pupa` database:

        pupa update ca_on_toronto

3. Follow these steps:

```
bundle install
bundle exec rackup
```

You should now be able to access the API at

    http://localhost:9292/v0/

The current endpoints are:

```
GET /councillors
GET /councillors/:id
GET /councillors/:id/votes
GET /councillors/:id/vote_events
GET /bills
GET /bills/:id
GET /bills/:id/vote_events
GET /bills/:id/councillors
GET /bills/:id/votes
GET /legislative_session
GET /legislative_session/:id
GET /legislative_session/:id/bills
GET /legislative_session/:id/councillors **REALLY SLOW**
GET /vote_events
GET /vote_events/:id
GET /vote_events/:id/votes
GET /vote_events/:id/councillors
GET /memberships
GET /memberships/:id
GET /posts
GET /posts/:id
```

There are 20 results per page, and you may paginate by adding the page
query string.

No guarantees of stability while the API is labelled as `v0`.
