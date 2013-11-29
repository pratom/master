<#
.EXAMPLE
    PS C:\> computer_get_memory_size
    8589934592
#>
Function computer_get_memory_size
{
    # Type long (64-bit integer) is necessary because the WMI class state the capacity in byte --> might be too long for int32 ;-)
    [long]$memory = 0

    # Get the WMI class Win32_PhysicalMemory and total the capacity of all installed memory modules
    Get-WmiObject -Class Win32_PhysicalMemory | ForEach-Object -Process { $memory += $_.Capacity }

    return $memory
}


