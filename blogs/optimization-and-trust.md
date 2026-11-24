# The Optimization and Trust Dilemma

Your endpoint is open to third parties. You do not know who calls it.

At any given moment the caller can be a partner syncing orders or someone probing for a hole in your parser. Same URL, same headers, same shape of request. Usually there is nothing in the request itself that separates the two.

Everything below follows from that one fact.

## No identity, only behavior

The first instinct is a whitelist. Collect IPs, verify the company, let them through.

It sounds like security, but the work happens in the human step. Someone has to look at the requester and decide they are legitimate. If anyone can ask to be whitelisted, the whitelist is just a queue with extra steps. A malicious requester will happily fill the form.

And even a verified company is not a verified request. Their server can be compromised, their key can leak, their contractor can ship a retry loop that hammers you at 3 AM. You verified who they were last year, not what their code does right now.

So we stop trying to know intent and start watching behavior.

## Rate limits are a tax on the honest

A limit has to sit somewhere between "does not break a legitimate burst" and "does not take down the service".

There is no setting that satisfies both. Pick a number low enough to survive an attack and you will also throttle the partner who batches at midnight. Pick a number high enough for them and you are the one absorbing the attack. This is the trade, and it is unavoidable.

The honest requesters pay for the dishonest ones. That is not a flaw in the design, it is the design. A system with no limits is a system that optimizes for the attacker, because the attacker cares more about throughput than you do.

The only thing we can do is make the tax small for people who rarely trigger it.

## Short bans are cheaper than smart detection

The common tool here is something like fail2ban. You watch recent activity and, once a threshold is crossed, you block the source for a while.

Notice what this does not require. It does not require knowing whether the requester is malicious. It does not require a classifier, a reputation database or a support ticket. It just requires noticing that the recent past looks wrong and making the near future expensive.

The important detail is the length of the window. A block measured in seconds or minutes is cheap to serve, cheap to reverse and cheap to be wrong about. A permanent block based on a heuristic is a liability. Eventually the heuristic fires on a customer, and now you are explaining to them why their integration died.

Short blocks also handle the case where you are wrong in the other direction. A false positive costs a minute of retries. A missed attacker costs you whatever a minute of unrestricted traffic costs. Both are bounded.

## Trust is a budget

Punishment is one half. The other half is reward, and it is usually neglected.

If we can watch bad behavior, we can watch good behavior too. Age of the integration. Volume of successful calls. Absence of parse errors. Consistent payload shapes. Same endpoints, same hours, same rates, for months.

Wrap it into a score. Let the score buy things: higher concurrency, larger payloads, priority in the queue, access to endpoints that are expensive to serve.

This is not just kindness. It is optimization. A requester with a long clean history is cheaper to serve. You can skip some checks, some retries and some defensive throttling. You both win.

The reverse also holds. The score gives you a way to express "I trust this source enough to spend more on it" without pretending the trust is absolute.

## What trust should actually buy

Bulk endpoints are the clearest example.

A bulk endpoint is a real optimization for both sides. One request instead of a hundred means one TLS handshake, one auth check, one scheduling decision and one transaction instead of a hundred context switches. The requester saves round trips, you save overhead. Done well, it is strictly better than the same work in a loop.

It is also the most dangerous endpoint you can expose. A single request now carries a hundred units of work. If it goes wrong, it goes wrong a hundred times at once. The blast radius scales with the convenience.

That is exactly why it belongs behind a score. The feature is safe only for callers whose behavior is boring. Expose it to everyone and you have built an amplifier for whoever finds it first.

A rough ladder:

| Tier | What unlocks |
|------|--------------|
| New | Strict rate limit, small payloads, no bulk |
| Established | Normal limits, longer payloads |
| Trusted | Bulk endpoint, higher concurrency, priority queue |
| Verified | Dedicated capacity, raised ceilings, direct contact |

Each row costs more to serve and rewards better behavior. The ladder is the whole idea in one table: the more expensive the privilege, the more evidence it should require.

## Make trust expensive to fake

A score that only looks at your own traffic is farmable. Anyone patient can warm up an account with months of clean, cheap requests and then spend the earned privileges on one expensive abuse.

The defense is not a better score. It is making the top tier cost something that cannot be farmed. A signed contract, a payment history, a human call, a bond forfeited on abuse. The same manual research that made the whitelist weak is what makes the top of the ladder strong. The difference is that now it guards a small, specific, high-value privilege instead of the front door.

So the split is simple. Automate trust for everything cheap. Require humans for everything unbounded.

## Trust expires

The uncomfortable part: the score is a guess about the future based on the past, and the future does not owe you consistency.

A faithful integration can turn malicious overnight. The key leaks, the company is acquired, an employee with a grudge pushes a commit. The behavior that earned the score says nothing about the behavior after the change of ownership.

The opposite happens too. Someone probes you, gets throttled, signs a contract and becomes a model citizen. If your blocks are permanent, you never find out.

So:

- Keep block windows short and let the score recover.
- Let trust decay with inactivity, so a dormant account does not keep its privileges forever.
- Revoke privileges faster than you grant them. Granting is a slow climb, revocation should be a switch.
- Keep an audit trail. When a request is rejected, you should be able to say why, in one sentence, without opening the code.

That last point is underrated. A trust system you cannot explain is a trust system you cannot debug, and eventually cannot defend.

## What we are actually doing

We are not identifying intent. We cannot. We are pricing it.

Abuse should cost more than it returns. Good behavior should cost less than it does today. The score, the limits, the bans and the tiers are all just ways of moving those two numbers in opposite directions.

No system gets this right. The design goal is narrower and more honest: make the wrong guesses cheap, and make them reversible.

---

The requester you banned for a minute and the requester you promoted to bulk access are the same unknown party, seen at different times. Treat both decisions as temporary.

---

## Original notes

_Verbatim, as written before editing._

My idea is to write about a optimization and trust dilemma:

Let's say we have an endpoint that should be called by 3rd party service, this service could be either good-faith or malicious requester.

We can't possible know if who it will be at each point of time. We can communicate and whitelist requester ips, but that requires manual research from people, otherwise it won't help since malicious requester can whitelist their ips too.

So a malicious requester may send a lot of requests, big requests or incorrect ones to try to compromise the endpoint or the whole system. So we add rate limiting, which affects good-faith requesters too, which is a trade-off that we do to keep the system working for other while filtering unfaithful.

Another common way to limit bad actors is to limit them for a prolonged time based on their recent activity (This is what fail2ban does).
For example, block any requests for 1 minute or such. It also helps to severe limits based on the age of the requester.
If it has been making requests to your service for some time, it is natural to assume they are more faithful.

On the opposite side, we can lift the limits for proven faithful requesters if they have been using the service faithfully for quite a while.
We can give a score of faithfulness and change the limits or lock/unlock certain features.
Like the optimization of a request - bulk requests, for truly faithful requesters we can allow bulk processing of requests in one go. Which is more server intensive but more harmful if done with bad intentions, so we give this privilege only for those who deserve. We optimize request time both for us and them and we can dedicate more processing power for faithful requesters too.

However, faithful can turn malicious and vice versa. That's why we keep block windows short and require high score for privileges.
