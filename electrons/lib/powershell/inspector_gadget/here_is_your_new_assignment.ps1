Function here_is_your_new_assignment
{
    [cmdletbinding()] Param ( 
        [Parameter(Mandatory=$False)] [Object]      $object_to_inspect 
        # Mandatory=$False --> :(  If $true, null and empty strings would fail before they even got here.
        , [Parameter(Mandatory=$True)] [string]     $label_for_the_object_to_inspect 
        )
    [string] $inspection_report = (formatted_obj -formatting_name:$name -obj:$errorRecord_to_read -Verbose:$true)
    return $inspection_report
}