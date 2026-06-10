# Code Boundaries

## Free-for-all

Probably the most common way to start a codebase. Just do something and put somewhere.

> Why a folder names this way? - idk, it's just history.

Though, it becomes clearer and clearer as more codebase grows that everything is coupled so much.

> Wtf does that even mean?

Well, more coupling means more dependencies - that's it! Dependency can be whole file or even **Module** (a little codebase) or just a tiny function. But each dependency may have its own dependencies... AND these dependencies can rely on previous dependencies...

That's where it becomes uncontrollable pile of junk, Each time you make a change, something breaks in a far away place, God only knows why it's affected.

It's surprisingly ease to avoid (not taking about fixing 😕), you just need to represent your codebase as a Tree Nodes.

## A Cure for Spaghetti Code

I encountered whole spaghettified projects, which had severe problems, I'm going to tell how to avoid.

---

These projects often lacked clear structure and had poor organization. The absence of well-defined boundaries between different components led to cyclical dependencies. This made it nearly impossible to fix, change, or modify the code unless you were the developer who created it—and even then, it was challenging.

That time I failed to help to pull the codebase from the ditch, but I'm possible to least explain this and warn you, so you well prepared next time.

---

One of the most effective ways to achieve this is by implementing code boundaries, also known as code fences.

These boundaries are essential for developers of all levels, as they provide a structured approach to writing and organizing code, preventing the dreaded "spaghetti code" syndrome.

They don't constrain you to write code in a specific way, but rather establish "red lines" that you shouldn't cross. This means, "Don't use this method here because it's not supposed to be here." It's quite abstract, which is why it's both flexible and useful.

The boundaries can be based on various factors:

- Domains (User, Blog, Dashboard)
- Features
- Purpose (utils, UI, controllers)
- Your sense of justice 😜

These boundaries can be applied in numerous ways and are adopted by many teams.

For example, there's a well-known concept called "Feature-Sliced Design," which is essentially a massive compilation of strict code boundaries.

## What are Code Boundaries?

Code boundaries are architectural principles that help separate different parts of a codebase, defining clear interfaces and responsibilities for each component. By establishing these boundaries, developers can create modular, maintainable, and scalable code structures.

## Implementing Code Boundaries

To implement effective code boundaries, consider the following practices:

1. Break down your code into smaller, focused modules or functions with clear responsibilities.
2. Use clear and descriptive naming conventions for your modules, functions, and variables.
3. Implement interfaces to define how different parts of your code should interact.
4. Follow the principle of separation of concerns, ensuring each module or function has a single, well-defined purpose.
5. Utilize design patterns and architectural principles like Model-View-Controller (MVC) or microservices to structure your code effectively.

## Starting with Organized Code

The key to maintaining clean code is to start with a well-organized structure from the beginning. By making it a habit to implement code boundaries from the outset, you can avoid the need for extensive refactoring later on. This proactive approach not only saves time and effort but also ensures that your codebase remains manageable as it grows.

## Conclusion

Code boundaries are an invaluable tool for developers at all levels. By implementing these architectural principles, you can create more maintainable, scalable, and efficient code. Remember, it's always easier to start with organized code than to refactor spaghetti code later. Make code boundaries a habit in your development process, and you'll reap the benefits of cleaner, more manageable code throughout your project's lifecycle.

## Code Boundaries Examples

### Pure TypeScript Example

```tsx
// user.ts
export interface User {
  id: number;
  name: string;
  email: string;
}

// userService.ts
import { User } from './user';

export class UserService {
  private users: User[] = [];

  addUser(user: User): void {
    this.users.push(user);
  }

  getUser(id: number): User | undefined {
    return this.users.find(user => user.id === id);
  }
}

// main.ts
import { UserService } from './userService';
import { User } from './user';

const userService = new UserService();
const newUser: User = { id: 1, name: 'John Doe', email: 'john@example.com' };
userService.addUser(newUser);
```

In this pure TypeScript example, we have established clear boundaries between the User interface, the UserService class, and the main application logic. Each component has a specific responsibility and doesn't cross into the others' domains.

### React with TypeScript Example

```tsx
// UserTypes.ts
export interface User {
  id: number;
  name: string;
  email: string;
}

// UserList.tsx
import React from 'react';
import { User } from './UserTypes';

interface UserListProps {
  users: User[];
}

const UserList: React.FC<UserListProps> = ({ users }) => (
  <ul>
    {users.map(user => (
      <li key={user.id}>{user.name} ({user.email})</li>
    ))}
  </ul>
);

export default UserList;

// App.tsx
import React, { useState } from 'react';
import UserList from './UserList';
import { User } from './UserTypes';

const App: React.FC = () => {
  const [users, setUsers] = useState<User[]>([
    { id: 1, name: 'John Doe', email: 'john@example.com' },
    { id: 2, name: 'Jane Doe', email: 'jane@example.com' },
  ]);

  return (
    <div>
      <h1>User List</h1>
      <UserList users={users} />
    </div>
  );
};

export default App;
```

In this React with TypeScript example, we've created clear boundaries between the User type definition, the UserList component, and the main App component. Each component has its own file and specific responsibilities, adhering to the principle of separation of concerns.
