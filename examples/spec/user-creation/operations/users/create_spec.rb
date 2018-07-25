require 'spec_helper'
require './user-creation/operations/users/create.rb'

RSpec.describe Operations::Users::Create do
  subject { described_class.new(user_params: user_params,
                                email_notifier: email_notifier_double,
                                validation_service: validation_service_double) }

  describe ".call" do
    before do
      stub_request(:post, "http://www.example.com/foo/bar").
        with(
          body: "notification",
          headers: {
       	    'Accept'=>'*/*',
       	    'Host'=>'www.example.com',
       	    'User-Agent'=>'Ruby'
          }).
        to_return(status: 201, body: "", headers: {})

      # User validation succeeded by default
      allow(validation_service_double).to receive(:call).and_return(success_validation_result)
    end

    let(:user_params) do
      {
        name: 'John',
        sex: 'male',
        age: 25,
        email: 'user@email.com'
      }
    end
    let(:email_notifier_double) { class_double('Notifiers::EmailNotifier', call: true) }
    let(:success_validation_result) { OpenStruct.new(success: true) }
    let(:fail_validation_result) { OpenStruct.new(success: false, messages: 'Error message') }
    let(:validation_service_double) { class_double('Validations::Users::Create') }

    describe 'user creation' do
      context 'when no validation errors' do
        before do
          allow(validation_service_double).to receive(:call).and_return(success_validation_result)
        end

        it 'creates user' do
          expect { subject.call }.to change { UserRepo.all.count }.by(1)
        end
      end

      context 'when validation errors present' do
        before do
          allow(validation_service_double).to receive(:call).and_return(fail_validation_result)
        end

        it 'returns appropriate error' do
          result = subject.call

          expect(result.errors).to include fail_validation_result.messages
        end
      end
    end

    describe 'email sending' do
      it 'sets email notifier as default notifier' do
        expect(described_class.new(user_params: nil).email_notifier).to be Notifiers::EmailNotifier
      end

      it 'sends email to user\'s email' do
        expect(email_notifier_double).to receive(:call).with(email: user_params[:email], text: 'Welcome, traveller!')

        subject.call
      end
    end

    describe 'notification sending' do
      it 'sends notification to external API about user creation' do
        subject.call

        expect(WebMock).to have_requested(:post, "http://www.example.com/foo/bar").once
      end
    end
  end
end
