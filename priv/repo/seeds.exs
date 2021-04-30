# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Homework.Repo
alias Homework.Merchants.Merchant
alias Homework.Transactions.Transaction
alias Homework.Users.User

# Merchants
amazon = Repo.insert!(%Merchant{
  name: "Amazon",
  description: "The largest and most blood-thirsty corporation on Earth"
})
paypal = Repo.insert!(%Merchant{
  name: "PayPal",
  description: "Elon Musk's first attempt at taking people's money"
})
divvy = Repo.insert!(%Merchant{
  name: "Divvy",
  description: "The most modern and tech-savvy payment processor platform on Earth"
})

# Users
noah = Repo.insert!(%User{
  first_name: "Noah",
  last_name: "Betzen",
  dob: "redacted"
})
john = Repo.insert!(%User{
  first_name: "John",
  last_name: "Smith",
  dob: "01-01-1990"
})
bezos = Repo.insert!(%User{
  first_name: "Jeff",
  last_name: "Bezos",
  dob: "01-12-1964"
})

# Transactions
Repo.insert!(%Transaction{
  description: "Jeff's new boat",
  amount: 1_000_000,
  credit: false,
  debit: true,
  merchant_id: amazon.id,
  user_id: bezos.id
})

Repo.insert!(%Transaction{
  description: "Noah's paycheck",
  amount: 10_000,
  credit: true,
  debit: false,
  merchant_id: divvy.id,
  user_id: noah.id
})
