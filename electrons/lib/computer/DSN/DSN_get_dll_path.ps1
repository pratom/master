Function DSN_get_dll_path
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=0)][string]$driver_name
    , [Parameter(Mandatory=$True,Position=1)][string]$mem_arch
    )
    write-debug "DSN_get_dll_path - BEGIN"
    [string]$driver_path = DSN_get_driver_path($mem_arch)
    [string]$driver_file_name = ""
    switch ($driver_name)
    {
        ([pratom.enums.MSSQL_Drivers.WDAC]::Value) { $driver_file_name = $driver_path + [pratom.constants.MSSQL_Drivers.WDAC]::Value }
        ([pratom.enums.MSSQL_Drivers.native_9]::Value) { $driver_file_name = $driver_path + [pratom.constants.MSSQL_Drivers.native_9]::Value }
        ([pratom.enums.MSSQL_Drivers.native_10]::Value) { $driver_file_name = $driver_path + [pratom.constants.MSSQL_Drivers.native_10]::Value }
        ([pratom.enums.MSSQL_Drivers.native_11]::Value) { $driver_file_name = $driver_path + [pratom.constants.MSSQL_Drivers.native_11]::Value } 
        default {throw "Unknown driver name driver_name=[$driver_name]";}
    }

    return $driver_file_name
}


