###
 *
###
fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
fs.copyFileSync = require('fs-copy-file-sync')

cmakeFiles = [
  'CMakeLists.txt',
  "FindVala.cmake",
  "FindValadoc.cmake",
  "GObjectIntrospectionMacros.cmake",
  "GSettings.cmake",
  "Makefile",
  "ParseArguments.cmake",
  "GSettings.cmake",
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
    "name"      : projectName,
    "template"  : projectTemplate,
    "version"   : "0.0.1",
    "vala"      : "0.34",
    "files"     : [
      "src/#{projectName}.vala"
    ],
    "packages"  : [
      "gee-0.8",
      "gio-2.0",
      "glib-2.0",
      "gobject-2.0"
    ],
    "resources" : [ ],
    "options"   : ["-g"],
    "cc"        : "clang"
  }

  # define some custom filters
  liquid.Template.registerFilter do (filter = ->) ->
    filter.ucfirst  = (str) -> str.charAt(0).toUpperCase() + str.substr(1)
    filter.camel    = (str) -> str.charAt(0).toLowerCase() + str.substr(1)
    filter.nosrc    = (str) -> str.replace(/^src\//, "")
    filter

  # set the src location for the project template
  src = do (template = __dirname.split(path.sep)) ->
    template.pop()
    template.push "templates"
    template.push projectTemplate
    template.join(path.sep)

  # render a template
  render = (template, data) ->
    xform = liquid.Template.parse(fs.readFileSync(path.join(src, template), 'utf8'))
    xform.render(data)
  
  # create folder at current location
  fs.mkdirSync path.join(process.cwd(), projectName)

  ## cmake folder
  fs.writeFileSync path.join(process.cwd(), projectName, 'CMakeLists.txt'), render('CMakeLists.liquid', project)
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

  ## data folder
  fs.mkdirSync path.join(process.cwd(), projectName, 'data')
  fs.mkdirSync path.join(process.cwd(), projectName, 'data', 'local')
  fs.copyFileSync path.join(src, 'data', 'local', 'CMakeLists.txt'), path.join(process.cwd(), projectName, 'data', 'CMakeLists.txt')

  ## po folder
  fs.mkdirSync path.join(process.cwd(), projectName, 'po')
  fs.copyFileSync path.join(src, 'po', 'CMakeLists.txt'), path.join(process.cwd(), projectName, 'po', 'CMakeLists.txt')
  fs.copyFileSync path.join(src, 'po', 'POTFILES.in'), path.join(process.cwd(), projectName, 'po', 'POTFILES.in')

  ## src folder
  fs.mkdirSync path.join(process.cwd(), projectName, 'src')
  fs.writeFileSync path.join(process.cwd(), projectName, 'src', 'CMakeLists.txt'), render('src/CMakeLists.liquid', project)
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
