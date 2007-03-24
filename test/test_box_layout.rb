#!/usr/local/bin/ruby -w

require 'test/unit'
require 'box_layout'

class TestBoxLayout < Test::Unit::TestCase
  def setup
    @grid = "
---------
|   |   |
---------
|       |
---------
".strip.split(/\n/)

    @layout = BoxLayout.new
    @layout.parse(@grid.join("\n"))

    @boxes = []
    @boxes << Box.new(0, 0, 3, 1)
    @boxes << Box.new(4, 0, 7, 1)
    @boxes << Box.new(0, 2, 7, 3)

    @expected_html = "
<table border=\"border\">
  <tr>
    <td>%s</td>
    <td>%s</td>
  </tr>
  <tr>
    <td colspan=\"2\">%s</td>
  </tr>
</table>
".strip


  end

  def test_class_html
    html = BoxLayout.html(@grid.join("\n"))
    assert_equal @expected_html, html
  end

  def test_class_html_big
    table = "
---------------------------
|         |       |       |
|         |       |       |
|         |       |       |
|         |-------|       |
|         |       |       |
|         |       |-------|
|         |       |       |
|         |       |       |
|---------|       |-------|
|    |    |       |       |
|    |    |-------|       |
|    |    |       |       |
|    |    |       |       |
|    |    |       |       |
---------------------------
"
    expected = "<table border=\"border\">
  <tr>
    <td rowspan=\"3\" colspan=\"2\">%s</td>
    <td>%s</td>
    <td rowspan=\"2\">%s</td>
  </tr>
  <tr>
    <td rowspan=\"3\">%s</td>
  </tr>
  <tr>
    <td>%s</td>
  </tr>
  <tr>
    <td rowspan=\"2\">%s</td>
    <td rowspan=\"2\">%s</td>
    <td rowspan=\"2\">%s</td>
  </tr>
  <tr>
    <td>%s</td>
  </tr>
</table>"

     html = BoxLayout.html(table)
     assert_equal expected, html
  end

  def test_to_s
    assert_equal @expected_html, @layout.to_s
  end

  def test_char
    assert_equal '-', @layout[0, 0]
    assert_equal '|', @layout[0, 1]
    assert_equal '-', @layout[0, 2]
    assert_equal '-', @layout[1, 0]
    assert_equal '-', @layout[2, 0]
    assert_equal ' ', @layout[1, 1]
  end

  def test_box_bottom
    assert_equal(1, @layout.box_bottom(0, 0))
    assert_equal(3, @layout.box_bottom(0, 2))
    assert_equal(3, @layout.box_bottom(4, 2))
    assert_equal(3, @layout.box_bottom(7, 2))
  end

  def test_box_right
    assert_equal(3, @layout.box_right(0, 0))
    assert_equal(7, @layout.box_right(0, 2))
    assert_equal(7, @layout.box_right(4, 2))
    assert_equal(7, @layout.box_right(7, 2))
  end

  def test_box_colspans
    expect = {
      @boxes[0] => 1,
      @boxes[1] => 1,
      @boxes[2] => 2,
    }
    assert_equal expect, @layout.box_colspans
  end

  def test_box_rowspans
    expect = {
      @boxes[0] => 1,
      @boxes[1] => 1,
      @boxes[2] => 1,
    }
    assert_equal expect, @layout.box_rowspans
  end

  def test_box_rows
    assert_equal [@boxes[0..1], [@boxes[2]]], @layout.box_rows
  end

  def test_box_x_delimeters
    assert_equal [3, 7], @layout.box_x_delimeters
  end

  def test_box_y_delimeters
    assert_equal [1, 3], @layout.box_y_delimeters
  end

  def test_parse
    result = @layout.parse(@grid.join("\n"))
    assert_equal @boxes, result
  end
end
