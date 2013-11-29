# prompt customization coming from the following:
# http://winterdom.com/2008/08/mypowershellprompt
function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

# This is function is called by convention in PowerShell
function prompt { 
   # our theme 
   $cdelim = [ConsoleColor]::DarkCyan 
   $chost = [ConsoleColor]::Green 
   $cloc = [ConsoleColor]::Cyan 

   Microsoft.PowerShell.Utility\write-host "$([char]0x0A7) "              -n -f $cloc 
   Microsoft.PowerShell.Utility\write-host ([net.dns]::GetHostName())     -n -f $chost 
   Microsoft.PowerShell.Utility\write-host ' {'                           -n -f $cdelim 
   Microsoft.PowerShell.Utility\write-host (shorten-path (pwd).Path)      -n -f $cloc 
   Microsoft.PowerShell.Utility\write-host '}'                            -n -f $cdelim 

   return '> '
}

prompt