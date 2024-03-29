**Day 01: 9th of February 2021**

## Summary
For now I am building the universal requirements of a search engine;
a crawler, indexer, and query engine. Today I completed the first two with limited but sufficient testing.
While likely not bug proof, and certainly not scalable, the ground work is coming along nicely for a proof of
concept search engine.

## Models
#### User, Account, Profile
In the application I built the scaffold from I had needed the distinction between Users, Accounts, and their Profiles.
The reason being to allow for one individual to own multiple accounts, with seperate permissions and application data.
This is not currently the case for Myweb however I can imagine this being a valid use case in the future and therefore
decided to leave the abstraction as is to avoid any potential rework in the future. Had I not already done the work of
making such distinctions I wouldn't have so early on made such an abstraction,
but with it already in place and thoroughly tested its only a benefit.

#### Page, Hydration
Pages are a unique url. Each page gets Hydrated upon creation which contains all of the extracted information unique to 
the page such as the title, raw html content, and author (see [migration](../../db/migrate/20220209195657_create_hydrations.rb) for full list).

When a page is saved the hydration is built. This actual extraction of information is being done by 
a nodejs micro-service I have running locally called [Extract](https://github.com/yserkez/mercury_parser_service)
reached through the [PageParser](../../app/models/services/page_parser.rb) Service.

During indexing work is done on the Content returned from the Hydration.

A Page can be rehydrated anytime, and is by default according the FRESHNESS_POLICY of the Page.

####  Word
Words are stems of extracted words from all pages. The [word stem](https://en.wikipedia.org/wiki/Word_stem) is the
part of the word responsible for its meaning, useful for reducing the number of indexes and improving search results
semantically.

#### Location
A Location is the intersection between a Word and its place in a Page. A join table containing the Word and Page id's and a position
in the Page. The position is not an actual position but a reference for order when optimizing our query results.

#### Indexer
The Indexer is responsible for taking a URL and creating the Page entry, and performming the indexing on its content.
Indexer instantiates the creation of the Pages, and directly manages the Words, and Locations.

#### Spider
The Spider is responsible for passing a list of links to the Indexer one by one, and consequently searching the resulting
Page's content for any links to add to the list for next round. As is the Spider is a breadth first algorithm, running through
one list of links per call, resulting in a new list of links. It's trivial to set it to crawl automatically but given that
the point right now is to visit known sites, I will leave the crawler simple for the time being.

## Views
As of now just the views for registration and sessions are implemented, again borrowing from previous projects.
I dont quite have an interface in mind yet and won't consider it until the primary backend is complete. I typically like
to build back to front, feature by feature, however with the primary complexity being so highly backend dependent I am keeping the entirety of my focus there first.

### Notes
- I chose to extend the String class with a `valid_url?` function since it is integral throughout the application and
  I want one source of truth. See the [logbook](../logbook.md#extending-core-ruby) for more details.
- The [link helper](../../app/models/concerns/link_helpers.rb) concern is for domain specific link methods such as `scrub`, utilized
  by the crawler and indexer.
- Formatters will house any formatting functionallity. As of now the [Html Formatter](../../app/models/formatters/html.rb) handles
  the cleansing, and conversion of a Pages raw content to text for indexing.

### Resources
- [My project scaffold template](https://github.com/yserkez/rails_hotwire_template).
- Much of the efforts today was rework of this awesome project https://github.com/sausheong/saushengine.v1
- https://github.com/feedbin and https://github.com/davidesantangelo/dato.rss provide much appreciated reference for html processing and general project structure.
