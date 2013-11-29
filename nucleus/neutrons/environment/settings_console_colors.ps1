$ruby_ruber="#CE4676"
$ruby_power="#4a0000"
$ruby_antique="#841B2D"
$lime = "#00ff00"
$bright_red =  "#FF0000"


<#
http://www.vim.org/scripts/script.php?script_id=750
hi Normal guifg=lightred guibg=#600000
hi Cursor guifg=bg guibg=fg
hi ErrorMsg guibg=red ctermfg=1
hi Search term=reverse ctermfg=darkred ctermbg=lightred guibg=lightred guifg=#060000

hi Comment guifg=#ffffff
hi Constant guifg=#88ddee
hi String guifg=#ffcc88
hi Character guifg=#ffaa00
hi Number guifg=#88ddee
hi Identifier guifg=#cfcfcf
hi Statement guifg=#eeff99 gui=bold
hi PreProc guifg=firebrick1 gui=italic
hi Type guifg=#88ffaa gui=none
hi Special guifg=#ffaa00
hi SpecialChar guifg=#ffaa00
hi StorageClass guifg=#ddaacc
hi Error guifg=red guibg=white
#>





$SCRIPT:console_properties = @{
<# ----------------------------------------------#>
FontName                                    = "Courier New"     ;
FontSize                                    = 9                 ;
<# ----------------------------------------------#>
ShowIntellisenseInConsolePane               = $true             ;  
ShowIntellisenseInScriptPane                = $true             ;
ShowLineNumbers                             = $true             ;
ShowOutlining                               = $true             ;
ShowToolBar                                 = $true             ;
ShowWarningBeforeSavingOnRun                = $true             ;
ShowWarningForDuplicateFiles                = $true             ;
UseEnterToSelectInConsolePaneIntellisense   = $true             ;
UseEnterToSelectInScriptPaneIntellisense    = $true             ;
<# ----------------------------------------------#>
ConsolePaneBackgroundColor                  = $ruby_ruber       ;
ConsolePaneForegroundColor                  = "black"             ;
ConsolePaneTextBackgroundColor              = "White"     ;

ConsolePaneBackgroundColor_bland            = "DarkRed"       ;
ConsolePaneForegroundColor_bland            = "White"         ;

<# ----------------------------------------------#>
ScriptPaneBackgroundColor = "White" ;
ScriptPaneForegroundColor = "Black" ;
<# ----------------------------------------------#>
DebugBackgroundColor            = $ruby_ruber     ;
DebugForegroundColor            = "black"       ;
ErrorBackgroundColor            = $bright_red     ;
ErrorForegroundColor            = "white"         ;
VerboseBackgroundColor          = $ruby_ruber     ;
VerboseForegroundColor          = "#88ddee"       ;
WarningBackgroundColor          = "OrangeRed"     ;
WarningForegroundColor          = "Black"         
}