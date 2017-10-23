###
 *
###
fs = require('fs')
path = require('path')
request = require('request')
liquid = require('liquid.coffee')
bower = require('bower').commands
recursive = require 'recursive-readdir'
{ exec } = require 'child_process'
#
# install a module from the registry
#
# @param  [String]  name
# @return none
#
install = (name) ->

  # define some custom filters
  liquid.Template.registerFilter do (filter = ->) ->
    filter.ucfirst  = (str) -> str.charAt(0).toUpperCase() + str.substr(1)
    filter.camel    = (str) -> str.charAt(0).toLowerCase() + str.substr(1)
    filter.nosrc    = (str) -> str.replace(/^src\//, "")
    filter

  # render a template
  render = (template, data) ->
    # set the src location for the project template
    src = do (s = __dirname.split(path.sep)) ->
      s.pop()
      s.push "templates"
      s.push data.template
      s.join(path.sep)
    
    xform = liquid.Template.parse(fs.readFileSync(path.join(src, template), 'utf8'))
    xform.render(data)


  ## get the repository url from the package registry
  registry = "https://raw.githubusercontent.com/darkoverlordofdata/doran/master/registry/#{name}"

  request registry, (error, response, uri) ->
    if error then throw error
    uri = switch name ## testing patch for local testing
      when "entitas"  then "../../GitHub/doran-entitas"
      when "goop"     then "../../GitHub/doran-goop"
      when "lua"      then "../../GitHub/doran-lua"
      when "mt19937"  then "../../GitHub/doran-mt19937"
      when "sdx"      then "../../GitHub/doran-sdx"
      else uri
    console.log "Install from: #{uri}"

    bower.install(["#{name}=#{uri}"], save: true)
      .on 'end', (res) ->

        if res?
          name = Object.keys(res)[0]
          config = require(path.join(process.cwd(), 'bower.json'))
          config.install.path = 
            vala  : 'src'
            gs    : 'src'
            c     : 'src'
            h     : 'src'
            txt   : 'src'
            vapi  : 'src/vapis'
            deps  : 'src/vapis'
          config.install.sources ?= {} 
          config.install.sources[name] =
            mapping: [
              { ".cache/#{name}/src/**":  "" }
              { ".cache/#{name}/vapis/**": "" }
            ]
          
          # update project/bower.json:
          fs.writeFileSync path.join(process.cwd(), 'bower.json'), JSON.stringify(config, null, '  ')

          # execute bower-installer to fetch the files
          exec 'bower-installer', (err, stdout, stderr) ->
            if error?
              console.log error
              process.exit()

            ## need recursive file list
            recursive path.join('src', name), (err, files) ->

              # update the project data
              project = require(path.join(process.cwd(), 'project.json'))
              project.files.push file.replace(/\\/g, '/') for file in files
              fs.writeFileSync path.join(process.cwd(), 'project.json'), JSON.stringify(project, null, '  ')

              # update the CMake scripts
              fs.writeFileSync path.join(process.cwd(), 'CMakeLists.txt'), render('CMakeLists.liquid', project)
              fs.writeFileSync path.join(process.cwd(), 'src', 'CMakeLists.txt'), render('src/CMakeLists.liquid', project)

  return

###
##
# Entry point
##
###
module.exports = main: (args ...) ->
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
    
  install moduleName