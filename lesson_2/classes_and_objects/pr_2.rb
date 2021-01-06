class Person
  attr_accessor :first_name, :last_name

  def initialize(fn, ln = '')
    @first_name = fn
    @last_name = ln
  end

  def name
    "#{@first_name} #{@last_name}"
  end

end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
p bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'
