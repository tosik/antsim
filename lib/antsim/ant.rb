class Antsim::Ant
  attr_accessor :x, :y, :direction
  attr_accessor :pheromone

  def initialize
    @x = 5
    @y = 5
    @direction = 0
    @pheromone = 0
  end

  def move(pheromone_map)
    tb = movement_table.shuffle.reject {|movement|
      @direction == movement[3]
    }.map {|mov|
      {
        x: mov[0], y: mov[1], direction: mov[2],
        pheromone: pheromone_map["#{@x + mov[0]},#{y + mov[1]}"] || 0,
      }
    }.sort {|a, b| b[:pheromone] <=> a[:pheromone]}

    rank = [0, 0, 0, 0, 0, 0, 0, 1].sample
    movement = tb[rank]
    @x += movement[:x]
    @y += movement[:y]
    @direction = movement[:direction]
  end

  def pick_random_movement
    movement_table.sample
  end

  def movement_table
    [
      [-1, 0, 3, 1],
      [+1, 0, 1, 3],
      [0, -1, 0, 2],
      [0, +1, 2, 0]
    ]
  end

  def give_pheromone
    @pheromone = 10
  end

  def remove_pheromone
    @pheromone = 0
  end

  def rot
    @direction * 90
  end
end