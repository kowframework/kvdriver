------------------------------------------------------------------------------
--                                                                          --
--                          KOW Framework :: View                           --
--                                                                          --
--                              KOW Framework                               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--               Copyright (C) 2007-2011, KOW Framework Project             --
--                                                                          --
--                                                                          --
-- KOWView is free software; you can redistribute it  and/or modify it under--
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion. KOWView is distributed in the hope that it will be useful,but WITH---
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License distributed with KOWView; see file COPYING.  If not, write--
-- to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, --
-- MA 02111-1307, USA.                                                      --
--                                                                          --
------------------------------------------------------------------------------
pragma License (GPL);



--------------
-- Ada 2005 --
--------------
with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Directories;
with Ada.Strings.Unbounded;	use Ada.Strings.Unbounded;


-------------------
-- KOW Framework --
-------------------
with KOW_Config;
with KOW_Lib.String_Util;





package body KOW_View_Tools is


	function Project_Name return String is
	begin
		if Ada.Directories.Exists( "kvdriver.cfg" ) then
			declare
				use KOW_Config;
				Cfg : Config_File_Type := New_Config_File(
										N			=> "kvdriver.cfg",
										Is_Complete_Path	=> True
								);
				Ite : Config_Item_Type := Item( Cfg, "project_name" );
			begin
				return Default_Value( Ite );
			end;
		else
			return Ada.Command_Line.Argument( 2 );
		end if;
	end Project_Name;



	function Destination_Path( Name : in String ) return String is
		First : Integer := Length( Skel_Path ) + Name'First;

		-- TMP1 and TMP2 variables are needed because of a bug in the
		-- Str_Replace implementation.
		-- The Str parameter must be indexed from 1 to 'Length....
		Tmp1 : String := Name( First .. Name'Last );
		Tmp2 : String( 1 .. Tmp1'Length ) := Tmp1;
		Ret : String := To_String( 
				KOW_Lib.String_Util.Str_Replace(
						From	=> "project_name",
						To	=> Ada.Characters.Handling.To_Lower( Project_Name ),
						Str	=> Tmp2
					)
				);
		Last : Integer := Ret'Last;
	begin

		if Ada.Characters.Handling.To_Lower( Ada.Directories.Extension( Name ) ) = "tpl" then
			Last := Last - 4;
		end if;

		if Ret( Ret'First ) = '/' then
			return Ret( Ret'First + 1 .. Last );
		else
			return Ret( Ret'First .. Last );
		end if;
	end Destination_Path;

	function Destination_Path( Name : in Unbounded_String ) return String is
	begin
		return Destination_Path( To_String( Name ) );
	end Destination_Path;


end KOW_View_Tools;
