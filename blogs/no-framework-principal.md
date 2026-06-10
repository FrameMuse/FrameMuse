# No-Framework Principle in Frontend

## Statement

**No-Framework Principle** in <u>Frontend Development</u> states that Developer should not rely on framework utils/tools/methods to build [dataflow](https://en.wikipedia.org/wiki/Dataflow) or [data structures](https://en.wikipedia.org/wiki/Data_structure).

Instead, Developer should rely on a language and well-known libraries to build and maintain them.

Developer should go for a codebase that splits into two branches: Framework-Based and Framework-Free and provide another integration between. Shortly: good and isolated [APIs](https://simple.wikipedia.org/wiki/Application_programming_interface).

The framework should take care of initiating, storing and reacting to updates of external data. On other hand, a Developer should choose right tools to better support the integration of the external data.

Though there are cases when **a part** of the flow could only be implemented in a way that is well-supported by framework. Or local object environments where data is not going beyond itself and has no [side-effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science)).

## Problem

Writing components often involves establishing data flow/structures locally or between other components. This usually done by abusing framework (e.g. using React Hooks), which to accomplish correctly requires  learning the framework deeply that leads to a learning curve just to support a data flow/structure.

Moreover, this tightly couples a data flow/structure to a framework, which kills reusability across other frameworks and puts additional burden to always stick to latest updates of the particular framework for maintenance.

## Afterward

There is a noticeable movement to a similar paradigm, like this one: <https://pureweb.dev/>.

And people are tend to ask for alternative approaches for handling reusability like bit.dev and such, which stores components in a specific way allowing better reusability across FrameWorks.

The web itself is striving to provide much better support for native [Web Components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components)
[Related comment to the topic of Components Composition](https://dev.to/brucou/comment/1ebij)

Though I don't think we should just quit the FrameWorks, but rather they should be better optimized and adapted to handling, reusing and declaring the data-flow independently of their own code.

- The original "[zero framework manifesto](https://bitworking.org/news/2014/05/zero_framework_manifesto/)"
- [Framework-Free at Last](https://www.infoq.com/articles/functional-UI-introduction-no-framework/)
