require 'spec_helper'
require './user-creation/operations/users/create.rb'

RSpec.describe Operations::Users::Create do
  describe ".call" do
    let(:user_params) do
      {
        name: 'John',
        sex: 'male',
        age: 25
      }
    end

    it 'creates user' do
      expect { subject.call(user_params: user_params) }.to change { UserRepo.all.count }.by(1)
    end

    it 'sends email to user\'s email' do

    end

    it 'sends notification to external API about user creation' do

    end

    context 'when user already exists' do
      it 'returns appropriate error' do

      end
    end
  end
end
