class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

cricket = AngryCat.new(3, 'Cricket')
cloe = AngryCat.new(14, "Chloe")
