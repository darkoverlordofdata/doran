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
bower = require('bower').commands
mkdirp = require('mkdirp')

module.exports =
#
# create a new component or system
#
# @param  [String]  packageName
# @return none
#
  run: (packageName) ->
    name = packageName.split('doran-')[1]

    bower.install(["#{name}=#{packageName}"], save: true).on 'end', (s) ->
      if s?
        name = Object.keys(s)[0]
        config = require(path.join(process.cwd(), 'bower.json'))
        config.install.path = 
          vala  : "src"
          c     : "src"
          h     : "src"
          txt   : "src"
          vapi  : "src/vapis"
          deps  : "src/vapis"
        config.install.sources ?= {} 
        config.install.sources[name] =
          mapping: [
            { ".cache/#{name}/src/**": "" }
            { ".cache/#{name}/vapis/**": "" }
          ]
        
        fs.writeFileSync path.join(process.cwd(), 'bower.json'), JSON.stringify(config, null, '  ')
        require 'bower-installer'
    return
