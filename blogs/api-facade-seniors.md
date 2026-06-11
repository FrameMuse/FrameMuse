# API Facade Patterns That Senior Developers Don't Talk About

Every frontend developer eventually writes an API client. It usually starts with a function like this:

```ts
async function apiClient<T>(endpoint: string, body?: unknown): Promise<T | null>
```

It adds the host. Sets JSON headers. Returns null on errors. It works.

## The Pattern Nobody Names

What you just wrote is an API facade — a wrapper that hides the mechanical details of talking to a server so the rest of your code doesn't have to think about them. And you probably didn't think twice about the signature. (endpoint, body?) is the path of least resistance. It's comfortable.
But there's a subtle cost: you introduced a new API. Your team now has to learn, remember, and maintain apiClient — its argument order, its return shape, its error conventions. None of this is hard, but it accumulates.

## An Alternative: Enhance, Don't Replace

`fetch` already has a well-known signature. Instead of hiding it behind `apiClient(path, body?)`, keep it at the surface and add small helpers that produce or consume standard fetch types:

```ts
function apiRequest(path: string, init?: RequestInit): Request {
  const url = new URL(path, API_HOST)
  const headers = new Headers(init?.headers)
  if (init?.body && !(init.body instanceof FormData)) {
    headers.set("Content-Type", "application/json")
  }
  return new Request(url, { ...init, headers, body: JSON.stringify(init.body) })
}

function processResponse<T>(response: Response): Promise<T> {
  if (!response.ok) throw new HTTPError(response.statusText, response.status)
  if (response.status === 204) return null as T
  return response.json()
}

fetch(apiRequest("/users", { body: { name: "John" } }))
  .then(processResponse<User>)
```

No new API. `Request`, `Response`, `Headers` are the same objects fetch already uses. The helpers are optional — use raw fetch for edge cases. And `processResponse` is a pure function — test it without mocking fetch at all.
