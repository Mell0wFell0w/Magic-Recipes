//
//  SampleRecipes.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import Foundation

let sampleRecipes = [
    Recipe(
        title: "Pfeffernüsse",
        subtitle: "Spicy Gingerbread Cookies",
        summary: "*Adapted for high-altitude baking.  This is my favorite Christmas cookie.*",
        course: "Dessert",
        cuisine: "German",
        difficultyLevel: "Intermediate",
        author: "",
        duration: "",
        servings: "48",
        calories: "",
        instructions: [
            Instructions(
                sequence: 1,
                ingredients: [
                    Ingredient(name: "bread flour", quantity: Decimal(320), sequence: 1, unit: "g"),
                    Ingredient(name: "almond meal", quantity: Decimal(30), sequence: 2, unit: "g"),
                    Ingredient(name: "baking soda", quantity: Decimal(0.5), sequence: 3, unit: "tsp"),
                    Ingredient(name: "salt", quantity: Decimal(0.25), sequence: 4, unit: "tsp"),
                    Ingredient(name: "Lebkuchengewürz", quantity: Decimal(4), sequence: 5, unit: "tsp"),
                    Ingredient(name: "ground ginger*", quantity: Decimal(0.5), sequence: 6, unit: "tsp"),
                    Ingredient(name: "white pepper", quantity: Decimal(0.25), sequence: 7, unit: "tsp"),
                    Ingredient(name: "black pepper*", quantity: Decimal(0.125), sequence: 8, unit: "tsp")
                ],
                header: "Dry Team",
                text: """
                      Try substituting ammonium bicarbonate (baker's ammonia) for the \
                      baking soda. Some recipes use ~10-15 ml rum (2-3 tsp.) to dissolve \
                      ½-1 tsp. baker's ammonia.
                      """
            ),
            Instructions(
                sequence: 2,
                ingredients: [
                    Ingredient(name: "brown sugar", quantity: Decimal(100), sequence: 1, unit: "g"),
                    Ingredient(name: "honey", quantity: Decimal(113), sequence: 2, unit: "g"),
                    Ingredient(name: "unsalted butter", quantity: Decimal(71), sequence: 3, unit: "g"),
                    Ingredient(name: "heavy cream", quantity: Decimal(50), sequence: 4, unit: "g"),
                    Ingredient(name: "molasses*", quantity: Decimal(25), sequence: 5, unit: "g"),
                    Ingredient(name: "eggs", quantity: Decimal(2), qualifier: "large", sequence: 6, unit: ""),
                ],
                header: "Wet Team",
                text: """
                      Some recipes add candied orange and lemon peel (~30 g each), and \
                      the zest of a lemon to the wet team. Especially consider this when \
                      glazing with a non-lemon-based glaze.

                      *Molasses is not in the original recipe. For a lighter flavor, drop \
                      the molasses, increasing the honey by a corresponding amount. You \
                      can similarly reduce the amount of brown sugar.
                      """
            ),
            Instructions(
                sequence: 3,
                ingredients: [
                    Ingredient(name: "powdered sugar", quantity: Decimal(300), sequence: 1, unit: "g"),
                    Ingredient(name: "hot water or lemon juice and zest", quantity: Decimal(4), sequence: 2, unit: "g")
                ],
                header: "Glaze:",
                text: "See notes below for an alternative glaze recipe."
            ),
            Instructions(
                sequence: 4,
                ingredients: [],
                header: "Instructions",
                text: """
                      1. Mix the dry team in a small bowl.

                      2. The wet team except egg goes in a saucepan. \
                      Heat, stirring frequently until melted and sugar dissolved \
                      (do not boil). Let sit for 5 minutes.

                      3. Mix in the dry team and then the egg. Seal in cling wrap; \
                      refrigerate 24-48 hours. Time lets the dough blend and mature.

                      4. Roll into two ¾-inch snakes then cut into ¾-inch slugs \
                      (~17g). Roll in balls and place on silicone or parchment \
                      lining. Chill for 20-30 minutes.

                      5. Bake at 375 degrees for ~10 minutes. Cool completely, \
                      dip in glaze. You can thin the glaze with hot water (or \
                      lemon juice) as desired.

                      *To reduce the amount of kick to these cookies, reduce or \
                      eliminate the ginger and black pepper.
                      """
            ),
        ],
        notes: """
              Simple glaze is traditional, but you could try decorating with a \
              chocolate drizzle, orange zest, or lemon zest. I prefer a glaze \
              made with lemon juice and the lemon zest mixed in.

              The high-altitude adjustments I made include using bread flour in \
              place of all-purpose flour, increasing the amount of flour and \
              almond meal, slightly decreasing the amount of baking soda, \
              slightly increasing the amount of butter and heavy cream, and \
              adding an egg. And at high altitude you need to bake at a higher \
              temperature for a shorter time. Using baker's ammonia in place of \
              baking soda also helps create a better dome shape. I've tweaked \
              the spices by adding molasses while reducing the brown sugar and \
              adding ground ginger and black pepper.

              Some recipes add rum (~10 ml), candied orange and lemon peel (~30 g each), \
              and the zest of a lemon to the wet team. It is traditional to dissolve the \
              baker's ammonia in rum. (For example, see \
              [My German Recipes](https://mygerman.recipes/peppernuts-pfeffernusse/). \
              That recipe also suggests rum extract in the glaze of 250 g powdered sugar \
              and 2 Tbsp. milk, combined with some rum extract. It further suggests \
              dipping the bottoms of the frosted Pfeffernüsse in melted semisweet chocolate.)

              Adapted from [The Daring Gourmet's Pfeffernüsse recipe]\
              (https://www.daringgourmet.com/pfeffernuesse-german-iced-gingerbread-cookies/).
              """,
        isFavorite: true
    )
]

