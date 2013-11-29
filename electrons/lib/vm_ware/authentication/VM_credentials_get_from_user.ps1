Function UI_VM_credentials_get_from_user ( $related_machine_name, $function_related_prompt )
{
    write-debug "VM_credentials_get_from_user : requesting credentials from user  $function_related_prompt"
    $msg = "Need to gather credentials to access=[$related_machine_name].  $function_related_prompt"
    return(Get-Credential -Message:$msg)
}