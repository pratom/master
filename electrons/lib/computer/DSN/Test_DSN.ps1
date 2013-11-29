Function Test_DSN
{
    [cmdletbinding()]
    Param ( [Parameter(Mandatory=$True)] [string] $DSNName )

    Write-Host "     BEGIN Test_DSN, [$DSNName]"
    [boolean] $ret_success = $false

    try
    {
        $DebugPreference = "Continue"
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        Write-Debug "Test_DSN BEGIN $DSNName"
        #SQL Authentication
        $connectstring = "DSN=$DSNName;"
        #Windows Authentication
        #$connectstring = "DSN=myDsn;"
        
        $conn = New-Object System.Data.Odbc.OdbcConnection($connectstring)
        Write-Debug "`$conn.open()=[$($conn.open())]"
        
        $sql_that_will_run_for_any_server_login = "select GETDATE() AS TimeOfQuery"
        $cmd = New-Object system.Data.Odbc.OdbcCommand($sql_that_will_run_for_any_server_login,$conn)
        
        $da = New-Object system.Data.Odbc.OdbcDataAdapter($cmd)
        $dt = New-Object system.Data.datatable
        
        Write-Debug "$($da.fill($dt))"
        Write-Debug "`$conn.close()=[$($conn.close())]"
        Write-Debug "$($dt.ToString())"
        Write-Host "The Result for the Query, $sql_that_will_run_for_any_server_login"
        foreach ($Row in $dt.Rows)
            { 
              write-host "Is: $($Row[0])"
            }
        Write-Debug "Test_DSN COMPLETE $DSNName"
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        Write-Debug ""
        <#
            The driver does not exist on the machine:
                Exception calling "Open" with "0" argument(s): "ERROR [IM002] [Microsoft][ODBC Driver Manager] Data source name not found and no default driver specified"
                At C:\Users\jmaass\Desktop\hide\dsn.ps1:line:304 char:12
                +   $conn.open( <<<< )
                
            The DSN does not exist on the machine:
                Exception calling "Open" with "0" argument(s): "ERROR [IM002] [Microsoft][ODBC Driver Manager] Data source name not found and no default driver specified"
                At C:\Users\jmaass\Desktop\hide\dsn.ps1:line:304 char:12
                +   $conn.open( <<<< )
        #>
        Write-Host "     SUCCESS testing the DSN, [$DSNName]."
        $ret_success = $true
    }
    catch
    {
        $ret_success = $false
        write-host "Test_DSN, [$DSNName], FAILED.  Information about errors will follow.  You may view this information in the log files, [$(pratom_PATH_LOG_FILE_SNIFFER_WRITES)] or [$(pratom_PATH_LOG_FILE_SNIFFER_WRITE_HOST)]."
        [string]$ret_string = ( ooooops_describe_error_briefly -errorRecord_to_read:$_ )
        $ret_string +=  (ooooops_describe_global_error_variable)  
        write-host ($ret_string)  
    }
    Write-Host "     END Test_DSN, [$DSNName]"
    return $ret_success   
}
