# Uncontrollable Modal in React

## Introduction

Modals have become an essential component in web development for creating interactive and intuitive user experiences. Traditionally, modals controlled by developers, which means that the developer is responsible for managing the modal's state and behavior.
However Uncontrolled modals offer a fresh and more efficient approach to modal implementation.

In this post, we will dive into what Uncontrollable Modals are and why they may be a better choice than the traditional ones.

## Origins

The concept of modals can be traced back to the early days of web development when developers sought to create dynamic and interactive user interfaces. Modals were initially used as a way to display additional information or prompt users for input without navigating away from the current page.

Over the years, websites have recognized the importance of enhancing User Experience (UX) and have taken more control over the modals. With the rapid advancement of technologies, decoupling the modals from the website became irrelevant.

In the present day, we have stunning modals that not only offer great functionality, but also provide a seamless user experience. However, despite their impressive appearance, these modals often suffer from poor and boilerplate implementation, which harms developer experience.

### The Negative Effects of Taking More Control over Modals

Moreover, the more control developers had over modals, the more difficult it became to reuse them across different components and projects. Each modal implementation required specific code, making it time-consuming and error-prone. This lack of reusability hindered productivity and resulted in duplicated efforts.

While taking more control over modals initially aimed to enhance user experience, it eventually became a burden for developers in terms of maintenance, reusability, and performance.

## Rise of Uncontrolled Modals

As the name suggests, they are modals that are designed to be largely "uncontrolled" by the developer. They are built on the concept of unidirectional data flow and allow the modal to manage its own state internally. This means that the modal itself handles its open/close state, animations, and other behavior without the need for explicit control from the developer.

One of the significant advantages of uncontrollability is a simplicity and ease of use. By encapsulating the modal's logic within itself, developers can focus more on their application's core functionality rather than spending time managing the modal's state. This can lead to cleaner and more maintainable code, as well as improved productivity.

### Enhanced Flexibility and Reusability

Modal components can be easily reused across different components and projects. This reusability comes from their self-contained nature and removes the need to copy code or modify existing modals to match new requirements. By simply importing the modal component and passing in the necessary props, developers can quickly integrate the modal into their application without any hassle.

### Improved UX

It can greatly contribute to an enhanced user experience by offloading the modal's state management to itself, you can optimize their rendering and reduce unnecessary re-renders.

Additionally, it offers more advanced features, such as the ability to handle multiple modals simultaneously or nested modals, which can be challenging to achieve with traditional modal implementations. These features can elevate the user experience by allowing for more complex and interactive modal interactions.

## A piece of code

There are already several libraries that offer pre-built components, such as [nice-modal-react](https://www.npmjs.com/package/@ebay/nice-modal-react) and [react-modal-global](https://www.npmjs.com/package/react-modal-global), which has nearly the same implantation but more flexible.

They make it even easier to incorporate Uncontrolled Modals into your projects. These libraries provide a wide range of customization options and additional features, saving time and effort in implementing new modal functionality.

### Here's short code example of [react-modal-global](https://www.npmjs.com/package/react-modal-global)

[![Edit react-modal-global](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/edit/react-modal-global)

```tsx
function PopupMyFirst() {
  const modal = useModalWindow()

  function onSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()

    const target = event.currentTarget
    const ageInput = target.elements.namedItem("age")

    alert(ageInput) // Show age
    modal.close() // Then close `this modal`
  }

  return (
    <PopupLayout>
      <form onSubmit={onSubmit}>
        <h2>My first popup modal</h2>
        <input name="age" placeholder="Enter your `first popup modal` age" />
        <button type="submit">See my age</button>
      </form>
    </PopupLayout>
  )
}
```

## Conclusion

Uncontrollable Modals present a compelling alternative to traditional modal implementations. With their self-contained nature, enhanced flexibility, it offers developers a more efficient and enjoyable way to implement modals in their applications. By embracing this modern approaches, they can streamline their development process, create more reusable code and ultimately provide a better user experience.

## Last word

Generally, new technologies or methodologies may not always bring anything new and can sometimes make work a little harder for those accustomed to traditional methods. However, we should never overlook the importance of developer experience, especially in today's environment where there are numerous upcoming features and codebases are growing larger. It becomes increasingly easy to get lost in the code, so it is important to remember the reasons why SOLID principles were created and why they have gained popularity and recognition.

These principles, such as separating concerns, decoupling components, and preventing premature optimization, etc. - all prioritize code quality and developer experience.

*Created with the help of AI, please let me know if anything needs revision.*
