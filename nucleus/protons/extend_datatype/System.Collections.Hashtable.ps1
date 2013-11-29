<#
.SYNOPSIS
    Creates New Hash, sorted
    Sets the $hash_to_sort to the new hash, effectively replacing the $hash_to_sort 
.EXAMPLE
    [System.Collections.Hashtable]$usa_states=@{ "4" = "2"; "1"="3";  "2" = "1"; "3" = "4"}
    Sorted_Enumerate -hash:$usa_states  | Format-Table
    Sorted_Enumerate -hash:$usa_states  | Format-List
    Sorted_Enumerate -hash:$usa_states  | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -KEY | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -KEY -ASCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -KEY -DESCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -VALUE -DESCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -VALUE -ASCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -VALUE | ForEach-Object { write-host "$($_.Name) = $($_.Value)" } 
    Sorted_Enumerate -hash:$usa_states -ASCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" }
    Sorted_Enumerate -hash:$usa_states -DESCENDING | ForEach-Object { write-host "$($_.Name) = $($_.Value)" }
#>

Function Sorted_Enumerate
{
  [cmdletbinding()]
  PARAM
  (
    [
        Parameter (
                    Mandatory=$true , Position=0 , ValueFromPipeline = $true , ValueFromPipelineByPropertyName = $false , ValueFromRemainingArguments = $true 
                    )
    ]                                 [System.Collections.Hashtable] $hash
    , [switch]                        $KEY = $false
    , [switch]                        $VALUE = $false
    , [switch]                        $ASCENDING = $false
    , [switch]                        $DESCENDING = $false
  )

    PROCESS
    {

        $who_me = "Hash_Enum_Sorted"

        if ($KEY -eq $true -and $VALUE -eq $true)               { throw "-KEY and -VALUE switches may not both be true." }
        if ($ASCENDING -eq $true -and $DESCENDING -eq $true)    { throw "-ASCENDING and -DESCENDING switches may not both be true." }
        if ($KEY -eq $false -and $VALUE -eq $false)             { $KEY = $true }
        if ($ASCENDING -eq $false -and $DESCENDING -eq $false)   { $ASCENDING = $true }



        switch ($KEY)
        {
            $true{
                write-debug "$who_me key=Sort by hash key"
                switch ($ASCENDING)
                {
                    $true {
                        write-debug "$who_me key=Sort by hash key ascending"
                        $hash.GetEnumerator() | Sort-Object Name  | ForEach-Object { write-output(@{Name=$_.Name;Value=$_.Value}) <# write to pipe #> }
                    }
                    $false {
                        write-debug "$who_me key=Sort by hash key decscending"
                        $hash.GetEnumerator() | Sort-Object Name -descending | ForEach-Object { write-output(@{Name=$_.Name;Value=$_.Value}) <# write to pipe #> }  
                    }
                }
            }
            $false{
                write-debug "$who_me key=Sort by hash value"
                switch ($ASCENDING)
                {
                    $true {
                        write-debug "$who_me key=Sort by hash value, ascending"
                        $hash.GetEnumerator() | Sort-Object Value | ForEach-Object  { write-output(@{Name=$_.Name;Value=$_.Value})<# write to pipe #> }  
                    }
                    $false {
                        write-debug "$who_me key=Sort by hash value, descending"
                        $hash.GetEnumerator() | Sort-Object Value -descending | ForEach-Object  { write-output(@{Name=$_.Name;Value=$_.Value})<# write to pipe #> }   
                    }
                }
            }        
        }
    }
}








<#
Function PRIVATE:add_member_Sorted_Enumerate
{
    [cmdletbinding()] Param ()
    $script_block = {return(Sorted_Enumerate -hash:$this)}
    extend_datatype_with_method -member_name:Sorted_Enumerate -script_block_get:$script_block -type_name:System.Collections.Hashtable
}
add_member_Sorted_Enumerate
#>
