################################################################################
function New-ParameterAttribute
{
<#
.Synopsis
    Creates a PowerShell ParameterAttribute.
.Description
    This command is used in metaprogramming scenarios where you dynamically
    generate a cmdlet on the fly.  Parameters of Cmdlets must have a Parameter 
    Attribute attached to them to tell PowerShell what to do with the parameter.
    This command generates that attribute.
.Parameter Position 
    What position to map this parameter to when users don't use named parameters.
.Parameter ParameterSetName 
.Parameter Mandatory 
    Is this parameter Mandatory
.Parameter ValueFromPipeline 
    Does this parameter take a value from the pipeline object
.Parameter ValueFromPipelineByPropertyName 
    Does the parameter take a value from a property of the pipeline object
.Parameter ValueFromRemainingArguments
    Does this collect the remaining arguments on the command line
.Example
    New-ParameterAttribute
.ReturnValue
    System.Management.Automation.ParameterAttribute
.Link
    New-ProxyCommand
.Notes
 NAME:      New-ParameterAttribute
 AUTHOR:    NTDEV\jsnover
 LASTEDIT:  1/4/2009 8:53:35 AM
#Requires -Version 2.0
#>
[CmdletBinding(
    SupportsShouldProcess=$False,
    SupportsTransactions=$False, 
    ConfirmImpact="None",
    DefaultParameterSetName="")]
param(
[Parameter()]
[Int32]
$Position = [int32]::MinValue,

[Parameter()]
[String]
$ParameterSetName,

[Parameter()]
[Switch]
$Mandatory,

[Parameter()]
[Switch]
$ValueFromPipeline,

[Parameter()]
[Switch]
$ValueFromPipelineByPropertyName,
      
[Parameter()]
[Switch]
$ValueFromRemainingArguments

)
    New-Object System.Management.Automation.ParameterAttribute -Property @{
      Position = $Position
      ParameterSetName = $ParameterSetName
      Mandatory = $Mandatory
      ValueFromPipeline = $ValueFromPipeline
      ValueFromPipelineByPropertyName = $ValueFromPipelineByPropertyName
      ValueFromRemainingArguments = $ValueFromRemainingArguments
    }
} # New-ParameterAttribute





################################################################################
function New-ProxyCommand
{
<#
.Synopsis
    Generate a script for a ProxyCommand to call a base Cmdlet adding or removing parameters.
.Description
    This command generates command which calls another command (a ProxyCommand).
    In doing so, it can add additional attributes to the existing parameters.
    This is useful for things like enforcing corporate naming standards.
    It can also ADD or REMOVE parameters.  If you ADD a parameter, you'll have
    to implement the semantics of that parameter in the code that gets generated.    
.Parameter Name 
    Name of the Cmdlet to proxy.  
.Parameter CommandType 
    Type of Command we are proxying.  In general you dont' need to specify this but
    it becomes necessary if there is both a cmdlet and a function with the same 
    name
.Parameter AddParameter
    List of Parameters you would like to add. NOTE - you have to edit the resultant
    code to implement the semantics of these parameters.  ALSO - you need to remove
    them from $PSBOUND 
.Parameter RemoveParameter
.Example
    New-ProxyCommand get-process -CommandType all -RemoveParameter `
    FileVersionInfo,Module,ComputerName -AddParameter SortBy > c:\ps\get-myprocess.ps1
    
.ReturnValue
    System.String
.Link
    New-ParameterAttribute
.Notes
 NAME:      New-ProxyCommand
 AUTHOR:    NTDEV\jsnover
 ToDo:      Need to modify script to emit template help for the proxy command.
            Probably should add a -AsFunction switch
 LASTEDIT:  1/4/2009 8:53:35 AM
################################################################################
#Requires -Version 2.0
#>

[CmdletBinding(
    SupportsShouldProcess=$False,
    SupportsTransactions=$False, 
    ConfirmImpact="None",
    DefaultParameterSetName="")]
param(
[Parameter(Position=0, Mandatory=$True)]
[String]$Name ,

[Parameter(Position=1)]
[Alias("Type")]
[System.Management.Automation.CommandTypes]$CommandType="All" ,

[Parameter(Position=2)]
[String[]]$AddParameter ,

[Parameter(Position=3)]
[String[]]$RemoveParameter ,

[Parameter(Position=4)]
[HashTable]$AddParameterAttribute
)


    $Cmd = Get-Command -Name $Name -CommandType $CommandType
    if (!$cmd)
    {
        Throw "No such Object [$Name : $CommandType]"
    }elseif (@($cmd).Count -ne 1)
    {
        Throw "Ambiguous reference [$Name : $CommandType]`n$($Cmd |Out-String)"
    }
    $MetaData = New-Object System.Management.Automation.CommandMetaData $cmd
    if ($RemoveParameter)
    {
        foreach ($p in @($RemoveParameter))
        {
            [Void]$MetaData.Parameters.Remove($p)   
        }
    }
    if ($AddParameter)
    {
@'
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
'@
        foreach ($p in @($AddParameter))
        {        
            [Void]$MetaData.Parameters.Add($p, $(New-object System.Management.Automation.ParameterMetadata $p )) 
@"
        if (`$$p)
        {
            [Void]`$PSBoundParameters.Remove("$p")
        }
"@            
        }
"
################################################################################
#>
"
    }
    [System.Management.Automation.ProxyCommand]::create($MetaData) 
}#New-ProxyCommand