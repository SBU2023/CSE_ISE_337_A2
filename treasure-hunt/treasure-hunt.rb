require "json"
class Cave
  def self.dodecahedron
    from_json("#{File.dirname(__FILE__)}/dodecahedron.json")
  end

  def self.from_json(filename)
    new(JSON.parse(File.read(filename)))
  end

  def initialize(edges)
    # FIXME: Can probably be changed to use an arbitrary number of rooms.
    # The only reason it's not set up that way now is for simplicity
    @rooms = (1..20).map.with_object({}) { |i, h| h[i] = Room.new(i) }

    edges.each { |a,b| @rooms[a].connect(@rooms[b]) }
  end

  def add_hazard(thing, count)
    count.times do
      room = random_room

      redo if room.has?(thing)

      room.add(thing)
    end
  end

  def random_room
    @rooms.values.sample
  end

  # def move(thing, from: raise, to: raise)
  #   from.remove(thing)
  #   to.add(thing)
  # end

  def move(thing, from, to)
    from.remove(thing)
    to.add(thing)
  end

  def room_with(thing)
    @rooms.values.find { |e| e.has?(thing) }
  end

  def entrance
    @entrance ||= @rooms.values.find(&:safe?)
  end

  def room(number)
    @rooms[number]
  end
end

class Player
  def initialize
    @senses     = {}
    @encounters = {}
    @actions    = {}
  end

  attr_reader :room

  def sense(thing, &callback)
    @senses[thing] = callback
  end

  def encounter(thing, &callback)
    @encounters[thing] = callback
  end

  def action(thing, &callback)
    @actions[thing] = callback
  end

  def enter(room)
    @room = room

    @encounters.each do |thing, action|
      return(action.call) if room.has?(thing)
    end
  end

  def explore_room
    @senses.each do |thing, action|
      action.call if @room.neighbors.any? { |e| e.has?(thing) }
    end
  end

  def act(action, destination)
    @actions[action].call(destination)
  end
end

class Room
  def initialize(number)
    @number    = number
    @neighbors = []
    @hazards   = []
  end

  attr_reader :number, :neighbors

  def add(thing)
    @hazards << thing
  end

  def remove(thing)
    @hazards.delete(thing)
  end

  def has?(thing)
    @hazards.include?(thing)
  end

  def empty?
    @hazards.empty?
  end

  def safe?
    empty? && neighbors.all? { |e| e.empty? }
  end

  def connect(other_room)
    neighbors << other_room

    other_room.neighbors << self
  end

  def exits
    neighbors.map { |e| e.number }
  end

  def neighbor(number)
    neighbors.find { |e| e.number == number }
  end

  def random_neighbor
    neighbors.sample
  end
end

class Console
  def initialize(player, narrator)
    @player   = player
    @narrator = narrator
  end

  def show_room_description
    @narrator.say "-----------------------------------------"
    @narrator.say "You are in room #{@player.room.number}."

    @player.explore_room

    @narrator.say "Exits go to: #{@player.room.exits.join(', ')}"
  end

  def ask_player_to_act
    actions = {"m" => :move, "s" => :shoot, "i" => :inspect }

    accepting_player_input do |command, room_number|
      @player.act(actions[command], @player.room.neighbor(room_number))
    end
  end

  private

  def accepting_player_input
    @narrator.say "-----------------------------------------"
    command = @narrator.ask("What do you want to do? (m)ove or (s)hoot?")

    unless ["m","s"].include?(command)
      @narrator.say "INVALID ACTION! TRY AGAIN!"
      return
    end

    dest = @narrator.ask("Where?").to_i

    unless @player.room.exits.include?(dest)
      @narrator.say "THERE IS NO PATH TO THAT ROOM! TRY AGAIN!"
      return
    end

    yield(command, dest)
  end
end

class Narrator
  def say(message)
    $stdout.puts message
  end

  def ask(question)
    print "#{question} "
    $stdin.gets.chomp
  end

  def tell_story
    yield until finished?

    say "-----------------------------------------"
    describe_ending
  end

  def finish_story(message)
    @ending_message = message
  end

  def finished?
    !!@ending_message
  end

  def describe_ending
    say @ending_message
  end
end
