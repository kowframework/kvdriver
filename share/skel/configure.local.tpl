#!/usr/bin/env bash
# 
# Local configuration file for @_project_name_@


# Please do change this to reflect your project needs. It's called by configure, so any specific configuration
# code should be placed in here



project="@_lower_project_name_@"
project_type="executable"
include_files=src/* components/*/src/*

mkdir -p gnat
cp src-in/@_lower_project_name_@.gpr.in gnat/@_lower_project_name_@.gpr
replace_in_file gnat/@_lower_project_name_@.gpr @version@ $version

set_configuration @_upper_project_name_@_EXTERNALLY_BUILT "false"
