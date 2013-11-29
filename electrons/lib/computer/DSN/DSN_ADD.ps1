Function DSN_ADD ()
{
    [cmdletbinding(DefaultParametersetName="windows_credentials")]             
    Param(
        [Parameter(Mandatory=$True)]                                                    [string]    $mem_arch
        , [Parameter(Mandatory=$True)]                                                  [string]    $DSNName
        , [Parameter(Mandatory=$True)]                                                  [string]    $driver_name
        , [Parameter(Mandatory=$True)]                                                  [string]    $server_name
        , [Parameter(Mandatory=$True)]                                                  [string]    $database_name 

        , [Parameter(ParameterSetName='windows_credentials', Mandatory = $true)]        [switch]    $windows_credentials

        , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $user_name
        , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $password

        , [Parameter( Mandatory = $false ) ]                                            [switch]    $test_dsn_after_creation
        ) 
    Write-Debug  "DSN_ADD BEGIN"

    [string]$ODBC_DSN_path      = ODBC_get_registry_path_to_DSN $mem_arch $DSNName
    [string]$ODBC_DSN_LIST      = ODBC_get_registry_path_to_DSN_LIST $mem_arch
    [string]$driver_full_path   = DSN_get_dll_path $driver_name $mem_arch

    switch ($PsCmdlet.ParameterSetName) 
    { 

    "windows_credentials"  
        { 
            $null = ( DSN_ADD_TO_REGISTRY -DSNName:$DSNName -driver_name:$driver_name -server_name:$server_name -database_name:$database_name -driver_full_path:$driver_full_path -ODBC_DSN_path:$ODBC_DSN_path -ODBC_DSN_LIST:$ODBC_DSN_LIST -windows_credentials ) 
        } 

    "user_pw"  
        { 
            $null = ( DSN_ADD_TO_REGISTRY -DSNName:$DSNName -driver_name:$driver_name -server_name:$server_name -database_name:$database_name -driver_full_path:$driver_full_path -ODBC_DSN_path:$ODBC_DSN_path -ODBC_DSN_LIST:$ODBC_DSN_LIST -user_name:$user_name -password:$password )  
        }  
    } 


    if ( $test_dsn_after_creation )
    {
        Write-Host "Setup of the DSN is complete.  Now, because the parameter -test_dsn_after_creation was passed, as a test, the code will run a simple T-SQL statement through the DSN.  Please be patient, since, especially if it fails, this test may take what seems an unreasonable amount of time."
        if (( Test_DSN -DSNName:$DSNName ) -ne $true )
        {
            $msg = "DSN_ADD_64_bit : The test of the DSN failed.  DSN=[$DSNName].  Actions: 1) Re-run script in Debug mode  2) Review logs."
            write-host $msg
            throw $msg
        }
        else
        {
            Write-Debug "The setup of the DSN, [$DSNName], succeeded."
        }
    }
    Write-Debug  "DSN_ADD FINISHED"
    return $true
} 