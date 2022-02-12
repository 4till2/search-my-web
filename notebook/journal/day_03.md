**Day 03: 11th of February 2021**

## Summary
Today I built the foundation for importing data into the app, as well as some placeholder views as I continue to withhold my attention from the interface.
The importer is architected to easily extend its abilities to different data sets, with the current importer handling any data type but only indexing at most an array of urls. 
In the future it should handle other data types, such as files, and remote sources. I haven't written tests for the views, and dont think I will until its more solidified, since its constantly subject to change.
It feels like I'm moving a bit more slowly at least compared to day 01, but progress is being made and I find this project quite interesting. 
Today I learned how slow it is to index a bunch of sites. I already see that it's not in the fetching but indexing. Tomorrow I should implement Sidekiq to move the processing off the main thread, and search for bottlenecks.

## Models
#### Importer
The importer is to handle the importing of urls from a user. This should be possible through multiple mechanisms
such as uploading a file (html, csv, etc), dumping a list of urls through a form input, or connecting to a third party service.
Though I am building the architecture to support all of the above, for now I will only support manual uploading through files, and form input.

The Importer class accepts any number of arbitrary data sources, and then attempts to extract, validate, and index all urls. When an invalid data type is uploaded an error is added to `@errors`, 
as is the case for each invalid url. The `Importer` communicates with the `Indexer` gracefully, meaning one url can fail while the rest are processed. In the
case of a failed index the url in question gets a status code of 'ERROR'. These problematic urls can be easily retrieved through `.failed`. There are also `.ready` and `.complete` 
helper functions, useful to give feedback to the user.

## View
#### Importer, Search
The view for import accepts an Html file and extracts all links within a href before rendering those on the page for submission.
It's rudimentary, yet functional for testing. I'm using some awesome features of Hotwire to rather easily handle the above. Most 
notable is the [import_controller](../../app/javascript/controllers/import_controller.js) which using [importer.js](../../app/javascript/importer.js) handles the reading, parsing, and rendering 
of the uploaded html file. It's in no way robust and only the beginnings of what will need further development even for beta. Doing some work client side 
will be good when allowing users to upload from arbitrary sources, enabling them to work with the urls before being uploaded. 

Search is just a basic input field that auto submits a query to the `search` endpoint, which then renders any results below. Using turbo streams
with stimulus enables the process to be super fluid. Again it's a foundational placeholder for what will need to be a more robust solution.
## Controller
#### Importer
Data is sent to this controller to be processed. The input currently is to the `do` method which is configured to accept just an array of urls, however soon it should also directly accept
file uploads. It then instantiates an `Importer` class with the data and renders the results.


### Notes
- I did a bunch of reading on search engines, and its become apparent that
  postgresql will not suffice for truly custom search. However my current objective is not to maintain an index of the entire web
  but rather an enhanced directory of what users input. So for the time being I will hold off on the task of managing
  the cost and complexity of an Elastic Search instance. **Reminder:** The primary objective for now is to input, index, and query a collection
  of urls. Following that the query can be enhanced through the inclusion of peer collections. And finally all urls can be enhanced through crawling,