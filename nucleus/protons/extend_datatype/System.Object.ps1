<#
.EXAMPLE
    $a = ""
    PS C:\projects\ready_bake> Has_Member $a "blah"
    False
    PS C:\projects\ready_bake> Has_Member $a "Has_Member"
    True
    PS C:\projects\ready_bake> Has_Member $a ""
    False
    PS C:\projects\ready_bake> 
    FalseHas_Member $a $null
#>
Function Has_Member
{
    [cmdletbinding()] Param 
    (
         [Parameter(Mandatory=$False)][System.Object]   $this 
         , [Parameter(Mandatory=$False)][string]        $member_name 
    )  
    $ret_exists = $false
    $found_matching = ($this | Get-Member | Where-Object { $_.Name -eq $member_name.ToString() } | Select { $_.Name } )
    $ret_exists = ( $found_matching -ne $null ) 
    return $ret_exists
}
<#
.EXAMPLE
    $a = ""
    PS C:\projects\ready_bake> $a.Has_Member("blah")
    False
    PS C:\projects\ready_bake> $a.Has_Member("Has_Member")
    True
    PS C:\projects\ready_bake> $a.Has_Member("")
    False
    PS C:\projects\ready_bake> $a.Has_Member($null)
    False
#>
Function PRIVATE:add_member_Has_Member
{
    [cmdletbinding()] Param ()
    $script_block_get={ Has_Member $this @args }
    extend_datatype_with_method -member_name:Has_Member -script_block_get:$script_block_get -type_name:System.Object
}
add_member_Has_Member





<#
.SYNOPSIS
    Quickly adds a member property to object.  Once System.Object is extended with this method then extending objects is trivial
    Quickly add note properties or custom properties
    You can chain multiple calls together and continue passing the objects through the pipeline
    Use a hashtable to add a bunch of properties at once.
    Note that any expressions for the property value are executed when added
    and the resulting value of the xpression is stored in a NoteProperty value.   

.EXAMPLE
    $hash=@{Author="Me";"Thread-Count"=($_.Threads.Count)}
    Get-Process | %{ $_.PSAddMember($hash) } | Select Name,Author,Thread-Count

.EXAMPLE
    # Get-Process | %{ $_.PSAddMember(@{Author=Me;Thread-Count=($_.Threads.Count)}) } | Select Name,Author,Thread-Count

#>
Function PSAddMember
    {
        $this = $args[0]

        switch($args.Count) 
        {
            2 {
            ($args[1] -as [HashTable]) | %{ $_.GetEnumerator() } | %{ Add-Member -InputObject $this -Name $_.Name -value $_.Value -MemberType Noteproperty -Force -PassThru }
            break;
            }

            3 {
            Add-Member -InputObject $this -Name $args[1] -value $args[2] -MemberType Noteproperty -Force -PassThru
            break;
            }

            4 {
            Add-Member -InputObject $this -Name $args[1] -value $args[2] -MemberType $args[3] -Force -PassThru
            break;
            }
        }
    }


<#
.EXAMPLE
    $object = New-Object Object |  
        Add-Member -MemberType NoteProperty -Name 'var_1' -Value $null -PassThru  |  
        Add-Member -MemberType NoteProperty -Name 'var_2' -Value $null -PassThru  |      
        Add-Member -MemberType:ScriptProperty -Name:property_name_1 -Value:{ return this.var_1 } -SecondValue:{ $this.var_1 = $args[0] } -PassThru |           
        Add-Member -MemberType:ScriptProperty -Name:property_name_2 -Value:{ return this.var_2 } -SecondValue:{ $this.var_2 = $args[0] } -PassThru 

    $object | Format-Table       
    $object.property_name_1 = "I am set to 1"
    $object.property_name_2 = "I am set to 1 + 1"
    $object | Format-Table

    $props = @{"property_name_1"="I am the new value for the property named property_name_1";
        "I_do_not_exist" = "does not matter";
        "property_name_2"="I also a different value for the property named property_name_2"
    }
    $props | Format-Table


    Has_Member $object "property_name_1"
    Has_Member $object "property_name_2"
    Has_Member $object "I_do_not_exist"


    if (( Set_Properties_From_Hash ([ref]$object) -property_hash:$props ) -ne $true )
    {
        write-error "Failed to set properties"
    }
    $object | Format-Table
    
#>
Function Set_Properties_From_Hash
{
    [cmdletbinding()] Param 
    (
         [Parameter(Mandatory=$True)]                   [ref]   [System.Object]                             $ref_obj
         , [Parameter(Mandatory=$True)]                         [System.Collections.Hashtable]              $property_hash
    )  
    $obj = $ref_obj.Value
    if ($obj -eq $null)
    {
        throw "object may not be null."
    }

    write-debug "
Item Count in the property hash  =[$($property_hash.Count)]
property_hash type               =[$($property_hash.GetType().Name)]
object to change's type          =[$($obj.GetType().Name)]
    "
    foreach ($property in $property_hash.GetEnumerator()) {
        $property_name = $property.name
        $property_value = $property.value
        write-debug "Property to set = `$obj.($property_name)=[$($property_value)]."
        if ( (Has_Member $obj $property_name) -eq $true )
        {
            $old_val = $obj.($property_name)
            $obj.($property_name) = $property_value
            <#
            Happened when I added a Property using Add-Member, but did not specify -SecondValue
            Set accessor for property "property_name_2" is unavailable.
                + CategoryInfo          : NotSpecified: (:) [], SetValueException
            #>            
            write-debug "Property has been set.  OLD VALUE=[$old_val].  NEW VALUE=[$property_value]."
        }
        else {
          write-debug "$obj.($property_name) was NOT set because the property does not exist." 
        }
    }
    return $true 
}
































<#
# Extend every object in the powershell system with a PSAddMember function
Function PRIVATE:add_member_PSAddMember
{
    [cmdletbinding()] Param ()
    $script_block_get={ PSAddMember $this @args }
    extend_datatype_with_method -member_name:PSAddMember -script_block_get:$script_block_get -type_name:System.Object
}





Function PRIVATE:add_member_extend_with_method
{
    [cmdletbinding()] Param ()
    $script_block = {
        extend_with_method $this @args
    }
    extend_datatype_with_method -member_name:extend_with_method -script_block_get:$script_block -type_name:System.Object  
}






# System.Object.ps1 ===========================================================================
add_member_extend_with_method
add_member_PSAddMember



#>

<#
# ----------------------------------------------------------------------------------------------
# TEST : Has_Member
[System.Object].Has_Member("PSAddMember")

# TEST : PSAddMember
$hash=@{Author="Me";"Thread-Count"=($_.Threads.Count)}
$ret_var = Get-Process | %{ $_.PSAddMember($hash) } | Select Name,Author,Thread-Count
($ret_var.GetType = [System.Array])
($ret_var.Count > 100)
#>