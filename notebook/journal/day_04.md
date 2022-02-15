**Day 04: 15th of February 2021**

## Summary

Implementation of Sidekiq with Redis to handle jobs, offloading all of the indexing to an async worker. After the
indexing is complete the job will create a new `source` with and if an account_id is present.

Search is also now scoped to "trusted" sources by default. Next steps are to create views, improved search, and improved
indexing.
