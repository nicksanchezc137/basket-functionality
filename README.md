# README


## How to run the application

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails db:seed`
5. Run `rails s`
6. Go to `http://localhost:3000` in your browser

## How to run the tests

1. Run `rails test`





## How it works

 The application uses Rails version Rails 7.0.8.7, Bootstrap as the UI framework and uses several models who's data is persisted in an SQLite database. The design decision to use SQLite is because SQLite is easy to setup for testing and demo purposes. The application models include;

  - ProductCatalogue - The product catalogue is the model that defines the products at Acme Widget Co. The initial product data is seeded in the database using the seeds.rb file.

  - DeliveryCharge - The delivery charge is the model that defines the delivery charges for the products. It includes the lower limit and upper limit(the limits are used to tell what delivery charge applies) of the delivery charge and the delivery cost. The decision to include a model for delivery charges is to allow for a more dynamic approach to delivery charges. Instead of hard coding, we can edit the lower/upper limits and the respective charges. The charges as described in the question are included in the seed file.

  - Offer - The offer is the model that defines the offers for the products. It includes the offer description(the offer description eg buy one get another at half price), the offer price(A negative price that will be discounted from the basket), the trigger count(The number of items of type product catalogue that need to be in the basket to trigger the offer) and the offer product catalogue(The product catalogue item that will be discounted from the basket eg a BOGAF offer where if you buy one you get another product at a discounted price). The buy one and get one at half price offer for the red widget is included in the seed file.
 
  - Basket - The basket is the model that defines the basket that will contain the products and offers.

  - Basket Line Items - This model belongs to the Basket model and defines the line items that are in the basket. It includes the product catalogue item or offer and the price of the item. The basket totals taking into account the offers and delivery charges are computed instead of storing the totals in the basket model.



## Assumptions

 - The offer for the red widget applies to only the first 2 product catalogue items.
 - No users model so we end up with floating baskets. Baskets are created when "Add to Basket" is clicked and if no basket exists, its created. There is also the option to Delete the basket.
 - An offer is treated as a separate basket line item.

 ## Improvements that can be made

 - Add a users model, associate baskets with users, add devise for auth and cancan for authorization.
 - An Image for the product catalogue.
 - Increase test coverage and add tests for delivery charges, product_catalogue and offers
 - Modify the basket and basket_line_item controllers and transferring majority of the business logic to the models to keep the controllers thin.