# Valery Zinchenko · Full-Stack Systems Engineer

**I design, build and run production systems end to end: React frontends, TypeScript/Rust/Python backends, PostgreSQL, Linux servers, and the CI/CD that ships them.**

10+ years of building for the web, 7+ of them in React and TypeScript. I've led frontend architecture as a Tech Lead, written a UI framework, and debugged the production incidents that come with real users.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-framemuse-0A66C2?logo=linkedin&style=flat-square)](https://linkedin.com/in/framemuse)
[![Telegram](https://img.shields.io/badge/Telegram-FrameMuse-26A5E4?logo=telegram&style=flat-square)](https://t.me/FrameMuse)
[![Stack Overflow](https://img.shields.io/badge/Stack%20Overflow-FrameMuse-F58025?logo=stackoverflow&style=flat-square)](https://stackoverflow.com/users/12468111/framemuse)

> **Open to work:** senior / lead frontend or full-stack roles, and contract work like architecture reviews, API layer design,
> performance work and infrastructure setup. The fastest way to reach me is [Telegram](https://t.me/FrameMuse).

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white&style=flat-square)
![React](https://img.shields.io/badge/React-20232A?logo=react&style=flat-square)
![Node.js](https://img.shields.io/badge/Node.js-5FA04E?logo=nodedotjs&logoColor=white&style=flat-square)
![Bun](https://img.shields.io/badge/Bun-000?logo=bun&style=flat-square)
![Rust](https://img.shields.io/badge/Rust-000?logo=rust&style=flat-square)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white&style=flat-square)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white&style=flat-square)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white&style=flat-square)
![NGINX](https://img.shields.io/badge/NGINX-009639?logo=nginx&logoColor=white&style=flat-square)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonwebservices&style=flat-square)

---

## ⭐ Featured open source

| Project | What it is | |
|---|---|---|
| [**react-modal-global**](https://github.com/FrameMuse/react-modal-global) | Open React modals from plain JS, outside the component tree | [npm](https://www.npmjs.com/package/react-modal-global) |
| [**Tama**](https://github.com/pinely-international/tama) | Reactive JSX UI rendering without a root, usable across frameworks (formerly *Proton*, about 2 years of R&D) | [npm](https://www.npmjs.com/package/@denshya/tama) |
| [**node-group**](https://github.com/FrameMuse/node-group) | A persistent, CSS-transparent group of DOM nodes, without patching the DOM ([write-up](blogs/node-group.md)) | [npm](https://www.npmjs.com/package/node-group) |
| [**react-i18n-editor**](https://github.com/FrameMuse/react-i18n-editor) | Edit translations directly on the live page | [npm](https://www.npmjs.com/package/react-i18n-editor) |
| [**API Facade**](https://github.com/FrameMuse/rest-api-facade) | A handbook of API client patterns: recipes, filtering, sorting, auth, Swagger typing ([intro](blogs/api-facade-introduction.md)) | guide |
| [**benchik**](https://github.com/FrameMuse/benchik) | A tiny benchmark for browser and terminal with no dependencies | [npm](https://www.npmjs.com/package/benchik) |
| [**mermaid-svg-native**](https://github.com/pinely-international/mermaid-svg-native) | Renders Mermaid to SVG without a headless browser | [npm](https://www.npmjs.com/package/mermaid-svg-native) |

## ✍️ Writing

I write about architecture, performance and the web platform. Start here:

| Article | About |
|---|---|
| [Objects Where the Domain Lives](blogs/objects-where-the-domain-lives.md) | Domain code becomes classes, utilities stay pure functions, I/O goes in namespaces, and why each gets that shape |
| [Faster JavaScript Loops Even Seniors Don't Know About](blogs/faster-loops.md) | Benchmarks of every loop and iterable, the generator penalty, unrolling, `for..in` vs `Object.keys` |
| [The Optimization and Trust Dilemma](blogs/optimization-and-trust.md) | Rate limits, short bans and trust scores for public APIs |
| [Group: A Persistent Node Range for the DOM](blogs/node-group.md) | The missing DOM primitive, prior art, and how `node-group` works |
| [Code Boundaries](blogs/code-boundaries.md) | Where to draw lines in a codebase so it stays maintainable |
| [No-Framework Principle](blogs/no-framework-principal.md) | Keep your dataflow and data structures independent of the framework |
| [API Facade Patterns Seniors Don't Talk About](blogs/api-facade-seniors.md) | HTTP client architecture beyond `fetch` wrappers |
| [SSR Breakdown](blogs/ssr-breakdown.md) | Trade-offs in server-side rendering, hydration and caching |
| [What React Is Actually Doing](blogs/react-doing.md) | React internals and a critique of its dataflow |
| [`useEffect` With `AbortSignal`](blogs/useEffect-abortSignal.md) | Cleaner subscriptions with one `abort()` |

## 🔧 From production

Short write-ups of real incidents and the decisions behind them:

- **RabbitMQ connection leak.** A webhook worker didn't close connections in its `catch` block. After about 10k errors the server ran out of memory and was OOM-killed every 2–3 hours. The fix was a `finally` block, graceful shutdown and alerts on memory growth. → [post-mortem](work-stories/server-attack.md)
- **Brute-force attack.** CPU was pinned at 100% by thousands of auth attempts. I preserved the logs, set up a fail2ban auto-jail and moved SSH to keys only. → [post-mortem](work-stories/server-attack.md)
- **8 s → 80 ms query.** A 5-table join was doing a sequential scan on a 50M-row table; a composite index fixed it. → [story](work-stories/database.md)
- **Schema design at 50M rows.** CRM and transaction platforms with composite, partial and covering indexes, `CONCURRENTLY` migrations and PgBouncer. → [story](work-stories/database.md)
- **Integration platform.** A normalization layer that brings 20 external webhook sources into one internal contract (NestJS, React, Electron). → [story](work-stories/difficult-task.1.md)
- **Supply-chain incident.** I found malicious code injected into one of my published libraries, then traced and removed it.
- **How I start a task.** → [questions I ask before writing code](work-stories/work-requirements.md)

## 🧰 What I work with

<details>
<summary><b>Details by area</b></summary>

**Frontend:** React and TypeScript (7+ years), Redux / Zustand / signals, SSR, component libraries, Canvas 2D, Three.js / WebGL. Author of the [No-Framework Principle](blogs/no-framework-principal.md) and the [Denshya](https://github.com/denshya) libraries. Custom TypeScript tooling (ts-patch, ESLint, TSServer and Vite plugins).

**Backend:** TypeScript (NestJS, Express, Next.js, Payload CMS); Rust (Axum, SQLx, JWT, WebSocket) for high-throughput auth and API services; Python (FastAPI, Django, Flask, Frappe/ERPNext). Go, Java and C# when a project needs them.

**Data:** PostgreSQL (indexing, window functions, JSONB, full-text search, PgBouncer), Redis, RabbitMQ, Celery, MongoDB.

**Infrastructure:** Linux servers, SSH hardening, nginx reverse proxies with TLS, fail2ban, DNS, and Docker Compose stacks with healthchecks.

**CI/CD & cloud:** GitHub Actions (reusable workflows, composite actions, matrix builds), GitLab CI, AWS (SAM, Lambda, Amplify, S3 with OIDC, CodeBuild), Cloudflare Workers, GCP App Engine, Fly.io, DigitalOcean, Supabase, Hasura.

</details>

## 📦 More projects

Links go to public repositories. 🔒 marks client or private work: I can walk you through it, but the code isn't public.

<details>
<summary><b>Libraries & tooling</b></summary>

| Project | Description |
|---|---|
| [@denshya/reactive](https://github.com/denshya/reactive) | State engine with signals, fine-grained updates, derived values and actions ([npm](https://www.npmjs.com/package/@denshya/reactive)) |
| [@denshya/router](https://github.com/denshya/router) · [@denshya/navigation](https://github.com/denshya/navigation) | URL pattern routing and navigation |
| [denshya/ssr](https://github.com/denshya/ssr) | Server-side rendering for the Denshya stack |
| [tamui](https://github.com/pinely-international/tamui) | Cross-framework UI kit and design system |
| [jsx-canvas](https://github.com/pinely-international/jsx-canvas) | Render HTML-like JSX markup to `<canvas>` |
| [documaru](https://github.com/pinely-international/documaru) · [tamablog](https://github.com/pinely-international/tamablog) | Markdown docs and blog generators that run as GitHub Actions |
| [vite-mermaid-svg](https://github.com/pinely-international/vite-mermaid-svg) | Vite plugin that compiles Mermaid to SVG at build time |
| [svg-bbox](https://github.com/pinely-international/svg-bbox) | `getBBox` polyfill for browser-less environments ([npm](https://www.npmjs.com/package/svg-bbox-polyfill)) |
| [mixedin](https://github.com/FrameMuse/mixedin) | Mixins (multiple inheritance) in TypeScript ([npm](https://www.npmjs.com/package/mixedin)) |
| [react-zod-form](https://github.com/FrameMuse/react-zod-form) | Zod-based form validation for React ([npm](https://www.npmjs.com/package/react-zod-form)) |
| [openapi-schema-tools](https://github.com/FrameMuse/openapi-schema-tools) · [universal-swagger-exporter](https://github.com/FrameMuse/universal-swagger-exporter) | OpenAPI / Swagger schema manipulation and type export |
| [closure-signal](https://github.com/FrameMuse/closure-signal) · [event-signal](https://github.com/FrameMuse/event-signal) | Minimal signal implementations (TC39 Signals compliant / event-based) |
| [typescript-operator-overloading](https://github.com/FrameMuse/typescript-operator-overloading) | Operator overloading for TypeScript via Symbols |
| [llm-rag](https://github.com/FrameMuse/llm-rag) | CLI and MCP tool that turns code and docs into a RAG / graph knowledge base |
| [web-scrapper](https://github.com/FrameMuse/web-scrapper) | `scrape` CLI that converts a website to Markdown |
| [bemer](https://github.com/FrameMuse/bemer) | BEM class-name helper |
| [ci-cd](https://github.com/pinely-international/ci-cd) | Reusable GitHub Actions workflows: PM2 and S3 deploys, bun/npm support |
| [folder-structure](https://github.com/pinely-international/folder-structure) | Project structure conventions |
| [react-template](https://github.com/FrameMuse/react-template) | TypeScript React starter |
| [vscode-frontend-helper](https://github.com/FrameMuse/vscode-frontend-helper) | VS Code extension with frontend utilities |
| 🔒 story-studio | Custom TypeScript compiler plugins (ts-patch, ESLint, TSServer, Vite) |
| 🔒 project-atlas | Local-first, git-based project management (React, isomorphic-git) |
| 🔒 react-sai · query-tools | Swagger-driven API integration for React; URL query utilities |

</details>

<details>
<summary><b>Products & client work</b></summary>

| Project | Description | Stack |
|---|---|---|
| 🔒 rukaku | Multi-language microservice finance platform | nginx (6 vhosts, TLS, WebSocket, `auth_request`), Docker Compose, Rust, Python, TS |
| 🔒 smartlink | Link management platform, API and frontend | NestJS, TypeORM, PostgreSQL, WebSocket, PM2, React 19, Redux Toolkit, Zod |
| 🔒 campaign-dashboards | Analytics dashboard with a serverless backend | AWS SAM + Lambda, CloudFormation, Hasura, Auth0, Amplify, React |
| 🔒 creaty | Content creation platform | Django, PostgreSQL, Redis, Celery, nginx, Cal.com · [frontend](https://github.com/FrameMuse/creaty-frontend) |
| 🔒 pinely.eu | Company CMS site | Next.js 15, Payload CMS, MongoDB, S3 with OIDC |
| 🔒 plapi | NestJS backend | TypeORM, Swagger, S3, PM2 |
| 🔒 solana-dex-trading-bot | DEX trading strategies | TypeScript/Bun + Python (IPC), Solana SDK, gRPC, Jito |
| 🔒 Stream menu ecosystem | Figma plugin, admin panel and menu app ([retrospective](blogs/project-1-year.md)) | React, Figma API |
| 🔒 erpnext-optora | ERPNext customizations | Python, Frappe |
| 🔒 feature.fm | Feature management | Cloudflare Workers |
| 🔒 fbz-shop-bot | Telegram commerce bot (TS and Python versions) | Telegraf, MikroORM, PostgreSQL, Docker |
| 🔒 HCF | Charity fundraising sites | React, Docker, GitHub Actions · [Water](https://github.com/FrameMuse/HCF-Water) · [House](https://github.com/FrameMuse/HCF-House) · [Childhood](https://github.com/FrameMuse/HCF-Childhood) |
| [merlines-frontend](https://github.com/FrameMuse/merlines-frontend) | Business frontend | React, Docker, GitLab CI |
| [Invix-Solutions](https://github.com/FrameMuse/Invix-Solutions) | Product catalog | Next.js, FastAPI, aiogram, PostgreSQL, MinIO |
| [rust-web](https://github.com/FrameMuse/rust-web) | Rust web app | Axum, Fly.io |

</details>

<details>
<summary><b>Games & 3D</b></summary>

| Project | Description | Stack |
|---|---|---|
| 🔒 usagi3d editor | 3D game editor with a GPU path tracer | Three.js, WebGL |
| 🔒 COH | 3D game with navmesh pathfinding | Three.js, recast-navigation, @react-three/fiber |
| [Tower-Defense](https://github.com/FrameMuse/Tower-Defense) · [Freeze-Man](https://github.com/FrameMuse/Freeze-Man) | Unity games | Unity, C# |
| [react-world](https://github.com/FrameMuse/react-world) | A small, fast React world map | React, SVG |

</details>

<details>
<summary><b>Archive (early work, 2015–2021)</b></summary>

Archived repositories from when I was starting out: CS:GO / Standoff sites, landing pages and early React apps. For example
[Case-Simulator-React](https://github.com/FrameMuse/Case-Simulator-React),
[StandoffSpin](https://github.com/FrameMuse/StandoffSpin),
[algo-academy](https://github.com/FrameMuse/algo-academy),
[corpachat-frontend](https://github.com/FrameMuse/corpachat-frontend),
[articulum-frontend](https://github.com/FrameMuse/articulum-frontend),
[AtomSMM-frontend](https://github.com/FrameMuse/AtomSMM-frontend),
[FrameMuse-Galaxy](https://github.com/FrameMuse/FrameMuse-Galaxy).
I started with *HTML & CSS for Dummies* at 11 and kept going.

</details>

## More about me

- [Bio](bio.md): from PHP at 11 to Rust microservices, plus percussion, skateboarding and four languages
- [Resume](Resume.md): work history in full
- [Easy Linux](easy-linux/): my scripts for setting up a desktop or server
