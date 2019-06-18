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
  return filter

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
  return xform.render(data)

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
  return Object.keys(unique)

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
# make sure the metadata format is up to date
# patch in fields that have been added since v0
# or that are not in bower
upgrade = (project) ->

  if not project.vala?
    project.vala = "0.26"

  if not project.c?
    project.vala = "99"

  if not project.cpp?
    project.vala = "17"

  if not project.packages?
    project.packages = null

  if not project.includes?
    project.includes = null

  if not project.libraries?
    project.libraries = null

  if not project.options?
    project.options = null

  if not project.definitions?
    project.definitions = null

  if not project.symbols?
    project.symbols = null

  if not project.copy?
    project.copy = null

  if not project.vapidir?
    project.vapidir = null

  if not project.console?
    project.console = false

  if project.template is "package" and not project.main?
    project.main = "CMakeLists.txt"

  return project
#
# Sync metadata and CMake to reflect the current state of the project
#
sync = () ->
  exec "bower list --path --json", (error, stdout, stderr) ->
    if error then throw error
    project = require(path.join(process.cwd(), 'component.json'))
    project = upgrade(project)

    srcPath = project.source ? 'src'
    libs = JSON.parse(stdout)
    fs.recursiveReaddir path.join(process.cwd(), srcPath), (error, files) ->
      if error then throw error
      project = require(path.join(process.cwd(), 'component.json'))

      project.files = []
      project.files.push clean(file) for file in files when ".m.gs.vala.c.cpp.vapi".indexOf(path.extname(file)) != -1
      # ObjFw support:
      if project.template is 'objc'
        if project.libraries.indexOf('objfw') is -1     then project.libraries.push('objfw')
        if project.libraries.indexOf('objfw_rt') is -1  then project.libraries.push('objfw_rt')
        # if project.libraries.indexOf('dl') is -1        then project.libraries.push('dl')
        if project.libraries.indexOf('pthread') is -1   then project.libraries.push('pthread')

      fs.writeFileSync path.join(process.cwd(), 'component.json'), JSON.stringify(project, null, '  ')
      
      
      project.files = []
      project.files.push clean(file) for file in files when ".gs.vala".indexOf(path.extname(file)) != -1
      if project.files.length is 0 then project.files = null

      project.c_source = []
      project.c_source.push clean(file) for file in files when ".c.cpp.m".indexOf(path.extname(file)) != -1
      if project.c_source.length is 0 then project.c_source = null

      project.vapi_files = []
      project.vapi_files.push clean(file) for file in files when ".vapi".indexOf(path.extname(file)) != -1
      if project.vapi_files.length is 0 then project.vapi_files = null

      project.installed = []
      project.installed.push lib.replace('/CMakeLists.txt', '') for name, lib of libs
      for lib in project.installed
        if fs.existsSync("#{lib}/component.json")
          doran = require(path.join(process.cwd(), "#{lib}/component.json"))
          project.definitions = [] if project.definitions is null
          project.definitions.push d for d in doran.definitions
      
      fs.writeFileSync path.join(process.cwd(), 'CMakeLists.txt'), render('CMakeLists.txt.liquid', project)


module.exports =
  liquid: liquid
  getSrc: getSrc
  render: render
  sync:   sync
