# myweb

**Building a Search Engine**

---

## Objective

The objective is to quickly implement a proof-of-concept search engine with a focus on querying sites I deem trustworthy.
The assertion of trust should begin with my saving of a web page, marking it as a Trusted Source. A basic query then searches only Trusted Sources directly.
Another query can expand the search to include pages `n` number of links away from a Trusted Source. Further searches can include
the Trusted Sources of other users. And finally a query should be capable of scoping the trust given to a particular source (by topic or keyword).
A complex query will take advantage of multiple refined rules, but the default search will follow a per account default.

## Setup

- Download, setup and start the [Extraction service](https://github.com/4till2/extract).
- Copy and set environment variables from `config/application_SAMPLE.yml` into `config/application.yml`
- Run `bin/dev`

## Usage

1. Import urls
2. Search. Search can be author or domain restricted using the format `domain:[example.com, example2.com]` `author:[yosef]`
