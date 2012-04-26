-- Build file for @_project_name_@
--

with "kowlib";
with "kowconfig";
with "kowent";
with "kowview";



with "apq";
with "apqprovider";
with "apqprovider-mysql";


project @_project_name_@ is

	-----------------------
	-- Type declarations --
	-----------------------

	type True_False is ( "true", "false" );
	type Supported_OS is ("Windows_NT", "GNU/Linux", "Darwin" );


	--------------------
	-- Main Variables --
	--------------------

	Project_Name := "@_project_name_@";
	version	:= "@version@";
	OS	: Supported_OS	:= external( "OS", "GNU/Linux" );
	Debug	: True_False	:= external( "DEBUG", "false" );





	----------------
	-- Parameters --
	----------------


	for Source_Dirs use ( "../../include/" & Project_Name & "/" );
	for Externally_Built use External( "@_upper_project_name_@_EXTERNALLY_BUILT", "true" );
	for Exec_Dir use "../../bin/";
	for Main use ("@_project_name_@_server", "@_project_name_@_cli");




	----------------------
	-- Compiler Package --
	----------------------
	package Compiler is
		case Debug is
			when "true" =>
				for Default_Switches ("ada") use ("-O2", "-gnat05", "-fPIC", "-g");
			when "false" =>
				for Default_Switches ("ada") use ("-O2", "-gnat05", "-fPIC" );
		end case;
	end Compiler;



end @_project_name_@;
