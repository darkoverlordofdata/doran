# doran
## the missing package manager for Vala

## Install

    npm install -g doran-cli

        or

    yarn global add doran-cli


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

## Overview
Doran recognizes 2 package types, default and package. Default is a top level project containing the main proc. Packages are source libraries, and compiled as sub-projects to the default project. All projects can be a mixture of Vala, C, and C++.

Project templates are Liquid templates. If you've used Jekyll, chances are you've used Liquid. Template values are pulled from the project component.json. The json node "files" is maintained by scanning "source" during update. The "dependencies" node is maintained by doran install. The remaining nodes are initialized by doran init, and them maintained by the developer. 

For an example of most doran features, look at https://github.com/darkoverlordofdata/valagame

#### start a new project
    doran init myproject
    cd myproject
    mkdir build
    ./configure
    cd build
    make

#### start a new package
    doran init --template package mysub
    rename mysub doran-mysub
    cd doran-mysub
    mkdir build
    ./configure
    cd build
    make

#### add package to registry

1. project name should be formated doran-project-name.
2. pull request to add a file to the registry/remote and registry/local folders in github.com/darkoverlordofdata/doran 
3. local folders should be located as a sibling, as ../../GitHub/doran-project-name

#### add package to project
    cd myproject
    doran install mysub

#### link package to project
    cd myproject
    doran install mysub
    del ./.lib/mysub
    doran install --link mysub

## component.json
    name
        project name
    template
        template name -> |default|package|
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
        pkg-config dependencies
    libraries
        other libraries
    includes
        folders with *.h files
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
    symbols
        symbols to define for valac

## Why?
Autovala is like the best thing ever. But it doesn't work on windows, and it's depencencies and scope make it unlikely that it ever will. Doran runs on both windows
and linux.

    The intention was that this is a prototype. but it works too well. So I'm leaving well enough alone.

Doran packages are cmake modules shoved into bower format. Doran scans the src folder to build a file list, using it to generate a CMakeLists.txt file to drive build via cmake.

    Bower? Yeah, I know. Don't use bower, but I'm not running it on a server. Doran only uses client functionality locally to manage downloads of Vala and c/c++ dependencies from github.

At this point, doran is experimental, and is just used to package my own projects.

