Before starting any work, I always ask questions to eliminate uncertainty. I never begin implementation until I understand exactly what needs to be done and why.

First, I look at the task from the user's perspective: Who will be using this, and what problem are we solving? If a task comes from a product manager or the CEO, I clarify the specific scenario they want to address. It often turns out that things can be done much more simply than what is written in the task.

Next, I look at the technical constraints: What services already exist, and how will the current architecture affect the implementation? I estimate the load. If a feature is going to be used by thousands of users, we need to think about caching and indexes upfront. If it’s an admin panel for 10 people, we can keep it simpler.

I also look at dependencies: Do we need integrations with external services? Do we have access to their APIs? What are their rate limits and timeouts? On one project, we planned to upload files through a third-party service, which turned out to have a 10-megabyte limit. We found this out during the assessment stage, rather than after the code was already written.

I highlight risks immediately. If there is uncertainty regarding deadlines, I speak up about it. If part of a task breaks existing behavior, I suggest a rollout plan. If there isn't enough data to make a decision, I propose building a prototype or a PoC (Proof of Concept) first.

Once all questions are answered, I decompose the task into subtasks and estimate each one individually. This helps uncover hidden pitfalls that aren't visible when looking at the task as a whole.