<#
.SYNOPSIS
    found at http://www.gregorystrike.com/2011/01/27/how-to-tell-if-powershell-is-32-bit-or-64-bit/
    How to tell if Powershell is 32 bit or 64 bit
#>
function is_powershell_running_as_32_or_64_bits {
    Switch ([System.Runtime.InterOpServices.Marshal]::SizeOf([System.IntPtr])) {
        4 { Return "32-bit" }
        8 { Return "64-bit" }
        default { Return "Unknown Type" }
    }
}