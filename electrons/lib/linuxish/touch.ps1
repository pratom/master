<#
.SYNOPSIS
    creates an empty file
#>
function touch($file) 
    { 
        "" | Out-File $file -Encoding ASCII 
    }