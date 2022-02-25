**Day 05: 16th of February 2021**

## Summary

## Notes

- a search for fine tuning a search engine results in seo nonsense for fine tuning webistes for search engines. Its
  obvious that we have submitted ourselves to the algorithms. I will show why each results ranks the way it does, and
  allow the end user make knowledgable decisions to adjust their own algorithm.
- Sure theres confirmation bias at play, but it seem no coincicdence that one of the highest ranking HN article of all
  time was shared yesterday, on the death of google, critisizing their search results.

## Search

Until now I haven't really dived deep into what the search algorithm should optimize for. I'd like to do that now.

There are multiple [ways of organizing information](https://dkb.io/post/organize-the-world-information). For example
through a directory, backlinks, and oral wisdom. I'd like to utilize multiple methods in particular those mentioned here
to help mitigate the downsides of each, while improving on the upsides.

The primary objective of the engine is to return high quality trusted information. To do so requires borrowing from
multiple information organization strategies.

**The Library**
Each page on the web can be indexed for its actual content as well as some meta information such as the author, domain,
keywords, and possibly content categories, and subcategories. Just gathering and making available that information is
useful for direct queries against from trusted sources. Typically libraries are an ok proxy for quality content since
the shelf space is limited and someone is typically reviewing a book before it makes it on one. Of course its not
perfect but in the real world, a good start. The issue arises digitally when the barrier to entry is practically null
and the amount of information on the web is only growing rapidly. We can still query the same results in a directory
like fashion, however we lose the ability to a) practically sort millions of results into a few practical ones and b)
how to differentiate between two pages with similarly ranking indexes on their reliability.

**The Research Paper**
Research papers have citations and are used as a primary point of validity. Peer reviewed and referenced is an excellent
means for attributing trust to a source. This could help with reliability and is in fact what Google did with PageRank
in their early algorithms. By using all link-backs to a page to determine a particular pages validity Google was able to
surface the most popular pages first. This however has its downsides too. For research papers theres once again a proxy
for being published. This is not true (thankfully) for the internet. But since anyone can publish anything, and a simple
link-back algorithm counting the number of references (without considering the trustworthiness of the reference) fails
to solve our problem across the internet. But we see already that this is a technically feasible mechanism for
attributing trust. Peer approved. And this introduces a key factor in truth. Truth is a general concensus among people
who utilize their existing knowledge to accept or reject something new. Since machines only speak math, to teach an
algorithm what is truthful, requires breaking it down to mathematical terms. Excellent for getting formal solutions to
formulaic problems, but less so for exploring general knowledge. Luckily humans already have much experience on this
matter.

**Town Square**
In the town square all the gossip, information, ideas, and theories are discussed. Twitter, and Reddit are good examples
in our age. It's no surprise that so many are using these platforms as the primary means of finding new information.
Through conversation ideas develop, are refined, and new ones emerge. This is not the case with stagnant information on
a library shelf. But it can be the case with the information within. Meaning a book thats ready by 100 people in
isolation leaves 100 impressions. Left in isolation those 100 impressions are not very meaningful. Gather the 100 people
together though and have them discuss their impressions and the number of ideas will likely grow exponentially. Well
that's the power of the town square. The downside is its noisy. Anyone whose ever scrolled through Twitter knows how
"loud" it can get there. This is not really a flaw, but a consequence of gathering all of the worlds population into one
meeting. The thing is once the conversation moves on whose documenting the conclusions? Its a shame to let that all
dissapear with the scrolling of a feed. Valuable information often isn't bound by the ephemeral nature of a social feed.

**Oral Wisdom**
Oral traditions and verbal wisdom has been at the core of our evolution since language was discovered, and we haven't
looked back. Some theories suggest that one of our primary advantages as a specie is our ability to share information.
The entire index of all of humanities knowledge accessible by anyone within less than a second is a remarkable feat. But
its not enough. We still need to make sense of all the information, and while all of the truths lie in that index, so do
the lies. Going back to studying the truths of our ancestors is not quite comprehensive enough to solve this problem.
What we need is a way to introduce general wisdom into the feed of arbitrary information.

**Bringing it all together**
Ok so heres where we are;

- The Library method gives us a great index of information, but not an opinion on the source.
- The research paper method gives us a strong opinion on the popularity of a source but only assumes that correlates
  with the reliability of the information and also depends on the creation of new content to impact its popularity.
- The town square takes all the information avaialble from all sources and methods and discusses it before reaching new
  conclusions and opinions. Crowd wisdom has strong feelings toward truth and in general is what dictates it. Issue
  being its level of noise and ephemeral nature.
- Oral wisdom is disorganized and limited in reach but excellent for making statements of trustworthiness as well as
  exploring non linear ideas.

By combining the above methods of organizing information we can mitigate the downsides while amplifying their upsides.

To begin with a page can be analyzed and indexed for all relevant information (Library Method). Then each backlink can
be extracted and utilized to create an idea of a pages popularity. Ultimately we still dont know if the page is a
reliable source so we use general feedback and discussions about the page to determine its trustworthiness. Of course
some individuals are more qualified to make such statements of truth on particular subject matters, so much like the
elders of past, or the electoral college of current, we also consider more seriously the opinion of an individual who is
trusted by others.

Ok so thats the general philosophy behind the organization of results from this search engine. What does it actually
look like?

### General

**Trust**
Each page begins as an untrusted but indexed entity. As individuals mark it as trusted the higher its ranking goes. As
the individuals who ranked it get marked as trusted themselves, the pages they trust are ranked higher. The more trusted
pages linking back to it the higher its ranking. Actual feedback from Humans become the key factor in a results
trustworthiness. The results can also vary from person to person depending on the sources they themselves trust. This of
course is an option, and an interesting side effect is the ability to ask for results that fall outside ones general
bubble.

# The Algorithm

- Indexing
- Ranking
- Querying
- Sorting

## Indexing

To begin with each page gets indexed for its content. The index is something that happens on a regular schedule to keep
up to date. The following information is extracted.

1. Title
2. Author
3. Domain
4. Content (text, images, etc)
5. Tags (keywords, subject, etc)
6. References (links from other pages)

## Ranking

Each page, domain, and person is ranked according to their "reliability". This gets updated regularly since it depends
on real time feedback. Each entity gets ranked in the aggregate according to the rules outlined.

**Page Rank**

1. For each ranking source adjust according to their **Person Rank**.
3. For each referring page adjust according to its **Page Rank**.
4. For the pages domain adjust according to the **Domain Rank**.
5. For the pages author adjust according to their **Person Rank**.

**Domain Rank**

1. For each page under the domain adjust according the their **Page Rank**.

**Person Rank**

1. For each trusting source adjust according to their **Person Rank**.
2. For each distrusting source adjust according to their **Person Rank**.
3. For each authored page adjust according to the **Page Rank**.

The actual weight of the adjustment per consideration is a variable that should reflect its perceived importance. Over
time the defaults of these variables will likely change as I explore the impact of each on the quality of results. Maybe
it should be configurable by the individual.

Additionally the ranking of an entity is a default aggregated from all individual rankings. Only
in [unscoped](#query-scope) searches are the aggregate entity ranks directly reflected in the results. Typically the
direct attribution of trust by an individual upon a source will have a greater impact then the aggregate rank itself
which serves as auxiliary data.

_Notice how the rankings are bi-directional and dependent on each other. This makes for a dynamic but at times out of
sync system. This is tolerable since it will be equally distributed among all ranks. Any serious discrepancies should be
adjusted by the next round of ranking._

## Querying

Querying is where an individual asks for a particular subset of documents matching default criteria and within an
optional **Query Scope**.

1. Find all pages within the **Query Scope** where the query is found in the pages **Index**.

### Query Scope

Any given search query can be limited to only include a particular subset of pages determined by the individual. As a
default a guest will use the general scope, and an account their personal scope. Scopes can be mixed and customized. One
of the exciting features planned is to share scopes for other to use. Imagine using Elon Musk's scope for a search on
space travel!

**Unscoped**
All pages.

**Personal Scope**
Limit the scope of the search to the individuals trusted sources. Both **Direct** and **Indirect** sources are possible.

**Custom Scope**
For example: Limit the scope of the search to pages with a minimum ranking of `n`

**Direct source**
A source I trust directly ("I trust this page", "I trust this author").

**Indirect source**
A source I tangentially trust (ie. trusted by a person I trust, linked to by a source I trust, on the same domain as a
source I trust).

## Sorting

The final step of a search is to sort and return the results from the query according to a default or optionally
provided **Sort Scope**.

1. For each page adjust position ranking according to the location and frequency of the query matching the index.
2. Merge duplicate pages together with their position rankings.
3. For each page adjust its position ranking according to its **Page Rank** and the **Sort Scope**
4. Finally sort and return each page according to its determined position ranking.

### Sort Scope

Similarly to the Query Scope an individual can dictate how their trusted sources impact the sorting of the results. This
is useful for when wanting to limit the results to one scope, but sort them according to another. By default the sort is
done according to the same scope as the query.

## Next steps

The natural question that follows is how to get significant data on trusted vs untrusted sources. To begin with its
actually not important to "untrust" any sources since the index will grow over time naturally from manually inputed
sources. What?! Manually inputted sources? Well not exactly, just not in the typical web crawler way. The premise is
that it takes time to determine an individual sources reliability. Time consuming and time comparing to others. But once
it's done it would suffice to say that "bookmarking" or otherwise marking the source is a form of attributing trust. So
with that I suggest an entry point to the search index being each individuals personal collection of bookmarks, saved
tabs, and otherwise collected web pages. For that theres an easy way to import. Following the initial import, save all
future pages to your index through the browser extension. This way you're not just filing them but using them as entry
points for future internet discovery. Going from there the index can expand through thoughful crawling, such as only
going as far as `n` links away from a trusted page, or only visiting pages with `n` number of trusted references. This
allows for It's at this point that untrusting gains importance since the non organic indexes will gain or loose trust as
their exposed as results. As they go up in trust the cycle repeats, as they go down they are removed from results. An
important consideration for this method is that a) this mitigates the costs of initially indexing the entire web and b)
the quality of the results will be high from day one. The obvious limitation is the lack of results to begin with, which
is why I don't suggest this to immediately be an alternative to the everyday search engine, but rather a powerful
assistant.
