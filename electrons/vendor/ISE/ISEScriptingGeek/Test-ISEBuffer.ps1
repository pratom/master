#requires -version 2.0

#from Bruce Payette

function Test-Buffer
{
    $text = $psISE.CurrentFile.Editor.Text
    $out=$null
    $tokens = [management.automation.psparser]::Tokenize($text, [ref] $out)
    $out | fl message, @{
        n="line";
        e = {
           "{0} char: {1}" -f $_.Token.StartLine, $_.Token.StartColumn
        }
    }
}  



