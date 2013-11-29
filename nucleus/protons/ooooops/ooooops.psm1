$oops_dir = $PSScriptRoot
. $oops_dir\ooooops_describe_error_briefly.ps1
<# . $oops_dir\ooooops_describe_global_error_variable.ps1 #>
Export-ModuleMember -Function ooooops_describe_error_briefly 
Export-ModuleMember -Function ooooops_describe_error 
<# Export-ModuleMember -Function ooooops_describe_global_error_variable  #>