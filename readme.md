# doran

Cross platform build tool/package manager for Vala. Inspired by Autovala, works on Windows 10 and Linux.
Requires CMake.

### commands
 * doran get libname
 * doran init projectname
 * doran add filename
 * doran build

Uses the base cmake vala files from autovala.

Why cmake and out of tree builds - can't we just directly call valac? For large projects, we only have to recompile sources that have changed. This saves a lot of time during dev phases.