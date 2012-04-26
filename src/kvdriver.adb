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


with KOW_Config;
with KOW_View_Tools.Commands;
with KOW_View_Tools.Driver;





with Ada.Command_line;		use Ada.Command_line;
with Ada.Exceptions;
with Ada.Text_IO;




procedure kvdriver is
	Command : KOW_View_Tools.Driver.Available_Commands;
begin
	KOW_Config.Add_Config_path( "." );

	if Argument_Count = 0 then
		raise KOW_View_Tools.Commands.Usage_ERROR with "no command given";
	end if;


	begin
		Command := KOW_View_Tools.Driver.Available_Commands'Value( Argument( 1 ) );
	exception
		when constraint_error =>
			raise KOW_View_Tools.Commands.Usage_ERROR with "unknown command """ & Argument( 1 ) & """";
	end;


	KOW_View_Tools.Driver.Run_Command( Command );
exception
	when e : KOW_View_Tools.Commands.Usage_ERROR =>
		Ada.COmmand_Line.Set_Exit_Status( Ada.Command_Line.Failure );
		Ada.Text_IO.Put_Line( "Usage error: " & Ada.Exceptions.Exception_Message( e ));
		Ada.Text_IO.New_Line;
		KOW_View_Tools.Driver.Run_Command( KOW_View_Tools.Driver.Help );
end kvdriver;
