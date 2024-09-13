# Development

## Setup

First things first, you'll need to fork and clone the repository to your local machine.

`git clone https://github.com/ecosyste-ms/timeline.git`

The project uses ruby on rails which have a number of system dependencies you'll need to install. 

- [ruby 3.3.5](https://www.ruby-lang.org/en/documentation/installation/)
- [postgresql 14](https://www.postgresql.org/download/)
- [node.js 16+](https://nodejs.org/en/download/)

Once you've got all of those installed, from the root directory of the project run the following commands:

```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
rails server
```

You can then load up [http://localhost:3000](http://localhost:3000) to access the service.

### Docker

Alternatively you can use the existing docker configuration files to run the app in a container.

Run this command from the root directory of the project to start the service.

`docker-compose up --build`

You can then load up [http://localhost:3000](http://localhost:3000) to access the service.

For access the rails console use the following command:

`docker-compose exec app rails console`

Runing rake tasks in docker follows a similar pattern:

`docker-compose exec app rake events:last_day`

## Importing data

Data is downloaded from [gharchive.org](https://www.gharchive.org/).

For the initial data import you will first need to download the original archives into a folder (this will take a very long time and multiple terabytes of disk space):

`wget https://data.gharchive.org/20{15..22}-{01..12}-{01..31}-{0..23}.json.gz`

Then from the rails console you can import all the archives in one go with the following code:

```ruby
Event.import_from_folder('/path/to/my/gharchive/folder')
```

This will take a very long time (well over 200 hours) and use multiple terabytes of disk space, recommended to run on the most powerful server you have access to.

To download a smaller dataset for testing you can run the following rake task:

`rake events:last_day`

## Tests

The applications tests can be found in [test](test) and use the testing framework [minitest](https://github.com/minitest/minitest).

You can run all the tests with:

`rails test`

## Rake tasks

The applications rake tasks can be found in [lib/tasks](lib/tasks).

You can list all of the available rake tasks with the following command:

`rake -T`

## Deployment

todoA container-based deployment is highly recommended, we use [dokku.com](https://dokku.com/).