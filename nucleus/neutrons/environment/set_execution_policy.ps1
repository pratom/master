# Import-Module PowerYaml
# need to set it globally.  fire up powershell as an admin, set it.
# These require changes to Active Directory Group Policy Objects...................................
# Set-ExecutionPolicy -Force -ExecutionPolicy:Bypass -Confirm:$false -Scope:MachinePolicy
# Set-ExecutionPolicy -Force -ExecutionPolicy:Bypass -Confirm:$false -Scope:UserPolicy
# These can be set at the command line.............................................................

WRITE-DEBUG "BEGIN : Setting Execution Policy to Bypass"
Set-ExecutionPolicy -Force -ExecutionPolicy:Bypass -Confirm:$false -Scope:Process
Set-ExecutionPolicy -Force -ExecutionPolicy:Bypass -Confirm:$false -Scope:CurrentUser
Set-ExecutionPolicy -Force -ExecutionPolicy:Bypass -Confirm:$false -Scope:LocalMachine
WRITE-DEBUG "END : Setting Execution Policy to Bypass"
# Get-ExecutionPolicy -List
<#
Scope               ExecutionPolicy
-----                ---------------
MachinePolicy        Undefined
UserPolicy           Undefined
Process              Undefined
CurrentUser          RemoteSigned
LocalMachine         Unrestricted
#>