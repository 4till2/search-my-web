**Day 07: 18th of February 2021**

## Summary
Refactor Friday. Today I did my second favorite thing after coding. Deleting code. After spending yesterday evening and this morning
attempting to solve the Ranking algorithm I have opted to take a step back and continue building. It turns out the built
in Postgresql full text search is faster, returns better results, and is far simpler than what I had implemented, so
while glad I did it to learn im also glad to have deleted it in favor of PG. Certainly I'll need to switch it to
something like Elastic search either way so better to be quick with the mvp. I'll just focus on creating a great personal experience
for now. With all the refactoring the code base is smaller, more efficient, quicker, cleaner, and easier to reason through. That being 
said the search complexity was moved to postgres. Importing and hydrating a few hundred links took just a few minutes which is comparatively fast to what it was before.
Also search is fast. I moved Hydration into Page since they arent actually separate entities, and it saves the cost of fetching both.
Links are going to be important for growing ones library with recommendations, and sources. I'd like to implement category analysis on each page.


- Use association helper functions! Because I created all manipulation of hydration through the page it was trivial
to merge hydration with page.