#!/usr/local/bin/ruby -w

require 'set'

class Box
  attr_accessor :x, :y, :right, :bottom
  def initialize(x, y, right, bottom)
    @x, @y, @right, @bottom = x, y, right, bottom
  end

  def == o
    x = o.x and y = o.y and right == o.right and bottom == o.bottom
  end
  alias :eql? :==

  def hash
    [x, y, right, bottom].hash
  end

  def inspect
    "Box[x=%d, y=%d, r=%d, b=%d]" % [x, y, right, bottom]
  end
end

class BoxLayout
  VERSION = '1.0.0'

  def self.html(str)
    layout = self.new
    layout.parse(str)
    layout.to_s
  end

  attr_reader :boxes, :grid
  def initialize
    @grid = []
    @boxes = []
  end

  def parse(str)
    @grid = str.strip.split(/\n/)
    @boxes = [] # in case some dork is calling parse multiple times

    grid.size.times do |y|
      grid[y].size.times do |x|
        if %w(- |).include? self[x, y] and
            self[x, y + 1] == '|' and
            self[x + 1, y] == '-' then
          boxes << Box.new(x, y, box_right(x, y), box_bottom(x, y))
        end
      end
    end
    return boxes
  end

  def to_s
    rowspans, colspans = box_rowspans, box_colspans
    table = "<table border=\"border\">\n"
    box_rows.each do |row|
      table += "  <tr>\n"
      row.each do |box|
        r, c = rowspans[box], colspans[box]
        table += "    <td"
        table += " rowspan=\"%d\"" % r if r > 1
        table += " colspan=\"%d\"" % c if c > 1
        table += ">%s</td>\n"
      end
      table += "  </tr>\n"
    end
    table += "</table>"
    table
  end

  def box_x_delimeters
    boxes.map { |box| box.right }.uniq.sort
  end

  def box_y_delimeters
    boxes.map { |box| box.bottom }.uniq.sort
  end

  def box_rowspans
    rowspans = Hash.new(0)
    boxes.each do |box| rowspans[box] = 0 end

    box_y_delimeters.each do |delim|
      boxes.each do |box|
        rowspans[box] += 1 if box.y < delim and box.bottom >= delim
      end
    end

    rowspans
  end

  def box_colspans
    colspans = Hash.new(0)
    boxes.each do |box| colspans[box] = 0 end

    box_x_delimeters.each do |delim|
      boxes.each do |box|
        colspans[box] += 1 if box.x < delim and box.right >= delim
      end
    end

    colspans
  end

  def box_rows
    rows, boxes_left = [], boxes.uniq
    box_y_delimeters.each do |delim|
      boxes_in_row, boxes_left = boxes_left.partition { |box| box.y < delim }
      rows.push(boxes_in_row.sort_by { |box| box.x })
    end
    rows
  end

  # Rendering and parsing tables.

  def [](x, y)
    grid[y][x].chr rescue " "
  end

  def box_right(x, y)
    # todo: find
    (x..grid[y+1].size).each do |right|
      return right if self[right + 1, y + 1] == '|'
    end
    raise "Unterminated box. c=#{self[x, y].inspect}"
  end

  def box_bottom(x, y)
    # todo: find
    (y..grid.size).each do |bottom|
      return bottom if self[x + 1, bottom + 1] == '-'
    end
    raise "Unterminated box. c=#{self[x, y].inspect}"
  end

  def parse_ascii_table(table)
    grid = table.strip.split(/\n/)
    boxes = []

    grid.size.times do |y|
      grid[y].size.times do |x|
        if %w(- |).include? self[x, y] and
            self[x, y + 1] == '|' and
            self[x + 1, y] == '-' then
          boxes << Box.new(x, y, box_right(x, y), box_bottom(x, y))
        end
      end
    end
    return boxes
  end
end
