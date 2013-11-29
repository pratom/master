<#
.EXAMPLE
Test-Path -LiteralPath:"" -IsValid
  "".path_is_valid
  "C:\".path_is_valid
  path_is_valid ""
#>


Function is_numeric
{
    [cmdletbinding()] Param ( 
              [string] $var
      )
    [reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
    return ( [Microsoft.VisualBasic.Information]::isnumeric($var) )
}
Function add_member_is_numeric
{
    [cmdletbinding()] Param ()
    $script_block_get={ is_numeric $this }
    extend_datatype_with_method -member_name:path_is_to_file -script_block_get:$script_block_get -type_name:System.String
}
add_member_is_numeric


<#
I'm leaving System.String.ps1 here, because I intend on coming back and adding these methods

ScriptProperties DO NOT throw exceptions
ScriptMethods DO throw exceptions

TODO: Add the path functions as methods of string.  path functions are in pratom_nucleus, so they are available in this scope.
#>