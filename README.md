# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

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

 The application uses Rails version Rails 7.0.8.7 and uses several models who's data is persisted in an SQLite database. The design decision to use SQLite is because SQLite is easy to setup for testing and demo purposes. The application models include;

  - ProductCatalogue - The product catalogue is the model that defines the products at Acme Widget Co. The initial product data is seeded in the database using the seeds.rb file.

  - DeliveryCharge - The delivery charge is the model that defines the delivery charges for the products. It includes the lower limit and upper limit of the delivery charge and the delivery cost. The decision to include a model for delivery charges is to allow for a more dynamic approach to delivery charges. Instead of hard coding, we can edit the lower/upper limits and the respective charges. The charges as described in the question are included in the seed file.

  - Offer - The offer is the model that defines the offers for the products. It includes the offer description(the offer description eg buy one get another at half price), the offer price(A negative price that will be discounted from the basket), the trigger count(The number of items of type product catalogue that need to be in the basket to trigger the offer) and the offer product catalogue(The product catalogue item that will be discounted from the basket eg a BOGAF offer where if you buy one you get another product at a discounted price). The buy one and get one at half price offer for the red widget is included in the seed file.
 
  - Basket - The basket is the model that defines the basket for the products. It includes the basket line items and the basket total. The basket line items are the products that are in the basket and the basket total is the total price of the basket. The basket line items can be type product catalogue or offer(discounts).



## Assumptions

 - The offer for the red widget applies to only the first 2 product catalogue items.
 - No users model so we end up with floating baskets. Baskets are created when "Add to Basket" is clicked and if no basket exists, its created. There is also the option to Delete the basket.
 - An offer is treated as a separate basket line item.

 ## Improvements that can be made

 - Add a users model, associate baskets with users, add devise for auth and cancan for authorization.
 - An Image for the product catalogue.
 - Increase test coverage and add tests for delivery charges, product_catalogue and offers
 - Modify the basket and basket_line_item controllers and transferring majority of the business logic to the models to keep the controllers thin.