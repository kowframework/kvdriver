------------------------------------------------------------------------------
--                                                                          --
--                          KOW Framework :: View                           --
--                                                                          --
--                              KOW Framework                               --
--                                                                          --
--                                 S p e c                                  --
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



------------------------------------------------
-- This is the home for the command interface --
------------------------------------------------

package KOW_View_Tools.Commands is



	Usage_Error : Exception;

	type Command_Type is abstract tagged null record;

	procedure Run( Command : in out Command_Type ) is abstract;
	-- execute the command
	

	procedure Help( Command : in out Command_Type ) is abstract;
	-- print the detailed help message about the command (used by the help command)
	

	procedure Describe( Command : in out Command_Type ) is abstract;
	-- print a short description about the command (used by the help command)

end KOW_View_Tools.Commands;
