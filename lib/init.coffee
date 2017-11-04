###
 *
###
fs = require 'fs'
path = require 'path'
fs.copyFileSync = require 'fs-copy-file-sync'
{ liquid, render, getSrc } = require './util'

#
# Copy template to destionation using cfg
#
#  
copyTemplates = (tmppath, newpath, data) ->

  fs.mkdirSync newpath unless fs.existsSync(newpath)

  for tmpname in fs.readdirSync(tmppath)

    ext = path.extname(tmpname)
    newname = if ext is ".liquid" then tmpname.substring(0, tmpname.length-7) else tmpname
    newname = liquid.Template.parse(newname).render(data)

    tmp_file = path.join(tmppath, tmpname)
    new_file = path.join(newpath, newname)

    if fs.statSync(tmp_file).isDirectory()
      copyTemplates tmp_file, new_file, data

    else
      if ext is ".liquid"
        fs.writeFileSync new_file, liquid.Template.parse(fs.readFileSync(tmp_file, 'utf8')).render(data)

      else
        fs.copyFileSync tmp_file, new_file, data


#
# Initialize a vala project
#
# @param  [String]  projectName
# @param  [String]  projectTemplate
# @return none
#
init = (projectName, projectTemplate = 'default') ->

  project = {
    name            : projectName,
    template        : projectTemplate,
    version         : "0.0.1",
    vala            : "0.34",
    authors         : [ "" ],
    description     : "",
    license         : "",
    private         : true,
    ignore          : [],
    devDependencies : {},
    dependencies    : {},
    files           : [ "src/#{projectName}.vala" ],
    packages        : [
      "gio-2.0",
      "glib-2.0",
      "gobject-2.0"
    ],
    libraries       : [ ],
    options         : [ ],
    vapidir         : "/src/vapis"
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

    i = 0
    while i < args.length 
      switch args[i]
        when '-t', '--template'
          projectTemplate = args[++i]
        else
          projectName = args[i]
      i++
      
    init projectName, projectTemplate

