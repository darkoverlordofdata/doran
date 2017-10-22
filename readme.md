# doran

Autovala is like the best thing ever. But it doesn't work on windows, and it's depencencies and scope make it unlikely that it ever will.

### Work In Progress

Doran is a cross platform build tool/package manager for Vala. Co inspired by Autovala and Bower and Sam (ooc package manager), doran should work on Windows 10 and Linux. So development is on windows, testing on linux.

Requires CMake, and MSYS2 on windows. 
The prototype uses coffeescript. It will probably stay coffee unless I port liquid to vala, or find an equivalent templating engine for vala.
The prototype uses bower-installer to manage modules. Bower is dead - long live bower.

Why not componentjs? Why not duojs? Why not jspm? Why not npm? Why not yarn? Why not normalize.io? Why not ... oh I give up. Whch one do you use this week? Bower does what I want and does it simply. I don't want to take more time to learn yet another package manager that might even be around tomorrow.

Uses the base cmake vala files from autovala.

Why cmake and out of tree builds - can't we just directly call valac? For large projects, we only have to recompile sources that have changed. This saves a lot of time during dev phases.

### commands
 * doran init projectname
 * doran get package
 * doran add filename
 * doran remove filename
 * doran build

