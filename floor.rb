require_relative 'person'

class Floor
  attr_accessor :floor_number, :waiting_persons, :up_button, :up_button
  def initialize(number, sum_floor_number)
    person_num=rand(1..5)
    @floor_number=number
    @waiting_persons=Queue.new
    @up_button=0
    @down_button=0
    for i in 1..person_num
      temp=Person.new(number, sum_floor_number)
      @waiting_persons.push(temp)
      if temp.target_floor>number
        @up_button=1
      else
        @down_button=1
      end
    end
  end
  def to_s
    puts "the floor is NO.#{@floor_number} floor, has #{@waiting_persons.length} waiting persons, up button is #{@up_button}, down button is #{@down_button}."
  end
end