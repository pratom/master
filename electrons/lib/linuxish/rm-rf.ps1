<#
.SYNOPSIS
	nukes a file or folder and all its contents
#>
function rm-rf($item) 
	{ 
		Remove-Item $item -Recurse -Force 
	}