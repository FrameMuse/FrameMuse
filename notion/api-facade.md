# A facade that simplifies a work with API using a Swagger Documentation.

## Goal

The facade simplifies the interface for easier API integration while ensuring the validity and consistency of requests and responses. This creates a reliable system that developers can use to streamline their work.

They can confidently process data without fear of errors such as partitioning, server unavailability, or incorrect responses. It also facilitates smoother local development, similar to tRPC.

## Key features

- [ ]  Simple API Interface
- [ ]  Full-scale typization (type-safety on all request and response steps)
    - [ ]  Response
        - [ ]  Body
        - [ ]  Headers
    - [ ]  Request
        - [ ]  Method
        - [ ]  Body
        - [ ]  Path Params
        - [ ]  Query Params
        - [ ]  Headers
- [ ]  Request and Response body polymorphism
    - [ ]  Accepting and Returning interconvertible body types (`FormData` that can be converted to plain object or vice versa)
- [ ]  Request and Response validation
- [ ]  Basic configuration
- [ ]  Rich interface (Typed headers, HTTP Errors, informative validation errors based on Zod)
- [ ]  Openness (request, response, validation and such events)
- [x]  Only needs **one** JSON spec. file
- [ ]  Preloading (prefetching) - access and cache a resource for future usage; optimizes requests waterfall time and visual feedback speed after interaction that requires a request.
- [ ]  Idempotent Requests, returning the same response for the same request that already occurred before
- [ ]  Vite plugin for
    - [ ]  Keeping the spec. up to date
    - [ ]  Partial retrieve of spec. (e.g. by tags or by `operationId`)
    - [ ]  Testing the spec
        - [ ]  Create test suites
- [ ]  Data Mocking
- [ ]  Spec. overriding (i.e. “servers” field and other meta data? }~
- [ ]  Multiple and single items request optimization???
    - [ ]  Probably JSON optimization
- [ ]  Native Caching Interface
- [ ]  Batching
- [ ]  Batching Merge (Merging similar requests with body and params of arrays or objects according to schemas)
    - [ ]  PATCH
    - [ ]  PUT
    - [ ]  DELETE (Bulk)
- [ ]  Explicit DTOs generation
- [ ]  Implicit DTOs handling by picking only known properties
- [ ]  Allow mapping of tolerable values absence and critical (fatal)
    - [ ]  Define how optional and absence go together
    - [ ]  Handle optional and absent values in a convenient and predictable way
- [ ]  Response normalization according to a schema and response status
    - [ ]  When a response status is 404 without body, it can be normalized to have consistent body with partial and optional values (emptied)
- [ ]  `FormDataSerialization` to switch body type to `FormData` if there are files
    - [ ]  may be json
    - [ ]  may be split by dots
