
$vi_host_server         = ""
$guest_os               = ""
$g_no_work              = ( Get-VMGuest -VM:$guest_os -Server:$vi_host_server )
$guest_os               = ""
$g_works                = ( Get-VMGuest -VM:$guest_os -Server:$vi_host_server )
# TypeName: VMware.VimAutomation.ViCore.Impl.V1.VM.Guest.VMGuestImpl
$g_works | Get-member -MemberType:property | ForEach-Object { 
    write-host " -------   $($_.name) "
    write-host "Works            = $($g_works.($_.name))" 
    write-host "Not Works        = $($g_no_work.($_.name))" 
}
