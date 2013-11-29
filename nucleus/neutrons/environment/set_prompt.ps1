






<#
http://www.computerperformance.co.uk/powershell/powershell_profile_ps1.htm

PowerShell Prompt

The default PowerShell prompt displays the current working directory.

To display the prompt definition:
(Get-Command prompt).definition


PS C:\projects\ready_bake> (Get-Command prompt).definition
"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
# .Link
# http://go.microsoft.com/fwlink/?LinkID=225750
# .ExternalHelp System.Management.Automation.dll-help.xml

PS C:\projects\ready_bake>

#>


<#
The prompt function can be changed by simply creating a function called 'prompt' this can be just for the current session, or if saved in your profile will apply to all future sessions.

A simple prompt showing the current location:

function prompt { 'PS ' + $(get-location) + '> ' }

or using the automatic variable $pwd

function prompt { 'PS ' + $pwd + '> ' }

Display only the current folder instead of the full path (via Larry Weiss)
function prompt { 
'PS ' + ($pwd -split '\\')[0]+' '+$(($pwd -split '\\')[-1] -join '\') + '> '
}

Display a different prompt when logged in as an Administrator, note this calculates the Administrator membership once (in the PowerShell profile) rather than every time the prompt() function is run:



Function prompt { $Admin + "PS $(get-location)> " }

Window Title
The Window Title can also be modified as part of the prompt definition. By default this is the username followed by "Windows PowerShell"

$host.ui.rawui.WindowTitle = "String you want to show on the title bar"

Display the current location in the title bar:

$host.ui.rawui.WindowTitle = "PS $pwd"

To display the current Host settings including WindowTitle: 
$ 

#>



function prompt { 
   # our theme 
   $cdelim = [ConsoleColor]::DarkCyan 
   $chost = [ConsoleColor]::Green 
   $cloc = [ConsoleColor]::Cyan 

   Microsoft.PowerShell.Utility\write-host "$([char]0x0A7) " -n -f $cloc 
   Microsoft.PowerShell.Utility\write-host ([net.dns]::GetHostName()) -n -f $chost 
   Microsoft.PowerShell.Utility\write-host ' {' -n -f $cdelim 
   Microsoft.PowerShell.Utility\write-host (shorten-path (pwd).Path) -n -f $cloc 
   Microsoft.PowerShell.Utility\write-host '}' -n -f $cdelim 
   write-host '------------------------>'
   return ' ' 
}

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

# One thing to keep in mind regarding shorten-path: I do a very simple replace of $HOME by ~. The reason it works correctly is that I ensure in my profile script that the $HOME variable has a fully qualified path and "completed" using the resolve-path command. I also modify what the home directory is under PowerShell by using a trick I've described previously


<#
#
# Set the $HOME variable for our use
# and make powershell recognize ~\ as $HOME
# in paths
#
set-variable -name HOME -value (resolve-path $env:Home) -force
(get-psprovider FileSystem).Home = $HOME

#>



