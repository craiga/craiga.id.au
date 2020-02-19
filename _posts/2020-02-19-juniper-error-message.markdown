---
title: A quick note to help others using Juniper, a Rust GraphQL library
date: 2020-02-19 11:30:00 +0000
---

TL;DR: `panicked at 'resolve() must be implemented by non-object output types'` might just mean that your GraphQL query is badly formatted.

---

I've been spending some time with Rust recently, using it to build a GraphQL API.

It's been a steep learning curve, but one I was enjoying until I started getting this error:

    thread '…' panicked at 'resolve() must be implemented by non-object output types', …/juniper/src/types/async_await.rs:44:13

Googling found barely any mention of this error message outside of [Juniper's source code](https://docs.rs/juniper/0.14.2/src/juniper/types/base.rs.html#341).

It took quite a bit of pairing and rubber-duck debugging to figure out what this message meant, but it turns out that it was because my GraphQL query was badly formatted; instead of this:

```graphql
{
  products(searchTerm: "cool products") {
    pageInfo {
      hasPreviousPage
      hasNextPage
    }
    edges {
      node {
        id
      }
    } 
  }
}
```

…I was just asking for `pageInfo`.

```graphql
{
  products(searchTerm: "cool products") {
    pageInfo
    edges {
      node {
        id
      }
    } 
  }
}
```

The GraphiQL interface was able to automatically correct a similar errors with `edges` or `node`, but there's some magic[^clarkes-law] missing from my implementation of `pageInfo` which doesn't allow for the same.

[^clarkes-law]: ["Any sufficiently advanced technology is indistinguishable from magic."](https://en.wikipedia.org/wiki/Clarke%27s_three_laws)
