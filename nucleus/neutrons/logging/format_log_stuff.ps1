Function value_pad_left ( $column_name, $value )
{
    $column_width = ( get_column_width $column_name $value )
    $value = $value.PadLeft($column_width, $SCRIPT:Pad_character) 
    return $value  
}

Function value_pad_right ( $column_name, $value )
{
    $column_width = ( get_column_width $column_name $value ) 
    $value = $value.PadRight($column_width, $SCRIPT:Pad_character) 
    return $value  
}


Function scrub_new_lines ( $value )
{
    $value = $value.Replace([string]$SCRIPT:ascii_carriage_return_string   , "") 
    $value = $value.Replace([string]$SCRIPT:ascii_vertical_tab_string      , "")    
    $value = $value.Replace([string]$SCRIPT:ascii_line_feed_string         , $nl)
    return $value
}

Function value_new_lines_indented ( $column_name_of_previous_column, $value )
{
    if ( $value -eq $null ) { return $null }
    $data_left_indent = ( get_column_indent -column_name:$column_name_of_previous_column )
    $value = $value.Replace($nl, "$($nl)$data_left_indent|")
    return $value
}

Function pratom_logging_category_formatted
{
    [CmdletBinding()] Param ( [Parameter(Mandatory=$true)]      [string]     $log_category  )
    $log_category=$log_category.Replace("|", '')
    if ( $log_category.Length -ge $SCRIPT:pratom_logging_longest_logging_category_length ) 
    {
        $SCRIPT:pratom_logging_longest_logging_category_length = ( $log_category.Length + 2 )
    }
    $log_category = $log_category.PadLeft($SCRIPT:pratom_logging_longest_logging_category_length, " ")
    return  $log_category
}


<# --------- PRIVATE ------------------------------ #> 
Function get_column_width 
{
    [CmdletBinding()] 
    Param ( 
        [Parameter(Mandatory=$true)]            [string]     $column_name  
        , [Parameter(Mandatory=$false)]         [string]     $value 
        )
    assert_caller_is_in_my_file
    if ( $value -eq $null ) { $value = ""}
    [string]$script_var_name = ( script_variable_column_width_name $column_name )
    [int]$current_column_width = ( column_width $column_name )
    $value_width = $value.Length
    if ( $value_width -ge $current_column_width) 
        { 
            $current_column_width = ($value_width + 6 ) 
            # expand the width of the column, permanently for this session
            (Invoke-Expression "$script_var_name = $current_column_width") 
        } 
    return (Invoke-Expression $script_var_name)     # this is returning an int 
}

Function script_variable_column_width_name( $column_name )
{
    assert_caller_is_in_my_file
    [string]$script_var_name = "`$SCRIPT:PRLS_COL_WIDTH_$($column_name)" 
    return $script_var_name   
}

Function column_width( $column_name )
{
    assert_caller_is_in_my_file
    [int]$current_column_width = (Invoke-Expression (script_variable_column_width_name $column_name) )
    return $current_column_width
}

Function get_column_indent ( $column_name )
{
    assert_caller_is_in_my_file
    return ( $SCRIPT:Indent_character * ( column_width $column_name ) )
}