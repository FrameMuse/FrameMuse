# List Reconciling Problem

## What is Reconcile (Reconciling)?

In Web Frontend Development, this is a process of differentiating <u>source</u> and <u>target</u> versions of a **dependency list** (that creates a list of renderable elements) to tell what happens to items: Added, Removed or Moved.

## The problem

The first two aren't a problem, but the problem is to tell if an item was **moved**

If a tracked item value is `1` in a list of `[2, 1, 3]`, what happens to the value if the list is rearranged as `[1, 2, 3]`.

- Is `1` was **removed** and then **added** another `1`?
- Is `1` was just moved to the start?

You can't tell if there were many operations that resulted in a new array or e.g. only one. You have to figure it out a different way.

### Why is this important?

Well, it may not actually matter unless it's a Frontend... Mainly because developers want performance and consistency for users.

Imagine you have 50 music albums, while you see only 10 prefetched ones, you search for a specific one by name, which triggers a fetch request with another 10 found albums.

Now, how do you tell if you need to create more HTML elements, delete redundant or rearrange existing ones?

And that's a real problem, if you do it wrong, you left with numerous problems:

- Leftover elements that are not supposed to be there anymore
- Existing elements that were meant to be refreshed still have stale information
- Existing elements that were NOT meant to be refreshed and overwrites user changes
- Existing elements that were meant to be rearranged (moved) are **removed** and new ones were created

Here we go - you're having problems with consistency and performance, users won't have a fun from using your website.

## Solutions

There are different solutions, but they all have their own limitations, there is no a perfect way to do this.

### How different frameworks are doing it?

Basically, they (usually) force you to put a `key` attribute for each element so the reconcile algorithm could easily tell if the element should be reused, deleted or it doesn't exist and requires creation.

### And?

There is another way, which is to iterate through the data and compare what has been changed and what the item belongs to.

Even GitHub and Git fails to always accurately tell the added, removed lines difference of your files...

Of course you can avoid reconciliation by manually managing your elements, but you will have to create your own custom architecture for that, often you will end up rebuilding the whole elements list without reusage.

You can draw your own conclusions.
