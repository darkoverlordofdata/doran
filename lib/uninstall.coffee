###
 *
###
fs = require('fs')
path = require('path')
bower = require('bower').commands
{ sync } = require './util'

#
# uninstall a module 
#
# @param  [String]  name
# @return none
#
uninstall = (name) ->

  # 
  # todo:
  #
  #   * update valac.json to remove module files
  #   * update the cmake texts from the template 
  #
  bower.uninstall([name])
    .on 'end', (res) ->
      sync()
  return

###
##
# Entry point
##
###
module.exports =
  main: (args ...) ->
    moduleName = ''
    projectTemplate = undefined

    i = 0
    while i < args.length
      switch args[i]
        when '-t', '--template'
          projectTemplate = args[++i]
        else
          moduleName = args[i]
      i++
      
    uninstall moduleName