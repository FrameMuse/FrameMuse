# SSR Breakdown

## Why

### Target

SSR is used for rendering a client code before a client actually gets ANY code, ensuring that when it gets it, it gets the **full** code, not a blank page with subsequent JS loading.

This delegates rendering **the first paint** to the server, which puts a some more load to the server. This is extremely useful while targeting users which are "you know they're using browsers with disabled js", like union websites; you're exclusively serving static data, or you just want SEO.

Of course, there are many other client "modes" - MPA, SPA. Experimental libraries and frameworks that allow doing client & server parts at the same codebase, which may be useful for small projects or you're just used to this kind of staff (lazy guy).

However, the main reason why even isolated client code like SPA is still widely preferred to be run at the server side - SEO.

Basically, it means a _ro_bot may be too lazy to run all of your js to render your page to get needed content loaded, so it discards it either lower your search index or don't index at all.

This is actually worked on and might be no problem in future, but still services like Facebook/Telegram and some search engines don't run you js **at all**, even though Google/Bing/Yandex claim to run your js.

### Efficiency

The client code can't acquire initial state as a server can. Meaning client should wait for html first, then wait again for js to load and render the page and probably wait again for fetch requests.

A lot of waiting users must go through (which seems they don't mind) if isolating backend from frontend. Whereas SSR streamlines it all as one request, which is usually 99% faster since all the requests resolve faster as endpoints are closer, which leads to minimal delay and faster operational speed. As you know client-to-server requests are a bit more complex than sending a content, it followed by handshakes and checks. Now take into account your client internet speed and location, it may result into waiting ~200ms for a no-content response.

Backlash - it strains your server and it's a thing about targeting again - if you know your users have slow internet, you may prefer serving a html first.

---

Worth to mention - separating server and client haven't appeared because of nothing, it _serves_ a great purpose of separating human concerns about when they change what. Which results into much higher stability, flexibility and ... for BOTH server and client.

## How

Theory & Terminology

Server-Side Rendering operates on the principle of generating HTML on the server before sending it to the client. Whereas Client-Side Rendering (CSR) receives a minimal HTML shell and uses JS to construct the page on the fly.

Comparison Between SSG, SSR, and CSR

SSG (Static Site Generation): Pages are built at build time and served as static files. Super-fast, great for SEO, but lacks real-time data updates.

SSR (Server-Side Rendering): Pages are generated on request, meaning dynamic content can be served fresh but at the cost of a higher server load.

CSR (Client-Side Rendering): The browser receives minimal HTML, fetches data via JS, and renders content dynamically. Works well for SPAs but is bad for SEO and initial load times.

TTFB with SSR

Time to First Byte (TTFB) can be higher in SSR than in SSG because the server must generate and send the page content dynamically. However, since everything is served at once, overall interactivity can still be faster than CSR.

Server Load Consideration

Since every page request is processed on the server, high traffic can overload the server. Load balancing, caching, and smart API calls are required to mitigate performance issues.

Hydration

Once the page loads, JavaScript must "hydrate" the static HTML for interactivity. If hydration mismatches occur (e.g., differences between server-rendered and client-rendered output), errors and UI glitches may happen.

Difficulties

With a great load, you get even more complexity.

You thought all your problems were gone with SSR for the price of a higher load? - Nope, you now need to solve the problems that are usually handled by your CDN/Hoster.

Of course, there are libraries/frameworks for easier SSR and best practices/guides for how to optimize CDN and hosting.

Common Issues with SSR

Increased Server Load

Each request triggers server-side processing, leading to higher CPU and memory usage.

Scaling requires efficient caching or load-balancing strategies.

Slower Time to First Byte (TTFB)

Generating HTML on the server takes time, potentially delaying the initial response.

More complex pages with database queries may further slow responses.

Hydration Complexity

Once the page loads, JavaScript must "hydrate" the static HTML for interactivity.

Mismatches between server-rendered and client-rendered content can cause issues (e.g., React hydration errors).

Limited Third-Party Library Support

Many frontend libraries assume they run in a browser (e.g., window, document APIs).

Using them in SSR requires workarounds like conditional imports or alternative libraries.

Caching and Performance Optimization Challenges

Dynamic SSR responses are harder to cache compared to static files.

Optimizing database queries and API calls is critical to avoid bottlenecks.

Authentication and Session Handling

Managing user sessions securely in SSR is more complex than in CSR.

Requires careful handling of cookies, tokens, and server-side user verification.

Routing

Routing mechanisms largely depend on the website's structure and how navigation is handled:

Single Page Application (SPA) Routing

In SPAs, navigation happens entirely on the client side using JavaScript.

The URL updates without triggering a full page reload, thanks to frameworks like React Router.

This enables smooth transitions but requires additional strategies for SEO and initial page load optimization.

Multi-Page Application (MPA) Routing

Each route corresponds to a new request to the server, fetching a fresh page each time.

This traditional approach is commonly used in content-heavy sites like blogs and e-commerce platforms.

While naturally SEO-friendly, it can lead to slower navigation compared to SPAs.

From an SSR perspective, the initial load for both SPA and MPA is identical, the difference occurs during a next navigation.

When an SPA initially loads, the server renders the requested page as if it were an MPA. However, it only fetches data for that specific page. When the user navigates elsewhere, the routing happens on the client side without a full-page reload.

Conversely, in an MPA, every new navigation triggers a new request to the server, always loading a new page from scratch without relying on client-side (browser).

1. Increased Server Load
Each request triggers server-side processing, leading to higher CPU and memory usage.
Scaling requires efficient caching or load balancing strategies.
2. Slower Time to First Byte (TTFB)
Generating HTML on the server takes time, potentially delaying the initial response.
More complex pages with database queries may further slow responses.
3. Hydration Complexity
Once the page loads, JavaScript must "hydrate" the static HTML for interactivity.
Mismatches between server-rendered and client-rendered content can cause issues (e.g., React hydration errors).
4. Limited Third-Party Library Support
Many frontend libraries assume they run in a browser (e.g., window, document APIs).
Using them in SSR requires workarounds like conditional imports or alternative libraries.
5. Caching and Performance Optimization Challenges
Dynamic SSR responses are harder to cache compared to static files.
Optimizing database queries and API calls is critical to avoid bottlenecks.
6. Authentication and Session Handling
Managing user sessions securely in SSR is more complex than in CSR.
Requires careful handling of cookies, tokens, and server-side user verification.
Would you like to integrate these into your document?

Basic SSR Implementation

To implement SSR in a framework-agnostic way, a web server must be capable of generating and delivering a fully rendered HTML response before sending it to the client. This can be achieved by setting up a backend that:

Processes the incoming request.

Retrieves necessary data from a database or API.

Renders the HTML dynamically using a templating engine or server-side logic.

Sends the fully rendered HTML response to the client.

For example, in a generic server-side setup:

from flask import Flask, render_template
import requests

app = Flask(__name__)

@app.route('/')
def index():
    data = requests.get('https://api.example.com/data').json()
    return render_template('index.html', data=data)

if __name__ == '__main__':
    app.run()

Similarly, for a Node.js-based implementation:

const express = require('express');
const fetch = require('node-fetch');
const app = express();

app.get('/', async (req, res) => {
    const data = await fetch('https://api.example.com/data').then(res => res.json());
    res.send(`<html><body><h1>${data.title}</h1></body></html>`);
});

app.listen(3000, () => console.log('Server running on port 3000'));

This ensures that the client receives pre-rendered HTML with the necessary data, improving both performance and SEO.

Hybrid Rendering (SSR + CSR)

For some applications, a hybrid approach combining SSR with client-side rendering (CSR) can be beneficial. This allows for a fast initial load with SSR while enabling dynamic interactions on the client side.

A typical hybrid approach follows these steps:

The server renders and sends the initial HTML.

The client hydrates the page with JavaScript, enabling interactivity.

Subsequent data updates or interactions are handled via client-side requests.

This method balances performance and interactivity, leveraging the best of both SSR and CSR.

By adopting a framework-agnostic approach, SSR can be implemented using any backend technology that supports dynamic HTML rendering, making it a versatile choice for various web applications.

## Routing

There are two types of app routing they directly depend on the type of the website - SPA or MPA.

### Next.js

It's based on a React and provides several other ways to manage server-side fetched data.

- `getServerSideProps` and `getStaticProps`
- `"use server"`
- "middleware"

---

Even though these methods are pretty different from each other, they are still subsets of "manual" server-side fetching. They may seem otherwise since they hide behind their developer interfaces for convenience sake, but essentially the same thing.

We can confirm that by looking at their implementation...
