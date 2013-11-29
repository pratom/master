Function Open_ODBC_manager_for_user
{
    [cmdletbinding()] Param ( )
    
    $mem_arch = computer_what_its_memory_architecture
    $system_drive =  [System.Environment]::ExpandEnvironmentVariables("%systemdrive%")

    if ($mem_arch -eq ([pratom.enums.computer_memory_architecture._32_bit]::Value))
    {
        "$system_drive\Windows\SysWoW64\Odbcad32.exe" | Invoke-Item 
    }
    elseif ($mem_arch -eq ([pratom.enums.computer_memory_architecture._64_bit]::Value))
    {
        "$system_drive\Windows\System32\Odbcad32.exe" | Invoke-Item 
    }
    else{
        throw "Unknown memory architecture from the machine OS.  machine OS memory architecture=[$mem_arch]...I was expecting [$(([pratom.enums.computer_memory_architecture._32_bit]::Value))] or [$(([pratom.enums.computer_memory_architecture._64_bit]::Value))]"
    }
}