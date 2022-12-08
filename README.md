# LetsDessert
Native iOS app in Swift using UIKit that allows users to browse dessert recipes from an API

API: https://www.themealdb.com/api.php

Utilizing 2 endpoints:
https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert for fetching the list of meals in the Dessert category.
https://www.themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID for fetching the meal details by its ID.

The user is shown the list of meals in the Dessert category, sorted alphabetically.

When the user selects a meal, they are taken to a detail view that includes:
Meal name
Instructions
Ingredients/measurements

- Filters out any null or empty values from the API before displaying them
- Loading indicators and error handling used
- Unit tests added
- No Third-party libraries used
- Image caching used

The app is compiled using the latest version of Xcode.
