	KOW_Ent.Entity_Registry.Add_Property(
			Entity_Tag	=> @_application_@.entities.@_entity_@'Tag,
			Property	=> KOW_Ent.Extra_Properties.dimension_Properties.New_Property(
							Column_Name	=> "@_column_name_@",
							Getter		=> @_getter_@'Unrestricted_Access,
							Setter		=> @_setter_@'Unrestricted_Access
							@@IF@@ @_immutable_@ /= ""
								,Immutable	=> @_immutable_@
							@@END_IF@@
						)
			@@IF@@ @_is_unique_@ /= ""
				,Is_Unique => @_is_unique_@
			@@END_IF@@
		);

