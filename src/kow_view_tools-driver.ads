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





with KOW_View_Tools.Commands;

with KOW_View_Tools.Help;
with KOW_View_Tools.Info;
with KOW_View_Tools.Init;
with KOW_View_Tools.Install_Tool;
with KOW_View_Tools.NewComponent;
with KOW_View_Tools.Setup;
with KOW_View_Tools.Version;

-- Contains some tools for managing KOW_View_Tools Projects --
package KOW_View_Tools.Driver is


	-- a enum type used to trac all Commands available.
	type Available_Commands is (
			help,
			info,
			init,
			install_tool,
			newcomponent,
			setup,
			version
		);



	procedure Run_Command( Command : in Available_Commands );

	function Get( Command : in Available_Commands ) return KOW_View_Tools.Commands.Command_type'Class;

private
	type Available_Commands_Array is array( Available_Commands'First .. Available_Commands'Last ) of access function return KOW_View_Tools.Commands.Command_Type'Class;

	
	Command_Constructors : constant Available_Commands_Array := (
						Help		=> KOW_View_Tools.Help.New_Command'Access,
						Info		=> KOW_View_Tools.Info.New_Command'Access,
						Init		=> KOW_View_Tools.Init.New_Command'Access,
						Install_Tool	=> KOW_View_Tools.Install_Tool.New_Command'Access,
						newcomponent		=> KOW_View_Tools.NewComponent.New_Command'Access,
						Setup		=> KOW_View_Tools.Setup.New_Command'Access,
						Version		=> KOW_View_Tools.Version.New_Command'Access
					);


end KOW_View_Tools.Driver;
