---
title: Structured Data in 2020
date: 2020-01-10 16:40:00 +0000
---

Structured data is a way to describe a web page so it's easier for a computer to read it. Normally, this is so search engines are able to show rich data about your page.

![Google search result showing rich data about Banana Bread recipes](/assets/structured-data/google.png)


The last time I thought about embedding structured data in a web page, [Microformats](http://microformats.org) were a new, exciting idea. I was horrified to discover that was almost fifteen years ago! The web has changed a lot since then, so I had lots to re-learn about this topic.

The most confusing thing to me was understanding the separation of **vocabularies** (the schema for data) and **encodings** (the structure of the data).

# Vocabularies

Vocabularies are analogous to a database schema. A vocabulary is list of field names and expected data types for that field.

[Schema.org](https://schema.org) is an organisation backed by the big players in the search industry. It defines [vocabularies for all sorts of things](https://schema.org/docs/schemas.html).

For example, there's [a schema for recipes](https://schema.org/Recipe) which defines fields for ingredients, instructions, the yield of the recipe, the cuisine of the recipe, etc.

# Encodings

These vocabularies can be encoded into an HTML document using three encodings: Microdata, RDFa, and JSON-LD.

## Microdata and RDFa

[Microdata](https://developer.mozilla.org/en-US/docs/Web/HTML/Microdata) and RDFa work by adding attributes to an existing HTML document. 

Here's [an example of Microdata from Schema.org](https://schema.org/Recipe#eg-13):

```html
<div itemscope itemtype="http://schema.org/Recipe">
  <span itemprop="name">Mom's World Famous Banana Bread</span>
  By <span itemprop="author">John Smith</span>,
  <meta itemprop="datePublished" content="2009-05-08">May 8, 2009
  <img itemprop="image" src="bananabread.jpg"
       alt="Banana bread on a plate" />
  <span itemprop="description">This classic banana bread recipe comes
  from my mom -- the walnuts add a nice texture and flavor to the banana
  bread.</span>
  Prep Time: <meta itemprop="prepTime" content="PT15M">15 minutes
  Cook time: <meta itemprop="cookTime" content="PT1H">1 hour
  Yield: <span itemprop="recipeYield">1 loaf</span>
  Tags: <link itemprop="suitableForDiet" href="http://schema.org/LowFatDiet" />Low fat
  <div itemprop="nutrition"
    itemscope itemtype="http://schema.org/NutritionInformation">
    Nutrition facts:
    <span itemprop="calories">240 calories</span>,
    <span itemprop="fatContent">9 grams fat</span>
  </div>
  Ingredients:
  - <span itemprop="recipeIngredient">3 or 4 ripe bananas, smashed</span>
  - <span itemprop="recipeIngredient">1 egg</span>
  - <span itemprop="recipeIngredient">3/4 cup of sugar</span>
  ...
  Instructions:
  <span itemprop="recipeInstructions">
  Preheat the oven to 350 degrees. Mix in the ingredients in a bowl. Add
  the flour last. Pour the mixture into a loaf pan and bake for one hour.
  </span>
</div>
```

Here's [the same example, but this time in RDFa]((https://schema.org/Recipe#eg-13)):

```html
<div vocab="http://schema.org/" typeof="Recipe">
  <span property="name">Mom's World Famous Banana Bread</span>
  By <span property="author">John Smith</span>,
  <meta property="datePublished" content="2009-05-08">May 8, 2009
  <img property="image" src="bananabread.jpg"
    alt="Banana bread on a plate" />
  <span property="description">This classic banana bread recipe comes
  from my mom -- the walnuts add a nice texture and flavor to the banana
  bread.</span>
  Prep Time: <meta property="prepTime" content="PT15M">15 minutes
  Cook time: <meta property="cookTime" content="PT1H">1 hour
  Yield: <span property="recipeYield">1 loaf</span>
  Tags: <link property="suitableForDiet" href="http://schema.org/LowFatDiet" />Low Fat
  <div property="nutrition" typeof="NutritionInformation">
    Nutrition facts:
    <span property="calories">240 calories</span>,
    <span property="fatContent">9 grams fat</span>
  </div>
  Ingredients:
  - <span property="recipeIngredient">3 or 4 ripe bananas, smashed</span>
  - <span property="recipeIngredient">1 egg</span>
  - <span property="recipeIngredient">3/4 cup of sugar</span>
  ...
  Instructions:
  <span property="recipeInstructions">
  Preheat the oven to 350 degrees. Mix in the ingredients in a bowl. Add
  the flour last. Pour the mixture into a loaf pan and bake for one hour.
  </span>
</div>
```

These are nice, simple approaches. However, embedding structured data into the body of an HTML document can quickly become unwieldy.


## JSON- LD

Here's [the same data from the previous examples, but this time in JSON-LD](https://schema.org/Recipe#eg-13):

```html
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "Recipe",
  "author": "John Smith",
  "cookTime": "PT1H",
  "datePublished": "2009-05-08",
  "description": "This classic banana bread recipe comes from my mom -- the walnuts add a nice texture and flavor to the banana bread.",
  "image": "bananabread.jpg",
  "recipeIngredient": [
    "3 or 4 ripe bananas, smashed",
    "1 egg",
    "3/4 cup of sugar"
  ],
  "name": "Mom's World Famous Banana Bread",
  "nutrition": {
    "@type": "NutritionInformation",
    "calories": "240 calories",
    "fatContent": "9 grams fat"
  },
  "prepTime": "PT15M",
  "recipeInstructions": "Preheat the oven to 350 degrees. Mix in the ingredients in a bowl. Add the flour last. Pour the mixture into a loaf pan and bake for one hour.",
  "recipeYield": "1 loaf",
  "suitableForDiet": "http://schema.org/LowFatDiet"
}
</script>
```

This has the downside of duplicating some information, but it far more flexible than Microdata or RDFa. It's able to be manipulated on the client side, and is [Google's recommended encoding](https://developers.google.com/search/docs/guides/intro-structured-data).

# Testing

Google provides a very useful [Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool/u/0/) which makes it simple to show how structured data is being parsed.
