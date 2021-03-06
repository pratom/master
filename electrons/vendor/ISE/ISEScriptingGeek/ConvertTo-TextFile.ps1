#requires -version 2.0

# -----------------------------------------------------------------------------
# Script: ConvertTo-TextFile.ps1
# Version: 1.0
# Author: Jeffery Hicks
#    http://jdhitsolutions.com/blog
#    http://twitter.com/JeffHicks
# Date: 3/14/2011
# Keywords: ISE
# Comments:
#
# "Those who forget to script are doomed to repeat their work."
#
#  ****************************************************************
#  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
#  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
#  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
#  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
#  ****************************************************************
# -----------------------------------------------------------------------------

Function ConvertTo-TextFile {

    Param (
      [switch]$Reload
    )

    #verify we are in the ISE
    if ($psise) {
        #get the current file name and path and change the extension
        $psVersion=$psise.CurrentFile.FullPath
        $textVersion=$psversion -replace "ps1","txt"

        #save the file.
        $psise.CurrentFile.SaveAs($textVersion)

        #if -Reload then reload the PowerShell file into the ISE
        if ($Reload)
        {
            $psise.CurrentPowerShellTab.Files.Add($psVersion)
        }
    } #if $psise
    else 
    {
        Write-Warning "This function requires the Windows PowerShell ISE."
    }
} #end function