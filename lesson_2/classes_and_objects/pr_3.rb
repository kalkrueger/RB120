class Person
  attr_accessor :name, :first_name, :last_name


  def initialize(n)
    parse_name(n)
  end

  def name=(n)
    parse_name(n)
  end

  def name
    @name = "#{first_name} #{last_name}".strip
  end

  private

  def parse_name(n)
    @first_name = n.split.first
    @last_name = n.split.size > 1 ? n.split.last : ''
  end

end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name
