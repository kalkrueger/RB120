class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
    @size = 12
  end
end

p Pizza.new('pep').instance_variables
p Fruit.new('Apple').instance_variables
