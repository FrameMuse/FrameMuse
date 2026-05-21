# Faster JavaScript Loops Even Seniors Don't Know About

_Measured with Bun 1.3.14 (JavaScriptCore) on Linux. Different engines produce different numbers, but the relative ordering holds._

---

## Loops

Loops are everywhere. Every program iterates over something: API responses, DOM nodes, event lists, pixel buffers, database rows. JavaScript gives us several ways to write a loop, most developers pick one and stick with it without ever questioning whether it's the right one for the job.

Before we talk about speed, let's catalog what we're working with.

_Feel free to skip this section if you're already aware of every iterating approach._

### `for` range

The classic C-style loop. You manage the counter yourself:

```js
for (let i = 0; i < items.length; i++) {
  process(items[i])
}
```

It's explicit, it's familiar, and it puts you in control of the index. You can iterate forward, backward, skip elements, break early. This is the loop most developers reach for to achieve higher performance.

### `for..of`

Introduced in ES6, `for..of` consumes any **iterable** object:

```js
for (const item of items) {
  process(item)
}
```

Cleaner syntax. No index variable. Works with arrays, strings, Maps, Sets, generators, and anything that implements `Symbol.iterator`. Under the hood, it calls `.next()` on an iterator object until `done` is `true`.

### `for..in`

The oldest specialized loop. It enumerates **keys** of an object:

```js
for (const key in record) {
  process(record[key])
}
```

It traverses the prototype chain - not just own properties. For plain objects you usually guard with `hasOwnProperty`. For arrays, it iterates indices as strings (`"0"`, `"1"`, ...), which is almost never what you want.

### `while`

The primitive loop. Runs as long as or while a condition is truthy:

```js
let i = 0
while (i++ < items.length) {
  process(items[i])
}
```

`do..while` is its lesser used sibling. `while` doesn't give you anything `for` doesn't, it's just a different alternative option.

### `.forEach()`

The functional approach:

```js
items.forEach(item => process(item))
```

No `break`, no `continue`, no `return` to short-circuit. Every element gets a function call. Elegant, but lack of control flow has a cost.

---

Each of these loops has its place. But they don't all work with the same data structures. To understand which loop is fastest for which job, we need to understand what we can iterate over in the first place.

---

## Iterable Objects

Loops are one half. The other half is what you're looping over. Here are the primitives JavaScript gives you.

### `Array`

The most common iterable. Arrays have a `.length`, numeric indices and a dense memory layout. They implement `Symbol.iterator`, so `for..of` works natively. It's also common to iterate them over via  `for (range)`.

This dual compatibility is what makes array iteration interesting: you can go through the iterator protocol (`for..of`, `forEach`) or bypass it entirely with `for (range)`.

### `Object`

Plain objects, dictionaries or records have no `.length`, no numeric indices nor built-in iterator. You cannot `for..of` an object. Your options are:

- **`for..in`** - enumerates keys including the prototype chain.
- **`Object.keys(obj)`** / **`Object.entries(obj)`** / **`Object.values(obj)`** - returns an array of keys/values/entries, which you then iterate as a regular array.

Objects have a different memory structure. Each property lookup is a hash table access (), which makes object iteration fundamentally different from array iteration.

### `Iterable` / `Generator`

Any object can become iterable by implementing `Symbol.iterator` — a method that returns an iterator object with a `next()` method. Each call to `next()` must return `{ value, done }` — a fresh object on every call.

Here's a manual iterator that yields numbers from `start` to `end`:

```js
const range = {
  from: 1,
  to: 5,
  [Symbol.iterator]() {
    return {
      current: this.from,
      last: this.to,
      next() {
        if (this.current < this.last) {
          return { value: this.current++, done: false };
        }
        return { value: undefined, done: true };
      }
    };
  }
};
```

That's a lot of boilerplate. Generators are syntax sugar that let you write the same logic declaratively:

```js
function* range(start, end) {
  for (let i = start; i < end; i++) yield i;
}
```

The `yield` keyword pauses execution and returns `{ value: i, done: false }`. When the function ends, it returns `{ value: undefined, done: true }`. Each `.next()` call allocates a result object, a detail that will matter enormously when we measure speed.

---

## Making Them Faster

Now let's measure.

**Setup**: all benchmarks run on 1,000,000 items (except where noted), summing values into a single accumulator. The work is identical, only the loop mechanism changes.

### Arrays: The Expected Answer

Ask a senior JS developer "what's the fastest way to iterate an array?" and they'll say: the classic `for` loop. No function calls, no iterator protocol — the engine can optimize it down to pointer arithmetic.

They're right, but the margins are tight:

| Technique | Time | vs `for (range)` |
|-----------|------|----------------|
| `for (range)` | 4.209 ms | 1× |
| `.forEach()` | 4.218 ms | +1.00× |
| `for..of` (array) | 4.157 ms | 0.99× |
| Generator (`for..of`) | 25.829 ms | **+6.14×** |

`for (range)`, `.forEach()`, and native array `for..of` are all identical — JS engines special-case array iterators so aggressively the protocol overhead vanishes. But the generator is **6× slower** even with `for..of`. Custom iterables pay the full cost.

And calling `.forEach()` on a generator makes it worse:

| Technique | Time | vs `for (range)` |
|-----------|------|----------------|
| `for (range)` (array) | 4.209 ms | 1× |
| Generator (`for..of`) | 25.829 ms | +6.14× |
| Generator `.forEach()` | 53.621 ms | **12.7×** |

Generator `.forEach()` is 12.7× slower. Why?

The iterator protocol: every `.next()` call allocates `{ value, done }`. For 1M elements, that's 1M temporary objects. The generator `for..of` case pays a 6× penalty from the iterator protocol overhead. The `.forEach()` case adds a function call boundary on top of each allocation — too much for the optimizer to handle. Allocation pressure and per-element function calls compound into a 12.7× penalty.

**Takeaway**: For arrays, `for (range)` is a reliable default — but generators hide a sharp edge when combined with `.forEach()`.

### Objects: `for..in` vs Pre-Extracted Keys

For plain objects, the default is `for..in`:

```js
for (const key in record) {
  sum += record[key]
}
```

But there's an alternative: extract keys into an array first, then iterate with `for (range)`:

```js
const keys = Object.keys(record)
for (let i = 0; i < keys.length; i++) {
  sum += record[keys[i]]
}
```

The first costs a prototype chain walk on every iteration. The second pays a one-time cost to build the keys array, then cheap indexed access. Intuition says the second wins because we pre-allocate an array of keys once, which is cheaper than per-iteration property lookups. Let's measure.

| Technique | Time | |
|-----------|------|------------|
| `for..in` on record | 41.0 ms | **fastest** |
| `for (range)` on `Object.keys()` | 136.1 ms | +3.32× |
| `for..of` on keys | 141.2 ms | +3.44× |

`for..in` wins by 3.3×. The conventional wisdom is **wrong** for string keys.

**But why?** Building an array of 1 million strings is expensive. `Object.keys()` allocates the entire array upfront with massive amount of strings, then you iterate it. `for..in` walks the object internal property table directly, no allocation, no intermediate array.

The prototype chain walk is cheaper than allocating million elements.

#### Numeric-only keys

Everything changes when a record contains only numbers (e.g. `0`, `1`, `2`, ...).

| Technique | Time | |
|-----------|------|------------|
| `for (range)` on `Object.keys()` | 41.3 ms | **fastest** |
| `for..of` on keys | 42.7 ms | +1.03× |
| Unrolled on keys | 41.4 ms | +1.00× |
| `for..in` on record | 236.0 ms | +5.71× |

The opposite happens. `for..in` loses by 5.7×.

**What changed?** Engines store integer-indexed properties in a different internal structure (similar to arrays). `for..in` must enumerate this structure in insertion order, which requires sorting and extra bookkeeping, the overhead dwarfs the keys array allocation. Meanwhile, `Object.keys()` returns an array that's already ordered, and indexed access on integer keys hits the fast path.

A third thing to notice: for both key types, `for..of` on the pre-extracted array is essentially the same speed as `for (range)` on it. JS engines special-case array iterators so heavily that the iterator protocol overhead vanishes. There's no meaningful difference between `for (const key of Object.keys(obj))` and extracting + `for (range)`.

#### Pre-allocation

But real programs rarely iterate an object once. You might process the same record inside a render loop, a hot path, or across multiple request handlers.

To see how this plays out, we iterate the same 10,000-key object 100 times:

##### String keys

| Technique | Time | |
|-----------|------|------------|
| `for..in` (record) | 33.3 ms | **fastest** |
| `Object.keys()` reused | 43.4 ms | +1.30× |
| `Object.keys()` called every pass | 72.3 ms | +2.17× |

##### Numeric keys

| Technique | Time | |
|-----------|------|------------|
| `for..in` (record) | 89.2 ms | +2.25× |
| `Object.keys()` reused | 39.7 ms | **fastest** |
| `Object.keys()` called every pass | 199.7 ms | +5.03× |

Even amortized over 100 passes, `for..in` still wins for string keys — the prototype chain walk is cheap enough to beat iterating an array. For numeric keys, the pre-extract-and-reuse approach holds its lead.

The real gotcha is the third row in each group: **calling `Object.keys()` inside the loop**. If you write `for (const key of Object.keys(obj))` inside a hot outer loop, you're allocating the full keys array on every pass — a 2×–5× penalty compared to extracting once and reusing. The fix is trivial: hoist the `Object.keys()` call above the outer loop.

---

**Takeaway**: The fastest strategy depends on your keys. String keys? `for..in` wins (no allocation). Numeric keys? `Object.keys()` + `for (range)` wins (engine fast path). However, very often you just don't, so to make your life easier, just use `for in` for records.

### Loop Unrolling

`for (range)` is the smart default for arrays. But can we go further?

Yes! We process multiple elements per loop iteration, reducing the number of condition checks and increments:

```js
// Round down to the nearest multiple of 8.
const limit = items.length & -8

// Process 8 elements per iteration.
for (let i = 0; i < limit; i += 8) {
  process(items[i])
  process(items[i + 1])
  process(items[i + 2])
  process(items[i + 3])
  process(items[i + 4])
  process(items[i + 5])
  process(items[i + 6])
  process(items[i + 7])
}

// Remaining elements if array length doesn't divide by 8.
for (let i = limit; i < items.length; i++) {
  process(items[i])
}
```

Rounding down to the nearest multiple of 8. The cleanup loop catches the tail.

You can also wrap this into a reusable function — the call overhead is negligible compared to the 3.5× speedup from unrolling, so you get free performance from a userland helper.

| Technique | Time | |
|-----------|------|------------|
| Unrolled Loop (function) | 1.214 ms | **fastest** |
| Unrolled Loop (inline) | 1.214 ms | +1.00× |
| `for (range)` | 4.209 ms | +3.47× |

**3.5× faster**. The main loop runs 8× fewer iterations, which means 8× fewer branch predictions, 8× fewer bounds checks, 8× fewer increment operations. This is the spiritual descendant of Duff's Device, a 1983 C technique for unrolling memory copies. JS engines don't auto-unroll, so you do it yourself.

On objects, unrolling barely helps, property lookup cost dominates the loop overhead. But on arrays, it's a free 3.5×.

**Takeaway**: For massive arrays, unrolling is the real step beyond `for (range)`. You can add a simple check if array is bigger than 32 elements to kick in unrolling, otherwise do a normal iteration, which results in a balanced speed for both small and massive arrays.

### The Generator Problem

We saw Generator `.forEach()` at 53.6 ms is 12.7× slower than `for (range)`.
Even plain generator `for..of` is 6× slower — the iterator protocol allocates `{ value, done }` per iteration.

What if we stop allocation somehow?

```js
class ZeroGCRange {
  result = { value: 0, done: false }

  [Symbol.iterator]() {
    this.result.value = this.start - 1
    this.result.done = false
    return this
  }

  next() {
    this.result.value++
    if (this.result.value >= this.end) {
      this.result.done = true
    }
    return this.result
  }
}
```

No allocations. No GC pressure. The result:

| Technique | Time |
|-----------|------|
| ZeroGCRange (`for..of`) | 4.196 ms |
| `for (range)` (array) | 4.209 ms |
| Generator (`for..of`) | 25.829 ms |

ZeroGCRange matches `for (range)` — eliminating allocations brought the 6× penalty down to zero. The allocations **were** the bottleneck. The iterator protocol's method dispatch (`.next()`) adds negligible overhead; it's the 1M `{ value, done }` objects that hurt.

**Takeaway**: ZeroGC is useful when you _must_ use the iterable protocol but want predictable GC behavior. It's not faster than `for (range)`, but it restores competitive performance by eliminating the allocation churn. To go beyond `for (range)`, you need to escape the iterator protocol entirely — either with unrolling (fewer iterations) or with no loop at all.

> **Shared instance is faster but fragile.** Reusing one `ZeroGCRange` across nested loops corrupts the outer loop position. You trade GC safety for reentrancy bugs. More broadly: mutating a shared result object means any code that iterates the same instance mid-flight (nested loops, concurrent passes, event-driven iteration) will see scrambled state. It's a valid technique, but only when you control the entire call stack.
>
> **When you don't need it.** Not all iterables need this treatment. Arrays, Maps, and Sets have engine-level optimizations that make `for..of` as fast as `for (range)`, the JS engine optimizes their iterators so aggressively that the allocation overhead vanishes. Sticking with a standard `for..of` on a built-in iterable is both idiomatic and fast. Only pull out a shared iterator when you're iterating a custom iterable (like a generator) on a hot path and you've measured that allocations are the bottleneck.
>
> **When you do.** If profiling shows iterator allocations dominating your hot path and you can guarantee no nested iteration of the same instance, a shared iterator gives you consistent 6× speedups over generators. It becomes more fragile, but the wins are real.

---

We've pushed `for (range)` as far as it goes: unrolling gives 3.5× on arrays, and the iterator protocol is a fixed cost we can avoid but not eliminate. Native `for..of` on arrays is free — engines special-case it — but custom iterables pay the full price. Objects are more nuanced — `for..in` wins for string keys, `Object.keys()` wins for numeric keys — but neither approach can be meaningfully improved by unrolling. What comes next is a different category of speed — and a different category of risk.

---

## The Unconventional Method

What if we eliminated the loop entirely?
Technically, it wouldn't be a loop anymore but still.

If the keys are known ahead of time (e.g. a fixed set of JSON fields to sum), we can generate code that spells out every operation as a single expression.
No loop. No iteration counter. No condition checks. No iterator protocol.
Just one massive straight-line path of property lookups and additions:

```js
const keys = ["k0", "k1", "k2", /* ... */ "k9999"]

// Generate: OBJ["k0"] + OBJ["k1"] + OBJ["k2"] + ...
const body = keys.map(k => `OBJ["${k}"]`).join(" + ")

// Compile it into a function. OBJ is a parameter — not a closure variable.
const sumFn = new Function("OBJ", `return ${body}`)
```

This is called **baking**: you pre-generate code at init time, pay the compilation cost once, then call the function as many times as you need. The JIT sees one enormous basic block without branches and can apply optimizations (instruction scheduling, register allocation, etc.).

At 10,000 string-keyed properties:

| Technique | Time | vs Fastest |
|-----------|------|------------|
| `for..in` on record | 294.6 µs | +3.17× |
| Baked (`eval`) | 143.9 µs | +1.55× |
| Baked (`new Function`) | 93.0 µs | **fastest** |

Baked is **3.2× faster** than `for..in`. But notice two things: `new Function` is 1.5× faster than `eval`, the parameter approach lets the engine optimize the function better than the scope-capturing `eval` version.

**`eval` vs `new Function`**: `eval` runs in the current scope and can see local variables, so you can write `eval("() => RECORD.k0 + RECORD.k1 + ...")` and it works. `new Function` has **no closure access**: it can only see global variables. The body above uses `OBJ` as a parameter name because `new Function("return RECORD.k0 + ...")` would throw `ReferenceError: RECORD is not defined`. The fix is simple: use a parameter. And it's worth doing, passing the record as an argument also makes the function reusable across different records.

[ajv](https://www.npmjs.com/package/ajv) package, one of the most downloaded JSON schema validators, uses code generation (`new Function()`) to compile validation schemas into optimized functions. The same principle powers template engines, SQL query builders and serialization libraries. It's a real technique, used in production by packages you depend on.

It seems like solving everything, but it comes with heavy constraints:

- **`eval` and `new Function` are blocked by CSP** in most browser deployments. If you ship to the web, assume this technique is unavailable unless you control the CSP headers.
- **`new Function` has no closure access.** Variables from the enclosing scope are invisible, you must pass data as parameters.
- **Keys must be known at init time.** If the set of keys is dynamic, baking make much less sense.
- **Code generation is a security boundary.** Any user input interpolated into generated code is an injection vector. Never bake with unsanitized data.
- **Debugging is miserable.** Stack traces point into `eval` strings with no source maps. If something breaks, you're reading generated code by hand.

It's the fastest technique in JavaScript and also the most dangerous. Reach for it when the speedup trade-off much bigger than the fragility and security concerns.

---

## Premature Optimization

Knuth's quote:

> "The real problem is that programmers have spent far too much time worrying about efficiency in the wrong places and at the wrong times; premature optimization is the root of all evil (or at least most of it) in programming."

Even though this guys' quotes are debatable the word is _premature_.

Iterating 50 form fields? `for..of` is fine.
Building a dropdown list? `.forEach()` is fine.
Quickly sketching something? Use whatever first comes to your mind.

But knowing _why_ things are fast or slow changes your instincts:

- Writing a **game loop** at 60 FPS? Millisecond budgets are real.
- Building a **library** consumed by millions? The 3.5× from unrolling may justify the ugly code. (`ajv` developer thought so.)
- Processing **streaming data**? Understanding that iterator allocations cause GC pressure helps you pick the right abstraction.
- Iterating a **record with known fields**? Knowing that string keys favor `for..in` (no allocation) while numeric keys favor `Object.keys()` (engine fast path) lets you pick the right tool instantly.

The goal isn't to chase the fastest technique every time. It's to understand the landscape so you can make informed trade-offs when it counts.

---

## Conclusion

Each step taught us something: the iterator protocol allocates a lot. `ZeroGCRange` proved the allocations are the bottleneck. Unrolling reduces control overhead. String-keyed objects favor `for..in` (no allocation), numeric-keyed objects favor `Object.keys()` (engine fast path). And regardless of approach, extract `Object.keys()` once, never inline it in a loop body. Code generation eliminates the loop entirely at the price of safety. Prefer `new Function` over `eval`: it's 1.5× faster and forces you to pass data as parameters rather than capturing scope, which makes the baked function reusable.

What frustrates me is that JavaScript engines _could_ close most of these gaps. Loop unrolling, scalar replacement of aggregates (optionally eliminating `{ value, done }` allocations) and escape analysis are textbook compiler optimizations. Some engines apply them in narrow cases. None do it reliably enough that idiomatic iterators perform as well as hand-optimized loops.

Until they do, knowing the landscape, not blindly applying every trick, is what separates a curious engineer from a cargo-cult optimizer.

---

_Benchmarks: Bun 1.3.14 (JavaScriptCore), Linux. 1,000,000 elements per test (10,000 for baked eval). Median across repeated runs. Absolute numbers vary by engine; the ordering is stable across V8, JavaScriptCore, and SpiderMonkey._
