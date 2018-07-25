require_relative '../../repositories/user_repo.rb'
require_relative '../../notifiers/email_notifier.rb'

module Operations
  module Users
    class Create
      attr_reader :user_params, :email_notifier
      attr_reader :user, :result

      def self.call(args)
        new(args).call
      end

      def initialize(user_params:, email_notifier: Notifiers::EmailNotifier)
        @user_params = user_params
        @email_notifier = email_notifier
      end

      def call
        create_user!
        send_email
      end

      def create_user!
        @user = UserRepo.create(user_params)
      end

      def send_email
        email_notifier.call(email: user[:email], text: 'Welcome, traveller!')
      end
    end
  end
end
