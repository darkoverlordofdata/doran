###
 *
###
fs = require 'fs'
path = require 'path'
request = require 'request'
bower = require('bower').commands
{ sync } = require './util'

#
# install a module from the registry
#
# @param  [String]  name
# @return none
#
install = (name, repository = "remote") ->

  if name is ''
    bower.install()
      .on 'end', (results) ->
        sync()

  else
    ## get the repository url from the package registry
    registry = "https://raw.githubusercontent.com/darkoverlordofdata/doran/master/registry/#{repository}/#{name}"

    request registry, (error, response, uri) ->
      if error then throw error
      console.log "Install from: #{uri}"
      bower.install(["#{name}=#{uri}"], save: true)
        .on 'end', (results) ->
          sync()


  return

###
##
# Entry point
##
###
module.exports = main: (args ...) ->
  moduleName = ''
  repository = undefined

  i = 0
  while i < args.length
    switch args[i]
      when '-l', '--local'
        repository = 'local'
      when '-r', '--remote'
        repository = 'remote'
      else
        moduleName = args[i]
    i++
    
  install moduleName, repository