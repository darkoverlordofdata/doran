###
 *
###
fs = require 'fs'
path = require 'path'
fs.copyFileSync = require 'fs-copy-file-sync'

{ liquid } = require './util'
{ render } = require './util'
{ getSrc } = require './util'

cmakeFiles = [
  "FindVala.cmake",
  "FindValadoc.cmake",
  "GObjectIntrospectionMacros.cmake",
  "GSettings.cmake",
  "Makefile",
  "ParseArguments.cmake",
  "README",
  "README.Vala.rst",
  "Tests.cmake",
  "Translations.cmake",
  "Valadoc.cmake",
  "ValaPrecompile.cmake",
  "ValaVersion.cmake"
]
vscodeFiles = [
  "launch.json",
  "settings.json",
  "tasks.json"
]

#
# Initialize a vala project
#
# @param  [String]  projectName
# @param  [String]  projectTemplate
# @return none
#
init = (projectName, projectTemplate = 'default') ->
  project = {
    name      : projectName,
    template  : projectTemplate,
    release   : "",
    desc      : "",
    version   : "0.0.1",
    vala      : "0.34",
    files     : [
      "src/#{projectName}.vala"
    ],
    libraries : { },
    packages  : [
      "gee-0.8",
      "gio-2.0",
      "glib-2.0",
      "gobject-2.0"
    ],
    resources : [ ],
    options   : [ ],
    vapidir   : "src/vapis"
  }

  src = getSrc(projectTemplate)

  # create folder at current location
  fs.mkdirSync path.join(process.cwd(), projectName)

  ## cmake folder
  fs.writeFileSync path.join(process.cwd(), projectName, 'CMakeLists.txt'), render('CMakeLists.txt', project)
  fs.writeFileSync path.join(process.cwd(), projectName, "project.json"), JSON.stringify(project, null, '  ')
  fs.copyFileSync path.join(src, 'license.md'), path.join(process.cwd(), projectName, 'license.md')
  fs.copyFileSync path.join(src, 'readme.md'), path.join(process.cwd(), projectName, 'readme.md')
  fs.copyFileSync path.join(src, '.bowerrc'), path.join(process.cwd(), projectName, '.bowerrc')
  fs.writeFileSync path.join(process.cwd(), projectName, "bower.json"), render('bower.liquid', project)

  fs.mkdirSync path.join(process.cwd(), projectName, '.vscode')
  for file in vscodeFiles
    fs.copyFileSync path.join(src, '.vscode', file), path.join(process.cwd(), projectName, '.vscode', file)

  fs.mkdirSync path.join(process.cwd(), projectName, 'cmake')
  for file in cmakeFiles
    fs.copyFileSync path.join(src, 'cmake', file), path.join(process.cwd(), projectName, 'cmake', file)

  # ## data folder
  # fs.mkdirSync path.join(process.cwd(), projectName, 'data')
  # fs.copyFileSync path.join(src, 'data', 'CMakeLists.txt'), path.join(process.cwd(), projectName, 'data', 'CMakeLists.txt')

  ## src folder
  fs.mkdirSync path.join(process.cwd(), projectName, 'src')
  fs.copyFileSync path.join(src, 'src', 'Config.vala.base'), path.join(process.cwd(), projectName, 'src', 'Config.vala.base')
  fs.writeFileSync path.join(process.cwd(), projectName, 'src', "#{projectName}.vala"), render('src/vala.liquid', project)
  return

###
##
# Entry point
##
###
module.exports =
  main: (args ...) ->
    projectName = ''
    projectTemplate = undefined

    i = 0
    while i < args.length 
      switch args[i]
        when '-t', '--template'
          projectTemplate = args[++i]
        else
          projectName = args[i]
      i++
      
    init projectName, projectTemplate

