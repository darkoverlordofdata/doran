#+--------------------------------------------------------------------+
#| doran.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2017
#+--------------------------------------------------------------------+
#|
#| This file is a part of doran
#|
#| doran is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# doran command dispatch
#

Object.defineProperties module.exports,

  init:  
    get: -> require('./init.coffee').main

  install: 
    get: -> require('./install.coffee').main

  uninstall: 
    get: -> require('./uninstall.coffee').main

  add: 
    get: -> require('./add.coffee').main
      
  remove: 
    get: -> require('./remove.coffee').main
      
  build: 
    get: -> require('./build.coffee').main
            
