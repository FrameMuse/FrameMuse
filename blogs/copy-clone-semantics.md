
```ts
interface Copyable {
  toJSON?(): unknown
  clone(): this
  copy(other: this): this
}
```

What do you think about it? How to name (namespace) it in one word?:

Copy/Clone/Serialize/Deserialize Semantics in JavaScript

## Serialization/Deserialization

(de)Serialization of scene objects is trivial, use `JSON.stringify` and `JSON.parse` to serialize and deserialize them.

```ts
  const rectangle = new RectangleNode

  const serialized = JSON.stringify(rectangle)
  const deserialized = JSON.parse(serialized)

  const rectangleClone = new RectangleNode().copy(deserialized)
```

```ts
  abstract clone(): CanvasNode

  protected copy(other: CanvasNode): this {
    this.transform.copy(other.transform)
    this.box.copy(other.box)
    this.name = other.name
    this.visible = other.visible
    this.style = { ...other.style }

    return this
  }
```

Inherited classes

```ts
  clone() { return new RectangleNode().copy(this) }
  override copy(other: RectangleNode): this {
    super.copy(other)

    this.radius = other.radius

    return this
  }
```

This is an ultimate/best semantics and performance-wise as it allows support of copy, clone, serialize and deserialize in basically just one method - copy. It works because `copy` assigns properties and may coalesce or fallback them, which naturally creates validation. Then cloning simply creates and object and calls copy. Serialization depends on toJSON, but most of the time, it's not required. Deserialization simply creates new object of desired type and calls copy too.

---

It's also a debatable topic in programming language community - whether to
