Function DSN_get_registry_path
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True,Position=0)][string]$mem_arch
    )
    write-debug "DSN_get_registry_path - BEGIN"
    if ($mem_arch -eq ([pratom.enums.computer_memory_architecture._32_bit]::Value))
        {
            $registry_path = ([pratom.constants.registry.path_to_odbc_32bit_on_a_64bit_machine]::Value)
        }
    elseif ($mem_arch -eq ([pratom.enums.computer_memory_architecture._64_bit]::Value))
        {
            $registry_path = ([pratom.constants.registry.path_to_odbc_64bit]::Value)
        }
    else
        {
            throw "Unknown memory architecture memory_architecture=[$mem_arch.]";
        }
    return $registry_path
}