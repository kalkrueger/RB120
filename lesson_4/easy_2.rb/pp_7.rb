
class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end


#@@cats_count is a class variable that is reassigned to its current integer + 1 every time a new Cat object is initialized

cricket = Cat.new("orange")
p Cat.cats_count
