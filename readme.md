# doran
## package manager for Vala

Autovala is like the best thing ever. But it doesn't work on windows, and it's depencencies and scope make it unlikely that it ever will. Doran runs on both windows
and linux.

    The intention was that this is a prototype. but it works too well. So I'm leaving well enough alone.

Doran packages are cmake modules shoved into bower format. Doran scans the src folder to build a file list, using it to generate a CMakeLists.txt file to drive build via cmake.

    Bower? Yeah, I know. Don't use bower. But I'm not using this for live web pages.
    I'm not actually storing anything in bower. I'm using it as a mechanism that 
    manages downloads of Vala and c/c++ dependencies from github.

At this point, doran is experimental, and is just used to package my own projects.



## Install
    $ git clone git://github.com/darkoverlordofdata/doran
    $ cd doran
    $ npm install . -g

## Usage

    doran init project-name             # create folder and initialize project
    doran install [-k] <package-name>   # install module package-name
    doran uninstall <package-name>      # uninstall module package-name
    doran update [-t template]          # refresh CMakeLists.txt
    doran source path/to/source         # change source path

    Options:
    -h  [--help]      # display this message
    -k  [--link]      # link local dependancy
    -t  [--template]  # template name
    -v  [--version]   # display version


## component.json
    name
        project name
    template
        template name -> |default|adria|
    version
        application version
    vala
        min version of vala to use
    authors
        list of authors
    description
        appliction
    license
        MIT, Apache2, etc.
    private
        true = application
        false = library
    dependencies
        source libraries maintained using bower
    files
        files in src folder (maintained by doran)
    packages
        pkg-config dependencies (maintained by doran)
    libraries
        other libraries
    options
        valac options
    definitions
        define -D symbols for the compiler
    copy
        folder to copy exe to for testing
    vapidir
        local vapi folder
    console
        false for windowed applications
    [installed]
        virtual array of installed source dependencies

