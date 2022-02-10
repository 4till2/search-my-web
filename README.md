# myweb
===
**Building a Search Engine**

## Objective
A search engine with a focus on querying sites I deem trustworthy. The assertion of trust begins with my saving
of a web page, thereby indicating it as a Trusted Source. A basic query searches only Trusted Sources directly.
Another query expands the search to include pages `n` number of links away from a Trusted Source. Yet another includes
the Trusted Sources of other users. And finally a query can scope the trust given to a particular source (by topic or keyword).
A complex query will take advantage of multiple refined rules, but the default search will follow a per account default.

## Technology
Ruby on Rails is the technology I have become most comfortable with and therfore the most logical choice. Most would
agree Ruby is not an ideal language for building a search engine, but for proof of concept it couldn't be better. I'm writing
this after day one (about 5 hours) of programming and I have already implemented all of the full stack scaffolding such as
users, accounts, profiles, authorization, and authentication as well as the initial crawler, and indexer for the search
engine. All fully tested (80 assertions to be exact). I did reuse some of my old code from other projects, and
reference public projects for my implementation of the crawler and indexer, which is precisely why Ruby on Rails is
the perfect choice. I could move silly quick. Once I have a strong proof of concept I will run some benchmarks to reevaluate.


## Methodology
Build quickly while documenting decisions, and progress. Each day I will implement one or more features along with a
suite of passing tests, upon which I will write a days summary outlining key progress and decisions.

Follow along with all updates in the [journal](notebook/journal).
Find key decisions in the [logbook](notebook)
