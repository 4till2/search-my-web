**Day 06: 17th of February 2021**

## Summary
I thought I'd be creating the search with elastic search today, but came again to the conclusion that I want to 
prove the algorithms feasibility in ruby before managing another service. Additionally it will allow for easier tweaking and experimentation
to have a ruby instance, even if its not the final version. Aaannnddd its educational af. I'm currently working through a 
creating a Personalized SourceRank algorithm.
## Models
**Links**
Pages can be linked to one another to represent actual links. Used for page ranking and discovery.
**Finder**

[comment]: <> (Search is now using some user parameters to return only requested results.)
**Source**
Updated to be polymorphic so that a source can be a page, or account. Added rank as a field.

**Ranker**
In progress: rank a source

**Sorter**

[comment]: <> (Abstracted sorting to its own class. Implemented the sorting of results.)
## View
## Controller

## Notes
- There has to be a way to provide data value outside of selling shit to people.
A business model could be to provide premium search abilities. For example: "How many people are searching for x", or additional lenses.
- Drop a note, essay, blog, image, etc into the import and its indexed as any page. Allows for
unstructured but easily retrievable creations. These items are also available to view and edit within the platform.
- 