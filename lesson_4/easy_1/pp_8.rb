
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

#self inside of the method is reffering to the Cat object that `make_one_year_older` is being called on
