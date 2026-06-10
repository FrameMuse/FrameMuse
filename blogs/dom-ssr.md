# SSR with Full DOM Support

## Background

I have never worked with SSR, but recently I was tasked with that and it was somewhat challenging. I found out that usually you can't use much DOM things in your SSR components - sheesh, that's frustrating. As someone who loves the flexibility of the full browser environment, I felt defeated. I thought, “There has to be a better way.”

So I decided that **my SSR** will support all the DOM and it actually turned out better than I expected...

## DOM Limitations

Traditional SSR setups usually come with a set of constraints that simplify the rendering process, but at the cost of the natural browser experience. In many systems, SSR components are stripped of access to a rich DOM API, meaning you can't use many of the things that DOM naturally provides in a client-rendered app. This not only makes development cumbersome but also forces to adopt workarounds. 😠

It was clear that the conventional way wasn't meeting my needs as a developer.

## Dedication

What if SSR could support the full browser environment, including unrestricted DOM access? That's when I set out to create a solution that didn't require a dedicated SSR build.

## Full DOM Support in SSR

First I take a look at how other libraries/frameworks implement SSR and found out that they either simply **don't** implement DOM at all or implement the least of it (like [Lit](https://lit.dev/)).

I tried to copy-paste the Lit implementation and tried using it, but was **disappointing** as it was merely a boilerplate without actual DOM rendering and without working features like HTML elements at least.

I tried using JSDOM for that purpose - it magically worked, but when I setup my first performance benchmark - it was **disappointing**. I realize I either should abandon this idea or implement my own JSDOM.

I looked into the JSDOM code and saw a gigantic codebase - phew...

> Ok, I don't need ALL the features to actually work but just **some**.

Nah, I took a third path - looking for alternatives to [JSDOM](https://github.com/jsdom/jsdom)... And I found it - [`happy-dom`](https://github.com/capricorn86/happy-dom).

It stated that it's ... Mmm... It's better at everything at least 10x. So I decided to use it.

The simple function I came with that just works was like this

```ts
import { Window } from "happy-dom"

export function injectDOMPolyfill(context: typeof globalThis) {
  const window = new Window

  for (const key of Object.getOwnPropertyNames(window)) {
    if (key in context) continue

    try {
      // @ts-expect-error ok.
      context[key] = window[key]
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
    } catch (error) {
      // skip
    }
  }

  context.requestAnimationFrame = (callback: (a: number) => void) => { callback(1); return 2 }
}

```

## JSX Optimization

This time, before benchmarking anything, since it was clear that I need to optimize how JSX elements are stringified (turned into a string) myself (I was purely relying on `document.documentElement.outerHTML`).

I developed [`JSXSerializer`](https://github.com/pinely-international/tama/blob/main/src/jsx/JSXSerializer.ts) class, which is standalone but able to inherit  [`WebInflator`](https://github.com/pinely-international/tama/blob/main/src/Inflator/web/WebInflator.ts) configs. And it does serialization as you can tell.

It worked ~8x faster than React, so I thought it's cool and it's just 1kb of code.

Now I was prepared to do benchmarking - it was AMAZING, it scored way more than Next or React and even 5% better than Solidjs, but frameworks like Vuejs and Svelte were 25% ahead in performance than TamaJs.

_Which makes sense since they are string based from the beginning comparing to JSX, which is first creates objects and only then being converted into strings._

## Assets Problem

When setting up basic server to test my solution and ended up with a lot unnecessary code, but it was somehow working (_after 50 hours of suffering_). Working, but not displaying any images nor loading CSS correctly, I was **disappointed**. However this time it was clearly fixable as the incorrectness came from incorrect paths.

Briefly saying: My imports of images were resolved to absolute path of the system like `import MyImagePNG from "./my-image.png"` to `/home/user/project/src/component/my-image.png`, which is clearly not where my image is located in the WEB.

This time it really made my brain flexing, the question was

> How do I customize import resolution?

It first seemed like impossible until I googled. I found that Bun supports  runtime plugins via `Bun.plugin` API, which to my surprise and fortune supported changing import resolution behavior.

That's where I came up with my first plugin in Bun
[Here's the code](https://github.com/FrameMuse/bun-vite-assets-import/blob/main/bun-plugin.ts)

Ok, now I can modify **where** my assets imports are resolved to.

> How do I specify where **exactly** they should be resolved to?

Was my next question, which basically broke my brain... I came up with several ideas, all of them wasn't that great.

> So Vite places assets into `./assets` folder - cool, it adds hash suffix to each file - sheesh. Ok I just need to figure what the hashing method is and the reuse it. Nope, I simply couldn't find anything useful, even though I kinda found the script for Vite hashing, but it turned out to be arbitrary, which means developer can override it in the config or even disable the hashing entirely.

So I decided to use additional build step - yeah now this contradicts with the article banner... Nonetheless, I continue and implemented **the second** plugin for Vite
[Here's the code](https://github.com/FrameMuse/bun-vite-assets-import/blob/main/vite-plugin.ts)

## Entry points

As for basically all the frameworks and for SSR generally, it's a standard to have two entry points and thus two builds. I thought I can go with one, so what I did instead was simply exporting the [`WebInflator`](https://github.com/pinely-international/tama/blob/main/src/Inflator/web/WebInflator.ts) instance and using in the `index.ts` (or `main.tsx`), which was used in the `index.html`, which is the client entry point. And that's it.

So it means, you don't need to modify your code or care about client/server sides in your Frontend App, you don't have to touch if want SSR, just use it or don't - that's up to your use case.

Want SSR? - Put the plugins and that's it!

## Server Setup

Now it was the time to clean up the mess after my experiments with SSR, DOM and Import Resolution. Additionally, my use-case required Initial Data loading, but with this setup it was just a breeze to implement.

The `server.ts` code looks like this

```ts
import compression from "compression"
import express from "express"
import sirv from "sirv"

import { injectDOMPolyfill } from "./dom"

import getInitialData from "../src/initial-data"



const PORT = process.env.PORT || 45678
const BASE = process.env.BASE || "/"


// Load HTML template.

let templateHTML = await Bun.file("./build/index.html").text()
templateHTML = templateHTML.replaceAll(/^\s*|\n/gm, "") // Minimize.

// Serve.

const server = express()

server.use(compression())
server.use(BASE, sirv("./build", { extensions: [] }))

// SSR happens here.

server.use("*", async (req, res) => {
  try {
    await injectInitialData()
    const initialDataJSON = JSON.stringify(__INITIAL_DATA__)

    const html = templateHTML
      .replace(`<!--element-->`, jsxSerializer.componentToString(AppRoot))
      .replace(`<!--initial-data-->`, `<script>window.__INITIAL_DATA__=${initialDataJSON}</script>`)

    res.status(200).set({ "Content-Type": "text/html" }).send(html)
  } catch (error) {
    console.error(error)
    res.status(500).send("Server error")
  }
})

server.listen(PORT, () => {
  console.log(`Server started at http://localhost:${PORT}`)
})

// Polyfill DOM.

injectDOMPolyfill(globalThis)
console.log("[SSR] DOM polyfilled")

Bun.plugin(assetsImportResolution({
  cwd: path.resolve("./"),
  assets: sourceAssetsMap.assets,
}))

console.log("[SSR] Resolving imports to Vite Build Assets")

// Inject initial data for app modules import
// as they may use the initial data immediately.

await injectInitialData()

// Load app modules.

const { WebJSXSerializer } = await import("@denshya/proton")
const { default: appInflator } = await import("@/app/inflator")
const { default: AppRoot } = await import("@/app/AppRoot")

// Setup serializer.

const jsxSerializer = new WebJSXSerializer
jsxSerializer.inherit(appInflator)

console.log("[SSR] Ready to render app")

async function injectInitialData() {
  try {
    globalThis.__INITIAL_DATA__ = await getInitialData()
  } catch (error) {
    console.log(error)
    return // Gracefully.
  }
}

```

---

## Conclusion

I implemented 2 little plugins in Vite and Bun, so that SSR can resolve assets imports of the client app directly to the static build.

I used Express, Bun and Vite. I didn't introduced any new build for Vite, so it was building only once - just the client bundle with the bundle assets map. There were no modifications to the codebase since the DOM is fully supported (for real) and you don't have to care about server-side/client-side things.

At this point I realized - it's Plug & Play SSR, it doesn't require dedicated SSR build (but a bundle map generated by plugin) and fully support browser environment.

## Cloud

Unfortunately, this doesn't fit to cloud computing architecture, it works only with static assets, build and source code all placed in the same server, so it needs a further evolution that it can be implemented in Cloud (like AWS and Google Cloud).

I'm working on it, so follow me for further news.

---

I invite you to experiment with this approach, test out the plugins, and share feedback. There's always room for improvement, and I'm excited to see how this idea can evolve further with community input.

Have you encountered similar challenges with SSR, or do you know of other innovative approaches?
