ConvertTo-ISEAddOn -DisplayName "File Explorer" -ScriptBlock {
    function Parse-Directory($dir) {
        $dname = (Split-Path -Leaf $dir)
        # Exclude some common modules.
        if ($dname -in @("ShowUI", "PowerTab", "SQLite")) { return }

        $item = New-TreeViewItem -Header $dname
        if ($dname -eq "WindowsPowerShell") { $item.IsExpanded = $true }
        foreach($obj in ls $dir) {
            if ($obj.PSIsContainer) {
                $d = (Parse-Directory $obj.FullName)
                if ($d) {
                    $item.items.Add($d) | Out-Null
                }
            } else {
                if ($obj.Name -like "*.ps1" -or 
                    $obj.Name -like "*.psm1") {
                    $item.items.Add((New-TreeViewItem -tag $obj.FullName -Header $obj.Name  -Foreground (new-object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Colors]::DarkBlue)))) | Out-Null
                }
            }
        }

        if ($item.items.Count -eq 0) { return } # Exclude empty folders
        $item
    }

    New-TreeView -Items (Parse-Directory "$HOME\Documents\WindowsPowerShell") -On_SelectedItemChanged { 
        if ($args.NewValue.Tag) {
            $psise.CurrentPowerShellTab.Files.Add([string]$args.NewValue.Tag)
        }
    } -FontSize ($psISE.Options.FontSize * ($psISE.Options.Zoom / 100.0)) -Padding 0 -Margin 0 -BorderThickness 0
} -AddVertically -Visible