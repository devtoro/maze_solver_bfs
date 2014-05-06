$LOAD_PATH << '.'

require "labyrinth_class"
require "discovered_class"

include Discoverable

class Adventurer
  attr_accessor :maze, :labyrinth
  attr_reader :starting_point

  def initialize(maze_width=15, maze_height=15)
    @labyrinth = Labyrinth.new(maze_width, maze_height)
    @maze = @labyrinth.maze[:matrix]
    @starting_point = {:x => @labyrinth.maze[:start][:x], :y => @labyrinth.maze[:start][:y]}
  end

  def to_screen
    @labyrinth.to_screen
  end

  # main  solving algorith -- ID (Iterative Deepening)
  def solve
    matrix = @maze
    finished = false

    start = Discovered.new(@starting_point[:x],@starting_point[:y],nil)
    frontier = []
    visited = []
    frontier << start

    while !frontier.empty? && !finished
      
      current_node = frontier.shift # take first item from queue
      if visited.include? [current_node.x,current_node.y]
        next
      else
        visited << [current_node.x,current_node.y]
        x = current_node.x
        y = current_node.y
        if (matrix[y][x] == 'G')
          finished = true
        else
          frontier << look_for_valid_moves(x,y,matrix,current_node,visited)
          frontier.flatten!
        end
      end
    end

    if finished
      @labyrinth.maze[:graphic_matrix][current_node.y][current_node.x] = 'X'
      while !current_node.parent.nil?
        current_node = current_node.parent
        @labyrinth.maze[:graphic_matrix][current_node.y][current_node.x] = @labyrinth.maze[:graphic_matrix][current_node.y][current_node.x] == 'S' ? 'S' : '.'
      end
      puts "Maze solved:\n"
      @labyrinth.to_screen
    else
      print "Goal was not found... :("
    end
  end

  private 

  def look_for_valid_moves(x,y,matrix,current_node=nil,visited=[])
    possible_moves = []
    possible_moves << Discovered.new(x+1,y,current_node) if (is_path?(x+1,y,matrix) && !(visited.include? Discovered.new(x+1,y,current_node)))
    possible_moves << Discovered.new(x-1,y,current_node) if (is_path?(x-1,y,matrix) && !(visited.include? Discovered.new(x-1,y,current_node)))
    possible_moves << Discovered.new(x,y+1,current_node) if (is_path?(x,y+1,matrix) && !(visited.include? Discovered.new(x,y+1,current_node)))
    possible_moves << Discovered.new(x,y-1,current_node) if (is_path?(x,y-1,matrix) && !(visited.include? Discovered.new(x,y-1,current_node)))
    possible_moves
  end

  def is_path?(x,y,matrix)
    path = (matrix[y][x] == 'G' || matrix[y][x] != 'S' || matrix[y][x] < 75 || x > 0 || x < matrix[0].size || y >0 || y < matrix.size) rescue false
    result = path ? true : false
  end

end