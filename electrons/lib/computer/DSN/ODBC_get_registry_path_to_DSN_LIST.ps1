Function ODBC_get_registry_path_to_DSN_LIST
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=0)][string]$mem_arch
    )
    write-debug "ODBC_get_registry_path_to_DSN_LIST - BEGIN"
    $registry_path = DSN_get_registry_path $mem_arch
    return $registry_path + ([pratom.constants.registry.ODBC_DSN_List]::Value)
}