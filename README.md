# myweb

**Building a Search Engine**

---
This is a proof of concept search engine built using Ruby on Rails with a Node.js service used for extraction. The search engine allows for importing URLs for indexing and ranks search results based on their proximity to imported URLs marked as trusted. Additionally, the search engine supports search filters such as `domain:[site.com]`.

## Objective

The objective is to quickly implement a proof-of-concept search engine with a focus on querying sites I deem trustworthy.
The assertion of trust should begin with my saving of a web page, marking it as a Trusted Source. A basic query then searches only Trusted Sources directly.
Another query can expand the search to include pages `n` number of links away from a Trusted Source. Further searches can include
the Trusted Sources of other users. And finally a query should be capable of scoping the trust given to a particular source (by topic or keyword).
A complex query will take advantage of multiple refined rules, but the default search will follow a per account default.

## Getting Started
To get started with the search engine, follow these steps:
- Install and setup [Extraction service](https://github.com/4till2/extract).
- Clone this repository locally and run `bundle install`
- Copy and set environment variables from `config/application_SAMPLE.yml` into `config/application.yml`
- Start the Extraction Service according to its readme
- Start this app with `bin/dev`

## Import URLs for indexing using the Import URL feature on the search engine.
To import URLs for indexing, use the Import URL feature on the search engine. Simply enter a URL or list of URL's and click the Import button. The search engine will extract content from the URL and add it to the index.

## Search Ranking Based on Proximity to Trusted URLs
The search engine ranks search results based on their proximity to imported URLs marked as trusted. This ensures that results from trusted sources are ranked higher than results from untrusted sources.

## Search Filters 
The search engine supports search filters with the following formats:
`domain:[site.com, siteb.com]` - This allows users to filter search results by domain.
`author:["author name"]` - Search by author.

