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
    ##
    ## if repository is "link" create link to folder, else:
    ## get the repository url from the package registry
    ##
    link = false
    if repository is "link" # play the shell game
      link = true
      repository = "local"

    registry = "https://raw.githubusercontent.com/darkoverlordofdata/doran/master/registry/#{repository}/#{name}"

    request registry, (error, response, uri) ->
      if error then throw error

      if link
      
        console.log "Install from: #{uri}"
        fs.symlink path.resolve(uri), "./.lib/#{name}", (err) ->
          if err then throw err
          else sync()
          #
          # https://github.com/nodejs/node/issues/18518
          # fs.symlink can’t create directory symlinks on Windows #18518
          # "The libuv upgrade will make its way into node 8 eventually.
          # Since there is nothing to do but wait I'll go ahead and close this out."
          #

      else

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
      when '-k', '--link'
        repository = 'link'
      else
        moduleName = args[i]
    i++
    
  install moduleName, repository