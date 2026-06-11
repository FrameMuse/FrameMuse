# Introduction to API Facade

It all starts with a `fetch`.

```ts
fetch("https://api.example.com/users/42")
  .then(response => {
    if (!response.ok) return null
    return response.json()
  })
```

This is what MDN shows, and it's fine. You have a server, you talk to it.

Then you notice the same things repeating on every call — the host, the headers,
the error handling. So you wrap it:

```ts
async function api<T>(
  endpoint: string,
  body?: Record<string, unknown>,
): Promise<T | null> {
  const url = new URL(endpoint, "https://api.example.com")
  const headers: Record<string, string> = {}
  if (body) headers["Content-Type"] = "application/json"

  const response = await fetch(url, {
    method: body ? "POST" : "GET",
    headers,
    body: body ? JSON.stringify(body) : undefined,
  })

  if (!response.ok) return null
  if (response.status === 204) return null
  return response.json()
}
```

Now every endpoint shares the same wiring. You call `api("/users/42")` and it
works. This is what the handbook calls the naive recipe, and it's a good place
to start.

---

Now, `api(path, body)` is a new signature. Your team has to learn it. The types
`Request` and `Response` that fetch already knows don't fit here, so file
uploads or streaming need workarounds.

There's another way: keep fetch at the surface and build helpers around it.

```ts
function request(path: string, init?: RequestInit): Request {
  const url = new URL(path, "https://api.example.com")
  const headers = new Headers(init?.headers)
  if (init?.body && !(init.body instanceof FormData)) {
    headers.set("Content-Type", "application/json")
  }
  return new Request(url, { ...init, headers })
}

function json<T>(response: Response): Promise<T> {
  if (!response.ok) throw new Error(response.statusText)
  if (response.status === 204) return null as T
  return response.json()
}

fetch(request("/users/42")).then(json<User>)
```

Same `fetch`, same `Request`, same `Response`. The helpers are optional — you
can still call raw fetch for edge cases.

> Which approach to pick? The `api(path, body)` way is simpler. The enhance
> way is more flexible. The handbook calls these naive and light recipes,
> and both are fine.

---

This pattern is older than fetch. Before it, we had `XMLHttpRequest` — and
people wrapped that too. The names changed (ajax, `$http`, axios) but the
idea stayed the same: hide the mechanical parts, expose the meaningful ones.

An API facade is one of those things you build without naming it. Naming it
makes it intentional.

You can find more patterns here:
<https://github.com/FrameMuse/api-facade>
