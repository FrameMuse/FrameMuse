# Refactoring Reflections

## Introduction

Refactoring is one of the attracting, challenging, enjoyable and often rejectable practice in software development.

Rejectable by Project managers of course! There is not much value in that, they say. But that’s not the whole truth.

## Refactoring

Refactoring IS a part of a healthy development, without one it faces difficulties…

Human species are known for their careless attitude to Health, to their own and others. That’s not good I’d say, though sometimes it’s actually hard to fight for your health. And there is another typeof people - they put their health above others.

Even though it doesn’t mean people DON’T want to be healthier or try to amend the situation. It is natural for us to make us and everything around better. It might not seen like it looking at our planet, but eventually we try to fix it when it gets too bad.

Apparently, that’s a pretty big argument for refactoring to be done early, thus it must be a widely spread practice, but somehow it’s been cursed. It has the rejection culture and generated tons of memes like “don’t touch it if it’s working”, “I finished refactoring! Cool, now the bug fixed? Eh-Mmm…”.

## Rejection

Developers themselves often rejecting idea of refactoring their own code, not talking about so-called “legacy code” (written by someone else). Managers not seeing the bigger picture. Clients not seeing the value. Being under pressure of shipping new features and fixing bugs, it becomes “normal” to avoid and stay away from it.

Furthermore, it’s not clear for developers themselves if it’s actually rewarding for them as well as walking the wire with newcomers and being respectful to everyone’s code. I notice that, personally, I started to avoid even the talk about refactoring so to not offend anyone’s feelings.

The code art has a very wide meaning, so it might not be clear for your managers and teammates if you’re being mean or you’re trying to improve. Refactoring by itself is a regular thing, so if it’s not well established in your team and company, constant mentioning of refactoring your own or someone else’s code may even harm your reputation. You’re sort of showing your inability to write a good code (which might not be actually true) or your subjective attitude to others.

There are many other reasons why it’s being squished out of development cycle, but mainly due to it’s counter-intuitive nature. You can feel it by trying to say “I want to make a refactoring” and “We need to make a refactoring”, which is practically the same statement in the context of refactoring. However, in the first case, you’re in more likelihood to be criticized and rejected, even if your intention is to benefit the project, not just yourself.

## Pain in the Ass

Not refactoring the code gives tons of problems, one of them code debt, it’s crawling in very slowly, but when it strikes - it’s like hurricane. There is a clear tendency of accumulating more code debt in all sort of projects around the world, which actually gives [pain to companies](https://www.sonarsource.com/blog/new-research-from-sonar-on-cost-of-technical-debt/).

Fair to mention that complete absence of refactoring in early stages of development is absolute normal, that’s ok to left a crap behind you while you’re validating an idea or experimenting. The problem comes when you KEEP avoiding it for any reasons while coming to production. That’s obvious that one time you will face a stone wall, which can be overcome only by complete refactoring or reworking from scratch and that happens.

Failing to modernize and maintain a Water Dam is leading to sudden break and a flood. Software development is a system as well as a Water Dam if not modernized (refactored) regularly, it cracks.

So why is it still being ignored by companies?

## Actually Reasonable?

The answer is actually understandable and pretty simple — money.

— Ah, those emotionless, cynical bUsInEsSPeOpLe!

No, not in the sense that they don't care. I mean, if you don't know your project is going to be successful and profitable, it makes sense to make it as cheap as possible. However, if it comes out successful, it's not a big deal to rework it from scratch. Even though it wouldn't have taken any extra time or money if done correctly from the start.
In case of failing, you would loose less money.

— Ok, I’m not gonna work for startup companies, only for big and established projects.

I’m afraid that you will still have the same problems. You know developers usually start their learning from startups as it’s easier to be involved and you’re allowed to do it the way you see it. So while you’re coming to a big tech company, to an established and probably complex project, you likely to be forced to avoid refactoring, which means creating a habit and getting used to it.

— Mmm, and what? That’s not about me!

Yes, about others. It took me some time to get a harsh truth - you’re not the only working and in most of cases, you’re not going to make decisions (at least in the very beginning). So you will be pushed and criticized by people with a strong, developed habit and networking, eventually becoming like them (potentially).

There is more to it, since companies are still tend to have managers that trying to optimize KPI or effectives of a development department.

## :(

I guess people tend to forget why development is called **Development**.

---

I don't have a good solution for that, I don't know where it's coming to, if you have anything to share - let's discuss.

What I personally feel to do is a sneaky refactoring, embed refactoring changes little by little in my feature and fixes PRs
