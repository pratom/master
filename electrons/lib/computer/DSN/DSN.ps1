<#
map out the registry locations for [pratom.constants.registry.path_to_odbc_32bit_on_a_64bit_machine]::Value, like I did for 64 bit......NOT NEEDED...
Do not hardcode the driver paths.  Pull them from the registry............We can probably get away with not doing this
TODO: Before adding DSN, test to see if the DLL actually exists...This is a reallty good idea for the tribal/checks.ps1 file
TODO: Unit testing for powershell
#>


# Script Enums --------------------------------------------------------------------------------------------
pr_enum "computer_memory_architecture" "32-bit"
pr_enum "computer_memory_architecture" "64-bit"
<#
write-host "$([pr_e._32b_bit].Name) = $([pr_e._32_bit])"
Write-host "$([pr_e.bit_32].Name) = $([pratom.enums.computer_memory_architecture._32_bit])"

write-host "$([pr_e._32b_bit].Name) = $([pr_e._64_bit])"
Write-host "$([pr_e.bit_32].Name) = $([pratom.enums.computer_memory_architecture._64_bit])"
#>
pr_enum "MSSQL_Drivers"     "WDAC"          "SQL Server"
pr_enum "MSSQL_Drivers"     "native_9"      "SQL Native Client"
pr_enum "MSSQL_Drivers"     "native_10"     "SQL Server Native Client 10.0"
pr_enum "MSSQL_Drivers"     "native_11"     "SQL Server Native Client 11.0"    
pr_enum "MSSQL_Drivers"     "native_12"     "SQL Server Native Client 12.0" 
# Script Enums --------------------------------------------------------------------------------------------



# Script Constants --------------------------------------------------------------------------------------------
pr_constant "registry" "path_to_odbc_32bit_on_a_64bit_machine"  "HKLM:\SOFTWARE\Wow6432Node\"
pr_constant "registry" "path_to_odbc_64bit"                     "HKLM:\SOFTWARE\"
pr_constant "registry" "ODBC_DSN"                               "ODBC\ODBC.INI\"
pr_constant "registry" "ODBC_DSN_LIST"                          "ODBC\ODBC.INI\ODBC Data Sources"


pr_constant "MSSQL_Drivers"     "WDAC"         "sqlsrv32.dll"
pr_constant "MSSQL_Drivers"     "native_9"     "sqlncli.dll"
pr_constant "MSSQL_Drivers"     "native_10"    "sqlncl10.dll"
pr_constant "MSSQL_Drivers"     "native_11"    "sqlncl11.dll"
pr_constant "MSSQL_Drivers"     "native_12"    "sqlncl12.dll"
# Script Constants --------------------------------------------------------------------------------------------



# These Must be looked up in the registry per DLL --------------------------------------------------------------------------------------------
[string]$SCRIPT:_m_driver_32bit_on_64bit       = "C:\WINDOWS\SysWOW64\"
[string]$SCRIPT:_m_driver_64bit                = "C:\WINDOWS\System32\"
# These Must be looked up in the registry per DLL --------------------------------------------------------------------------------------------

<#
# Not tested, but if you need it, you get the idea.....
Function DSN_ADD_32_bit_to_64_bit_list
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=1)][string]$DSNName
    , [Parameter(Mandatory=$True,Position=2)][string]$driver_name
    )
    Write-Debug "DSN_ADD_32_bit_to_64_bit_list BEGIN"

    [string]$registry_path = DSN_get_registry_path [pratom.enums.computer_memory_architecture._64_bit]::Value
    [string]$ODBC_DSN_path = ODBC_get_registry_path_to_DSN [pratom.enums.computer_memory_architecture._64_bit]::Value $DSNName
    [string]$ODBC_DSN_LIST = ODBC_get_registry_path_to_DSN_LIST [pratom.enums.computer_memory_architecture._64_bit]::Value
    [string]$driver_full_path = DSN_get_dll_path $driver_name [pratom.enums.computer_memory_architecture._32_bit]::Value

    DSN_ADD_TO_REGISTRY $DSNName $driver_name $server_name $DBName $user_name $password $driver_full_path $ODBC_DSN_path $ODBC_DSN_LIST
    
    Write-Debug "DSN_ADD_32_bit_to_64_bit_list FINISHED"   
}
#>

pr_include (code_to_load_a_file "$PSScriptRoot\DSN_ADD.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\DSN_ADD_64_bit.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\DSN_ADD_TO_REGISTRY.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\DSN_get_dll_path.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\DSN_get_driver_path.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\DSN_get_registry_path.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\ODBC_get_registry_path_to_DSN.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\ODBC_get_registry_path_to_DSN_LIST.ps1")
pr_include (code_to_load_a_file "$PSScriptRoot\Test_DSN.ps1")