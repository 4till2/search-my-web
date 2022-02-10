**Day 02: 10th of February 2021**

## Summary
Today I set up the searching part of the search engine. Using Postgres Full Text Search I was able to get going rather quickly,
with the primary efforts being in pre and post processing the query for a search. As of today Myweb can search across multiple
websites for matching words. Not the most complex search engine, but a fair position to build up from. I did notice some issues
with the indexing, where certain pages aren't being indexed due to the lack of hydration. Tomorrow I will look into solidifying
the indexer through better page scraping which should hopefully increase the quality of results. Following that I will improve
the searcher, at which point I should be ready to create a minimal interface.

Note: There are now 104 test assertions and its beginning to slow down. 
I'll likely need to start using test fixtures.

## Models
### Finder
**Search Algorithm**

I implemented a somewhat naive algorithm that gets the job done. It works as follows:
1. Convert a query to a list of word stems.
2. Get all locations with the word stems.
3. Get a list of sorted page ids according to their frequency in the list of locations.
4. Get all pages within the list of page ids.
5. Order the pages. Currently according to the sorted list in step 3 since the db query returns them in ascending order.

Each step is abstracted to its own method allowing alternative chaining, and better testing. I may make them class methods.

The actual searching is being done through Postgresql Full Text Search. Notes on that implementation are in the [logbook](../logbook.md#adding-postgresql-full-text-search).

Any word matching one of the search params will be returned.This means just one matching stem will include
a page, regardless of the number of stems included in the original search query. In theory this shouldn't be a problem since
the more stems provided the higher up a relevant result will appear. However it also means more lower quality results below. 
Work must be done to reduce the number of irrelevant results. I am of the opinion that a query should return just the 
most relevant results. More is not better, its just distracting.

### Notes
- I moved `as_word_stems` to the String class since again its something universally relevant to a string in our app.
- [pocket_export.txt](../pocket_export.txt) is an export of my pocket account which I'm using for testing purposes.