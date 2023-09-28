# Banking Service

The application is a Ruby app that runs a simple banking service. The system can load account balances and accept a day's transfers in a CSV file.

## Setup

### 1. Make sure you have Ruby 2.7.6 installed

### 2. Install dependencies:

```bash
gem install bundler
bundle install
```

### 3. Run the app:

```bash
ruby app/main.rb
```

### 4. Run the tests:

```bash
bundle exec rspec
```

## Get started

It's a simple Ruby console application that supports 3 commands: `loadaccounts`, `transfer` and `getbalance`.

Example commands for loading test files and displaying account balance:

```bash
loadaccounts acc_balance.csv

transfer trans.csv

getbalance 1111234522226789
```

## Considerations

* The app consists of three layers: `application`, `domain` and `infrastructure`. Application layer contains the business logic, domain layer contains two main domain entities: `BankAccount` and `Transaction`, and infrastructure layer is responsible for writing and retrieving data from the datastore.
* The app is a simple Ruby app without a physical database. By implementing Repository Pattern, the current memory datastore and be easily replaced with a database, or even APIs to a third party. It decouples the domain logic and the datastore.
* Command Pattern is implemented for reading and executing commands. It can be easily extended by adding new commands when adding new features.
* Further consideration regarding the `transfer_funds` method, if we implemented the app using `ActiveRecord`, it should be wrapped in a `ActiveRecord::Base.transaction` block to ensure data integrity. If any error happens we need to rollback the entire operation to the previous state.
