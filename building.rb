require_relative 'floor'
require_relative 'elevator'

class Building
  attr_accessor :floors, :elevators
  def initialize(floor_number, elevator_number)
    @floors=Array.new(floor_number)
    @elevators=Array.new(elevator_number)
    for i in 0..floor_number-1 
      floors[i]=Floor.new(i, floor_number)
    end
    for i in 0..elevator_number-1
      elevators[i]=Elevator.new(floor_number)
    end
  end
  def to_s
    puts "the building has #{@floors.length} floors, and #{@elevators.length} elevators."
  end
end