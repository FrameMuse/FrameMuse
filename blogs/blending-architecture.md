#

How to architect custom systems and blend them seamlessly to existing codebase and existing language practices.

This is one of the most challenging but the most interesting problem we face when designing and implementing architectures/APIs.

For example, we have a very well known `fetch` API, but we want to improve - very common desire.

What we usually do is we create some sort of a function like this: `apiClient(endpoint, body?)`.
While looks good and is a very common practice - it becomes a new API that we have to learn, remember and maintain.

While it's not always needed! Usually such `apiClient` method would just add a host name for the `endpoint`, mark `body` as `application/json` (for non-GET request) and maybe return `null` on errors or 204 status.

But **why** we have to choose a signature for an already known API?

For adding host name to the `endpoint` we can just do `fetch(new URL(API_HOST, endpoint), { body })`.

To automatically send headers based on the `body` type, we can create a custom function which returns `Request` - `fetch(api.request(endpoint))`

...

---

I'm just trying to say that: maybe we don't need to mess around well-known structures to extend them?
Maybe we're just doing something wrong?

Ok, it's clear that we can play around `fetch` in this surprisingly beautiful way,
but it's not always `fetch`.

Sometimes, we have to create something "optimized" for our own custom system.
