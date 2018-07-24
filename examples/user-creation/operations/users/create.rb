require_relative '../../repositories/user_repo.rb'

module Operations
  module Users
    class Create
      def self.call(args)
        new.call(*args)
      end

      def call(user_params:)
        UserRepo.create(user_params)
      end
    end
  end
end
