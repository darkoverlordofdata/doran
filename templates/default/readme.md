# doran

Autovala is like the best thing ever. But it doesn't work on windows, and it's depencancies and scope make it unlikely that it ever will.

### Work In Progress

Doran is a cross platform build tool/package manager for Vala. Co inspired by Autovala, Bower, and Sam (ooc package manager), doran should work on Windows 10 and Linux. So development is on windows, testing on linux.

Requires CMake, and MSYS2 on windows. The prototype uses coffeescript. It will probably stay coffee unless I port liquid to vala, or find an equivalent templating engine for vala.

Uses the base cmake vala files from autovala.

Why cmake and out of tree builds - can't we just directly call valac? For large projects, we only have to recompile sources that have changed. This saves a lot of time during dev phases.

### commands
 * doran init projectname
 * doran get package
 * doran add filename
 * doran remove filename
 * doran build

