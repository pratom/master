 function Get-FunctionName { 
    # -scope 1 means to get it for the calling function
    return (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
}