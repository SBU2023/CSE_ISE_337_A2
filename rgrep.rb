#!/usr/bin/env ruby
# args = ARGF.argv
args = ARGV
opMap = Hash.new
if args.empty?
  puts "Missing required arguments"
  exit 0
elsif args.length == 2
  fileNm = args[0]
  opMap[:p] = true
elsif !args[1,args.length-2].nil?
  fileNm = args[0]
  options = args[1,args.length-2]
  options.each { |o|
    if o == '-w'
      opMap[:w] = true
    elsif o == '-p'
      opMap[:p] = true
    elsif o == '-v'
      opMap[:v] = true
    elsif o == '-c'
      opMap[:c] = true
    elsif o == '-m'
      opMap[:m] = true
    else
      puts "Invalid option"
      exit 0
    end
  }
else
  puts "Missing required arguments"
  exit 0
end

pattern = args[args.length-1]
if opMap[:w] && opMap[:c].nil? && opMap[:p].nil? && opMap[:v].nil? && opMap[:m].nil?
  pattern = '\b' + pattern
  p = Regexp.new(pattern)
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    puts line if !m.nil?
  }
elsif opMap[:w] && opMap[:m] && opMap[:c].nil? && opMap[:p].nil? && opMap[:v].nil?
  pattern = '\b' + pattern
  p = Regexp.new(pattern)
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    puts m[0] if !m.nil?
  }
elsif opMap[:p] && opMap[:c].nil? && opMap[:w].nil? && opMap[:v].nil? && opMap[:m].nil?
  p = Regexp.new(pattern)
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    puts line if !m.nil?
  }
elsif opMap[:p] && opMap[:m] && opMap[:c].nil? && opMap[:w].nil? && opMap[:v].nil?
  p = Regexp.new(pattern)
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    puts m[0] if !m.nil?
  }
elsif opMap[:v] && opMap[:c].nil? && opMap[:p].nil? && opMap[:w].nil? && opMap[:m].nil?
  p = Regexp.new(pattern)
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    puts line if m.nil?
  }
elsif opMap[:w] && opMap[:c] && opMap[:p].nil? && opMap[:v].nil? && opMap[:m].nil?
  pattern = '\b' + pattern
  p = Regexp.new(pattern)
  count = 0
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    count = count + 1 if !m.nil?
  }
  puts count
elsif opMap[:p] && opMap[:c] && opMap[:w].nil? && opMap[:v].nil? && opMap[:m].nil?
  p = Regexp.new(pattern)
  count = 0
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    count = count +1 if !m.nil?
  }
  puts count
elsif opMap[:v] && opMap[:c] && opMap[:p].nil? && opMap[:w].nil? && opMap[:m].nil?
  p = Regexp.new(pattern)
  count = 0
  IO.foreach(fileNm) { |line|
    m = p.match(line)
    count = count + 1 if m.nil?
  }
  puts count
else
  puts "Invalid combination of options"
end
