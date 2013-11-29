Function computer_change_name
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$true)][string] $new_computer_name )    
    $computer = Get-WmiObject Win32_ComputerSystem 
    $computer.rename("$new_computer_name")
}

Function UI_computer_change_name
{
    [cmdletbinding()] Param ()
    $new_computer_name = Read-Host -Prompt "Enter the new computer name:"
    computer_change_name -new_computer_name:$new_computer_name
}