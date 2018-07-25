module Notifiers
  class EmailNotifier
    attr_reader :email, :text

    def self.call(args)
      new(args).call
    end

    def initialize(email:, text:)
      @email = email
      @text = text
    end

    def call
      puts "Email #{text} sent to #{email}!"
    end
  end
end
