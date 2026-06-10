# `useEffect` With `AbortSignal`

If this is the way you subscribe to events, then you must keep reading.

```tsx
function Component() {
  const ref = useRef()

  useEffect(() => {
    if (ref.current == null) return

    function onDrag(event: DragEvent) { ... }
    function onDrop(event: DragEvent) { ... }

    ref.current.addEventListener("drag", onDrag)
    ref.current.addEventListener("drop", onDrop)

    return () => {
      ref.current.removeEventListener("drag", onDrag)
      ref.current.removeEventListener("drop", onDrop)
    }
  }, [])  

  return <div ref={ref} />
}
```

Of course, there are other ways to subscribe to these ones such as:

- `<div onDrag={onDrag} onDrop={onDrop} />`
- Using libraries with utility hooks like `useEvent`

However, the problem is that - it's not always accessible.

- If you want to properly listen to resize updates, you should use `ResizeObserver` or to track viewport enter, the `IntersectionObserver`.
- There are cases when you need to integrate third-party libraries that are not React into React 😱, and subscribe to the elements like shown in the example above.

The shows example is already ok, but we can raise the bar a little bit. And this is good to know several ways how to implement something rather than single one.

## [`AbortSignal`](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal)

`AbortSignal` is simply an object that can be passed when you subscribe to an event source, either `addEventListener` or [`when(...).subscribe`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget).

So instead of calling a separate function to **unsubscribe**, you can just pass a `signal` and that's it. The subscription or **subscriptions** can terminated when `signal.abort` is called.

## Improved `useEffect`

To make an improvement, we simply introduce a `AbortController` to have access to `abort` and the `signal` that we can pass around.

```tsx
function Component() {
  const ref = useRef()

  useEffect(() => {
    if (ref.current == null) return

    const abortController = new AbortController
    const signal = abortController.signal

    ref.current.addEventListener("drag", event => { ... }, { signal })
    ref.current.addEventListener("drop", event => { ... }, { signal })

    return () => abortController.abort()
  }, [])

  return <div ref={ref} />
}
```

And you can go further and create a very simple custom hook

```tsx
function useEffectScoped(callback: (signal: AbortSignal) => void) {
  useEffect(() => {
    const abortController = new AbortController
    callback(abortController.signal)
    return () => abortController.abort()
  }, [])
}
```

To transform the final implementation into this

```tsx
function Component() {
  const ref = useRef()

  useEffectScoped(signal => {
    if (ref.current == null) return

    ref.current.addEventListener("drag", event => { ... }, { signal })
    ref.current.addEventListener("drop", event => { ... }, { signal })
  })

  return <div ref={ref} />
}
```

Which eliminates extra unsubscribe call (`removeEventListener`) for each subscription (`addEventListener`), shorts `AbortController` and `return` declaration.

In total we're abstracting away from almost half of the code!
