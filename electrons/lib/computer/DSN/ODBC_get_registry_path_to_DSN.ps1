Function ODBC_get_registry_path_to_DSN
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=0)][string]$mem_arch
    ,[Parameter(Mandatory=$True,Position=1)][string]$DSNName
    )
    write-debug "ODBC_get_registry_path_to_DSN - BEGIN"
    $registry_path = DSN_get_registry_path $mem_arch
    return $registry_path + ([pratom.constants.registry.ODBC_DSN]::Value) + $DSNName
}