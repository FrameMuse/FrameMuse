# Reduce your useEffect influence

In this article I will share my experience about making React more eventful, tell about alternatives to `useEffect` hook and how to not mess up with it.

## Introduction

React is designed with a thought in mind that its components will be written in a natural JS code, or at least it's supposed to.

But what sometimes I see it using `useEffect` and `useState` while there is no need for them at all.

I'm not going to talk about how bad the knowledge basis of those developers is, instead let's figure out actual React intentions and how to make your life easier.

There is a good video about this topic, I recommend you watch it as well to understand this article better or caught my own mistakes - <https://www.youtube.com/watch?v=bGzanfKVFeU&ab_channel=BeJS>.

## `useEffect`

First, let's briefly understand what `useEffect` is and why we need it in React.

`useEffect` is a React hook created to react to a values change.
Usually, this is helpful for external coming values: Browser or third-party API, event handling or component props.

By the [official documentation](https://react.dev/reference/react/useEffect):
> useEffect is a React Hook that lets you synchronize a component with an external system.

## no `useEffect`

Let's imagine there is no `useEffect` right now, how would you **react** to a value change **within** a component?

The thing is you **always** get a value from a user (i.e. text input) by passing a function and getting an access to the value in it. So if shortly, you can react a value change without any `useEffect`s.

The `useEffect` comes in mind when there is `useState` that is already bound to a user input, this is easy to follow a bad practice by adding a `useEffect` instead of little refactoring.

If you really want to grasp `useEffect` follow [the documentation](https://react.dev/reference/react/useEffect), they have a lot of good practices.

## Understand `useEffect`

When you're solving a problem of local component data maintenance, try to not think about `useEffect`, think about other hooks, for example the `useMemo` or `useCallback`, but same as for `useEffect` - don't overuse them too. That may surprise you, but you might not need any hooks at all if operations are simple, always appeal to a cleaner code first.

Remember, `useEffect` is a tool not a magic wand, not a react cancer, it's very powerful tool if you use it meaningfully.

Sometimes though, it is used with internal and external states at the same time, so you just need to find that feeling of what you can and can't do with `useEffect`.

This is a really discussed topic, you can find a lot discussions and practices on it.

- [React Documentation](https://react.dev/reference/react/useEffect#specifying-reactive-dependencies)
- [Goodbye useEffect](https://www.youtube.com/watch?v=bGzanfKVFeU&ab_channel=BeJS)
- [Detailed useEffect guide](https://blog.logrocket.com/useeffect-react-hook-complete-guide/)

## Obscure `useEffect`

Another good practice practice is to "hide" a `useEffect` block, e.g. a boilerplate code like store subscriptions, event handling or complex structure.

React is about creating UI, so when you see a component, you're focusing on the logic and how it affects the UI. It becomes challenging to [reason about the code](https://stackoverflow.com/questions/18666821/what-does-the-term-reason-about-mean-in-computer-science) when amount of logic increases.

In this case you may have to use several `useEffect`s to implement required features. The solution is simple - code splitting.
Create [custom hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) and use popular libraries like `react-use`, you don't need to implement everything on your own, **sometimes** you need to delegate to one that serves it better.

Instead of seeing all the code right in one component, it would become really easy to understand the code if you see several custom hooks with clear name without **exposed** `useEffect`s, even if they filled with barely understandable logic.

## Thanks

Thank you for reading!

_This article lacks code examples, so if you'd like to help, propose yours - I will add them._
