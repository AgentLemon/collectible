[![Code Climate](https://codeclimate.com/github/AgentLemon/collectible/badges/gpa.svg)](https://codeclimate.com/github/AgentLemon/collectible)
[![Test Coverage](https://codeclimate.com/github/AgentLemon/collectible/badges/coverage.svg)](https://codeclimate.com/github/AgentLemon/collectible/coverage)
![Test Status](https://travis-ci.org/AgentLemon/collectible.svg?branch=master)

# Collectible

A gem to build a tree of hashes or objects from regular list like csv file or sql query.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collectible'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collectible

## Usage

You need to define schema and then call proper collector

### Data

Can be any collection like array, csv, ActiveRecord::Base.connection.execute result.

    | user_id | name   | post_id | post_text    | attachment_id | filename |
    =====================================================================
    | 1       | Ivan   | 1       | hello        |               |          |
    | 2       | Simeon | 2       | hi           | 1             | 1.png    |
    | 2       | Simeon | 2       | hi           | 2             | 2.png    |
    | 2       | Simeon | 3       | how are you? |               |          |

### Schema

Define the schema. Parameters: entity name or type, entity primary key field, entity fields specification.

Schema for hash collector:

    schema = Collectible::Schema.new(
      :user,
      :id,
      id: "user_id",
      name: "name",
      posts: Collectible::Schema.new(
        :post,
        :id,
        id: "post_id",
        text: "post_text",
        attachments: Collectible::Schema.new(
          :attachment,
          :id,
          id: "attachment_id",
          filename: "filename"
        )
      )
    )
    
Schema for object collector:

    schema = Collectible::Schema.new(
      User,
      :id,
      id: "user_id",
      name: "name",
      posts: Collectible::Schema.new(
        Post,
        :id,
        id: "post_id",
        text: "post_text",
        attachments: Collectible::Schema.new(
          Attachment,
          :id,
          id: "attachment_id",
          filename: "filename"
        )
      )
    )

### Collector

Just call collect method of proper collector.

    result = Collectible::HashCollector.new(schema).collect(data)  
    
    result = Collectible::ObjectCollector.new(schema).collect(data)
    
### Result    
    
Result from hash collector:

    [
      { id: "1", name: "Ivan", posts: [{ id: "1", text: "hello", attachments: [] }] },
      { id: "2", name: "Simeon", posts: [
        { id: "2", text: "hi", attachments: [
          { id: "1", filename: "1.png" },
          { id: "2", filename: "2.png" }
        ]},
        { id: "3", text: "how are you?", :attachments => [] }]
      }
    ]
    
Result from object collector will be the same, but instead of hashes there will be objects.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/collectible. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

