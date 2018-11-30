FactoryBot.define do
  factory :user do
    nickname 'Bob'
    sequence(:email) { |n| "bob+#{n}@bob.bob"}
    avatar_url 'https://s.gravatar.com/avatar/f95c0f59cb9cef293c54bffd193a2652'
    token_details { Hash['nickname'=>'Bob',
      'picture'=> 'https://s.gravatar.com/avatar/f95c0f59cb9cef293c54bffd193a2652',
      'email'=> email
    ] }
  end
end
