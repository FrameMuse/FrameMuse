# Faster Loops Even Senior Don't know about

_maybe change title_
[JS]

## Loops

Loops are everywhere... it's used in every program...

### For range

### For of

### For in

### While

### `forEach`

---

So how to make them faster? To answer that, we need to undertsand what primitives we can iterate over.

## Iterable Objects

### `Array`

### `Object` (dictionary/record)

### `Iterable`/`Generator`

---

Now let's finally get to the point of iterating things faster.

## Faster

- `for range` is very fast to iterate over array, but there are other options to do so: `for of` shared iterator, unrolled loop
- `for in` is quite fast and simple to iterate over records, but
- `for of iterable` is not the fastest as you may expect, actually there is a faster way, which is

So the ultimate one

## Unconventional Method

This is something you rather NOT use, but it makes things even faster indeed and useful to know about.

One of the methods is "baked" iteration, where you bake code body like iterating over object properties (`for in`) via `eval`.

This is dangerous, might not work in every evironment and very much discouraged by community.

However, there are some libraries that use this method, these are treated as **Fastest** and very much popular - like [ajv](https://www.npmjs.com/package/ajv) package. _maybe it's not using `eval` anymore, make sure._

## "Premature Optimization Evil"

As one man once said:
> "Premature Optimization is the root of evil"

It's really interesting to dive into making things faster,
but

## Conclusion

We've covered many things, we understood bla-bla-bla

It's frustrating that JavaScript fails to provide fast iteration natively, while it's absolutely possible even via custom JS implementation
