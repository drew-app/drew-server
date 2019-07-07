module Types
  class QueryType < BaseObject
    field :ping, String,
      null: true,
      description: "Ping to verify GraphQL works",
      resolve: lambda{ |_, _, _| Time.now.to_s }

    field :tasks, [TaskType], null: true
    def tasks
      context[:current_user].tasks
    end
  end
end
