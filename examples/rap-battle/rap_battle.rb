require_relative 'string_with_obscenity_monkeypatch.rb'

class RapBattle
  attr_reader :battle_file_path

  def initialize(battle_file_path)
    @battle_file_path = battle_file_path
  end

  def title
    @title = File.basename(battle_file_path, '.txt').strip
  end

  def content
    @content ||= File.read(battle_file_path)
  end

  def battler_name
    title.split('vs').first.strip
  end

  def has_obscene_words?
    content.split(' ').any?(&:obscene?)
  end
end
