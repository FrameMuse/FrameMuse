# Group: A Persistent, Transparent Node Range for the DOM

## Introduction

The DOM gives us `DocumentFragment` for assembling nodes off-screen, but the moment you attach it, the fragment empties — its children scatter into the live tree and the handle goes dark. Want to move them later? Reorder them as a unit? You're on your own.

This isn't a niche problem. Every framework that renders lists, toggles sections, or composes UI from functions has invented its own workaround: comment sentinel nodes, wrapper `<div>`s, internal bookkeeping arrays. React has `Fragment`. Lit uses boundary comments. Svelte emits `<!>` anchors. The platform offers no first-class primitive.

This post traces the path from that gap to [`node-group`](https://github.com/FrameMuse/node-group) — a library that implements a persistent, CSS-transparent node range **without patching any DOM prototypes** — and situates it within the broader push for a web standard that has been unfolding since 2019.

## Why Group Nodes Matter

### Ownership Sharing

React popularized a compositional model where components don't insert themselves into the DOM — they *return* elements and let the caller decide placement. [@robbiespeed articulated this clearly](https://github.com/whatwg/dom/issues/736#issuecomment-2802918087): without a grouping primitive, a developer building a mini-framework must either special-case rendering for groups or manually track arrays of nodes and their insertion points.

Consider a simple list component that returns multiple sibling elements:

```js
function List() {
  const group = new Group()
  const items = []
  for (let i = 0; i < 20; i++) items.push(Item(i))

  const reverseButton = Button("Reverse Order", () => {
    group.replaceChildren(reverseButton, ...items.reverse())
  })

  group.append(reverseButton, ...items)
  return group
}
```

Without `Group`, the caller of `List()` receives a `DocumentFragment` that empties on first insertion — or an array of nodes with no stable anchor. With `Group`, the returned value is a persistent, movable handle. The caller can `append(group)` into any parent, move it with `insertBefore`, or replace its children, all through standard DOM APIs.

This is **ownership sharing**: the component owns the *content*, the caller owns the *placement*. `Group` makes that pattern work in vanilla JS without wrappers or bookkeeping.

### The Sentinel Problem

A single `Comment` node often serves as a placeholder for dynamic content. It works well for single-element swaps. But once you need to manage **multiple** sibling elements, you face a hard edge case: a comment cannot be replaced *again* after it is removed. You must track either all inserted nodes or at least one sentinel node. If that sentinel is removed — manually, by a framework, or via DevTools — you lose the anchor entirely.

`Group` eliminates this by acting as a persistent owner of a node range. It preserves placement semantics even as children come and go. It can insert, move, or replace its entire content without requiring external code to micromanage insertion points.

### React-like Fragment, in the Real DOM

React's `Fragment` groups multiple children without extra wrapper nodes — critical for table rows, list items, and flexbox children where an extra `<div>` breaks layout. Yet in the raw DOM, this concept has no native equivalent. `DocumentFragment` is ephemeral. Wrapper elements interfere with CSS and markup semantics.

`Group` serves as a durable, runtime-level fragment: one that lives in the actual DOM tree, can be referenced, mutated, and reasoned about. It brings the compositional ergonomics of virtual DOM frameworks into native APIs — without adopting a framework.

### Fine‑grained Updates

Animating or diffing isolated elements repeatedly invokes costly layout calculations. Grouping nodes reduces repaint storms by allowing batch operations on a logical unit. A single `group.remove()` or `group.replaceChildren(...)` replaces what would otherwise be a loop of individual mutations.

## Background & Prior Art

### `DocumentFragment` — Ephemeral by Design

The DOM's `DocumentFragment` is intentionally one-shot: it exists for off-screen assembly, and once appended, it empties. This is by spec — the fragment was never meant to persist. But this design leaves a gap: there is no native primitive for a *live* reference to a range of sibling nodes.

### `display: contents`

CSS `display: contents` makes a wrapper element invisible to box model and selectors, but it doesn't solve the programmatic problem. You still have a real element in the DOM — it participates in `querySelectorAll`, event bubbling, and serialization. It can't be used for table rows (`<tr>`) or list items that must be direct children of their parent. And it offers no API for batch operations on the group's children.

### Comment-Based Boundary Markers

In practice, every major template library uses comment nodes as boundary markers. Lit, hyperHTML, and React's streaming renderer all emit `<!>` or `<!--$-->` / `<!--/$-->` pairs to anchor dynamic content. This works, but it's fragile: comments can be stripped by sanitizers, are invisible in DevTools element panels, and require tree-walking to locate.

### WebReflection's `document-persistent-fragment`

[Andrea Giammarchi's polyfill](https://github.com/WebReflection/document-persistent-fragment) (2019) was the first concrete implementation of the `DocumentPersistentFragment` concept. It works by patching `Node.prototype.appendChild` and `Element.prototype.append` to detect `LiveFragment` instances and unwrap them. This global monkey-patching approach is functional but invasive — it modifies shared prototypes, which can conflict with other libraries and frameworks.

### WebReflection's `group-nodes`

[WebReflection's later implementation](https://github.com/WebReflection/group-nodes) extends `DocumentFragment` and uses comment boundary nodes (`<!--<>-->` / `<!--</>-->`) to mark the group's position in the DOM. Named groups can be retrieved via `document.groups[name]`. This approach supports hydration (the comments survive serialization) but patches DOM prototypes (`Node.prototype.appendChild`, `Node.prototype.insertBefore`, and `ChildNode` methods like `before`, `after`, `replaceWith`, `remove`) to intercept fragment operations — and leaves comment nodes in the DOM tree.

### React Fragment

React's `<Fragment>` (or `<></>`) is a compile-time abstraction — it never exists in the real DOM. The virtual DOM reconciler tracks the group, but once rendered, the children are just sibling nodes with no structural relationship. There is no runtime handle to move or update them as a unit.

### DOM Parts / Template Instantiation

[Template Instantiation](https://github.com/WICG/webcomponents/blob/gh-pages/proposals/Template-Instantiation.md) proposes a `Part` interface that lives *outside* the DOM tree — similar to `Range`. Justin Fagnani has argued this avoids disrupting existing tree-walking code. However, `ChildNodePart` is owned by its parent element, making it unsuitable for the "ownership sharing" pattern where the group itself is the unit of composition.

## The Standardization Journey

The quest for a persistent fragment primitive has been underway for over six years.

### WHATWG DOM Issue #736 (2019–present)

[The proposal](https://github.com/whatwg/dom/issues/736) was opened by WebReflection in March 2019 and has accumulated 89+ thumbs-up reactions. It proposes a `DocumentPersistentFragment` (or `LiveFragment`) that retains its children after insertion, is transparent to CSS, and provides a persistent handle for updates.

The issue carries the **"needs implementer interest"** label — no browser vendor has committed to implementation. Key concerns raised:

- **Tree-walking compatibility**: Justin Fagnani noted that a new node type in `childNodes` would be skipped by existing traversal code that assumes only `Element` can contain `Element`.
- **Serialization round-trip**: Any new node type that can't survive a serialize/parse cycle would be the first of its kind in the DOM tree (as opposed to the "tree-of-trees" like `<template>` content).
- **Non-Node interface alternative**: Ryosuke Niwa (Apple) argued that all you need is tracking where inserted content goes — no new node type required.

### W3C Web Components Community Group Meeting (April 2025)

A [meeting](https://docs.google.com/document/d/1MV7OTxlrU67x4Z0O9jgtIsRCya5LP04Jyf91aNr2Bqs/) was held with stakeholders including rniwa, justinfagnani, WebReflection, and FrameMuse. Key takeaways:

- **Consensus on the problem**: Everyone agrees the platform needs something.
- **Minimal API first**: Steve Orvell argued the primitive should be "valuable on its own, rather than only in large frameworks."
- **Comment nodes impact performance**: Using comments as boundaries has measurable overhead.
- **Hydration is essential**: Any solution must support server-side rendering and rehydration.

### Related Proposals

Several adjacent efforts are converging on the same problem space:

- **[Addressable Comments](https://github.com/WICG/webcomponents/issues/1116)** (noamr, Nov 2025): Proposes comment nodes with metadata that can be efficiently located without tree-walking. A lighter-weight alternative to full DOM Parts.
- **[Declarative Partial Updates](https://github.com/WICG/declarative-partial-updates)**: A W3C incubation for streaming HTML patches into a document without a full page refresh. Uses `<template patchfor>` and markers.
- **[Out-of-Order HTML Streaming](https://github.com/whatwg/html/issues/11542)** (noamr, Aug 2025): Proposes `<!marker>` processing instructions and `<template for>` for declarative streaming. Now at **Stage 3** with a [PR](https://github.com/whatwg/html/pull/12118) to add processing instructions to the HTML parser.
- **[Bulk Mutation Methods](https://github.com/whatwg/dom/issues/1369)** (justinfagnani, Apr 2025): Proposes `replaceChildren` and similar range operations on `ChildNodePart`.

These proposals are complementary: `Group` solves the *runtime grouping* problem, while declarative streaming and addressable comments solve the *hydration and server-rendering* problem. A complete solution likely needs both.

## How It Actually Works

`node-group`'s implementation rests on a single insight: **a custom element can serve as a temporary relay to position children, then remove itself**.

### The `group-relay` Pattern

```js
class Group extends HTMLElement {
  static TAG = "group-relay"

  static {
    window.customElements.define(Group.TAG, Group)
  }

  connectedCallback() {
    // Move all tracked children after this relay element
    super.after(...this.orderedNodes)
    // Remove the relay — it's no longer needed
    super.remove()
  }
}
```

When you call `parent.append(group)`:

1. The browser inserts the `group-relay` custom element into `parent`.
2. `connectedCallback` fires.
3. The callback moves all tracked children after the relay using `super.after(...)`.
4. The relay removes itself with `super.remove()`.

The children are now direct children of `parent`, in order, with no wrapper element. The `Group` instance retains its `orderedNodes` list and can continue to operate on those children — appending, removing, replacing, or moving the entire group.

### Property and Method Overrides

`Group` overrides key `HTMLElement` properties and methods so it behaves like a `ParentNode` / `ChildNode` hybrid:

| Property / Method | Behavior |
|---|---|
| `parentNode` | Returns the real parent of the first child (or `null` if detached) |
| `childNodes` | Returns a `NodeListOf<ChildNode>` of tracked children |
| `firstChild` / `lastChild` | First / last tracked child |
| `hasChildNodes()` | Whether the group has any children |
| `textContent` | Concatenated text content of all children |
| `appendChild(node)` | Adds to tracked list and inserts after the last child |
| `removeChild(node)` | Removes from tracked list and detaches from DOM |
| `replaceChild(new, old)` | Replaces one tracked child with another |
| `replaceChildren(...nodes)` | Replaces all children atomically |
| `after(...nodes)` | Inserts nodes after the last tracked child |
| `before(...nodes)` | Inserts nodes before the first tracked child |
| `remove()` | Removes all tracked children from the DOM |
| `replaceWith(...nodes)` | Inserts new nodes after the group, then removes all children |

### `parentNode` Transparency

This is the most deliberate — and most surprising — design choice. When you read `child.parentNode`, you get the *real* DOM parent, not the `Group`:

```js
const group = new Group()
group.append(A, B, C)

document.body.append(group)

console.log(group.firstChild === A)           // true
console.log(A.parentNode === document.body)   // true ← not group
console.log(A.isConnected)                     // true
console.log(A.nextSibling === B)              // true
```

The `Group` is a **logical owner**, not a physical parent. It tracks which nodes belong together and where they should go, but it doesn't insert itself into the `parentNode` chain. This means:

- Existing DOM traversal code works unchanged.
- CSS selectors are unaffected.
- `querySelector` and `querySelectorAll` see no group element.
- Event bubbling follows the real DOM tree.

The trade-off: code that expects `node.parentNode === group` will be surprised. The `Explanation.md` in the repo includes a [detailed comparison with Figma/Photoshop groups](https://github.com/FrameMuse/node-group/blob/main/Explanation.md#comparing-this-behavior-to-figma-and-photoshop) that makes this explicit.

### No DOM Patching

This is the key differentiator from WebReflection's prior work. Both `document-persistent-fragment` and `group-nodes` modify DOM prototypes globally — `document-persistent-fragment` patches `Node.prototype.appendChild` and `Element.prototype.append`, while `group-nodes` patches `Node.prototype` insertion methods (`appendChild`, `insertBefore`, `replaceChild`) and `ChildNode` methods (`before`, `after`, `replaceWith`, `remove`). `node-group` modifies no prototypes. It works entirely through the custom element lifecycle and property overrides. This means:

- No risk of conflicts with other libraries.
- No performance overhead on unrelated DOM operations.
- It can be used in production today, alongside any framework.

The trade-off: because `Group` relies on `connectedCallback`, it requires the group to be attached to a document at some point. You can't use it in a purely off-screen context (e.g., a `DocumentFragment` that never touches the DOM).

## Design Decisions & Trade-offs

### No Comment Boundaries (Yet)

WebReflection's `group-nodes` uses comment boundaries (`<!--<>-->` / `<!--</>-->`) to mark the group's position. This enables **hydration**: the server can render the comments, and the client can reconstruct the `GroupNodes` instance from them.

`node-group` deliberately avoids comments. This keeps the DOM clean and avoids the performance cost of extra nodes, but it means **there is currently no hydration story**. The README outlines a plan for named comment markers (`<!--$Named-->` / `<!--/$Named-->`) that could be parsed into `document.groups`, but this is not yet implemented.

WebReflection [critiqued this](https://github.com/whatwg/dom/issues/736#issuecomment-2967365763): "no comments, no hydration, and that's a huge red flag." This is a valid concern for SSR-heavy applications. For client-only use cases, the trade-off favors cleanliness.

### Custom Element Dependency

Because `Group` extends `HTMLElement` and registers as `group-relay`, it depends on the custom elements infrastructure. This means:

- The group must be attached to a document (or shadow root) for `connectedCallback` to fire.
- The custom element registry is global — there can only be one `group-relay` definition.
- It won't work in environments without custom elements support (though all modern browsers support them).

### Parent Strategies

The are two possible strategies for `parentNode` definition:

1. **Transparent**: `parentNode` returns the parent ignoring `Group`, so `group.firstChild.parentNode !== group`.
2. **Group-as-parent**: `parentNode` returns the group. More intuitive for group-oriented code, but breaks existing traversal patterns.

The current implementation chooses transparency. This aligns with the WHATWG proposal's intent that a persistent fragment should be invisible to the DOM tree.

### Named Groups (Planned)

Named groups with comment-based markers:

```html
<!--$Named-->
<div>Content</div>
<!--/$Named-->
```

These would be parsed into a `Group.items` registry, enabling hydration and server-side rendering. This feature is not yet implemented.

## Comparison: Group vs. Alternatives

| Approach | CSS Transparent | Persistent Handle | Hydration | No DOM Patching | Standardized |
|---|---|---|---|---|---|
| `DocumentFragment` | ✅ | ❌ (empties) | ❌ | ✅ | ✅ |
| `display: contents` wrapper | ❌ (element exists) | ✅ | ✅ | ✅ | ✅ |
| Comment markers (lit, React) | ✅ | ⚠️ (fragile) | ✅ | ✅ | — |
| WebReflection `document-persistent-fragment` | ✅ | ✅ | ❌ | ❌ (patches prototypes) | ❌ (proposal) |
| WebReflection `group-nodes` | ✅ | ✅ | ✅ (comments) | ❌ (patches prototypes) | ❌ (proposal) |
| DOM Parts / Template Instantiation | ✅ | ✅ | ⚠️ (planned) | ✅ | ❌ (proposal) |
| `node-group` (this library) | ✅ | ✅ | ❌ (planned) | ✅ | ❌ (library) |
| Processing Instructions (whatwg/html#11542) | ✅ | ✅ | ✅ | ✅ | 🔄 Stage 3 |

## Code Examples

### Ownership Sharing: A Dynamic List

```js
function List() {
  const group = new Group()
  const items = []

  for (let i = 0; i < 20; i++) {
    items.push(Item(i))
  }

  const reverseButton = Button("Reverse Order", () => {
    group.replaceChildren(reverseButton, ...items.reverse())
  })

  group.append(reverseButton, ...items)
  return group
}

// The caller decides placement — no wrapper needed
document.body.append(List())
```

### Moving a Group Between Parents

```js
const group = new Group()
group.append("A", "B", "C")

const parent1 = document.createElement("div")
const parent2 = document.createElement("div")

parent1.append(group) // Acts like DocumentFragment — children appear in parent1
parent2.append(group) // Children move to parent2 — no manual cleanup

group.append("D") // Reflected in parent2 immediately
```

### Conditional Rendering

```js
const details = new Group()
details.append(
  Object.assign(document.createElement("h2"), { textContent: "Details" }),
  Object.assign(document.createElement("p"), { textContent: "Hidden content here." })
)

const toggle = document.createElement("button")
toggle.textContent = "Show"

toggle.addEventListener("click", () => {
  if (details.parentNode) {
    details.remove()
    toggle.textContent = "Show"
  } else {
    document.body.append(details)
    toggle.textContent = "Hide"
  }
})

document.body.append(toggle)
```

### Integration with Table Elements

Because `Group` is transparent to the DOM, it can wrap `<td>` elements without introducing an invalid `<div>` inside `<tr>`:

```js
const cells = new Group()
cells.append(
  td("Name"), td("Email"), td("Role")
)

const row = document.createElement("tr")
row.append(cells) // Cells are direct children of <tr> — valid HTML
```

## Use Cases

- **Dynamic menus**: Swap entire menu groups in response to navigation context, without tracking individual items.
- **List reordering**: Reverse, sort, or shuffle a cluster of list items with a single `replaceChildren` call.
- **Conditional sections**: Show/hide groups of elements (form fields, panels, wizard steps) without wrapper elements.
- **Table row composition**: Group `<td>` cells without introducing invalid intermediate elements.
- **Canvas overlay layering**: Group overlay elements for batch z-index adjustments.
- **Component return values**: Functions return `Group` instances instead of `DocumentFragment`, enabling the caller to reposition, update, or remove the content later.
- **Framework integration**: Used in production by [Proton](https://github.com/denshya/proton), a React/SolidJS-like UI building library.

## Challenges & Open Questions

### Hydration

The most significant open question. Without comment boundaries or serialization markers, a `Group` cannot be reconstructed from server-rendered HTML. The planned `<!--$Named-->` / `<!--/$Named-->` markers and `document.groups` registry would address this, but they are not yet implemented. For client-only applications, this is not a concern.

### Tree-Walking Compatibility

Justin Fagnani raised a concern during the WHATWG discussion: any new node type in `childNodes` risks being skipped by existing traversal code. `node-group` sidesteps this by making the group invisible to the DOM tree — it never appears in `childNodes`, `querySelectorAll`, or event `composedPath()`. But this also means DevTools and accessibility tools can't see it.

### `connectedCallback` Dependency

The relay pattern requires the group to be attached to a document (or shadow root) for `connectedCallback` to fire. This means you can't use `Group` in a purely off-screen `DocumentFragment` that never touches the DOM. In practice, this is rarely a limitation — you almost always attach to a document — but it's worth noting.

### Reflow on Append

[Issue #1](https://github.com/FrameMuse/node-group/issues/1) reports that appending to a `Group` can trigger reflow. This is an area for optimization — batching DOM reads and writes, or using `requestAnimationFrame` for non-critical updates.

### The Path to Standardization

The WHATWG proposal has been open since 2019 with strong community support but no browser vendor commitment. The April 2025 W3C meeting established consensus that *something* is needed, but the form it should take — new node type, non-Node interface, or processing instructions — remains debated.

`node-group` exists as a proof of concept: it demonstrates that the core functionality can be achieved without DOM patching, using only standard web platform APIs. This is valuable evidence for the standardization discussion, even if the eventual standard takes a different form.

## Conclusion

`Group` challenges the assumption that fragments must be ephemeral and wrapper elements inevitable. By giving developers a persistent, CSS-transparent, DOM-transparent handle on a range of sibling nodes — without patching any prototypes — it unlocks the "ownership sharing" pattern that frameworks have long enjoyed but vanilla JS has lacked.

The library is not the end of the story. It's a proof of concept that informs a six-year standardization effort. The WHATWG proposal, the addressable comments discussion, the declarative streaming work, and the processing instructions PR are all converging on the same problem: the DOM needs a native way to group, move, and update sibling nodes as a unit.

Whether that native primitive ends up being `NodeGroup`, `DocumentPersistentFragment`, processing instructions, or something else entirely, the use cases are clear, the demand is proven, and the implementation is possible today.

## References

- **node-group library**: [github.com/FrameMuse/node-group](https://github.com/FrameMuse/node-group)
- **WHATWG DOM Issue #736** (DocumentPersistentFragment proposal): [github.com/whatwg/dom/issues/736](https://github.com/whatwg/dom/issues/736)
- **WebReflection's document-persistent-fragment**: [github.com/WebReflection/document-persistent-fragment](https://github.com/WebReflection/document-persistent-fragment)
- **WebReflection's group-nodes**: [github.com/WebReflection/group-nodes](https://github.com/WebReflection/group-nodes)
- **Addressable Comments proposal**: [github.com/WICG/webcomponents/issues/1116](https://github.com/WICG/webcomponents/issues/1116)
- **Declarative Partial Updates**: [github.com/WICG/declarative-partial-updates](https://github.com/WICG/declarative-partial-updates)
- **Out-of-Order HTML Streaming (Patching)**: [github.com/whatwg/html/issues/11542](https://github.com/whatwg/html/issues/11542)
- **Processing Instructions PR**: [github.com/whatwg/html/pull/12118](https://github.com/whatwg/html/pull/12118)
- **Bulk Mutation Methods proposal**: [github.com/whatwg/dom/issues/1369](https://github.com/whatwg/dom/issues/1369)
- **Proton UI library** (uses node-group in production): [github.com/denshya/proton](https://github.com/denshya/proton)
- **W3C Web Components CG Meeting Notes (April 2025)**: [Google Docs](https://docs.google.com/document/d/1MV7OTxlrU67x4Z0O9jgtIsRCya5LP04Jyf91aNr2Bqs/)
