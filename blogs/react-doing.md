# What React is actually doing?

It might sound obvious for you if you know React, but it's not what you think it really is.

Probably many of us started/tried building websites in vanilla JS or JQuery and then get caught up by React. Because it's **actually** great, it opened a whole new door to the fields of what building websites could really be - it can be simple and entertaining for **developers**.

They can compose html elements right in JS (what they were actually doing with `document.createElement` or jQuery alternatives), but now you can do it with very similar to HTML syntax called [JSX](https://en.wikipedia.org/wiki/JSX_(JavaScript)).

Moreover, now developers can build Dynamic components with JSX and JS at the same time without need of thinking for complex elements composition mechanisms. Not talking about Custom Components!

Sad part started when React began to "evolve" further, making the learning curve so steep that you need years to fully understand it.

The problem is ... DATAFLOW (*thunderclaps in the background*). It all happened due to the most liked feature of React **Virtual DOM** and this is also a reason why they had to implement their own dataflow mechanisms. Since React is not explicitly exposing any internal objects, you can't just create your own state manager - you only have to rely on what React is providing you with.

I recently posted very short article-statement about it, [No-Framework Principle](https://dev.to/framemuse/no-framework-principle-arised-2n39)

By itself, it's not a bad practice by itself, the issues come from the direction in what React Team has been leading us to.

---

Ok, we just got known about Why React great and Why it's not, now let's dive in what is React really is without its complexity and if can help it somehow.

- if you go to source code of useState, useMemo and useEffect, they're very simple and straight forward, ...
- what the jsx is all about
- counter intuitive react components update

## Broken react thinking

Let's have a mental experiment.

One is given a plain, standardized JS code that is a class that contains logic for checking the network status and JSON request and parsing of localization that is taken from `localStorage` in case if user is online.

One is asked to fit the code to the react application, to one or many components (it doesn't matter).

What this person would do in your Opinion? (tell me in the comments)

### My expectation

What I expect from hypothetical person, or my colleagues (or myself several years ago) to do with the code:

One will refactor the code to fit to react, it will use `useState` for `pending`, `error`, `response` states; `useEffect` for fetching + checking online status when component is rendered.

One also can consider extracting the code into [Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) in case the code will be reused. Like `useOnlineStatus` and `useLocalization()`.

Agree?

_I don't state that this is EXACTLY what could've been done, maybe it's just me here. Though this is what I have watched is done by many developers many times._

### IMHO

This is not what should be done. What I would've done is not a **refactoring**, I would not touch the original code at all.

My solution is simple - **integrate** given code by creating an adapter ([Guru](https://refactoring.guru/design-patterns/adapter) | [Wiki](https://en.wikipedia.org/wiki/Adapter_pattern))

I would write one single hook - `useResource`!
