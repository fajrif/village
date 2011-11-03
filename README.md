# Village

A simple static content pages and blog engine for Rails 3.x

Village are inspired by [high_voltage](https://github.com/thoughtbot/high_voltage) and [postmarkdown](https://github.com/ennova/postmarkdown) gems, for creating static content page and
mini blog engine inside your Rails 3 application. 

So Village are the combination of it, combination of all unnecessary files, nasty that you definitely don't want 
to be stored into the database, rather than just read from the disk and just use `http_caching`, `memcached`
or whatever caching mechanism you wish to use in your production mode.

Village is compatible with Rails 3 only and the gem is hosted on [RubyGems.org](https://rubygems.org/gems/village).

## Features

* Using various template engines such as markdown, textile, erb, etc. (whatever that `tilt` support)
* No database and administering page (update your content using git only)
* RSS Feed / Atom
* Customizable Routes
* HTML5 support
* Rails engine (so you can override views, controllers, etc)
* Easily customized
* Commenting via discuss
* Google analytics
* Support for tags / categories for articles
* Paginated article using `kaminari`
* Gravatar support using `gravtastic`
* `add-this` button support

## Installation

Simply add Village to your Gemfile and bundle it up:

    gem 'village'

Static pages and blog engine are managed under the named `village:pages` and `village:articles` respectively.
To setup both, run the generator to setup Village for your application:

    $ rails generate village:setup

The above command will setup all necessary files and folders, routes, views directory required by `village:pages` and `village:articles`,
you can pass `--skip` optional parameter if want to skip some of the functionality.
(e.g you don't want to install `village:pages` then pass `--skip-pages`)

By default Village are using `tilt` to render every contents, so it is required you to install some of the template
engine you wish to use with Village, for example `redcarpet` for markdown then add `gem 'redcarpet'` in your `Gemfile`
or `RedCloth` for textile, etc.

all the configuration settings are managed in YAML file `config/village_config.yml`, you can customize it later depending your needs.

## Village:Pages

Your static content pages are lived under `app/views/pages` directory, you can have many nested folder with pages in here!

you can access your static pages using route helper method `village_page_path`, for example:

    <%= link_to "My Page", village_page_path('to/my/page') %>

if you setup `village:pages` properly, you will have some example page `app/views/pages/example-page.markdown`
to tested it, open `http://localhost:3000/example-page` in your browser and you should be able to navigate to your static page. 

## Village:Articles

This is a mini blog engine for your Rails app, all the articles are managed under `app/articles` directory 
and the views files after you run the setup are copied into `app/views/articles` directory.

### Generate a new Article

Here's an example of how to generate a new article using a slug and publish date:

    $ rails generate village:articles test-post.md --date=2011-01-01

The above command will create the file `app/articles/2011-01-01-test-post.md`, which you can edit and add content to.

### View the Articles

Open `http://localhost:3000/articles` in your browser and you should be able to navigate to your index articles page. 
The URL for your new article is `http://localhost:3000/articles/2011/01/01/test-post`.

### Article metadata

Metadata are stored inside the generated article using YAML front-matter `---`

	---
	title: My First Article
	author:
	  name: Fajri Fachriansyah
	  uri: https://github.com/fajrif
	  email: fajri82@gmail.com
	summary: This is another article with custom metadata & summary.
	tags: ["Ruby","Rails"]
	---

Village are implementing `method_missing`, so you are able to add any others metadata attributes 
inside this kind of block and use it inside your views. For example :

	---
	title: My First Article
	summary: This is another article with custom metadata & summary.
	sub_summary: this is the sub-summary i want to use in my views.
	---

notice that `sub_summary` are not required by `village:articles`, but you still able to add it
and use it inside your views like this line:

	article.sub_summary if article.sub_summary?

### RSS Feed

Village:Articles comes prepared with a fully functional RSS feed / Atom.

You can take advantage of the built-in feed by adding the feed link to your HTML head tag. For example, simply add the following to your default layout:

    <head>
      <!-- include your stylesheets and javascript here... -->
      <%= yield :head %>
    </head>

To link to the feed in your app, simply use the route helper: `<%= link_to 'RSS Feed', village_articles_path(:rss) %>`
or if you like to use Atom: `village_articles_path(:atom)`

## Customizing Routes

By default Village will setup all article routes to go through the `/articles/*` path 
while static pages go through root path (/)

For example:

    http://localhost:3000/articles                      # lists all articles
    http://localhost:3000/articles/2011                 # lists all articles from 2011
    http://localhost:3000/articles/2011/01              # lists all articles from January 2011
    http://localhost:3000/articles/2011/01/01           # lists all articles from the 1st of January 2011
    http://localhost:3000/articles/tags/ruby            # lists all articles tagged with ruby
    http://localhost:3000/articles/2011/01/01/test-post # show the specified article
    http://localhost:3000/home                          # show the specified static page

You can change the default route path by modifying the 'village' line in `routes.rb`. For example:

    village :articles, :as => :blog
    village :pages, :as => :content

This will produce the following routes:

    http://localhost:3000/blog                      # lists all articles
    http://localhost:3000/blog/2011                 # lists all articles from 2011
    http://localhost:3000/blog/2011/01              # lists all articles from January 2011
    http://localhost:3000/blog/2011/01/01           # lists all articles from the 1st of January 2011
    http://localhost:3000/blog/tags/ruby            # lists all articles tagged with ruby
    http://localhost:3000/blog/2011/01/01/test-post # show the specified article
    http://localhost:3000/content/home              # show the specified static page

You can also customize the `articles#show` route for `village:articles` via the `:permalink_format` option:

    village :articles, :as => :blog, :permalink_format => :day   # URL: http://localhost:3000/blog/2011/01/01/test-post
    village :articles, :as => :blog, :permalink_format => :month # URL: http://localhost:3000/blog/2011/01/test-post
    village :articles, :as => :blog, :permalink_format => :year  # URL: http://localhost:3000/blog/2011/test-post
    village :articles, :as => :blog, :permalink_format => :slug  # URL: http://localhost:3000/blog/test-post

What about mapping Village:Articles to root? We got you covered:

    village :articles
    root :to => 'articles#index'

## Default Directory Structure

    ├── app
    │   ├── controllers
    │   ├── helpers
    │   ├── mailers
    │   ├── models
    │   ├── articles (where your article files live)
    │   │   ├── 2011-04-01-example-1.markdown
    │   │   ├── ...
    │   │   ├── 2011-04-04-example-4.markdown
    │   └── views
    │       └── articles (customizable)
    │           ├── _article.html.haml
    │           ├── _sidebar.html.haml
    │           ├── ...
    │           └── show.html.haml
    │       └── pages (where your static page files live)
    │           ├── home.haml
    │           ├── FAQ_FOLDERS
    │               └── how-to.markdown
    │           ├── ...
    │           └── user_guides.rdoc

## Supported Template Engine

According from [tilt](https://github.com/rtomayko/tilt) Village will support for these template engines:

    ENGINE                     FILE EXTENSIONS         REQUIRED LIBRARIES
    -------------------------- ----------------------- ----------------------------
    ERB                        .erb, .rhtml            none (included ruby stdlib)
    Erubis                     .erb, .rhtml, .erubis   erubis
    Haml                       .haml                   haml
    Builder                    .builder                builder
    Liquid                     .liquid                 liquid
    RDiscount                  .markdown, .mkd, .md    rdiscount
    Redcarpet                  .markdown, .mkd, .md    redcarpet
    BlueCloth                  .markdown, .mkd, .md    bluecloth
    Kramdown                   .markdown, .mkd, .md    kramdown
    Maruku                     .markdown, .mkd, .md    maruku
    RedCloth                   .textile                redcloth
    RDoc                       .rdoc                   rdoc
    Radius                     .radius                 radius
    Markaby                    .mab                    markaby
    Creole (Wiki markup)       .wiki, .creole          creole
    WikiCloth (Wiki markup)    .wiki, .mediawiki, .mw  wikicloth
    Yajl                       .yajl                   yajl-ruby


this handlers are configurable inside generated `config/initializers/init_village.rb` file after you run the `village:setup`,
you are able to edit this file, if you wish not to use all these handlers!

## FOUND A BUG

don't hesitate to post your issues in [here](https://github.com/fajrif/village/issues)

## LICENSE

Village is Copyright (c) 2011 [Fajri Fachriansyah](https://github.com/fajrif) and
distributed under the MIT license.
