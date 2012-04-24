
--------------
-- Ada 2005 --
--------------
with Ada.Characters.Handling;
with Ada.Command_Line;			use Ada.Command_Line;
with Ada.Directories;
with Ada.Text_IO;			use Ada.Text_IO;


-------------------
-- KOW Framework --
-------------------
with KOW_Lib.String_Util;
with KOW_Lib.UString_Hashed_Maps;
with KOW_Lib.UString_Vectors;


---------
-- AWS --
---------
with Templates_Parser;




package body KOW_View_Tools.Setup is



	function New_Command return KOW_View_Tools.Commands.Command_Type'Class is
		-- constructor for our command
		Command : Command_Type;
	begin
		return Command;
	end New_Command;


	overriding
	procedure Run( Command : in out Command_Type ) is
		-- update the [PROJECT_NAME]_Setup procedure so it can be built..


	begin
		Put_Line( "This is not implemented yet" );
	end Run;
	


	overriding
	procedure Help( Command : in out Command_Type ) is
		-- show detailed information about this command
	begin
		Put_Line( "Usage:" );
		Put_Line( Command_Name & " setup" );
		New_Line;
		Put_Line( "Update the setup procedure so it can load all the installed and configured applications." );
		Put_Line( "For more information, read the file ""applications.cfg""." );
	end Help;



	overriding
	procedure Describe( Command : in out Command_Type ) is
		-- show a short description about this command;
	begin
		Put( "update the setup procedure" );
	end Describe;


end KOW_View_Tools.Setup;
