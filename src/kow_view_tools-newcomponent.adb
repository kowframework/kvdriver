


--------------
-- Ada 2005 --
--------------
with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Directories;
with Ada.Strings.Unbounded;		use Ada.Strings.Unbounded;
with Ada.Text_IO;




-------------------
-- KOW Framework --
-------------------
with KOW_Lib.File_System;
with KOW_Lib.String_Util;
with KOW_Lib.UString_Vectors;
with KOW_View_Tools.Commands;
with KOW_View_Tools.Driver;
with KOW_View_Tools.Setup;



---------
-- AWS --
---------
with Templates_Parser;

------------------------------------------------
-- Implementation of the NewComponent command --
------------------------------------------------

package body KOW_View_Tools.NewComponent is


	function New_Command return KOW_View_Tools.Commands.Command_Type'Class is
		Command : Command_Type;
	begin
		
		return Command;
	end New_Command;



	overriding
	procedure Run( Command : in out Command_Type ) is
	-- create a newcomponent 
	-- required parameter :: component name
	

		use Ada.Directories;
		use KOW_Lib.UString_Vectors;


		To_Process		: Vector;
		-- list the directories that need processing..
		To_Process_C		: Cursor;
		Current_Directory	: Unbounded_String;

		Directories	: Vector;
		Ordinary_Files	: Vector;
		TPL_Files	: Vector;



		Tpl_Parameters	: Templates_Parser.Translate_Set;


		function Get_Component_Name return String is
		begin
			return Ada.Command_Line.Argument( 2 );
		exception
			when others =>
				raise KOW_View_Tools.Commands.Usage_Error with "Component name missing";
		end Get_Component_Name;


		Component_Name	: constant String := Get_Component_Name;
		Lower_Component_Name	: constant String := Ada.Characters.Handling.To_Lower( Component_Name );
		Component_Package	: constant String := KOW_Lib.String_Util.Str_Replace( From => '-', To => '.', Str => Component_Name );


		Lower_Project_Name	: constant String := Ada.Characters.Handling.To_Lower( Project_Name );


		function Component_Destination_Path( Name : in String ) return String is
			use KOW_Lib.String_Util;
			First : Integer := Length( Component_Skel_Path ) + Name'First;
		
			-- TMP1 and TMP2 variables are needed because of a bug in the
			-- Str_Replace implementation.
			-- The Str parameter must be indexed from 1 to 'Length....
			Tmp1 : String := Name( First .. Name'Last );
			Tmp2 : String( 1 .. Tmp1'Length ) := Tmp1;
			Ret1 : String := To_String( 
					KOW_Lib.String_Util.Str_Replace(
							From	=> "project_name",
							To	=> Lower_Project_Name,
							Str	=> Tmp2
						)
					);

			Ret  : String := To_String(
					KOW_Lib.String_Util.Str_Replace(
							From	=> "component_name",
							To	=> Lower_Component_Name,
							Str	=> Ret1
						)
					);
			Last : Integer := Ret'Last;
		begin
	
			if Ada.Characters.Handling.To_Lower( Ada.Directories.Extension( Name ) ) = "tpl" then
				Last := Last - 4;
			end if;
	
			if Ret( Ret'First ) = '/' then
				return "components/" & Lower_Component_Name & '/' & Ret( Ret'First + 1 .. Last );
			else
				return "components/" & Lower_Component_Name & '/' & Ret( Ret'First .. Last );
			end if;
		end Component_Destination_Path;
	
		function Component_Destination_Path( Name : in Unbounded_String ) return String is
		begin
			return Component_Destination_Path( To_String( Name ) );
		end Component_Destination_Path;
	
	


		
		procedure Process( Directory_Entry : in Directory_Entry_Type ) is
			SName	: constant String := Full_Name( Directory_Entry );
			Name	: constant Unbounded_String := To_Unbounded_String( SName );

			Filename : String := KOW_Lib.File_System.Get_File_Name( SName );
		begin
			if Filename = "." OR ELSE Filename = ".." then
				return;
			end if;
			Ada.Text_IO.Put_Line( "Processing """ & SName & """" );
			case Kind( Directory_Entry ) is
				when Directory =>
					Append( To_Process, Name );
				when Ordinary_File =>
					-- the ordinary files might be both .in files or real ordinary files...
					if Ada.Characters.Handling.To_Lower( Extension( SName ) ) = "tpl" then
						Append( TPL_Files, Name );
					else
						Append( Ordinary_Files, Name );
					end if;
				when Special_File => null;
					-- we ignore special files...
			end case;
		end Process;




		procedure Directories_Iterator( C : in Cursor ) is
		begin
			Create_Path( Component_Destination_Path( Element( C ) ) );
		end Directories_Iterator;



		procedure Ordinary_Files_Iterator( C : in Cursor ) is
			Name : String := To_String( Element( C ) );
		begin
			Copy_File(
					Source_Name	=> Name,
					Target_Name	=> Component_Destination_Path( Name )
				);
		end Ordinary_Files_Iterator;


	
		
		procedure TPL_Files_Iterator( C : in Cursor ) is
			use Ada.Text_IO;
			Name		: String := To_String( Element( C ) );
			Values		: String := Templates_Parser.Parse( Name, Tpl_Parameters );

			Destination	: File_Type;
		begin
			Create( Destination, Out_File, Component_Destination_Path( Name ) );
			Put( Destination, Values );
			Close( Destination );
		end TPL_Files_Iterator;


	
	begin
		if Ada.Command_Line.Argument_Count /= 2 then
			raise KOW_View_Tools.Commands.USAGE_ERROR with "the init command requires a parameter with the project name";
		end if;


		if not Exists( "kvdriver.cfg" ) then
			raise KOW_View_Tools.Commands.USAGE_ERROR with "you should run this command from a folder where there is an active kvdriver project";
		end if;


		Append( To_Process, Component_Skel_Path );

		To_Process_C := First( To_Process );

		while Has_Element( To_Process_C ) loop
			Current_Directory := Element( To_Process_C );
			Ada.Directories.Search(
					Directory	=> To_String( Current_Directory ),
					Pattern		=> "",
					Process		=> Process'Access
				);
			Delete( To_Process, To_Process_C );
			To_Process_C := First( To_Process );

			if Current_Directory /= Component_Skel_Path then
				Append( Directories, Current_Directory );
			end if;
		end loop;


		-- create the directory structure...
		Iterate( Directories, Directories_Iterator'Access );

		-- copy all the ordinary files
		Iterate( Ordinary_Files, Ordinary_Files_Iterator'Access );

		-- process all the .in files into ordinary files using AWS' Templates Parser and as variables
		-- 	Component_Name
		-- 	Component_Package
		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "component_name", Component_Name ) );
		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "lower_Component_name", Ada.Characters.Handling.To_Lower( Component_Name ) ) );
		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "upper_Component_name", Ada.Characters.Handling.To_Upper( Component_Name ) ) );

		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "component_package", Component_package ) );
		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "lower_Component_package", Ada.Characters.Handling.To_Lower( Component_Package ) ) );
		Templates_Parser.Insert( Tpl_Parameters, Templates_Parser.Assoc( "upper_Component_package", Ada.Characters.Handling.To_Upper( Component_Package ) ) );


		Iterate( TPL_Files, TPL_Files_Iterator'Access );


		-- NOW we run the setup.. --
		declare
			Setup : KOW_View_Tools.Setup.Command_Type;
		begin
			KOW_View_Tools.Setup.Run( Setup );
		end;
	end Run;


	overriding
	procedure Help( Command : in out Command_Type ) is
		-- show detailed information about this command
		use Ada.Command_Line;
		use Ada.Text_IO;
	begin
		Put_Line( "Usage:" );
		Put_Line( Command_Name & " newcomponent Component_name" );
		New_Line;
		Put_Line( "Initialize the Component, where ""component_name"" is a valid compilation unit in Ada for your project" );
	end Help;


	overriding
	procedure Describe( Command : in out Command_Type ) is
		-- show a short description about this command;
	begin
		Ada.Text_IO.Put( "initialize the Component folder" );
	end Describe;
end KOW_View_Tools.NewComponent;
