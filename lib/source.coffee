###
 *
###
fs = require 'fs'
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
  path = undefined

  i = 0
  while i < args.length
    switch args[i]
      when '-s', '--source'
        path = args[++i]
    i++
    
  source path
  