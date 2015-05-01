require_relative 'building'
require_relative 'floor'
require_relative 'elevator'
require_relative 'person'

class Simulation
  attr_accessor :my_building, :floor_number, :elevator_number
  def initialize(floor_number, elevator_number)
    @floor_number=floor_number
    @elevator_number=elevator_number
    @my_building=Building.new(floor_number, elevator_number)
  end

  def have_waiting_persons
    for i in 0..@floor_number-1
      if @my_building.floors[i].waiting_persons.length>0
        return true
      end
    end
    return false
  end
  
  def run(n)
    
    #for time 0, after initialize, update the elevators and floors
    for e in 1..@elevator_number
      for t in 1..@my_building.elevators[e-1].ELEV_MAX_PERSONS
        if @my_building.floors[0].waiting_persons.length==0
          break
        end
        tp=@my_building.floors[0].waiting_persons.pop
        @my_building.elevators[e-1].floor_buttons[tp.target_floor] += 1
        #puts "tp.target_floor  #{tp.target_floor}  is  #{@my_building.elevators[e-1].floor_buttons[tp.target_floor]}"
      end
    end
    show(0)
    
    #for time 1 to n-1
    for i in 1..n-1
      for e in 1..@elevator_number
        #puts "e #{e}"
        if @my_building.elevators[e-1].get_person_number==0 && !have_waiting_persons    #in this condition, elevator go to reseting floor
          #puts "reset"
          if @my_building.elevators[e-1].current_floor==0
            @my_building.elevators[e-1].state=0
          else 
            @my_building.elevators[e-1].state=-1
            @my_building.elevators[e-1].current_floor -= 1
          end
        else
          if @my_building.elevators[e-1].state==0
            #puts "state==0"
            @my_building.elevators[e-1].state=1
          elsif @my_building.elevators[e-1].state>0   #up
            #puts "up"
            @my_building.elevators[e-1].current_floor += 1
            cflr=@my_building.elevators[e-1].current_floor
            @my_building.elevators[e-1].floor_buttons[cflr]=0
            capacity=@my_building.elevators[e-1].ELEV_MAX_PERSONS-@my_building.elevators[e-1].get_person_number
            if cflr==@floor_number-1  #at top
              #puts "at top"
              @my_building.elevators[e-1].state=-1
              for t in 1..capacity
                if @my_building.floors[cflr].waiting_persons.length==0
                  break
                end
                tp=@my_building.floors[cflr].waiting_persons.pop
                @my_building.elevators[e-1].floor_buttons[tp.target_floor] += 1
              end
            else   #at mid floor
              #puts "at mid"
              #puts "capacity #{capacity}"
              #puts "cflr #{cflr}"
              t=1
              push_num=0
              while t<=capacity do
                #puts "length #{@my_building.floors[cflr].waiting_persons.length}"
                if @my_building.floors[cflr].waiting_persons.empty? || push_num==capacity
                  break
                end
                tp=@my_building.floors[cflr].waiting_persons.pop
                #puts "tp #{tp.target_floor}"
                #puts "cflr #{cflr}"
                #puts "push_num #{push_num}"
                if tp.target_floor>cflr
                  @my_building.elevators[e-1].floor_buttons[tp.target_floor] += 1
                  t+=1
                else 
                  #puts "tp #{tp.target_floor}"
                  #puts "cflr #{cflr}"
                  #puts "length #{@my_building.floors[cflr].waiting_persons.length}"
                  #puts "push_num #{push_num}"
                  @my_building.floors[cflr].waiting_persons.push(tp)
                  push_num += 1
                end
              end
            end
          else    #down
            @my_building.elevators[e-1].current_floor -= 1
            cflr=@my_building.elevators[e-1].current_floor
            @my_building.elevators[e-1].floor_buttons[cflr]=0
            capacity=@my_building.elevators[e-1].ELEV_MAX_PERSONS-@my_building.elevators[e-1].get_person_number
            if cflr==0  #at 0
              if have_waiting_persons
                @my_building.elevators[e-1].state=1
                for t in 1..capacity
                  if @my_building.floors[cflr].waiting_persons.length==0
                    break
                  end
                  tp=@my_building.floors[cflr].waiting_persons.pop
                  @my_building.elevators[e-1].floor_buttons[tp.target_floor] += 1
                end
              else 
                @my_building.elevators[e-1].state=0
              end
            else    #at mid floor
              t=1
              while t<=capacity do
                push_num=0
                if @my_building.floors[cflr].waiting_persons.length==0 || @my_building.floors[cflr].waiting_persons.length==push_num
                  break
                end
                tp=@my_building.floors[cflr].waiting_persons.pop
                if tp.target_floor<cflr
                  @my_building.elevators[e-1].floor_buttons[tp.target_floor] += 1
                  t+=1
                else 
                  @my_building.floors[cflr].waiting_persons.push(tp)
                  push_num += 1
                end
              end
            end
          end
        end
      end
      show(i)
    end
  end
  
  def show(n)
    puts "#{n} s:"
    print "    "
    for i in 1..@elevator_number
      print "  e#{i}  "
    end
    print "\n"
    
   (@floor_number-1).downto(0) do |i|
      print "f#{i}  "
      for j in 1..@elevator_number
        if @my_building.elevators[j-1].current_floor==i
          print "  #{@my_building.elevators[j-1].get_person_number}   "
        else
          print "      "
        end
      end
      puts "  #{@my_building.floors[i].waiting_persons.length}  "
    end
    
    puts "-----------------------------------------------------"
  end

end



sim=Simulation.new(5, 3)
sim.run(15)