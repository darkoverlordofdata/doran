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
fs.copyFileSync = require('fs-copy-file-sync')
cmake = [
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
vscode = [
  "launch.json",
  "settings.json",
  "tasks.json"
]
module.exports =
#
# Initialize a vala project
#
# @param  [String]  projectName
# @return none
#
  run: (projectName) ->
    # create folder at current location
    fs.mkdirSync path.join(process.cwd(), projectName)

    ## cmake folder
    src = __dirname.replace("\\lib", '')

    cmake1 = liquid.Template.parse(fs.readFileSync(path.join(src, 'CMakeLists.liquid'), 'utf8'))
    cmake2 = liquid.Template.parse(fs.readFileSync(path.join(src, 'src/CMakeLists.liquid'), 'utf8'))
    project = {
      "name"    : projectName,
      "version" : "0.0.1",
      "vala"    : "0.34",
      "files"   : [
        "src/#{projectName}.vala"
      ],
      "packages": [
        "gee-0.8",
        "gio-2.0",
        "glib-2.0",
        "gobject-2.0"
      ],
      "options" : ["-g"]
    }

    fs.writeFileSync path.join(process.cwd(), projectName, 'CMakeLists.txt'), cmake1.render(project)
    fs.writeFileSync path.join(process.cwd(), projectName, "vala.json"), JSON.stringify(project, null, '  ')
    fs.copyFileSync path.join(src, 'license.md'), path.join(process.cwd(), projectName, 'license.md')
    fs.copyFileSync path.join(src, 'readme.md'), path.join(process.cwd(), projectName, 'readme.md')

    fs.mkdirSync path.join(process.cwd(), projectName, '.vscode')
    for file in vscode
      fs.copyFileSync path.join(src, '.vscode', file), path.join(process.cwd(), projectName, '.vscode', file)

    fs.mkdirSync path.join(process.cwd(), projectName, 'cmake')
    for file in cmake
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
    fs.writeFileSync path.join(process.cwd(), projectName, 'src', 'CMakeLists.txt'), cmake2.render(project)
    fs.copyFileSync path.join(src, 'src', 'Config.vala.base'), path.join(process.cwd(), projectName, 'src', 'Config.vala.base')
    fs.writeFileSync path.join(process.cwd(), projectName, 'src', "#{projectName}.vala"), """
    public class #{projectName} {

      static int main (string[] args) {
        stdout.printf("Hello World\\n");
        return 1;
      }
    }
    """
    return
