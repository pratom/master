<#
.SYNOPSIS
Retrieves info from one or more computers.
.PARAMETER computername
The computer name(s) to retrieve the info from.
.PARAMETER logfile
The path and filename of a text file where failed computers will be logged. Defaults to c:\retries.txt.
.EXAMPLE
Get-ADComputer –filter * | Select @{label='computername';expression={$_.name}} | Get-Info
.EXAMPLE
Get-Info –computername SERVER2,SERVER3
.EXAMPLE
"localhost" | Get-Info
.EXAMPLE
Get-Info –computername (Get-Content names.txt)
.EXAMPLE
Get-Content names.txt | Get-Info
#>
<#
Function Get-ComputerInfo 
{
      [CmdletBinding()]
      Param(
                  [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
                  [string[]]$computername,
                  [string]$logfile = 'c:\retries.txt'
            )

      BEGIN {
            Remove-Item $logfile –erroraction silentlycontinue
            }
            
      PROCESS {
            Foreach ($computer in $computername) {
                  $continue = $true
                  try {
                        $os = Get-WmiObject –class Win32_OperatingSystem –computername $computer –erroraction Stop
                  } catch {
                        $continue = $false
                        $computer | Out-File $logfile
                  }
                  if ($continue) {
                        $bios = Get-WmiObject –class Win32_BIOS –computername $computer
                        $obj = New-Object –typename PSObject
                        $obj | Add-Member –membertype NoteProperty –name ComputerName –value ($computer) –passthru |
                        Add-Member –membertype NoteProperty –name OSVersion –value ($os.caption) –passthru |
                        Add-Member –membertype NoteProperty –name OSBuild –version ($os.buildnumber) –passthru |
                        Add-Member –membertype NoteProperty –name BIOSSerial –value ($bios.serialnumber) –passthru |
                        Add-Member –membertype NoteProperty –name SPVersion –value ($os.servicepackmajorversion)
                        Write-Output $obj  # out to pipe
                  }
                 
            }
      }
}
#>