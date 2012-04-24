


--------------
-- Ada 2005 --
--------------
with Ada.Command_Line;			use Ada.Command_Line;
with Ada.Text_IO;			use Ada.Text_IO;


-------------------
-- KOW Framework --
-------------------
with KOW_Ent;
with KOW_Sec.Entities;

with @_project_name_@_Setup;



procedure @_project_name_@_useradd is
begin

	if Argument_Count /= 2 then
		Put_Line( "Usage : " );
		Put_line( Command_Name & " username password" );
		return;
	end if;




	if Argument_Count /= 2 then
		Put_Line( "Usage : " );
		Put_line( Command_Name & " username password" );
		return;
	end if;

	@_project_name_@_Setup;

	Put_Line( "user " & KOW_Sec.To_String( KOW_Sec.Entities.New_User(
								Username	=> Argument( 1 ),
								Password	=> Argument( 2 )
						) ) & " created!" );
end @_project_name_@_useradd;
