require 'net/http'

require_relative '../../repositories/user_repo.rb'
require_relative '../../notifiers/email_notifier.rb'
require_relative '../../validations/users/create.rb'

module Operations
  module Users
    class Create
      attr_reader :user_params, :email_notifier, :validation_service
      attr_reader :user, :result

      def self.call(args)
        new(args).call
      end

      def initialize(user_params:, email_notifier: Notifiers::EmailNotifier, validation_service: Validations::Users::Create)
        @user_params = user_params
        @email_notifier = email_notifier
        @validation_service = validation_service
      end

      def call
        validation_result = validation_service.call(user_params)
        return build_result(success: false, errors: validation_result.messages) if !validation_result.success

        create_user
        send_email
        send_notification

        build_result(success: true)
      end

      def create_user
        @user = UserRepo.create(user_params)
      end

      def send_email
        email_notifier.call(email: user[:email], text: 'Welcome, traveller!')
      end

      # leave it here for education purposes
      def send_notification
        uri = URI::HTTP.build({:host => 'www.example.com', :path => '/foo/bar'})
        Net::HTTP.post(uri, 'notification')
      end

      private

      def build_result(success:, errors: nil)
        @result = OpenStruct.new(success: success, user: user, errors: errors || [])
      end
    end
  end
end
