# doran

Autovala is like the best thing ever. But it doesn't work on windows, and it's depencencies and scope make it unlikely that it ever will. Doran runs on both windows
and linux.

Doran packages are cmake modules shoved into bower format. Doran scans the src folder to build a file list, using it to generate a CMakeLists.txt file to drive build via cmake.

    the intention is that this is a prototype. but it works too well. re-writing
    in vala requires replacements for both bower and liquid.coffee


### Install
    $ git clone git://github.com/darkoverlordofdata/doran
    $ cd doran
    $ npm install . -g

### component.json
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
    vapidir
        local vapi folder
    console
        false for windowed applications
    [installed]
        virtual array of installed source dependencies

