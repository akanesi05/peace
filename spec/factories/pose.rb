FactoryBot.define do
  factory :pose do
    name {"干され"}
    #image{ fixture_file_upload('spec/fixures/images/test.jpeg') }
    user
  end
end
