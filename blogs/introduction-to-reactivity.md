# Introduction to Reactivity

You can look at the Reactivity from different angles

It all starts with an Accessor, which typically can be faced as a Variable

```ts
let a = 1
a = a + 1 // Gets and Sets `a` variable
```

Then you want to add some special meaning, behavior or encapsulate the Accessor

```ts
class Accessor<T> {
  private value: T
  constructor(initialValue: T) { this.value = initialValue }

  set(newValue: T) { this.value = newValue }
  get(): T { return this.value }
}
```

**Example**

```ts
const a = new Accessor(1)
a.set(a.get() + 1)
```

> In this context, "Accessor" is simply a structure that encapsulates a value with explicit getter and setter methods. It can be transformed to many other forms besides Observable one.

Now we want to run some code whenever it receives a new value, this is the point when it's called Reactivity since we want to react to a new value.

At this point it becomes obvious that Accessor is not just an Accessor anymore, it's State since we're talking about it as a structure capable of keeping a value, retrieving and updating it.

```ts
class State<T> {
  private value: T
  constructor(initialValue: T) { this.value = initialValue }

  set(newValue: T) { this.value = newValue }
  get(): T { return this.value }
}
```

Now this seems right (**to me**). Naming means a lot, it can completely change how you see and understand a code, the same structure can share/extend the same code while being used in different ways. This means a lot for a potential change in future.

## Observe

Before we continue with our state, we need a structure that would be handling updates observation.

There are two approaches to it: Event-based and [Closure-based](https://github.com/FrameMuse/closure-signal), let's dive in to Event-based for simplicity.

In theory, whenever something is updated, we would invoke a dispatch function to notify listeners.

We also need to register a listener for new updates (this is usually a callback function itself).

```ts
class Messager<T> {
  private readonly callbacks = new Set<(value: T) => void>()

  dispatch(value: T) {
    this.callbacks.forEach(callback => callback(value))
  }

  subscribe(next: (value: T) => void) {
    this.callbacks.add(next)

    // In reality, sometimes we need to unsubscribe from it,
    // so we're returning such function as per the TC39 Observable Proposal, which may be a new standard
    return {
      unsubscribe: () => this.callbacks.delete(next)
    }
  }
}
```

By composing it to the State or Accessor, it would become **Observable** State/Accessor

> I'm using a [composition pattern](https://en.wikipedia.org/wiki/Composite_pattern) here, analog is [inheritance](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)). Make sure to learn about [inheritance flaws](https://www.youtube.com/watch?v=hxGOiiR9ZKg&t=212s) as well.

```ts
class State<T> {
  private readonly messager = new Messager<T>()

  private value: T
  constructor(initialValue: T) { this.value = initialValue }

  set(newValue: T) {
    this.value = newValue
    this.messager.dispatch(newValue)
  }
  get(): T { return this.value }

  subscribe(next: (value: T) => void) {
    return this.messager.subscribe(next)
  }
}
```

**Example**

```ts
const state = new State(123)
state.get() // 123
state.subscribe(value => console.log("value", value))
state.set(6) // value 6
state.get() // 6
```

As you can see, this is a very simple though very powerful code, which can be applied widely and extended as well.

You can find a working code in this repository
<https://github.com/FrameMuse/event-signal>

It's written in TypeScript, to play with it, use [TypeScript Playground](https://www.typescriptlang.org/play)

---

If you're writing your own Signal-like structures, make sure to stick to standards, so your code can be easily understood.
