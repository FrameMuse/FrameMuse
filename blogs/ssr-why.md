# Do you use Next.js because of SSR? Here's how to do it with Plain React and without

I've often heard and been told that they use Next.js purely because of SSR to improve SEO, loading speed and such.

But do you really need Next.js to do SSR properly?
Well, let's try to get into it in this post.

## Next.js

To many surprise, it's not a magical framework to "somehow" render React on server. Actually, the React itself provides this feature natively via [`renderToString`](https://react.dev/reference/react-dom/server/renderToString) and such.

But then why you may have heard about Server-side vulnerabilities where Next.js was a central point? - That's because of how Next.js handles Component Props and Server-Client Sides Splitting via `"use server"` and `"use client"` directives - just like a well-known [`"use strict"`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode).

Next.js developers made several simple but critical mistakes in how data is serialized between client and server-side, which led to running **unsafe code** on the server.

The rest of Nest.js is a set of the most necessary libraries and a universal bundling.

## Custom Next.js

Luckily we have mature libraries of every need you may have as a React developer:

- Vite (can build in SSR/SSG modes)
- React Router
- React supports `<head>` tag now
- React has `renderToString`
