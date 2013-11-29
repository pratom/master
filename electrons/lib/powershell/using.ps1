<#
.SYNOPSIS
      http://weblogs.asp.net/adweigert/archive/2008/08/27/powershell-adding-the-using-statement.aspx
      Take an object and a script block
      ensures that the object's method, Dispose() is called after execution of the script block
      mimics C#'s using statement
.EXAMPLE
    # Short example ... 
    Using ($user = $sr.GetDirectoryEntry()) { 
      $user.displayName = $displayName 
      $user.SetInfo()       
#>

function Using {
    param (
        [System.IDisposable] $inputObject = $(throw "The parameter -inputObject is required."),
        [ScriptBlock] $scriptBlock = $(throw "The parameter -scriptBlock is required.")
    )
    
    Try 
      {
          &$scriptBlock
      } 
    Finally 
      {
          if ($inputObject -ne $null) 
            {
                if ($inputObject.psbase -eq $null) 
                  {
                      $inputObject.Dispose()
                  } 
                else 
                  {
                      $inputObject.psbase.Dispose()
                  }
            }
      }
}