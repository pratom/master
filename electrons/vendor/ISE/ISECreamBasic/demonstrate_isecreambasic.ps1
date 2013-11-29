Function demonstrate_isecreambasic
{
    Add-IseMenu -Name "Get"  @{
        "Process" = { Get-Process } 
        "Service" = { Get-Service } 
        "Hotfix" = {Get-Hotfix}
    }

    Add-IseMenu -Name "Get1" -module SQLIse @{
        "Process" = { Get-Process } 
        "Service" = { Get-Service } 
        "Hotfix" = {Get-Hotfix}
    }

    Add-IseMenu -Name "Get2" @{
        "Process" = { Get-Process } | Add-Member NoteProperty order  2 -PassThru
        "Service" = { Get-Service } | Add-Member NoteProperty order  1 -PassThru
        "Hotfix" = {Get-Hotfix}     | Add-Member NoteProperty order  3 -PassThru | Add-Member NoteProperty ShortcutKey "CTRL + ALT+B" -PassThru
    }


    Add-IseMenu -Name "Verb"  @{
        Get = @{
            Process = { Get-Process } | Add-Member NoteProperty order  2 -PassThru
            Service = { Get-Service } | Add-Member NoteProperty order  1 -PassThru
            Hotfix = { Get-Hotfix }   | Add-Member NoteProperty order  3 -PassThru | Add-Member NoteProperty ShortcutKey "CTRL + ALT+B" -PassThru
        } | Add-Member NoteProperty order  2 -PassThru
        Import = @{
            Module = { Import-Module } 
        } | Add-Member NoteProperty order  1 -PassThru
    }

    Add-IseMenu -Name "Verb2"  @{
        Get = @{
            Process = @{} | Add-Member NoteProperty order  2 -PassThru
            Service = { Get-Service } | Add-Member NoteProperty order  1 -PassThru
            Hotfix = { Get-Hotfix }   | Add-Member NoteProperty order  3 -PassThru | Add-Member NoteProperty ShortcutKey "CTRL + ALT+B" -PassThru
        } | Add-Member NoteProperty order  2 -PassThru
        Import = @{
            Module = { Import-Module } 
        } | Add-Member NoteProperty order  1 -PassThru
    }
}