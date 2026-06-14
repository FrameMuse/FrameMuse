PostgreSQL has been my primary database for the last 5 years; I work with it on every project. I have designed schemas from scratch for a CRM and a transaction management platform, where tables grew up to 50 million rows.

I optimized indexes to prevent queries from crashing. I used B-tree indexes for fields we filtered by most frequently, composite indexes when queries spanned multiple columns, partial indexes for highly repetitive conditions, and covering indexes with INCLUDE columns to avoid fetching from the heap entirely.

There was a case when a query with joins across 5 tables took 8 seconds to execute. I analyzed the EXPLAIN plan and saw that the database was performing a sequential scan on a massive table. After adding a composite index, the query time dropped to 80 milliseconds.

I handled migrations using Prisma, and on projects without Prisma, I wrote direct SQL scripts. I always made sure not to lock tables for writes. For large tables, I added columns with DEFAULT NULL to avoid long-lasting table locks. I also created indexes using CONCURRENTLY so production wouldn't go down.

I have experience with window functions for statistical aggregation, JSONB fields for storing flexible data structures, and full-text search for querying text. Additionally, I configured connection pooling via PgBouncer to keep the database stable under high loads.