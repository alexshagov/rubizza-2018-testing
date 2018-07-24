module RapBattleHelper
  def rap_battle_file_path(title:, obscenity: nil)
    with_obscenity_postfix = obscenity ? 'with_obscenity' : nil
    Pathname.new("spec/fixtures/#{title} #{with_obscenity_postfix}.txt")
  end
end
