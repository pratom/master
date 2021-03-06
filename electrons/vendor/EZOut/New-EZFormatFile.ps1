function New-EZFormatFile
{
    param(
    [ValidateScript({
        if (-not (Get-Module "$_")) {
            throw "Module $_ must be loaded"            
        }
    return $true
    })]        
    [Parameter(Mandatory=$true,Position=0,ParameterSetName='LoadedModule',ValueFromPipelineByPropertyName=$true)]
    [string]
    $Name,
    
    [Switch]
    $Force
    )
    
    process {
        $moduleRoot = Get-Module $name | Split-Path
        $ezFormatFilePath = "$moduleRoot\$name.ezformat.ps1"
        if ((Test-Path $ezFormatFilePath) -and (-not $Force)) {
            Write-Error "EZFormat File already exists"
            return
        }
        
@"
# EZFormat File for $name
`$moduleRoot = Get-Module '$name' | Split-Path
`$formatviews = @()
`$formatViews | 
    Out-FormatData |
    Set-Content "`$moduleRoot\$name.format.ps1xml"
    
`$typeviews = @()
`$typeViews | 
    Out-TypeData |
    Set-Content "`$moduleRoot\$name.types.ps1xml"
"@ |
        Set-Content $ezFormatFilePath
        
        Get-Item $ezFormatFilePath
    }
} 
