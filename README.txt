= URI-Templates
http://rubyforge.org/projects/uri-templates/

This release implements version 0.3 of the URI Template specification.

See: http://bitworking.org/projects/URI-Templates/spec/draft-gregorio-uritemplate-03.txt

== DESCRIPTION:

URI Templates are strings that contain embedded variables that are transformed into URIs after embedded variables are substituted. 

This specification defines the structure and syntax of URI Templates. 

Read more:
* http://bitworking.org/projects/URI-Templates/
* http://www.ibm.com/developerworks/web/library/wa-uri/
* http://code.google.com/p/uri-templates/

Bug-Tracker:
* http://rubyforge.org/tracker/?atid=22376&group_id=5767&func=browse

Source:
 git clone git://scm.juretta.com/uri-templates.git

== SYNOPSIS:
  require 'rubygems'
  require 'uri/templates'
  uri = UriTemplate::URI.new("http://example.org/{userid}").replace("userid" => "stefan")
  print uri # => http://example.org/stefan
  
  ut = UriTemplate::URI.new("http://example.org/?d={-listjoin|,|points}&{-join|&|a,b}")
  print ut.replace({
    'a' => 'foo',
    'b' => 'bar',
    'points' => ["10","20","30"]
  }) # => http://example.org/?d=10,20,30&a=foo&b=bar
   
== INSTALL:

 sudo gem install uri-templates

== LICENSE:

(The MIT License)

Copyright (c) 2008 Stefan Saasen

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
