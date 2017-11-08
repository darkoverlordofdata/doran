###
##
# Common tools
##
###
fs = require 'fs'
path = require 'path'
liquid = require 'liquid.coffee'
fs.recursiveReaddir = require 'recursive-readdir'
{ exec } = require 'child_process'

#
# Load Liquid templates with some custom filters
#
liquid.Template.registerFilter do (filter = ->) ->
  filter.ucfirst  = (str) -> str.charAt(0).toUpperCase() + str.substr(1)
  filter.camel    = (str) -> str.charAt(0).toLowerCase() + str.substr(1)
  filter.nosrc    = (str) -> str.replace(/^src\//, "")
  filter

#
# gets the source location of the template
#
getSrc = (data) ->
  template = __dirname.split(path.sep)
  template.pop()
  template.push "templates"
  template.push if typeof data is 'string' then data else data.template
  return template.join(path.sep)

#
# renders the template
#
render = (template, data) ->
  xform = liquid.Template.parse(fs.readFileSync(path.join(getSrc(data), template), 'utf8'))
  xform.render(data)

#
# get folders
#
# reduce a list of files to a list of the containing folders
#
getFolders = (folders, files...) ->
  unique = { }
  for name in folders
    unique[name] = true
  for ary in files
    for name in ary
      unique[path.dirname(name)] = true
  Object.keys(unique)

#
# clean up file path name
#
clean = (file) ->
  file = file.replace(/\\/g, "/")
  p = process.cwd().replace(/\\/g, "/")
  if file.indexOf(p) is 0
    file = file.substring(p.length+1)
  return file

#
# Sync metadata and CMake to reflect the current state of the project
#
sync = ->
  exec "bower list --path --json", (error, stdout, stderr) ->
    if error then throw error
    libs = JSON.parse(stdout)
    fs.recursiveReaddir path.join(process.cwd(), 'src'), (error, files) ->
      if error then throw error
      project = require(path.join(process.cwd(), 'component.json'))
      project.files = []
      project.files.push clean(file) for file in files when ".gs.vala".indexOf(path.extname(file)) != -1
      fs.writeFileSync path.join(process.cwd(), 'component.json'), JSON.stringify(project, null, '  ')
      
      project.libraries = []
      project.libraries.push lib.replace('/CMakeLists.txt', '') for name, lib of libs
      fs.writeFileSync path.join(process.cwd(), 'CMakeLists.txt'), render('CMakeLists.txt.liquid', project)




module.exports =
  liquid: liquid
  getSrc: getSrc
  render: render
  sync:   sync
