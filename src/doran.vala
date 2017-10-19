/**
 * 
 * doran get <lib>
 * doran init <project>
 * doran add <file>
 * doran build
 */

using GLib;

class Doran {

	public static bool version;
	[CCode (array_length = false, array_null_terminated = true)]
	public static string[] command;
	
	const OptionEntry[] options = {
		{ "version", 0, 0, OptionArg.NONE, ref version, "Display version number", null },
		{ "", 0, 0, OptionArg.FILENAME_ARRAY, ref command, null, "Command..." },
		{ null }
	};



	static int main (string[] args) {

		try {
			var opt_context = new OptionContext("- doran");
			opt_context.set_help_enabled(true);
			opt_context.add_main_entries(options, null);
			opt_context.parse(ref args);
		} catch (OptionError e) {
			stdout.printf("error: %s\n", e.message);
			stdout.printf("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 0;
		}

		if (version) {
			stdout.printf("doran 0.1.0 \n");
			return 0;
		}

		if (command == null || command.length == 0) {
			stdout.printf("No command specified.\n");
			return 0;
		}

		switch (command[0]) {
			case "init": return doranInit();
			case "get":	return doranGet();
			case "add":	return doranAdd();
			case "remove": return doranRemove();
			case "build": return doranBuild();
			default:
				stdout.printf("Unknown command [%s].\n", command[0]);
				return 1;
		}
	}


	/**
	 * Initialize new poject
	 * 
	 * doran init project-name
	 */
	static int doranInit() {
		var projectName = command[1];
		stdout.printf("PROJECT %s\n", projectName);
		try {
			File root = File.new_for_commandline_arg(projectName);
			root.make_directory();
			stdout.printf("Created %s\n", root.get_path());
			// populate the new project folder
			File cmake = File.new_for_commandline_arg(@"$projectName\\cmake");
			cmake.make_directory();
			
			File data = File.new_for_commandline_arg(@"$projectName\\data");
			data.make_directory();

			File po = File.new_for_commandline_arg(@"$projectName\\po");
			po.make_directory();

			File src = File.new_for_commandline_arg(@"$projectName\\src");
			src.make_directory();

			initialize(projectName, root, cmake, data, po, src);

		} catch (IOError e) {
			if (e is IOError.EXISTS) {
				// don't overwrite anything, so just bug out.
				stdout.printf("Folder for %s already exists.\n", projectName);
				return 0;
			} else {
				stdout.printf("Error: %s\n", e.message);
				return 1;
			}
		}

		return 0;
	}
	/**
	 * Get package
	 * 
	 * doran get package-name
	 */
	static int doranGet() {
		var packageName = command[1];
		return 0;
	}
	/**
	 * Add source file
	 * 
	 * doran add file-name
	 */
	static int doranAdd() {
		var fileName = command[1];
		return 0;
	}
	/**
	 * Remove source file
	 * 
	 * doran remove file-name
	 */
	static int doranRemove() {
		var fileName = command[1];
		return 0;
	}
	/**
	 * Build project
	 * 
	 * doran build
	 */
	static int doranBuild() {
		return 0;
	}

	static void initialize(name string, File root, File cmake, File data, File po, File src) {
		
	}
			
}