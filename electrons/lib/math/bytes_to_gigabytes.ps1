Function bytes_to_gigabytes
{
    [Parameter(Mandatory=$true)][int64] $bytes
    return ( $bytes / 1GB )
}