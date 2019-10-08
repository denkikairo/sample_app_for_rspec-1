FactoryBot.define do
  factory :task do
    title { "title" }
    content { "content" }
    status { 0 }
    deadline { '2019/10/9 11:11' }
  end
end
