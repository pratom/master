Function assert_vm_is_running ( $vm ) 
    { 
        if($vm.powerstate -ne "PoweredOn")
            { 
                write-debug "$vm is not running" ; 
                throw "$vm is not running"; 
            } 
    }