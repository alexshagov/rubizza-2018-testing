class UserRepo
  class << self
    def all
      Thread.current[:users] || []
    end

    def create(name:, sex:, age:)
      Thread.current[:users] ||= []
      Thread.current[:users] << { name: name, sex: sex, age: age }
    end

    def exists?(name:)
      all.any? { |user| user[:name] == name }
    end
  end
end
