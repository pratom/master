$SCRIPT:powershell_naming_restricted_characters =  @('#',
 ',', 
  '(',
   ')',
    '{{',
     '}}',
      '[',
       ']',
        '&',
         '-',
          '/',
           '\',
            '$',
             '^',
              ';',
               ':',
                '"',
                 "'",
                  '<',
                   '>',
                    '|',
                     '?',
                      '@',
                       '`',
                        '*',
                         '%',
                          '+',
                           '=',
                            '~')


function what_is_loaded_from_module_named
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string] $module_name
        )    
    process
    {
        return (get-command -module:$module_name -CommandType:all)
    }
}


Function what_is_loaded_from_rails
{
    [cmdletbinding()] Param ()
    
    $script_name = ($MyInvocation.ScriptName)
    if (( pr_setting_loaded_results_show_hide $script_name ) -eq "show" )
      {
        write-host "==============/==============/==============/==============/==============/=============="
        write-host "Caller of this code=[$($MyInvocation.PSCommandPath)]"
        if ( $script_name -ne $null -and $script_name -ne '' )
        {
            write-host "At this position in code: [$($MyInvocation.ScriptName )].[$($MyInvocation.InvocationName)] line=[$($MyInvocation.ScriptLineNumber)]"
        }  
        else {
             write-host "At the command line, CommandOrigin=[$($MyInvocation.CommandOrigin.ToString())]" 
          }  
        
        write-host "Here are the commands loaded by POWER RAILS into your environment:"
        what_is_loaded_write 'pratom_nucleus'
        what_is_loaded_write 'pratom_core'
        what_is_loaded_write 'ISECreamBasic'    
        what_is_loaded_write 'pester'
        what_is_loaded_write 'PowerYaml'
        what_is_loaded_write 'pratom'
        what_is_loaded_write 'Unexpected' (what_loads_are_unexpected)
        write-host "==============/==============/==============/==============/==============/=============="  
      }
    return $null 
}









Function what_is_loaded_write
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string] $module_name
        , [Parameter(Mandatory=$false)]      $members = $null
        )  
    assert_caller_is_in_my_file      
    write-host "----------/--------/------------/-----------"
    write-host "$module_name"
    if ($members -eq $null) {$members = (what_is_loaded_from_module_named $module_name )}
    if ($members -eq $null){ write-host "There are [0] commands loaded from module=[$module_name]."}
    else {
        write-host "-------------------------------------------"
        try {
          foreach ($rec in $members ) {
              $potential_problem_with_member = (get_potential_problems_with_member $rec)
              write-host "$($rec.CommandType)     $($rec.ModuleName)      $($rec.Name)    $($potential_problem_with_member)"
          } 
        }
        catch {
            write-host "[$($rec)]" 
        }

    }
    write-host "----------/--------/------------/-----------"    
}


Function get_potential_problems_with_member ($rec)
{
  assert_caller_is_in_my_file
    $potential_problem_with_member = ""
    foreach ( $str in $SCRIPT:powershell_naming_restricted_characters )  {
        if ( ($rec).ToString().Contains($str) )
        {
            $potential_problem_with_member += "Contains powershell restricted character=[$str].  "
        }
    }
    if ( $potential_problem_with_member.Length -gt 0 )
    {
        $potential_problem_with_member ="<------- $potential_problem_with_member"    
    }
    return $potential_problem_with_member
}

Function what_loads_are_unexpected
{
  assert_caller_is_in_my_file
    $expected_sources = @{'Microsoft.PowerShell.Management' = 'expected';
    'Microsoft.PowerShell.Core' = 'expected';
    'Microsoft.PowerShell.Utility' = 'expected';
    'ISE' = 'expected';
    'pratom' = 'expected';
    'pratom_nucleus' = 'expected';
    'pratom_core' = 'expected';
    '' = 'expected'
    }

    $members = ((get-command -CommandType:all) | where-object{ ($expected_sources.Contains($_.ModuleName) -eq $false)  } )
    
    return $members
}

Function pr_setting_loaded_results_show_hide
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$false)]             [string] $calling_file )
    assert_caller_is_in_my_file
    if ( $calling_file -eq $null -or $calling_file -eq '' )
    {
      return "show" 
    }
    $calling_file = (Split-Path -Path:$calling_file -Leaf)
    [HashTable]$settings_hash = pr_settings_get_hashtable
    $setting = $settings_hash[$calling_file]
    return ( $setting )
}