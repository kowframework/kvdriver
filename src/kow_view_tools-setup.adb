
--------------
-- Ada 2005 --
--------------
with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Directories;
with Ada.Text_IO;			use Ada.Text_IO;


-------------------
-- KOW Framework --
-------------------
with KOW_Lib.File_System;		use KOW_Lib.File_System;
with KOW_Lib.String_Util;


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

		Project	: constant String := Ada.Characters.Handling.To_Lower( Project_Name );

		Template_File : constant String := "src-in" / Project & "_setup.adb.in";
		Output_File: constant String := "src" / Project & "_setup.adb";

		procedure Message( Str : in String; Level : in Positive := 1 ) is
		begin
			for i in 1 .. Level * 3 loop
				Put( " " );
			end loop;
			Put_Line( "* " & Str );
		end Message;



		With_Buffer, Setup_Buffer : Unbounded_String;


		procedure Append_With( Component_Name : in String ) is
		begin
			Append( With_Buffer, "with " & component_name & ".setup;  " );
		end Append_With;


		procedure Append_Setup( Component_Name : in String ) is
		begin
			Append( Setup_Buffer, Component_name & ".setup( Spawn_Tasks );" );
		end Append_Setup;


		procedure List_Components( Directory_Entry : in Ada.Directories.Directory_Entry_Type ) is
			Component_Name : constant String := Ada.Directories.Simple_Name( Directory_Entry );
		begin
			if Component_Name'Length < 1 or else Component_Name( Component_Name'First ) = '.' then
				return;
			end if;
			Message( Component_Name, 2 );


			Append_With( Component_Name );
			Append_Setup( Component_Name );
		end List_Components;



		package TP renames Templates_Parser;
		Params : TP.Translate_Set;
		Output : File_Type;
	begin
		Put_Line( "Setting up the components for the application " & Project );
		Message( "building components list" );
		Ada.Directories.Search(
					Directory	=> "components",
					Pattern		=> "",
					Filter		=> ( Ada.Directories.Directory => True, Others => False ),
					Process		=> List_Components'Access
				);
		Message( "preparing the setup file" );
		TP.Insert( Params, TP.Assoc( "components_with", With_Buffer ) );
		TP.Insert( Params, TP.Assoc( "components_setup", Setup_Buffer ) );


		if Ada.Directories.Exists( Output_File ) then
 			Open( Output, Out_File, Output_File );
		else
			Create( Output, Out_File, Output_File );
		end if;
		Put( Output, Templates_Parser.Parse( Template_File, Params ) );
		Close( Output );
	end Run;
	


	overriding
	procedure Help( Command : in out Command_Type ) is
		-- show detailed information about this command
	begin
		Put_Line( "Usage:" );
		Put_Line( Ada.Command_Line.Command_Name & " setup" );
		New_Line;
		Put_Line( "Update the setup procedure so it can load all the available components." );
	end Help;



	overriding
	procedure Describe( Command : in out Command_Type ) is
		-- show a short description about this command;
	begin
		Put( "update the setup procedure" );
	end Describe;


end KOW_View_Tools.Setup;
