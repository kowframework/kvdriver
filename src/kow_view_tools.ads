


--------------
-- Ada 2005 --
--------------
with Ada.Directories;
with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;	use Ada.Strings.Unbounded;

package KOW_View_Tools is


	Prefix		: constant String := Ada.Strings.Fixed.Trim( "/home/ogro/.kvdriver ", Ada.Strings.Both );
	-- the trim is to fix a minor build system bug

	Skel_Path	: constant Unbounded_String := To_Unbounded_String( 
								Ada.Directories.Full_Name( Prefix & "/share/kvdriver/skel" )
								);

	App_Skel_Path	: constant Unbounded_String := To_Unbounded_String(
								Ada.Directories.Full_Name( Prefix & "/share/kvdriver/skel-application" )
								);
	Tools_Skel_Path	: constant String := Ada.Directories.Full_Name( Prefix & "/share/kvdriver/skel-tools" );


	function Project_Name return String;
	function Destination_Path( Name : in String ) return String;
	function Destination_Path( Name : in Unbounded_String ) return String;

end KOW_View_Tools;
