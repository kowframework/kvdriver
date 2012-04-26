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
with Ada.Command_Line;		use Ada.Command_Line;
with Ada.Text_IO;		use Ada.Text_IO;


-------------------
-- KOW Framework --
-------------------
with KOW_View_Tools.Commands;


----------------------------------------
-- Implementation of the Info command --
----------------------------------------

package body KOW_View_Tools.Info is



	function New_Command return KOW_View_Tools.Commands.Command_Type'Class is
		-- constructor for our command
		Command : Command_Type;
	begin
		return Command;
	end New_Command;



	overriding
	procedure Run( Command : in out Command_Type ) is
		-- display some information about the project
	begin
		Put_Line( "Project Name :: " & Project_Name );
	exception
		when constraint_error => raise CONSTRAINT_ERROR with "this is not a kvdriver project.. run init first";
	end Run;



	overriding
	procedure Help( Command : in out Command_Type ) is
		-- show detailed information about this command
	begin
		Put_Line( "Usage:" );
		Put_Line( Command_Name & " info" );
		New_Line;
		Put_Line( "Show some simple information about the current project" );

	end Help;


	overriding
	procedure Describe( Command : in out Command_Type ) is
		-- show a short description about this command;
	begin
		Put( "show some simple information about the current project" );
	end Describe;
end KOW_View_Tools.Info;
