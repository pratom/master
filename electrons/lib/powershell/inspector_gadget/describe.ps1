
set-strictmode –version Latest
$GLOBAL:ErrorActionPreference               = "CONTINUE"

#region formatting ---------------------------------------------------


Function get_object_description
{
    [cmdletbinding()]
    Param (
       [Parameter(Mandatory=$True)]        [object]     $obj
        , [Parameter(Mandatory=$True)]      [string]    $object_name
        , [Parameter(Mandatory=$True)]      [string]    $formatting_name
    )        
    write-host "$obj"
    if ( $obj -eq $null ) { return "The object is null." }
    [string]$ret_string_desc = ""
    $ret_string_desc = $obj.ToString()
    [string]$BaseName = $object_name   # which is $obj
    $Member_Properties = ( $obj | Get-Member -MemberType:Property ) 
    $ret_string_desc += iterate_through_properties $Member_Properties $formatting_name $BaseName
    return $ret_string_desc
} 

Function formatted_obj
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$True)][string]        $formatting_name
        , [Parameter(Mandatory=$True)]              $obj
        )
    [string]$object_name = '$obj'
    [string]$desc = get_object_description -obj:$obj -object_name:$object_name -formatting_name:$formatting_name
    $desc = $desc.Replace($object_name, $formatting_name)
    return $desc 
}







Function Does_Object_Have_Member
{
    [cmdletbinding()] Param  (
         [Parameter(Mandatory=$False)][System.Object]   $this 
         , [Parameter(Mandatory=$False)][string]        $member_name 
    )  
    $ret_exists = $false
    $found_matching = ($this | Get-Member | Where-Object { $_.Name -eq $member_name.ToString() } | Select { $_.Name } )
    $ret_exists = ( $found_matching -ne $null ) 
    return $ret_exists
}





Function iterate_through_properties($Children, $formatting_name, $BaseName)
{
    [string] $ret_desc = ""
    [string] $obj_name = '$obj'

    $base_obj = ( Invoke-Expression -Command:"$BaseName")
    if ( $base_obj -eq $null )
    {
        throw "HEY, this base object is NULL! `$BaseName=[$BaseName]"
    }
    else {
        write-host "$base_obj"
    }

    if ($Children -ne $null)
    {
        $Children2 = ($Children | where {$_.Name -ne $null})
        if ( $Children2 -eq $null ) { write-host "there are no kids here."}
        foreach ($Child in $Children2)
            {   

                Clear-Variable current_property_fully_qualified_name -ErrorAction SilentlyContinue
                Clear-Variable current_property_fully_qualified_name_friendly -ErrorAction SilentlyContinue
                Clear-Variable child_def -ErrorAction SilentlyContinue
                Clear-Variable current_property_value -ErrorAction SilentlyContinue
         
                if ( $Child.Name -eq "Length" -or $Child.Name -match "Dynamic[Property|Type]" -or $Child.Name -eq "" )
                {
                    continue;
                }


                [string]$current_property_fully_qualified_name = ("{0}.{1}" -f $BaseName, $Child.Name)       # use {} to enable use of strings with code or non standard characters.
                [string]$current_property_fully_qualified_name_friendly=$current_property_fully_qualified_name.Replace($obj_name, $formatting_name) 
                [string]$child_def = $Child.Definition
                
                formatted_obj_debug_loop_1 -current_property_fully_qualified_name:$current_property_fully_qualified_name `
                    -current_property_fully_qualified_name_friendly:$current_property_fully_qualified_name_friendly `
                    -child_def:$child_def
                 
                Write-Debug "NextBase=[$current_property_fully_qualified_name]."
                if ( $current_property_fully_qualified_name -eq $null )
                    {
                        $ret_desc += get_name_value_pair $null "There is no associated value because the fully qualified property name is null."
                    }  
                else          
                    {
                        "$nl-----------> BEGIN $current_property_fully_qualified_name"  | Write-Debug
                        $current_property_value = (Invoke-Expression -Command:$current_property_fully_qualified_name) 
                                    
                        If ($current_property_value -eq $null)
                            {
                                $ret_desc += get_name_value_pair $current_property_fully_qualified_name $null 
                            }
                        else
                            {
                                $ret_desc += get_description  $current_property_value  $current_property_fully_qualified_name $current_property_fully_qualified_name_friendly
                            }
                        "$nl-----------> END $current_property_fully_qualified_name$nl$nl"  | Write-Debug 
                    }          
            }
    }
    
    return $ret_desc        
}

Function get_name_value_pair ( $name, $value )
{
    $nl = [Environment]::NewLine + "-----"  
    [string] $is_null_value = ""
    [string] $is_null_name = ""
    if ($value -eq $null)
    {
        $is_null_value = "  [Value is NULL]"
    }
    if ($name -eq $null)
    {
        $is_null_name = "[Name is NULL]"    
    }
    return "$nl$is_null_name$name ===> [$value]$is_null_value"
}



Function get_description ( $current_property_value,  $current_property_fully_qualified_name, $current_property_fully_qualified_name_friendly)
{

    [string] $ret_description = "";
    $base_type = $current_property_value.GetType().BaseType

    If ($base_type -eq $null )
    {
        $ret_description += get_name_value_pair "BASE TYPE IS NULL for --> $current_property_fully_qualified_name" $current_property_value       
    }
    ElseIf ( is_powershell_native_type ($current_property_value) -eq $true )
    {
        $ret_description += get_name_value_pair  $current_property_fully_qualified_name $current_property_value
    }
    Else
    {
        [string]$current_property_class_type = $base_type.Name 
        [string]$parent_fqn = $current_property_fully_qualified_name
        [string]$parent_fqn_friendly = $current_property_fully_qualified_name_friendly
        [string]$parent_fqdn_mask = "*" * $parent_fqn.Length
        [string]$parent_fqdn_friendly_mask="*" * $parent_fqn_friendly.Length

        If ($current_property_class_type -eq "Array")
        {
            $current_property_fully_qualified_name = $current_property_fully_qualified_name + "[0]"
        }   
        $ret_description += [Environment]::NewLine + "#####" + $parent_fqn_friendly                
        [string]$description_of_property = formatted_obj -obj:$current_property_value -formatting_name:$current_property_fully_qualified_name_friendly
        # description_of_property = $description_of_property.Replace($parent_fqn_friendly, $parent_fqdn_friendly_mask)
        # $description_of_property = $description_of_property.Replace($parent_fqn, $parent_fqdn_mask)
        $ret_description += $description_of_property
    }               
    
    
    return $ret_description
}



Function is_powershell_native_type ($obj)
{
    $data_type = $obj.GetType();
    [boolean] $answer = 0;
    switch ($data_type)
    {
         string {  $answer =  1 }
         char {  $answer =  1}
         byte {  $answer =  1 }
         int {  $answer =  1} 
         int{  $answer =  1 } 
         long {  $answer =  1} 
         bool { $answer =  1} 
         decimal { $answer =  1 } 
         single {  $answer =  1} 
         double { $answer =  1 } 
         DateTime {  $answer =  1 } 
         # System.Management.Automation.ErrorRecord {  $answer =  1 }
         default { $answer =  0}
    }
    Write-Debug  "[$data_type] is native type? = [$answer]"
    return $answer
}

#endregion formatting ---------------------------------------------------



$var = (formatted_obj -formatting_name:"fred" -obj:"adsfasdf")
write-host $var

