###
 * Entitas code generation
 *
 * emulate the partial class strategy for extensions
 * used by Entitas_CSharp
 *
###
fs = require('fs')
path = require('path')
liquid = require('liquid.coffee')
mkdirp = require('mkdirp')

module.exports =
#
# create a new component or system
#
# @param  [String]  projectName
# @return none
#
  run: (projectName) ->
    console.log "doran::remove"
    return
