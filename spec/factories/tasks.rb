FactoryBot.define do
  factory :task do
    user_id { "C0XXXX" }
    task_name { "test" }
    completed { false }
    due_date { "2018-12-26 11:24:57" }
  end
end
