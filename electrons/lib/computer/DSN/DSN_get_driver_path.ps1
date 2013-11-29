Function DSN_get_driver_path
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=0)][string]$mem_arch
    )
    write-debug "DSN_get_driver_path - BEGIN"
    [string]$driver_path = ""
    
    switch ($mem_arch)
    {
       ([pratom.enums.computer_memory_architecture._32_bit]::Value) { $driver_path = ([pratom.constants.registry.path_to_odbc_32bit_on_a_64bit_machine]::Value) }
       ([pratom.enums.computer_memory_architecture._64_bit]::Value) { $driver_path = ([pratom.constants.registry.path_to_odbc_64bit]::Value) }
       default {throw "Unknown memory architecture memory_architecture=[$mem_arch.]";}
    }
    return $driver_path
}