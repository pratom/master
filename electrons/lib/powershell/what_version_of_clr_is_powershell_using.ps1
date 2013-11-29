<#
.SYNOPSIS
        Returns object with properties:
            .Major
            .Minor
            .Build
            .Revision

.EXAMPLE
        $ver = what_version_of_clr_is_powershell_using
        $major = $ver.Major 
        write-host "Powershell is using clr major version, [$major]."
 #>    
Function what_version_of_clr_is_powershell_using
{
    [cmdletbinding()]
    Param ()
    return $PSVersionTable.CLRVersion
}