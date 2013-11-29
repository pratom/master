Function DSN_ADD_64_bit
{
    [cmdletbinding()]
    Param (
    [Parameter(Mandatory=$True)]                                                    [string]    $DSNName
    , [Parameter(Mandatory=$True)]                                                  [string]    $driver_name
    , [Parameter(Mandatory=$False)]                                                 [string]    $server_name
    , [Parameter(Mandatory=$False)]                                                 [string]    $database_name 

    , [Parameter(ParameterSetName='windows_credentials', Mandatory = $true)]        [switch]    $windows_credentials

    , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $user_name
    , [Parameter(ParameterSetName='user_pw', Mandatory=$true)]                      [string]    $password

    , [Parameter( Mandatory = $false ) ]                                            [switch]    $test_dsn
    )
    Write-Debug "BEGIN DSN_ADD_64_bit, [$DSNName]."

    if ($test_dsn -eq $null)
    {
        $test_dsn = $false
    }

    $mem = ([pratom.enums.computer_memory_architecture._64_bit]::Value)

    switch ($PsCmdlet.ParameterSetName) 
    { 

    "windows_credentials"  
        { 
            $null = (DSN_ADD -mem_arch:$mem -server_name:$server_name -DSNName:$DSNName -driver_name:$driver_name -database_name:$database_name -test_dsn:$test_dsn -windows_credentials) 
        } 

    "user_pw"  
        { 
            $null = (DSN_ADD -mem_arch:$mem -server_name:$server_name -DSNName:$DSNName -driver_name:$driver_name -database_name:$database_name -test_dsn:$test_dsn -user_name:$user_name -password:$password)
        }  

    } 
    Write-Debug "END DSN_ADD_64_bit, [$DSNName]."
    return $true
}