<#
.SYNOPSIS
        Returns object with properties:
            .Major
            .Minor
            .Build
            .Revision

.EXAMPLE
        $ver = what_version_of_powershell_is_running
        $major = $ver.Major 
        write-host "Powershell major version is [$major]."
 #>
Function what_version_of_powershell_is_running
{
    [cmdletbinding()]
    Param (
        )
    return $PSVersionTable.PSVersion
}