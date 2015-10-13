# Rails Gem Store - An Exercise Deploying An Angular JS Application Using Rails

by [Matthew Yang](http://matthewgyang.com)

## Description
This Rails application is an extension on a previous Angular JS exercise/application that can be seen [here](https://github.com/yang70/gem-store).  The objective was to take that application and deploy it to Heroku within a Rails application, using Rails as the back-end framework.

Here is a link to the deployed application: [http://matts-gem-store.herokuapp.com/](http://matts-gem-store.herokuapp.com/)

## Method
I first created a new Rails application, skipping the built in testing framework (will add my own).  Also to save some configuration headaches before deployment, I set the database to Postgres for all environments (development, test and production).

Next I generated a simple controller, `gem_store_controller`, with one action, `index`, and set that to the root route in `config/routes.rb`.

To add the Angular application code, I added my generated JavaScript files to `app/assets/javascripts` and created an `app/assets/templates` folder where I added the HTML files.  I then added the Bootstrap css and Angular javascript code to their appropriate folders in `vendor/assets`.  I then updated the manifest's at `app/assets/javascripts/application.js` and `app/assets/stylesheets/application.css` to require the newly added files.

I decided, for now at least, to put the code from `index.html` from the Angular app directly into `app/views/layouts/application.html.erb` and have left `app/views/gem_store/index.html.erb` blank, since there are no other pages or views planned at the moment.  I will update that as needed.

With the HTML and JS being served successfully, I decided to get the app to load product data via an AJAX request back to a `Products` controller.  I generated the controller and also three models based on the data:  `Products`, `Reviews` and `Images`.  I set both `Reviews` and `Images` as `belongs_to :product` and set product to `has_many :reviews` and `has_many :images`.  To keep it simple at the moment, these have not been designated as resources yet in rails, so RESTful CRUD actions are not functioning yet.

Finally, I updated the `db/seeds.rb` file to create 3 products with one picture each and 2 reviews each and had the `index` action at `app/controllers/products_controller.rb` render a JSON object with the following code:

```ruby
class ProductsController < ApplicationController
  def index
    @products = Product.all
    render :json => @products.to_json(:include => [:images, :reviews])
  end
end
```
I then updated `config/routes.rb` to send GET requests for `/products` to the index action: `get '/products' => 'products#index'`

After all that, it works!

## Citation
[Code School: Shaping Up With Angular](http://campus.codeschool.com/courses/shaping-up-with-angular-js/intro)
[Angular JS](https://angularjs.org/)
[Bootstrap](http://getbootstrap.com/)
