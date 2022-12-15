# Secrets loader script

This is a basic script to take secrets from a csv file, and load them into kubernetes.

## Prerequisites

You have the kubernetes CLI installed and configured to your cluster and namespace.

## Setup

`bundle install`

## CSV File preparation

The csv file should be in the following format
```
secret-name1,username1,password1
secret-name2,username2,password2
```

## Tests

`bundle exec rspec`

## Usage

`ruby ./lib/load_secret.rb <path to csv>`

eg

`ruby ./lib/load_secret.rb ./spec/system/test.csv`
