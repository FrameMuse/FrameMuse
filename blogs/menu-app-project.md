# The story behind a "Menu Designing" Figma Plugin I've been working for 1.5 years

## Came up with idea

It all started from the idea of an application for creating menus for restaurants, so they can change the items on fly without recreating menus.

For that the "editor" idea was introduced, the main inspirations were Canva and Figma. This means to manage all the positioning hell, ...

When I was assigned to this task, I did the first thing anybody would do - I started learning more about the concept and looking for similar solutions in the internet. I found several nice ones that were doing a lot and had a moment of realization - we will have to repeat it all (⊙ˍ⊙).

I considered this is a bad idea to start everything from scratch, it would give us enormous amount of pain and maintain burden. So I searched for libraries that could help ease this problem - I couldn't find anything comprehensive and "bricks" were not doing enough to make the project lighter.

At the point of understanding that will be a very long run for our tiny team (which turned out into me working almost solely), the thought flashed through my mind, "Figma Plugin" it was whispering. I shook my head thinking "nah, it would be too simple and not beneficial for our company".

The time was going by and my belief in the plugin was rising each day as I was investigating approaches and seeing so many difficulties I/we would need to overcome. Then ... I'd decided to share the idea to the project manager, for my surprise he wasn't so rejectful about it, then I knew, I will be pushing this idea. We approached the CEO with all arguments we combined - he remained silent for the next days...

Thanks to the CEO, "the decision was made towards the plugin rather than much more difficult standalone 'editor'", he said. He didn't really like it this way though, he thought the longer project, the longer the partnership. It makes sense, but I an opposite opinion. My reasoning was simple, "short" project, made with love _and a bit of sweat_ would mean infinitely more, than "long" project with exhausted developers - _full of sweat and no love_. It could be counter-intuitive, but it's actually better to simplify project and "cut" its timeline since good partnership always yields new projects to work on.

Eventually, I pitched to the CEO and clients showing off the first "sketch" - They liked it.

## Outline the plan

So I continued on the next goal after the sketch - PoC. But first, the manager has scheduled a gathering to brainstorm what could be the main points that **must be** proved.

I developed a simple bare minimum app to demonstrate that those points are indeed possible to implement with Figma Plugin.

Here, my internal software architecture has turned on...

I laid out first superficial diagrams for how the Figma Plugin should work in connection with API and external Admin Panel.

I made a decision towards containing "Creation of Designs" in app that is made for this exact purpose - Figma. So the Figma Plugin would only be a UI to interactively save/restore designs and assets through API.

The Admin Panel would be a UI that interactively assigns saved designs to chosen "Screens", which are real physical Order Confirmation Board Monitor, which was baked by mini-pc with a 3rd app.

The Menu App, it was a desktop app only for displaying what was chosen in the Admin Panel and updated via WebSocket to instantly represent live prices, design changes or anything else.

So the simple system was:

Figma -> Figma Plugin -> API -> Admin Panel -> API -> Menu App.

## Building blocks

This all seemed simple yet like a lot of things, so I intuitively split everything in parts and worked one by one as libraries.

Multiple layers were duplicates, so I also committed to creating a composable structure to be able to separate heavy/important/shared code into several private NPM libraries: **Reusable Components**, and **Figma Design Viewer** and **PoS Integrations** (which was never implemented eventually).

The Design Viewer was the core actually, the most important. It was compiling Figma Design JSON to pure HTML.

The coverage of Figma Features was looking as well, with a help of a teammate I was able to move very fast and only things uncovered were Prototypes (Animations).

## Point Of Sales Integrations

One of the core features of this project were its integrations of many PoS, so that Customers could fetch their price list and access them in both the Admin Panel, Figma Plugin and see updates in the Menu App.

As always I approached it with care, I studied more about it, try implementing my first integration with the original code. Then I committed to improving current architecture of POS Integrations to ensure adding and removing integrations is straightforward.

When I finished it, I asked teammates to look at it and tell what they think about it - turned out I wrote the best documentation they have even seen, I didn't realize that at that time, but looking now - it's probably the best I created myself.

[The Actual Documentation Sample](../docs/pos-integration.md)

## Architecture (Heavy Technical)

The team praising me for such a well-prepared documentation gave me a motivation to take the most difficult architecture tasks I was afraid about for years.

So I 

## Raise of the Great

It was amusing to see that you could connect your PoS and then just **drop** prices to the Figma and they would update automatically right in the "static" design.

Everything went according to the plan.
We shipped the plugin to Figma store.
The Menu App was catching all the updates.
The Admin Panel was managing designs correctly.
The Figma Plugin was uploading and correctly handling edge cases.

The future seemed bright.

## Beyond Free Figma

## UI/UX Design Hell

## I Made Design Better Myself

## Down Fall

I gathered the team to present my "Embrace Modularity" Article, where I explained why we need to **care** about how code is composed from smaller building pieces, the article was great and it was welcomed warmly, though nothing has changed eventually.

I made a proposal to extract PoS Integrations from the Backend (API) to a separate library and combine it with utils since it was used in literally every repository, but it was pushed back.

I made another proposal to at least simplify PoS Integration data normalization without breaking changes, but was rejected by the future Tech Lead.

I presented my vision of how the product should evolve further, but didn't really see any feedback from my team, managers, CEO neither the client.

The "Tech Lead" eventually turned out to be a curtain for simply raising a salary to a worker that was liked more, which I realized only by now. The Tech Lead actually led us to the most disruptive decisions and mistakes for the product and the projects.

As we already lost 3 people from the team the pressure was at its peak and with the new leader it should've been solved, but became the nail in the coffin.

## Client Tension

## Quit
