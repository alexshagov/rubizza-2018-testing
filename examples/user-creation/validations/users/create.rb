module Validations
  module Users
    class Create
      attr_reader :user_params
      attr_reader :validation_messages

      def self.call(args)
        new(args).call
      end

      def initialize(user_params)
        @user_params = user_params
        @validation_messages = []
      end

      def call
        validate!

        OpenStruct.new(success: validation_messages.empty?, messages: validation_messages)
      end

      def validations_list
        [
          user_uniqueness_validation
        ]
      end

      private

      def validate!
        validations_list.each(&:call)
      end

      def user_uniqueness_validation
        Proc.new {
          if UserRepo.exists?(email: user_params[:email])
            @validation_messages << 'User already exists'
          end
        }
      end
    end
  end
end
