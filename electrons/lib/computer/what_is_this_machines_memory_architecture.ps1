function computer_what_its_memory_architecture
{
    [cmdletbinding()] Param ()
    
    [string]$_this_machines_mem_architecture=(Get-WmiObject Win32_OperatingSystem).OSArchitecture
    return $_this_machines_mem_architecture
}