<#
.SYNOPSIS
        Returns a collection of objects.  Each object has 2 properties - PSChildName, Version.  If no .Net CLR are installed, the return value is $null.
 #>     
Function what_versions_of_dot_net_are_installed
{
    [cmdletbinding()] Param ()
    $ret_var = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version -EA 0 |
    Where { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select PSChildName, Version

    return $ret_var
}