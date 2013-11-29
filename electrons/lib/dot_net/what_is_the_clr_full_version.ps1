<#
.SYNOPSIS
        returns a string containing a version #.  The version # is major.minor.build.revision, n.n.n.n

.EXAMPLE
        $var=what_is_the_clr_full_version
        write-host $var
 #> 
Function what_is_the_clr_full_version
{
    [cmdletbinding()] Param ()
    $ret_var = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version -EA 0 |
    Where { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select PSChildName,Version |
    Where-Object { $_.PSChildName -eq 'Full' } |
    Select Version 

    if ( $ret_var -eq $null )
    {
        return "0"
    }
    else {
        return $ret_var.Version.ToString()  
    }
}