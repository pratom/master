[string]$SCRIPT:nl                              = [Environment]::NewLine

pr_include (code_to_load_a_file "$(Split-Path $PSCommandPath)\set_preference_variables.ps1")
pr_include (code_to_load_a_file "$(Split-Path $PSCommandPath)\set_console.ps1")
pr_include (code_to_load_a_file "$(Split-Path $PSCommandPath)\set_prompt.ps1") 
