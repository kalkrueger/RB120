class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

#case 1
hello = Hello.new
hello.hi
#this will output "Hello" and return nil

#case 2
hello = Hello.new
hello.bye
#this will return a NoMethod error

#case 3
hello = Hello.new
hello.greet
# This will return an Argument error because there is no argument passed in

#case 4
hello = Hello.new
hello.greet("Goodbye")
#this will output "Goodbye" and return nil since is is by passing the `hi` method

#case 5
Hello.hi
#this wiill return a NoMethodError because there is no class method `hi` for the Hello class
