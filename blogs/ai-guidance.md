# AI Guidance - How to Progressively Apply LLM as a Senior Developer

I've been giving LLMs a chance every year now, and now I think the Agents are finally capable of something, so here's I make some use of AI as a Senior Developer.

I'm experimenting a lot so having a technology that might give me a quick implementation of what's in my mind is a game changer.

But usually LLMs generates a ton of shit if you don't tell them very specifically what to do, but if you already know what to do exactly, you can implement it yourself 10x faster than any CjAI that goes in circles.

![CJ Meme, Here we go again](https://media1.tenor.com/m/cJRcMyUAiMcAAAAd/ah-shit-here-we-go-again-ah-shit.gif)

It's not a secret here I'm going to expose here that has never been discussed. No, it's very common pattern of **AI Guidance**, but I was able to reproduce it and actually move forward with actual implementations.

## Put your reasons high

In contrast to you (a senior developer), the LLMs need more ~~water~~ specific instructions. You can simply go and implement whatever you need, but so that LLM can do its job, it needs hints and direction.

To make a good use of LLM direction, you basically need to put maximum reasoning level, otherwise it will deviate ridiculously often.

What works for me is `xHigh` setting in Copilot, it takes a very long time to "think" but its output is very on point. And it doesn't consume monthly limit!

## Prompting Strategy

It's very simple, write what you want in the beginning, add whatever resources you can think of to support your implementation idea.

It's very crucial since if you don't give all the resources you keep in mind yourself, AI might miss something. It's pretty obvious, but always slips out of mind when prompting, probably because we all think about LLMs as universal program that can read your mind.

## Multistep Implementation

### Preparation

As we're a senior engineer, we won't ask for a full implementation of a website/app.

Instead we first do our human work:

- Think about our app as modules/libraries, the manual labor that no one wants to pay for.
- Do the `git init` and you might want to add some initial files.

### Plan

Do the obvious things you usually do to have better results for yourself and then ask the **Agent** in the **Agent Mode** to make a comprehensive plan for the future implementation concentrated in one/few files.

Then look at the LENGTH of the plan file(s), you don't need to get into them deeply, treat them as PRs from your team mates - read only what's on the surface!

Keep asking it to iterate the plan once again until you're satisfied with a length of the plans (imagine how much text it would take if you wrote those yourself).

If you remembered something you forgot to add initially, it's time to add any forgotten/further details.

And ofc ask to iterate again.

### Sketch

Once it's done, commit the files, ask it to iterate again.

It's like `apt update` you see every before installing a new package.

Then ask it to outline the program using only Interfaces and Abstract Classes. This is where it starts being interesting.

It will output some code, you must go through a bit deeper than the plan files since this is what the Agent will be using a foundation, it will follow these interfaces and classes very carefully if it doesn't make sense.

You may want to edit the files to introduces the corrections, but the Agent is very likely to ignore them, so instead copy the changes in chunks and introduce them at once.

I personally edit the code myself and then copy-paste chunks to the Agent, sometimes explain how/what/why and then prompt it.

Commit the files.

### Exclusion

Look at the sketch files once again, think what else could be split or minimized since you want the Agent to be in full focus on the core implementation, you should guide it to skip anything it can waste time on instead of caring about the core.

e.g. Particle System is a part of a bigger system, but it also consists of sub-systems, you should choose wisely what the Agent should focus on.

### Implement

When you're satisfied with the sketch, which is a very exciting moment because usually it means you're on the very right track and have a very good understanding of the potential implementation (which you should do before moving on).

It means the Agent will likely have a similar understanding and you can proceed with asking the Agent to implement it using the whole knowledge base, the plans and the sketch.

When it's done, quickly peek if it actually follows the sketch and looks like something that would work.

Commit.

### Demo

To actually see if it's good or shit, ask it to create a very minimal, one html file demo, using this module/library.

Review the demo file, look for the module/library usage, it will tell if the interfaces were good enough:

- If there is a very minimal and simple setup of your module, it's a success.
- If the usage is more complex that you wanted, you should proceed with refining it.

Commit anyway.

### Refine

Refining might be the most toughest since the Agent would need to follow and update the Plan/Sketch/Implementation/Demo files - that's why we actually stick to a modular approach rather than a whole application - no LLM is capable of doing such at this moment.

There are no advice of how to do it better, sure make sure you do commits and review code changes important to you.

It will likely to change the implementation and the demo separately and lazily - that's good, ask things like "is it possible to do ... in the demo with current implementation?".

Keep iterating until the usage in the demo file looks clean enough and test the performance (performance tab of the devtools in browsers).

The interfaces are very important as they are those **you** will be working with and they are a natural constrain for the Agent.

### Merge

Keep going until you implemented satisfied versions of all the modules you see your app consists of.

Once you're done "building" the modules, you can finally engage yourself fully into the process without AI and maybe start getting  your croissant-only salary.

Using AI/LLMs/Agents at this stage is very dangerous since it can mess up all the libraries and the code itself, since the reason to [split the work for the Agent into multiple chunks] is for that it doesn't "forget" details much and do a concentrated work, instead of constantly having its context overflowed and compacted.

That's your stage to shine!

Later you may refactor the AI-built modules completely.

## Conclusion

Yeah, it looks exactly like you would do the project with a $200,000 salary, which is not what we usually practice, so we always forget that normality exists.

I tested this approach on my big project, it works nicely, it ofc takes time, but at least now I can suffer less from motivation loss since LLM can at least build something in 1 day that looks like a working solution, comparing to me, that takes 2 months to build non-working one - Hurray!
