
<#
Function get_child_item_names
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$True,Position=1)][string]$parent_path
    )
    $DebugPreference = "Continue"
    Write-Debug "get_child_item_names BEGIN"
    
    [string[]]$child_names = @('x')

    Get-ChildItem -path $parent_path -name | foreach-object {
            $child_names += $_
            Write-Debug $_
        }
    Write-Debug "get_child_item_names END"    
    return $child_names
}

Function print_DSNs_installed
{
    [cmdletbinding()]
    Param (
    )
    $ODBC_DSN_LIST = (ODBC_get_registry_path_to_DSN_LIST ([pratom.enums.computer_memory_architecture._64_bit]::Value))
    Write-Host ""
    Write-Host ""    
    Write-Host ""
    Write-Host ""
    Write-Host "$ODBC_DSN_LIST"
    Write-Host "------------------------------------------------------------------------------------"
    foreach($child_name in (get_child_item_names -parent_path:$ODBC_DSN_LIST)) {
        Write-Host "$child_name"
    }
    Write-Host "------------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
}
#>