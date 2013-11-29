http://blogs.msdn.com/b/powershell/archive/2009/01/04/extending-and-or-modifing-commands-with-proxies.aspx

Extending and/or Modifing Commands with Proxies

PowerShell Team 4 Jan 2009 11:55 AM 4
There are so many powerful features in V2, it is hard to know where to begin.  This one is going to blow to top of your head off when you understand what it enables you to do.

In this blog, I talk about Proxy Cmdlets which is the ability for one Cmdlet to call another.  You could always do this but to do it right has always been very difficult.  In particular, what you want to have happen is to be able to control the execution of the calling command - to control when it's BEGINPROCESS(), PROCESSRECORD(), ENDPROCESS(), etc methods are called so that it behave with the correct behavior.  What you needed was a "Steppable Pipeline".  You know have that in CTP3.  Now the bit-biters will want to explore steppable pipelines to great detail as they can be both powerful and complex - BUT the thing I want to make clear is that EVERYONE can and should use them to great effect by simply following the recipe I'm going to provide you in this blog and with the attached Module.

 

Scenario 1:  Removing Functions
Image the case where you are Configuring PowerShell for Remoting and you are setting up an ConfigurationName which will give people access to some but not all commands.  You might want to also further restrict the commands  you do provide. 

 

Scenario 2: Adding Functions
In V2 CTP3 we added the -FileVersionInfo and -Module parameters to Get-Process (did you know that?  Stop a minute and go give them a try - they are pretty cool/useful.  try this:  gps powershell -FileVersionInfo |fl * ).  With proxies - you could do this yourself very easily.

 

Concept
Let's take a minute and get things into focus.  PowerShell Cmdlets are .NET classes with attributes on the properties.  WHY?  Because that allows us to reflect on them and EXTRACT ITS METADATA (its grammar).  We then use that grammar to drive a command command line syntax.  This is the magic behind PowerShell.  You'll see us do all sorts of wonderful things with this in the future (e.g. early-bound WebService interface, emit earlybound C# accessors, autogenerate GUI front ends, etc., etc.).  The big things we did in V2 is

1) We expose the metadata.  You can do a New-Object on System.Management.Automation.CommandMetaData passing it cmdletInfo and get it's metadata.  Try this: 
    PS> New-Object System.Management.Automation.CommandMetaData (gcm Get-Process)

2) We make the metadata programmable.  You can add/remove parameters, change the parameters, change the name, etc.

3) We use metadata to emit a script Cmdlet. 
    PS> $metaData = New-Object System.Management.Automation.CommandMetaData (gcm Get-Process) 
    PS> [System.Management.Automation.ProxyCommand]::create($MetaData)

 

 

Developers and advanced scripters are going to be all over that like white on rice but that can get to be chewy stuff for novice scripters.  Does that mean that Novice scripters won't use this?  ABSOLUTELY NOT!  With PowerShell, people produce abstractions to enable other groups of people.  Advanced scripters often produce abstractions which enable lower skilled scripters to do things they would not have been able to do on their own.  That is what this blog is about.  I've attached a MetaProgramming Module which (hopefully) make this a pretty simple task.

PS> Import-Module MetaProgramming 

PS> Get-Command -Module MetaProgramming

CommandType     Name                          Definition 
-----------     ----                          ---------- 
Function        New-ParameterAttribute        ... 
Function        New-ProxyCommand              ...


PS> Get-Help New-ProxyCommand -Detailed

NAME 
    New-ProxyCommand

SYNOPSIS 
    Generate a script for a ProxyCommand to call a base Cmdlet adding or re 
    moving parameters.

SYNTAX 
    New-ProxyCommand [[-Name] [<String>]] [[-CommandType] [<CommandTypes>]] 
     [[-AddParameter] [<String[]>]] [[-RemoveParameter] [<String[]>]] [[-Ad 
    dParameterAttribute] [<Hashtable>]] [<CommonParameters>]

DETAILED DESCRIPTION 
    This command generates command which calls another command (a ProxyComm 
    and). 
    In doing so, it can add additional attributes to the existing parameter 
    s. 
    This is useful for things like enforcing corporate naming standards. 
    It can also ADD or REMOVE parameters.  If you ADD a parameter, you'll h 
    ave 
    to implement the semantics of that parameter in the code that gets gene 
    rated.

PARAMETERS 
    -Name 
        Name of the Cmdlet to proxy.

    -CommandType 
        Type of Command we are proxying.  In general you dont' need to spec 
        ify this but 
        it becomes necessary if there is both a cmdlet and a function with 
         the same 
        name

    -AddParameter 
        List of Parameters you would like to add. NOTE - you have to edit t 
        he resultant 
        code to implement the semantics of these parameters.  ALSO - you ne 
        ed to remove 
        them from $PSBOUND

    -RemoveParameter

    -AddParameterAttribute

    <CommonParameters> 
        This cmdlet supports the common parameters: -Verbose, -Debug, 
        -ErrorAction, -ErrorVariable, -WarningAction, -WarningVariable, 
        -OutBuffer and -OutVariable. For more information, type, 
        "get-help about_commonparameters".

    -------------------------- EXAMPLE 1 --------------------------

    New-ProxyCommand get-process -typ all -RemoveParameter FileVersionInfo, 
    Module,ComputerName -AddParameter SortBy > c:\ps\get-myprocess.ps1 
REMARKS 
    To see the examples, type: "get-help New-ProxyCommand -examples". 
    For more information, type: "get-help New-ProxyCommand -detailed". 
    For technical information, type: "get-help New-ProxyCommand -full".

 

 

So let's try a simple example to see how easy it can be:

PS>New-ProxyCommand get-process -RemoveParameter ID > .\get-myprocess.ps1 
PS>.\Get-MyProcess -Name lsass

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName 
-------  ------    -----      ----- -----   ------     -- ----------- 
   1126      17     5796      11744    37    97.64    488 lsass

PS>.\Get-MyProcess -ID 488 
C:\temp\get-myprocess.ps1 : A parameter cannot be found that matches parame 
ter name 'ID'. 
At line:1 char:20 
+ .\Get-MyProcess -ID <<<<  488 
    + CategoryInfo          : InvalidArgument: (:) [get-myprocess.ps1], Pa 
   rameterBindingException 
    + FullyQualifiedErrorId : NamedParameterNotFound,get-myprocess.ps1

 

 

Adding parameter is a bit more complicated but if you follow the steps - it is pretty straightforward (It might look intimidating but trust me - just do it a couple times and you'll see that is is super simple.).  How do you know what the steps are?  I put it into the script.  If you the following command:

PS> New-ProxyCommand get-process -AddParameter SortBy > .\get-myprocess.ps1 
PS> Powershell_ise .\get-myprocess.ps1 

This is what you'll see at the top of that file:

<# 
You are responsible for implementing the logic for added parameters.  These 
parameters are bound to $PSBoundParameters so if you pass them on the the 
command you are proxying, it will almost certainly cause an error.  This logic 
should be added to your BEGIN statement to remove any specified parameters 
from $PSBoundParameters.

In general, the way you are going to implement additional parameters is by 
modifying the way you generate the $scriptCmd variable.  Here is an example 
of how you would add a -SORTBY parameter to a cmdlet:

        if ($SortBy) 
        { 
            [Void]$PSBoundParameters.Remove("SortBy") 
            $scriptCmd = {& $wrappedCmd @PSBoundParameters |Sort-Object -Property $SortBy} 
        }else 
        { 
            $scriptCmd = {& $wrappedCmd @PSBoundParameters } 
        } 
################################################################################        
New ATTRIBUTES 
        if ($SortBy) 
        { 
            [Void]$PSBoundParameters.Remove("SortBy") 
        }

################################################################################ 
#>