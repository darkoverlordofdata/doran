###
 *
###
fs = require 'fs'
path = require 'path'
request = require 'request'
bower = require('bower').commands
fs.recursiveReaddir = require 'recursive-readdir'


{ exec } = require 'child_process'
{ liquid } = require './util'
{ render } = require './util'

strip = (file) ->
  file = file.replace(/\\/g, "/")
  p = process.cwd().replace(/\\/g, "/")
  if file.indexOf(p) is 0
    file = file.substring(p.length+1)
  return file

configure = ->
  exec "bower list --path --json", (error, stdout, stderr) ->
    if error then throw error
    libs = JSON.parse(stdout)
    fs.recursiveReaddir path.join(process.cwd(), 'src'), (error, files) ->
      if error then throw error
      project = require(path.join(process.cwd(), 'component.json'))
      project.libraries = []
      project.libraries.push lib.replace('/CMakeLists.txt', '') for name, lib of libs
      project.files = []
      project.files.push strip(file) for file in files when ".gs.vala".indexOf(path.extname(file)) != -1
      fs.writeFileSync path.join(process.cwd(), 'component.json'), JSON.stringify(project, null, '  ')
      fs.writeFileSync path.join(process.cwd(), 'CMakeLists.txt'), render('CMakeLists.txt', project)

#
# install a module from the registry
#
# @param  [String]  name
# @return none
#
install = (name, repository = "remote") ->

  if name is ''
    console.log "update configuration" 
    configure()

  else
    ## get the repository url from the package registry
    registry = "https://raw.githubusercontent.com/darkoverlordofdata/doran/master/registry/#{repository}/#{name}"

    request registry, (error, response, uri) ->
      if error then throw error
      console.log "Install from: #{uri}"
      bower.install(["#{name}=#{uri}"], save: true)
        .on 'end', (results) ->
          configure()


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