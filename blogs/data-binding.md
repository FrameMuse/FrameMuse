# Data Binding

I've read multiple articles trying to understand this <u>simple</u> concept, but it got all difficult because of so many articles written for [React](https://react.dev/), which have turned to be misleading.

Let's see together what Data Binding actually **is** and **isn't**.

## Where it came from

## Concept

Despite the naming, data binding in reality is about the properties [needs confirmation] not the data itself, but their "holders" (which are indeed **properties**).

That's nothing more than overriding a setter (hijacking) of a property in order to update the property itself (bound source) as well as a desired property (bound target).

---

There are two (almost 3) types of Data Binding.

If you update a property, it guarantees an update of another specific one.

## What it is
## What it isn't

You CAN'T think about it as binding between domains, different parts of application or stores. It's simply different concepts.

Parts, domains or whatever can contain tons of properties, by calling it "Data Binding" all together, you're making this concept more ambiguous. 

If you <u>exchange</u> data between different parts of your application, it's called **Interface**, not **Data Binding**.

If you <u>assign</u> a property

## Why React articles may be misleading

...

But why they got into this trap? - That's because of the React itself, how] how unintuitive its lifecycle is and lack of expertise in understanding the syntax (JSX).

> React provides one-way data...

That's not true, it doesn't provide any kind of Data Binding. If you thought about putting values into properties, that's just assigning values **ON RENDER**. Any properties will never be update if any of the declared assignee data changes. Thus it's not a **Binding**.

And you can have a Two-way Data Binding in React too by using Emitters. Yes, just as well as Angular does!

Meaning those React Articles are written by amateurs, they don't understand what's they're promoting. If you think otherwise, let's debate.

---

As you can see it's very simple and intuitive concept. It's not actually about the data itself but rather about their "holders" - properties. One property updates - second gets updated subsequently. It could be vice versa and they can work in synergy.
