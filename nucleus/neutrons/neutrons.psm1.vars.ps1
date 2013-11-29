$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_NEUTRONS = $PSScriptRoot

function RAILS_PATH_CORE
{
    return $SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_NEUTRONS
}

function RAILS_PATH
{
    return ( Resolve-Path "$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_NEUTRONS\.." )
}


[string]$SCRIPT:rails_path_env                                  = "$(RAILS_PATH_CORE)\environment"
[string]$SCRIPT:rails_path_lib                                  = "$(RAILS_PATH_CORE)\lib"
[string]$SCRIPT:rails_path_logging                              = "$(RAILS_PATH_CORE)\logging"   
[string]$SCRIPT:rails_path_logs                                 = "$(RAILS_PATH)\logs"  
[string]$SCRIPT:pratom_logging_path                             = $SCRIPT:rails_path_logs
[string]$SCRIPT:pratom_log_name_template                        = "pratom_main_listener_{sortable_date}"     

[string]$SCRIPT:Pad_character                                   = " "   # "~"
[string]$SCRIPT:Indent_character                                = " "   # "^"
[int]$SCRIPT:ascii_carriage_return_int = 13
[int]$SCRIPT:ascii_line_feed_int = 10
[int]$SCRIPT:ascii_vertical_tab_int = 11

[string]$SCRIPT:ascii_carriage_return_string   = ( [char]$SCRIPT:ascii_carriage_return_int )
[string]$SCRIPT:ascii_line_feed_string         = ( [char]$SCRIPT:ascii_line_feed_int    )
[string]$SCRIPT:ascii_vertical_tab_string      = ( [char]$SCRIPT:ascii_vertical_tab_int )


[string]$SCRIPT:nl                              = [Environment]::NewLine




function RAILS_PATH_ENV
{
    [cmdletbinding()] Param () 
    return $SCRIPT:rails_path_env 
}

function RAILS_PATH_LIB
{
    [cmdletbinding()] Param () 
    return $SCRIPT:rails_path_lib 
}

function RAILS_PATH_LOGGING
{
    [cmdletbinding()] Param () 
    return $SCRIPT:rails_path_logging 
}

function RAILS_PATH_LOGS
{
    [cmdletbinding()] Param () 
    return $SCRIPT:rails_path_logs 
}

Function pratom_PATH_LOGGING
{
    [cmdletbinding()] Param ()
    return($SCRIPT:pratom_logging_path)
}

Function pratom_PATH_LOG_FILE_NAME_TEMPLATE
{
    [cmdletbinding()] Param ()
    return("pratom_main_listener_{sortable_date}")
}
[string]$SCRIPT:pratom_log_name_base = pratom_PATH_LOG_FILE_NAME_TEMPLATE

Function pratom_PATH_LOG_FILE_NAME_BASE
{
    [cmdletbinding()] Param ()
    return( $SCRIPT:pratom_log_name_base )
}

Function pratom_PATH_LOG_FILE_MAIN
{
    [cmdletbinding()] Param ()
    return("$(pratom_PATH_LOGGING)\$(pratom_PATH_LOG_FILE_NAME_BASE)_MAIN.log")
}

Function pratom_PATH_LOG_FILE_SNIFFER_WRITES
{
    [cmdletbinding()] Param ()
    return("$(pratom_PATH_LOGGING)\$(pratom_PATH_LOG_FILE_NAME_BASE)_SNIFF_WRITES.log")
}

Function pratom_PATH_LOG_FILE_SNIFFER_WRITE_HOST
{
    [cmdletbinding()] Param ()
    return("$(pratom_PATH_LOGGING)\$(pratom_PATH_LOG_FILE_NAME_BASE)_SNIFF_WRITE_HOST.log")
}