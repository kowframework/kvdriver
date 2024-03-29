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


with Ada.Text_IO;





package body KOW_View_Tools.Driver is


	procedure Run_Command( Command : in Available_Commands ) is
		Comm : KOW_View_Tools.Commands.Command_Type'Class := Get( Command );
	begin
		KOW_View_Tools.Commands.Run( Comm );
	end Run_Command;


	function Get( Command : in Available_Commands ) return KOW_View_Tools.Commands.Command_type'Class is
	begin
		if Command_Constructors( Command ) = NULL then
			raise PROGRAM_ERROR with "command is not registered..";
		end if;

		return Command_Constructors( Command ).all;
	end Get;
end KOW_View_Tools.Driver;
