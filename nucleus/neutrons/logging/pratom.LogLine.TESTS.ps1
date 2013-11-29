<#

$object = New-Object pratom.LogLine(1, "my_date", "my_cat") 
write-host $object.Format
write-host $object.Data
$object.Data = "my_data"
write-host $object.Data
write-host $object.Formatted_SANS_Data
write-host $object.Formatted
$object.Data = "something completely different"
write-host $object.Data
write-host $object.Formatted

#>