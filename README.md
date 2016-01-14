# Toronto City Hall API

This repo aims to experiment with using the [Grape framework](https://github.com/ruby-grape/grape) to create an
API for Toronto City Hall data gathered via the [Open Civic Data
`scrapers-ca` project](http://github.com/opencivicdata/scrapers-ca).

**WARNING:** *I provide no guarantees on the docs being entirely
up-to-date. Please don't spend more than a few minutes getting it to
work without speaking with me. I'm on the Freenode IRC network as
"patcon". [[Sign into
IRC]](https://kiwiirc.com/client/irc.freenode.net/#sunlightlabs)*

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

### Documentation

This API is [Swagger-compliant](http://swagger.io/getting-started/).
With the service running, the base URL will redirect to the docs:

    http://localhost:9292/v0

There are 20 results per page, and you may paginate by adding the page
query string.

No guarantees of stability while the API is labelled as `v0`.

### Live Demo

A relatively up-to-date demo API is running at:

    https://tocityhall-api.herokuapp.com/v0

It is using data scraped from my in-progress improvements to the Toronto
OCD dataset:

    https://github.com/patcon/scrapers-ca/tree/toronto-committee-orgs

The Swagger docs can be viewed here:

    https://tocityhall-api.herokuapp.com/v0

### Related Resources

There are a few wonderful resources related to the current hosted OCD
API. I'm very appreciative of the prior art, but am interested in what I
consider the more RESTful approach of APIs built on Grape.

* Open Civic Data API
  - Legacy API: http://api.opencivicdata.org/jurisdictions/ (API key
  required)
  - Current API: http://ocd.datamade.us/jurisdictions/
  - Imago Django app: https://github.com/opencivicdata/imago (powers OCD
    APIs)
