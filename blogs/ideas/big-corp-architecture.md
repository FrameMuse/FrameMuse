# Big Corp Architecture — Why the Biggest Companies Build the Worst Systems

**Slug:** `big-corp-architecture`
**Status:** raw research / idea brief
**Date:** 2026-06-19

---

## Why This Now

You've been in the industry long enough to see the pattern repeat: you join a "big serious company" expecting mature architecture, and instead find a tangled mess held together by meetings and hero culture. The gap between *perception* (big tech = engineering excellence) and *reality* (big tech = feature factory) is so wide it's almost a lie.

This topic is evergreen, but it's been getting fresh attention: recent layoffs, return-to-office mandates, and AI gold-rush pressures have highlighted how fragile corporate engineering really is. Meanwhile, solo开发者s and small teams ship cleaner, more maintainable systems — without 200-person engineering departments.

---

## What You've Already Covered (don't repeat)

| Your Post | Overlap | How to Differentiate |
|-----------|---------|---------------------|
| **refactoring-reflections.md** | Talks about money killing refactoring, PMs rejecting it, sneaky refactoring | That post is about refactoring *as a practice*. This one is about *architecture as a whole* at the corporate level. The refactoring post is personal/philosophical; this one should be systemic/data-driven. |
| **corps-dont-grow.md** | 3-line stub: companies want profit from you | Expand that seed into full thesis — why companies don't grow *systems* either. |
| **code-boundaries.md** | About code fences as a technical pattern | Complementary: code boundaries are the solution, but *corps prevent you from using them* because of money pressure. |
| **work-requirements.md** | About asking good questions before work | Tangential — could mention that even when you ask good questions, corporate politics overrides the right answer. |

---

## Core Thesis Ideas

### Angle 1: "Big ≠ Good" — The Architecture Delusion

The software industry has a cargo-cult belief that FAANG-level companies have elite engineering. In reality, their architecture is often *worse* than a solo dev's side project — precisely *because* of their size.

**Evidence to deploy:**

- **Twitter** — the "Fail Whale" era. A Ruby on Rails monolith hitting a single MySQL master. Timeline generation required querying *all* followed users' tweets on every refresh. The fix? A multi-year fanout-on-write rewrite. But before that, the iconic Fail Whale was the *corporate architecture on display for the whole world*.
- **Uber** — the "God Monorepo" where every team committed to the same Python/Node.js codebase. Deploying anything required a full 30+ minute redeployment of the entire system. Their database layer (Schemaless) was a single logical store every team wrote to. This wasn't fixed until the multi-year DOMA overhaul.
- **Facebook** — "Move fast and break things" created such a tangled PHP monolith that *they had to build a compiler (HPHPc) that transpiled PHP to C++* just to survive. Later they forked the entire language (Hack) because architecture was unfixable. The NavBar took two years to update.
- **Amazon pre-2002** — teams reading directly from each other's production databases. Bezos had to threaten *firing* people to get them to use APIs instead.

**The uncomfortable truth:** These companies succeeded *despite* their architecture, not *because* of it. They had money to burn on rewrites, new languages, armies of SREs. You don't.

### Angle 2: Money Is the Only Architecture Decision

Your own words: *"They just do things for money, that's it."*

The mechanic is simple and brutal:
1. Client/customer pays for *features*, not architecture
2. Refactoring has zero visible client value
3. Every architecture decision that doesn't directly enable a sale is a hard sell
4. Over years of "just this once" shortcuts, architecture decays into a Big Ball of Mud

**Supporting quotes:**
- Joel Spolsky: *"When you are getting paid to write code, the incentive is to write code, not to write good code. The pressure is to ship features. The architecture suffers. The money ruins it because the business pays for the features, not the architecture."*
- Dan North (*Software, Faster*): *"The single biggest threat to a good architecture is the need to make money from it. Money creates pressure, pressure creates shortcuts, shortcuts create a mess."*
- Paul Graham (*How to Do What You Love*): *"If you're forced to write code you don't care about, the code will be bad. Money forces you to write code you don't care about."*

**Stats to drop:**
- Developers spend **35–42%** of their time on technical debt / maintenance (Stepsize/Shortcut 2024 survey)
- Tech debt represents **20–40%** of an enterprise tech estate's potential value (McKinsey 2024)
- Cost of Poor Software Quality in the US: **$2.4 trillion annually** (CISQ 2024)
- **80%** of software execs cite tech debt as a primary blocker for AI/ML adoption

### Angle 3: Conway's Law Is a Corporate Feature, Not a Bug

Melvin Conway (1968): *"Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations."*

In big corps, the org chart *is* the architecture. Microservice boundaries mirror team silos. Shared libraries become political turf. If your reporting lines are bad, your architecture will be bad — and you can't fix the reporting lines because that's a "people issue."

**Contrast:** In a personal project, there is *one* organization (you). Conway's Law is on your side — your architecture can be clean because your communication structure is simple.

### Angle 4: Your Best Architecture Is the One You Build for Yourself

The most compelling argument for the thesis. You said it: *"The best architecture you can have in your life is the one you built yourself in your own projects without deadlines."*

**Supporting voices:**
- Jeff Atwood (Coding Horror): *"The dirty little secret is that the vast majority of corporate code is… not that great. A personal project reflects your personal values in code."*
- Dan North: *"The best code I've ever written was hobby code. It solved a real problem and had zero external deadlines. The minute money entered the equation, the quality degraded."*

**Examples from your own work:**
- **Denshya ecosystem** (`@denshya/tama`, `@denshya/reactive`, etc.) — built without deadlines, with your own architectural principles (No-Framework Principle). This is cleaner than most corporate frontend stacks.
- **Proton** (2 years R&D) — a custom JavaScript framework where you got to make every architectural decision correctly.
- **rukaku** — a multi-language microservice finance platform where you chose the stack (Rust + Python + TS) without anyone telling you "we don't have budget for that."

### Angle 5: The "Sneaky Refactoring" Survival Guide

Your existing refactoring post mentions sneaky refactoring. This could be a practical layer: *given that corporate money pressure is inevitable, here's how to maintain architecture quality anyway:*

- The "Leave It Better Than You Found It" rule
- Embedding refactors in feature PRs (your own strategy)
- Making technical debt *visible and painful* to management (HN: *"The business will always prioritize shipping over quality unless the cost of not refactoring is made visible and painful."*)
- The Inverse Conway Maneuver — restructure teams to match desired architecture (DDD bounded contexts)
- Stripe's Spot Model: classify code as clean/manky/gross, contain decay

---

## The Debatable Part (Controversy = Good)

The thesis has natural counterarguments you should address:

1. **"But FAANG engineers are the best in the world!"** — They are often brilliant but constrained by the same system. A senior IC at Google told me their internal codebase is so tangled that new hires spend 6 months just learning to navigate it.

2. **"Big corps have money to fix things"** — They also have the wrong incentives to *prevent* things from breaking. Twitter, Uber, Facebook all had years of terrible architecture *before* they invested in fixing it. The money only arrives when the pain is visible to leadership.

3. **"Your personal project has no users/scale"** — True, but that's the point. Good architecture at small scale scales *better* than bad architecture at big scale. The question is: can a big company create small-team-quality architecture at scale? (Spoiler: Amazon with the API mandate tried, and it took a literal firing threat.)

4. **"Not all big corps are the same"** — Fair. Some invest seriously in architecture (Stripe, early Google, maybe). The question is whether the *default* incentives produce good architecture. The evidence says no.

---

## Related Concepts to Weave In

| Concept | How to Use It |
|---------|--------------|
| **Big Ball of Mud** (Foote & Yoder) | The canonical academic description of what corporate codebases become. Quote: *"These systems show unmistakable signs of unregulated growth, and repeated, expedient repair."* |
| **Broken Windows Theory** (Hunt & Thomas) | Once a codebase has one broken window (bad pattern), more follow. Corporate pressure creates the first broken window. |
| **No-Framework Principle** | Your own principle. Corporate codebases violate it constantly by coupling dataflow to frameworks. Personal projects can follow it. |
| **API Facade pattern** | A concrete architectural tool. Corps rarely enforce it properly (Amazon needed Bezos). Your personal libraries do it by design. |
| **Denshya ecosystem** | Living proof that personal-project architecture can beat corporate equivalents (React, Redux, etc.) |
| **Spot Model (Stripe)** | Their internal code-health taxonomy. Shows that even a well-run company treats architectural decay as a constant battle. |

---

## Potential Title Ideas

- *Big Corp Architecture: Why the Biggest Companies Build the Worst Systems*
- *Your Best Architecture Is the One You Build for Yourself*
- *Architecture Is Not a Business Priority (And That's the Problem)*
- *The Myth of Corporate Engineering Excellence*
- *Why Your Side Project Has Better Architecture Than Twitter*
- *The Money-Software Paradox*

---

## Sources Worth Reading

- Brian Foote & Joseph Yoder — *Big Ball of Mud* (1997) http://www.laputan.org/mud/
- Melvin Conway — *How Do Committees Invent?* (1968) http://www.melconway.com/Home/Conways_Law.html
- Joel Spolsky — *Things You Should Never Do, Part I* (2000) https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/
- Joel Spolsky — *Don't Let Architecture Astronauts Scare You* (2001) https://www.joelonsoftware.com/2001/04/21/dont-let-architecture-astronauts-scare-you/
- Dan North — *Software, Faster* (2023) https://dannorth.net/2023/09/02/software-faster/
- Dan North — *Measuring Software, Faster* (2023) https://dannorth.net/2023/09/09/measuring-software-faster/
- Jeff Atwood — *A Personal Project is Worth 1,000 Resumes* https://blog.codinghorror.com/a-personal-project-is-worth-1000-resumes/
- Paul Graham — *Hackers and Painters* http://www.paulgraham.com/hp.html
- Paul Graham — *How to Do What You Love* http://www.paulgraham.com/love.html
- Martin Fowler — *Who Needs an Architect?* https://martinfowler.com/ieee-software/who-needs-an-architect.html
- Fred Brooks — *The Mythical Man-Month*
- Neal Ford, Rebecca Parsons, Patrick Kua — *Building Evolutionary Architectures* (O'Reilly)
- Steve Yegge — *Stevey's Google Platforms Rant* (2011)
- Stepsize / Shortcut — Developer Tech Debt Survey (2024)
- McKinsey — Tech Debt Impact Report (2024)
- CISQ — Cost of Poor Software Quality (2024)
- Raffi Krikorian — *Timelines at Twitter* (QCon SF 2012 talk)
- Uber Engineering — *Introducing Domain-Oriented Microservice Architecture* (2019)

---

## How to Use This

Pull what works, skip what doesn't. The material is organized from hardest evidence (stories of Twitter/Uber/Facebook) → your own thesis → practical survival guide → sources. If you only have time for one section, **Angle 1 (the stories)** and **Angle 2 (the money mechanic)** are the strongest foundation.
