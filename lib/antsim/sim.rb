require 'antsim/ant'

class Antsim::Sim
  def ants
    @ants ||= []
  end

  def generate_ants
    ants.push Antsim::Ant.new
  end

  def initialize
    30.times do
      generate_ants
    end
    500.times do
      place_randome_feed
    end
  end

  def step
    ants.each do |ant|
      ant.move(pheromone_map)
    end

    ants.each do |ant|
      set_pheromone_map_at(ant.x, ant.y, pheromone_map_at(ant.x, ant.y) + ant.pheromone)
    end

    ants.each do |ant|
      if feed_map_at(ant.x, ant.y) > 0
        feed_map[xy(ant.x, ant.y)] -= 1
        ant.give_pheromone
      end
    end

    each_map do |x, y|
      set_pheromone_map_at(x, y, pheromone_map_at(x, y) * 0.9)
    end
  end

  def feed_map
    @feed_map ||= {}
  end

  def feed_map_at(x, y)
    feed_map[xy(x, y)] || 0
  end

  def each_feeds(&block)
    feed_map.each do |key, value|
      yield(*key.split(',').map {|v| v.to_i }, value)
    end
  end

  def place_randome_feed
    feed_map[xy(rand(100), rand(100))] = 10
  end

  def pheromone_map
    @pheromone_map ||= {}
  end

  def each_pheromones(&block)
    pheromone_map.each do |key, value|
      yield(*key.split(',').map {|v| v.to_i }, value)
    end
  end

  def xy(x, y)
    "#{x},#{y}"
  end

  def pheromone_map_at(x, y)
    pheromone_map[xy(x, y)] || 0
  end
  def set_pheromone_map_at(x, y, value)
    pheromone_map[xy(x, y)] = value
  end

  def size_x
    100
  end
  def size_y
    100
  end
  def each_map(&block)
    (0..size_x).each do |x|
      (0..size_y).each do |y|
        block.call(x, y)
      end
    end
  end
end
