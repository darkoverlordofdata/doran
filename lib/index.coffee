#+--------------------------------------------------------------------+
#| doran.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2017
#+--------------------------------------------------------------------+
#|
#| This file is a part of doran
#|
#| Entitas is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# entitas command dispatch
#

Object.defineProperties module.exports,

  init:  
    get: ->
      require('./init.coffee').run

  get: 
    get: ->
      require('./get.coffee').run

  add: 
    get: ->
      require('./add.coffee').run
      
  remove: 
    get: ->
      require('./remove.coffee').run
      
  build: 
    get: ->
      require('./build.coffee').run
            
