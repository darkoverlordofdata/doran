###
 *
###
fs = require 'fs'
path = require 'path'
{ sync } = require './util'

#
# change the source folder
#
# @param  [String]  path
# @return none
#
source = (pathToSource = 'src') ->
  project = require(path.join(process.cwd(), 'component.json'))
  project.source = pathToSource
  fs.writeFileSync path.join(process.cwd(), 'component.json'), JSON.stringify(project, null, '  ')
  sync()
  return

###
##
# Entry point
##
###
module.exports = main: (args ...) ->
    
  source args[0]
  