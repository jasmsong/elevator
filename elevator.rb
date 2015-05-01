class Elevator
  attr_accessor :ELEV_MAX_PERSONS, :ELEV_RESTING_FLOOR, :current_floor, :floor_buttons, :state
  def initialize(floor_number)
    @ELEV_MAX_PERSONS=3
    @ELEV_RESTING_FLOOR=0
    @current_floor=0
    @state=1    #0:stationary; 1:up; -1:down
    @floor_buttons=Array.new(floor_number)
    for i in 0..floor_number-1 
      @floor_buttons[i]=0
    end
  end
  
  def get_person_number
    sum=0
    for i in 0..@floor_buttons.length-1 
      sum += @floor_buttons[i]
    end
    return sum
  end
  
  def to_s
    puts "the state of elevator is #{@state}, and the current floor is #{@current_floor}"
  end
end