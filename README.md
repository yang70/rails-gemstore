# Rails Gem Store - An Exercise Deploying An Angular JS Application Using Rails As A Back-End API

by [Matthew Yang](http://matthewgyang.com)

## Description
This Rails application is an extension on a previous Angular JS exercise/application that can be seen [here](https://github.com/yang70/gem-store).  The objective was to take that application and deploy it to Heroku within a Rails application, using Rails as the back-end framework.

Here is a link to the deployed application: [http://matts-gem-store.herokuapp.com/](http://matts-gem-store.herokuapp.com/)

## Method
**Step One - Basic App Deploy**
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

**Step Two - Fleshing Out an Actual RESTful API**
The next step was to create an actual API that would serve JSON data via the standard CRUD URL's available with a rails resource.

First of all, I decided to organize my Angular code and put the entire app in it's own folder in `app/assets/javascripts` and appropriate subfolders and updated the code to reflect the change in some of the relative paths.

Next, while following along with [Code School: Surviving API's With Rails](https://www.codeschool.com/courses/surviving-apis-with-rails), I updated the `config/routes.rb` file to show as follows:
```ruby
Rails.application.routes.draw do
  root 'gem_store#index'

  constraints subdomain: 'api' do
    namespace :api, path: '/' do
      resources :products
    end
  end
end
```
This does several things.
* It designates `Products` as a resources and adds creates those routes to give us RESTful URL's.
* It routes it to a `api.url.com` subdomain.
* It routes it directly to the products controller, even though it is nested in an api folder (allows `api.url.com/products` rather than `api.url.com/api/products`)

Like I alluded to above, I then moved the `ProductsController` into a subfolder at `app/controllers/api/products_controller.rb` and also wrapped it in a `module` and updated `config/initializers/inflections.rb` with the following line that allows the module name `API` to be in all caps:
```ruby
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'API'
end
```
I then finally moved to the `ProductsController` and began updating/creating the `index`, `show`, `edit`, `update`, `create` and `destroy` actions as well as setting up strong params.  Instead of rendering a view however they are returning a JSON object with `Product` data.  As an example, here is the `update` code:
```ruby
def update
  product = Product.find(params[:id])
  if product.update(product_params)
    render json: product, status: 200
  else
    render json: product.errors, status: :unprocessable_entity
  end
end
```
(*One note, I was not able to set a product using a `before_action` like I have in the past, I suspect it may have something to do with the controller being wrapped in a `Module`*)

Next, I wanted to make sure the associated assets `Images` and `Reviews` were packaged along with `Products` in the JSON data but remove the code from the controller like I showed in the first section.  To do this I added the [Active Model Serializers](https://github.com/rails-api/active_model_serializers) gem and generated a serializer for each resource.  The serializers allow you to limit the data that you are exposing through your API as well as make sure associated resources are included.  It also allows for more control of the JSON that is returned (ie. having a root key) through the use of different adapters.

While updating each action in the `ProductsController`, I was also creating an integration test and updating the `test/fixtures` YAML files.  Here is an example of the test for `ProductsPatchTest`:
```ruby
require "test_helper"

class ProductsPatchTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'successful update' do
    patch "/products/#{products(:ruby).id}",
      { product: { name: "Red Ruby" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 200, response.status
    assert_equal 'Red Ruby', products(:ruby).reload.name
  end

  test 'unsuccessful update' do
    patch "/products/#{products(:ruby).id}",
      { product: { name: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
```
Along with the propper formating of the HTTP request `GET, POST, etc.`, the important thing to note is line 4 - `setup { host! 'api.example.com' }` which makes sure the test is pointing to the correct subdomain.

After getting all tests passing I enabled continuous integration by activating the GitHub repository at [Travis CI](https://travis-ci.org).

After all of that, we have a RESTful API!

## Citation
* [Active Model Serializers](https://github.com/rails-api/active_model_serializers)
* [Code School: Shaping Up With Angular](http://campus.codeschool.com/courses/shaping-up-with-angular-js/intro)
* [Code School: Surviving API's With Rails](https://www.codeschool.com/courses/surviving-apis-with-rails)
* [Angular JS](https://angularjs.org/)
* [Bootstrap](http://getbootstrap.com/)

