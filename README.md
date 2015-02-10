[![Circle CI](https://circleci.com/gh/cshirley/receipt_bank.svg?style=svg)](https://circleci.com/gh/cshirley/receipt_bank)
[![Coverage Status](https://coveralls.io/repos/cshirley/receipt_bank/badge.svg?branch=master)](https://coveralls.io/r/cshirley/receipt_bank?branch=master)
# ReceiptBank

API wrapper for http://www.receiptbank.com leveraging Faraday.

Support has been added for SSO features.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'receipt_bank', git: 'https://github.com/cshirley/receipt_bank.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install receipt_bank

## Usage

Get Bank Account Details:

```ruby
client = ReceiptBank::Client.new({ oauth_token: "oauth_token",
                                  oauth_secret: "oauth_secret",
                                  base_uri: "https://app.rb-logistics.com" }
)
```
To return my inbox receipts
```ruby
user = client.login(user_details[:email], user_details[:password])

```


## Contributing

1. Fork it ( https://github.com/cshirley/receipt_bank/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
