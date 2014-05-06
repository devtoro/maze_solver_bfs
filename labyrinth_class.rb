class Labyrinth
  attr_accessor :maze
  attr_reader :x_start, :x_goal, :y_start, :y_goal

  BLOCK = "#"
  PASS = " "
  EDGE = "*"
  START = "S"
  GOAL = "G"

  # Constructor
  def initialize(width=15, height=15)
    @x = width
    @y = height
    @maze = {:matrix => [], :graphic_matrix => [], :start => {:x => nil, :y => nil}, :goal => {:x => nil, :y => nil}}
    @maze = self.build
  end

  # Function to build the maze
  def build
    @y.times do |y|
      top_bottom = ((y == 0) || (y == @y-1))
      row = []
      graphic_row = []

      @x.times do |x|
        edge = ((top_bottom) || (x == 0) || (x == @x-1))
        weight = edge ? 0 : (rand(100) + 1)
        pix = case 
        when weight == 0
          EDGE
        when weight >= 75
          BLOCK
        when weight < 75
          PASS
        end
        row << weight
        graphic_row << pix
      end

      @maze[:matrix] << row
      @maze[:graphic_matrix] << graphic_row
    end
    set_start(sample_x, sample_y)
    set_goal(sample_x, sample_y)
    @maze
  end

  def to_screen
    maze_string = ""
    @maze[:graphic_matrix].each do |row|
      row.each_with_index do |square,index|
        pix = ((index+1) % @x != 0) ? square : square + "\n"
        maze_string << pix
      end
    end
    print maze_string
  end

  private

  def set_start(width, height)
    x = width
    y = height
    sample_is_bad = @maze[:matrix][y][x] == START || @maze[:matrix][y][x] == GOAL || @maze[:matrix][y][x].to_i >= 75
    if sample_is_bad
      set_start(sample_x, sample_y)
    else
      @maze[:start][:x] = x
      @maze[:start][:y] = y
      @maze[:matrix][y][x] = START
      @maze[:graphic_matrix][y][x] = START
      puts "***Start point initialized.***\n"
    end
  end

  def set_goal(width, height)
    x = width
    y = height
    sample_is_bad = @maze[:matrix][y][x] == GOAL || @maze[:matrix][y][x] == START || @maze[:matrix][y][x].to_i >= 75
    if sample_is_bad
      set_goal(sample_x, sample_y)
    else
      @maze[:goal][:x] = x
      @maze[:goal][:y] = y
      @maze[:matrix][y][x] = GOAL
      @maze[:graphic_matrix][y][x] = GOAL
      puts "***Goal point initialized.***\n"
    end
  end

  def sample_x
    x = rand(@x-1)
  end

  def sample_y
    y = rand(@y-1)
  end
end