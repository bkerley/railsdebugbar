Rails Debug Bar
===============

Bar of diagnostic info for Rails.  Inspired by
http://rob.cogit8.org/blog/2008/Sep/19/introducing-django-debug-toolbar/

Expect this to need extending to be useful for you.  Patches accepted,
forking encouraged.

Usage
=======

    class ApplicationController < ActionController::Base
      after_filter ::RailsDebugBar
    end
    

Copyright (c) 2008 Bryce Kerley, released under the MIT license.
My version: http://github.com/bkerley/railsdebugbar/tree/master
