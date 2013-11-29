<# PRSP - pratom Sniffed Parameter #>
Function PRSP ( $entry, $parameter_count )
{
    assert_caller_is_in_my_directory 

    $properties             = ( parameter_properties $entry  )
    switch ($properties["name"])
    {
        "ForegroundColor"   { return "" }
        "NoNewline"         { return "" }
        default {
            $parameter_tag_open     = ( PRSP_tag_open $parameter_count $properties )
            $data_value             = ( PRSP_tag_value $properties )
            return "$($parameter_tag_open)$($data_value)</PRSP>" 
        }
    }


    
}


Function parameter_properties ( $entry  )
{
    assert_caller_is_in_my_file 
    if ( $entry -eq $null ) 
        { 
            $parameter_data_type = "entry is null"
            $parameter_name = "entry is null"
            $data_value = ""
        }
    else 
        {
            $parameter_data_type    = PSRP_tag_get_data_type    -entry:$entry
            $parameter_name         = $entry.Key  
            $data_value             = PSRP_tag_get_data_value   -entry:$entry
        }
    return (@{"type"=$parameter_data_type ; "name"=$parameter_name ; "value"=$data_value})
}


Function PRSP_tag_open (  $parameter_count, $properties )
{
    assert_caller_is_in_my_file 
    $parameter_data_type    = ( value_pad_right -column_name:"PRSP_datatype"       -value:($properties["type"])           )
    $parameter_name         = ( value_pad_right -column_name:"PRSP_name"           -value:($properties["name"])           )
    $parameter_open_tag     = "<PRSP name='$($parameter_name)' type='$($parameter_data_type)'>"
    $parameter_open_tag     = ( value_pad_right -column_name:"PRSP_tag_open"   -value:$parameter_open_tag                 )    
    if ( $parameter_count -ge 2 ) { $parameter_open_tag = "$($nl)$($parameter_open_tag)" }          
    $parameter_open_tag     = "$parameter_open_tag|"
    return ( $parameter_open_tag )
}


Function PRSP_tag_value ( $properties  )
{
    assert_caller_is_in_my_file 
    [string]$data_value = $properties["value"]
    $data_value = ( scrub_new_lines -value:$data_value )
    $data_value = ( value_pad_right -column_name:"SNIFFED_data_value" -value:$data_value )
    $data_value = ( value_new_lines_indented -column_name_of_previous_column:"PRSP_tag_open" -value:$data_value )
    return $data_value
}

function PSRP_tag_get_data_type  ( $entry ){ if ( $entry.Value -eq $null ) { return "entry value is null" } else { return ( $entry.Value.GetType().Name )  } }
function PSRP_tag_get_data_value ( $entry ){ if ( $entry.Value -eq $null ) { return "" } else { return ( $entry.Value.ToString() )  } } 