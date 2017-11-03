###
##
# Common tools
##
###
fs = require 'fs'
path = require 'path'

liquid = require('liquid.coffee')

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


  
module.exports =
  liquid: liquid
  getSrc: getSrc
  render: render
