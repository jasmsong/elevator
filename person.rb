class Person
  attr_accessor :target_floor
  def initialize(number, sum)
    temp=rand(0...sum)
    while true
      if temp != number 
        break
      end
      temp=rand(0...sum)
    end
    @target_floor=temp
  end
  def to_s
    puts "the person is going to #{@target_floor} floor."
  end
end