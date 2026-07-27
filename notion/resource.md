- [ ]  Getting initial data

Maintains data in a way that UI needs.

- [ ]  Updating data chunks
- [ ]  Replacing data
- [ ]  Deleting data or its chunks

---

Transactions

- [ ]  Optimistic updates
- [ ]  Consecutive updates
- [ ]  Additionally, provides possibility for reactions to actions for richer debugging or deeper user awareness

- [ ]  Reference other resources in constructors to explicitly manage dependencies
    - [ ]  Location (id) → Products, Apps

## Allows

- [ ]  Data change listening
- [ ]  Free data modification
- [ ]  Adopting related children (allowing consequent change to assigned children like instances of `Company` from `Companies` instance)

## Provides

Easier interface to deal with “external” (for current scope) resource management

- [ ]  Plain
- [ ]  Iterable
- [ ]  Pageable
- [ ]  Grouped (Hashable)

## Interface

- [ ]  Fetch
- [ ]  Prefetch
- [ ]  Refetch
- [ ]  ?Synchronize?
- [ ]  Get
- [ ]  Update
- [ ]  Set
- [ ]  Reset
- [ ]  Delete

## Examples

1. Getting data from API
2. Updating data based on user input
3. Updating or replacing data based on socket message

`Resource` class in JS allows managing resource data in the way that is convenient for frontend like get, add, update and remove. Usually uses map, array of entities or an entity itself as `data`. Has a `addEventListener` to know when `data` is changed.

It can be extended to create resource specific classes like `UserResource`, `PostResource`, etc., where you can define additional methods or override the existing ones according to your requirements.

The `Resource` class provides a structured way to manage data for frontend applications in JavaScript. It is designed to be convenient and efficient, allowing for operations such as `get`, `add`, `update`, and `remove`. The data managed by a `Resource` class can take various forms, including a map, an array of entities, or a single entity.

One of the key features of this class is the `addEventListener`, which acts as a listener to track changes to the data. This allows for real-time updates and responses to alterations in the data set, increasing the responsiveness and efficiency of the application.

The `Resource` class can also be extended to create more specific classes like `UserResource` or `PostResource`. In these extended classes, you can define additional methods or override the existing ones based on your specific needs, offering a high degree of flexibility and customization.

It also has all needed information to conveniently operate with tanstack’s react query since `Resource` has internal tools to manage data. You can use bridge to react query to make it much easier to use.

Let's consider a `UserResource` class that extends the `Resource` class. In addition to the standard `get`, `add`, `update`, and `remove` methods, it might also include additional methods specific to user data.

Here's how you might use such a class with TanStack's React Query:

```jsx
import { useQuery } from 'react-query';
import UserResource from './UserResource';

function UserComponent() {
  const userResource = new UserResource();

  // Using useQuery to fetch user data
  const { data, isLoading } = useQuery('users', userResource.get);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      {data.map(user => (
        <div key={user.id}>
          <h2>{user.name}</h2>
          <p>{user.email}</p>
        </div>
      ))}
    </div>
  );
}
```

In this example, the `UserComponent` uses React Query's `useQuery` to fetch user data from the `UserResource`. The `UserResource.get` method is passed as the fetch function to `useQuery`.

For another example, let's extend the `Resource` class to create a `PostResource` class. This class could include methods for interacting with post data, such as fetching a specific post or adding a new post.

Here's how you might use the `PostResource` class with TanStack's React Query:

```jsx
import { useQuery, useMutation } from 'react-query';
import PostResource from './PostResource';

function PostComponent() {
  const postResource = new PostResource();

  // Using useQuery to fetch post data
  const { data: post, isLoading } = useQuery('post', () => postResource.get('post_id'));

  // Using useMutation to add a new post
  const mutation = useMutation(newPost => postResource.add(newPost), {
    onSuccess: () => {
      // Invalidate and refetch
      queryClient.invalidateQueries('post');
    },
  });

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h2>{post.title}</h2>
      <p>{post.content}</p>
    </div>
  );
}

```

In this example, the `PostComponent` uses React Query's `useQuery` to fetch post data from the `PostResource`. The `PostResource.get` method is passed as the fetch function to `useQuery`. The `useMutation` hook is used to add a new post using the `PostResource.add` method. After the mutation succeeds, the post queries are invalidated and refetched to ensure the UI is up to date.

---

## Resource Derivation/Branch/Draft

This describes how a resource data can be branched to be manipulated locally (synchronously) potentially to be merged back with a strategy (should be defaulted to persistence - API or like).

**Rough example**

```tsx
class CampaignModel {
  //#region API campaign data
  private queryObserver = new QueryObserver(queryClient, {});
  /** @returns Campaign data that is synced with backend. */
  static useQuery(): UseSuspenseQueryResult<CampaignModelData> { }

  async pull() { return this.queryObserver.refetch() }

  //#region In memory campaign data

  /** */
  reconcile() { }

  draft: CampaignModelData
}
```
