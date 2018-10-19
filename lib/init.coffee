###
 *
###
fs = require 'fs'
path = require 'path'
fs.copyFileSync = require 'fs-copy-file-sync'
{ liquid, render, getSrc } = require './util'
#
# Copy template to destionation using cfg-data
#
#  
copyTemplates = (tmpPath, newPath, data) ->

  fs.mkdirSync newPath unless fs.existsSync(newPath)

  for tmpName in fs.readdirSync(tmpPath)

    ext = path.extname(tmpName)
    newName = if ext is ".liquid" then tmpName.substring(0, tmpName.length-7) else tmpName
    newName = liquid.Template.parse(newName).render(data)

    tmpFile = path.join(tmpPath, tmpName)
    newFile = path.join(newPath, newName)

    if fs.statSync(tmpFile).isDirectory()
      copyTemplates tmpFile, newFile, data

    else
      if ext is ".liquid"
        fs.writeFileSync newFile, liquid.Template.parse(fs.readFileSync(tmpFile, 'utf8')).render(data)

      else
        fs.copyFileSync tmpFile, newFile


#
# Initialize a vala project
#
# @param  [String]  projectName
# @param  [String]  projectTemplate
# @return none
#
init = (projectName, projectTemplate = 'default', srcPath = 'src') ->

  project = {
    "!": "doran package manager v"+require("#{path.dirname(__dirname)}/package.json").version,
    name            : projectName,
    template        : projectTemplate,
    version         : "0.0.1",
    vala            : "0.26",
    authors         : [ ],
    description     : projectName,
    license         : "MIT",
    private         : (if projectTemplate == 'package' then false else true),
    dependencies    : {},
    source          : srcPath,
    files           : [ "#{srcPath}/#{projectName}.vala" ],
    packages        : [
      "gio-2.0",
      "glib-2.0",
      "gobject-2.0"
    ],
    includes        : null,
    libraries       : [
      "m"
    ],
    options         : { 
      VERSION       : "0.0.1", 
      RELEASE_NAME  : projectName 
    },
    definitions     : [],
    symbols         : [],
    copy            : null,
    vapidir         : (if projectTemplate == 'package' then "vapis" else "/src/vapis"),
    console         : false
  }

  templatePath = getSrc(projectTemplate)
  projectPath = path.join(process.cwd(), projectName)
  
  fs.mkdirSync projectPath
  fs.writeFileSync path.join(projectPath, "component.json"), JSON.stringify(project, null, '  ')
  copyTemplates templatePath, projectPath, project
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
    srcPath = undefined

    i = 0
    while i < args.length 
      switch args[i]
        when '-t', '--template'
          projectTemplate = args[++i]
        when '-s', '--source'
          srcPath = args[++i]
        else
          projectName = args[i]
      i++
      
    init projectName, projectTemplate, srcPath

