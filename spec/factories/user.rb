FactoryBot.define do
  factory :user do
    #email { Faker::Internet.email }
    name  {"山田"}
    email { "aaa@example.com" }
    password{"aaaaaaaa"}
    password_confirmation{"aaaaaaaa"}

  end
end
