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
      project = require(path.join(process.cwd(), 'project.json'))
      project.libraries = []
      project.libraries.push lib.replace('/CMakeLists.txt', '') for name, lib of libs
      project.files = []
      project.files.push strip(file) for file in files when ".gs.vala".indexOf(path.extname(file)) != -1
      fs.writeFileSync path.join(process.cwd(), 'project.json'), JSON.stringify(project, null, '  ')
      fs.writeFileSync path.join(process.cwd(), 'CMakeLists.txt'), render('CMakeLists.txt', project)

#
# install a module from the registry
#
# @param  [String]  name
# @return none
#
install = (name, repository = "remote") ->

  if name isnt ''
    ## get the repository url from the package registry
    registry = "https://raw.githubusercontent.com/darkoverlordofdata/doran/master/registry/#{repository}/#{name}"

    request registry, (error, response, uri) ->
      if error then throw error
      # uri = switch name ## testing patch for local testing
      #   when "bosco"    then "../../GitHub/doran-bosco"
      #   when "entitas"  then "../../GitHub/doran-entitas"
      #   when "goop"     then "../../GitHub/doran-goop"
      #   when "lua"      then "../../GitHub/doran-lua"
      #   when "mt19937"  then "../../GitHub/doran-mt19937"
      #   when "sdx"      then "../../GitHub/doran-sdx"
      #   when "utils"    then "../../GitHub/doran-utils"
      #   else uri
      console.log "Install from: #{uri}"

      bower.install(["#{name}=#{uri}"], save: true)
        .on 'end', (results) ->
          configure()

  else
    console.log "update configuration" 
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
        ++i
      when '-r', '--remote'
        repository = 'remote'
        ++i
      else
        moduleName = args[i]
    i++
    
  install moduleName, repository