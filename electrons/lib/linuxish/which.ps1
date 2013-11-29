
<#
.SYNOPSIS
    tells me the location of where an executable lives
#>
function which($name) 
    { 
        Get-Command $name | Select-Object Definition 
    }