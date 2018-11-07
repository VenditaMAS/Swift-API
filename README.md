MASApi
==

`MASApi` is a framework allowing RESTful communication with the MAS API. Its design goal is straightforward usability by being as Swifty as possible.

The interface is highly uniform and follows common patterns in naming, arguments, etc.

Here are some examples:

```swift
import MASApi

let api: Api = Caller(host: "mascloud1.venditabeta.com", username: "foo", password: "bar")
api.listForms { result in
  switch result {
  case .success(let forms):
    // We've got our forms, let's do something with them.
  case .fault(let fault):
    // Something possibly unexpected occurred.
  }
}

// It's possible to specify a queue on which the callback will occur.
// If no queue is specified (as above), the queue on which the callback
// occurs is unspecified.
api.listInvocations(queue: .main) { result in
  switch result {
    // You know the drill
  }
}

// For the `list*` methods, identifiers can be specified.
// If they are not specified, the MAS API assumes "all" is
// meant.
api.listForms([uuid1, uuid2], queue: .main) { result in
  // Handle the result
}

// Most `list*` methods have a corresponding `get*` method.
// However, instead of returning a list of entities in
// the result, a single entity is returned.
// If the entity doesn't exist, the result is Fault.notFound
// (i.e., 404).
// In addition, some of the `get*` methods return a different
// type from the `list*` method. This is because the `list*`
// methods often use an "abbreviated" type like `ListedForm`
// instead of a "full" type like `Form`, which `getForm` returns.
api.getForm(uuid) { result in
  // Handle the result
}

// Here's an example of POSTing a form. Note that a special type,
// `PostForm` is used here. When using a method that requires an
// HTTP body (like POST, PATCH, and PUT), the serialized instance
// must implement the `ResourceRequestDescription` protocol, which
// describes which endpoint to call and even which HTTP method to
// use. These constraints are enforced *at compile time*.
//
// You may think it strange to have different types for posting,
// patching, and so on. But these types are not actually the same.
// For instance, `PostForm` lacks a `uuid`, while `PutForm` and
// `PatchForm` require a `uuid`. The PATCH HTTP verb requires a
// diff, while `PUT` wants the whole entity. The types used to
// perform these tasks are thus different but related.
//
// In the event that exactly the same type is used for two
// different HTTP methods, the simplest solution is to create a
// generic type and pass the HTTP method to it.
let form = PostForm(name: "Foo", prototype: prototype)
api.post(form) { result in
  // Handle the result here
}

api.getForm(uuid, queue: .main) { result in
  if case .success(let form) = result {
    // `form` is an instance of `Form`, the "full", editable model.
    let patch = PatchForm(form)
    // We only want to modify the "size" field.
    patch.values = [["size": 13]]
    api.patch(patch) { result in
      // Handle the result
    }
  }
}
```

Architecture
--

This is a high-level architecture overview. The details can be gleaned by reading the source.

The `Api` protocol is the high-level interface to the API. Its methods should be regarded as conveniences. The low-level protocol is `CoreApi`, and `Api` is implemented in terms of it (although `Api` does not inherit from `CoreApi`). `CoreApi` is _much_ less convenient to use. It has only one method, `send`, with two overloads, along with two extension methods, `list` and `first`, each with two overloads.

Here are some `CoreApi` examples:

```swift
let api: ApiCore = Caller(host: "mascloud1.venditabeta.com", username: "foo", password: "bar")

// The list method requires the result to be contained in an `Envelope`.
// It extracts the contents of the result as a list.
api.list(Get<EnvelopeResult<Forms, ListedForm>>()) { result in
  // Do something with the result
}

// The first method requires the result to be contained in an `Envelope`.
// It extracts the first item in the list, or sends `Fault.notFound` if
// the list is empty.
api.first(Get<EnvelopeResult<Forms, Form>>(uuid), queue: .main) { result in
  if case .success(let form) = result {
    let patch = PatchForm(form)
    patch.values = [["size": 44]]
    // The send method is the lowest-level method in the framework.
    // It knows nothing about envelopes and the response can be any
    // valid JSON.
    // Since `PatchForm` declares that its response is `Envelope<ListedForm>`,
    // this is what we'll see in the result.
    api.send(patch) { result in
      if case .success(let envelope) = result {
        // `Envelope` implements `Sequence`.
        if let form = envelope.first {

        }
      }
    }
  }
}

```
