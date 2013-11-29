Function run_sql_through_dsn
{
    [cmdletbinding(DefaultParametersetName="param_set_windows_credentials")]
    Param ( 
            [Parameter(Mandatory=$True)]                                                            [string]    $DSNName 
            , [Parameter(Mandatory=$True)]                                                          [string]    $t_sql_statement
            , [Parameter(ParameterSetName='param_set_windows_credentials', Mandatory=$false)]       [switch]    $Windows_Credentials
            , [Parameter(ParameterSetName='param_set_user_pw',Mandatory=$True)]                     [string]    $user_name
            , [Parameter(ParameterSetName='param_set_user_pw',Mandatory=$True)]                     [string]    $password
        )

    $DebugPreference = "Continue"
    Write-Debug "=====> BEGIN run_sql_through_dsn, [$DSNName], [$t_sql_statement]"
    [boolean] $ret_success = $false
    try
    {
        switch ($PsCmdlet.ParameterSetName) 
        { 
            "param_set_windows_credentials"  
                    { 
                        Write-Debug "credentials - windows authentication"
                        $connectstring = "DSN=$DSNName;" 
                    } 
            "param_set_user_pw"  
                    {
                        Write-Debug "credentials - username / password"
                        $connectstring = "DSN=$DSNName;Uid=test_account_maass;Pwd=blah;" 
                    }  
        } 
    	$conn = New-Object System.Data.Odbc.OdbcConnection($connectstring)
    	Write-Debug "$($conn.open())"
    	$cmd = New-Object system.Data.Odbc.OdbcCommand($t_sql_statement,$conn)
    	$da = New-Object system.Data.Odbc.OdbcDataAdapter($cmd)
    	$dt = New-Object system.Data.datatable
    	Write-Debug "$($da.fill($dt))"  
    	Write-Debug "$($conn.close())"
    	Write-Debug "SUCCESS run_sql_through_dsn, [$DSNName], [$t_sql_statement]"
        $ret_success = $true
    }
    catch
    {
        Write-Debug "ERROR run_sql_through_dsn, [$DSNName], [$t_sql_statement]"
        [string]$ret_string = ( ooooops_describe_error_briefly -errorRecord_to_read:$_ )
        $ret_string +=  (ooooops_describe_global_error_variable)  
        write-error $ret_string
        $ret_success = $false
    }
    Write-Host "=====> END run_sql_through_dsn, [$DSNName], [$t_sql_statement]"
    return $ret_success
}