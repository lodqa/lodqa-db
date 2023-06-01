# lodqa-db

## For deployment 

```shell
EDITOR="vi" bin/rails credentials:edit
RAILS_ENV=production bin/rails assets:precompile
```

## For development

To run an applicatio to development: 

```shell
bundle
bin/rails db:create db:migrate db:seed
bin/rails s
```

To run tests:

```shell
bin/rails test
```

To run the linter:

```shell
bundle exec rubocop
```
