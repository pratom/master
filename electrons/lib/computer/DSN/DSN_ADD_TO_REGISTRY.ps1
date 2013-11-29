Function DSN_ADD_TO_REGISTRY
{
    [cmdletbinding(DefaultParametersetName="windows_credentials")]             
    Param(
          [Parameter(Mandatory=$True)]                                                  [string]    $DSNName
        , [Parameter(Mandatory=$True)]                                                  [string]    $driver_name
        , [Parameter(Mandatory=$True)]                                                  [string]    $server_name
        , [Parameter(Mandatory=$True)]                                                  [string]    $database_name         
        , [Parameter(Mandatory=$True)]                                                  [string]    $driver_full_path
        , [Parameter(Mandatory=$True)]                                                  [string]    $ODBC_DSN_path
        , [Parameter(Mandatory=$True)]                                                  [string]    $ODBC_DSN_LIST

        , [Parameter(ParameterSetName='windows_credentials', Mandatory = $true)]        [switch]    $windows_credentials

        , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $user_name
        , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $password
        ) 

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "windows_credentials"   {} 
            "user_pw"               {} 
            default                 { $windows_credentials = $true }
        }    

    Write-Debug "DSN_ADD_TO_REGISTRY BEGIN"

    $registry_return_values = @()

    ## this is the actual DSN's settings ----------------------------------------------------------------------------------------
        ## DSN / Driver settings
        write-debug "Create registry path to ODBC DSN"
        write-debug "$(New-Item -Path:$ODBC_DSN_path -ErrorAction:silentlycontinue )"

        write-debug "DSN_ADD_TO_REGISTRY - set driver"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Driver          -value $driver_full_path                                                )"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Description     -value "This DSN is being put here by the script=[$PSCommandPath]"      )"
    
        ## DBMS settings
        write-debug "DSN_ADD_TO_REGISTRY - DBMS settings"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Server          -value $server_name     )"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Database        -value $database_name   )"  

        ## Security Settings
        write-debug "DSN_ADD_TO_REGISTRY - Security Settings"
        if ( $windows_credentials -eq $true )
        {
            write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Trusted_Connection -value "Yes" )"
        }
        else 
        {
            write-debug "$( set-itemproperty -path $ODBC_DSN_path -name Trusted_Connection      -value "No"         )" 
            write-debug "$( set-itemproperty -path $ODBC_DSN_path -name User                    -Value $user_name   )"
            write-debug "$( set-itemproperty -path $ODBC_DSN_path -name PWD                     -Value $password     )"
        }

        ## Logging
        write-debug "DSN_ADD_TO_REGISTRY - Logging"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name QueryLog_On     -Value "Yes"                 )"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name QueryLogFile    -Value "%TMP%\QUERY.LOG"     )"

        ## MISC
        write-debug "DSN_ADD_TO_REGISTRY - MISC"
        write-debug "$( set-itemproperty -path $ODBC_DSN_path -name LastUser        -value ''    )"

    ## This is required to allow the ODBC connection to show up in the ODBC Administrator application, Odbcad32.exe. ----------------------------------------------------------------------------------------
    write-debug "Create registry path to ODBC DSN LIST"
    write-debug "$( New-Item            -Path:$ODBC_DSN_LIST -ErrorAction:silentlycontinue           )"
    write-debug "$( set-itemproperty    -path $ODBC_DSN_LIST -name "$DSNName" -value "$driver_name" )"

    Write-Debug "DSN_ADD_TO_REGISTRY END"
    return $true
}