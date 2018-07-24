require 'spec_helper'
require './rap-battle/rap_battle.rb'

include RapBattleHelper

RSpec.describe RapBattle do
  subject { described_class.new(battle_file_path) }

  let(:battler_name) { 'Окси' }
  let(:battle_title) { battler_name + ' vs ' + 'ATL' }
  let(:battle_file_path) { rap_battle_file_path(title: battle_title, obscenity: false) }

  describe '#rapper_name' do
    it 'returns rapper name' do
      expect(subject.battler_name).to eq battler_name
    end
  end

  describe '#title' do
    it 'returns battle title' do
      expect(subject.title).to eq battle_title
    end
  end

  describe '#content' do
    it 'returns battle content' do
      expect(subject.content).to eq File.read(subject.battle_file_path)
    end
  end

  describe '#has_obscene_words?' do
    context 'when battle is obscene' do
      let(:battle_file_path) { rap_battle_file_path(title: battle_title, obscenity: true) }

      it { expect(subject.has_obscene_words?).to eq true }
    end

    context 'when battle is not obscene' do
      let(:battle_file_path) { rap_battle_file_path(title: battle_title, obscenity: false) }

      it { expect(subject.has_obscene_words?).to eq false }
    end
  end
end
