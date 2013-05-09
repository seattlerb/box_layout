= BoxParse

home :: http://seattlerb.rubyforge.org/

== DESCRIPTION

Allows you to lay out HTML using ASCII art. Stolen from psykotic's
code posted to reddit: http://programming.reddit.com/info/k9dx/comments

ported to ruby by Ryan Davis, ryand-ruby@zenspider.com

== SYNOPSIS

    require 'box_layout'
    
    page_template = <<-END
    ----------
    |        |
    ----------
    | |    | |
    | |    | |
    | |    | |
    | |    | |
    ----------
    |        |
    ----------
    END
    
    layout = BoxLayout.html page_template
    puts "<title>cute</title>"
    puts "<style>* { border: 1px solid black }</style>"
    puts layout % %w[header left body right footer].map {|s| "**#{s}**" }

== REQUIREMENTS

* ruby 1.8+
* rubygems
* hoe

== INSTALL

* sudo gem install box_layout

== LICENSE

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
