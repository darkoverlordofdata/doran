# doran

Autovala is like the best thing ever. But it doesn't work on windows, and it's depencencies and scope make it unlikely that it ever will.

### Work In Progress

Doran is a thin wrapper around bower

    redirects access to it's own registry
    updates project metadata
    regenerates build system.


### Install
    $ git clone git://github.com/darkoverlordofdata/doran
    $ cd doran
    $ npm install . -g

### component.json
    name
        project name
    template
        template name
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
        libraries maintained by bower
    files
        files in src folder
    packages
        pkg-config dependencies
    options
        valac options
    vapidir
        local vapi folder
