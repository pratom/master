function path_data_type
{
  [cmdletbinding()] Param ( [Parameter(Mandatory=$False)][string]$a_path )  
  $ret_type = $null
  $path_item = (get-item -LiteralPath:$a_path)
  if ($path_item -ne $null)
  {
        $ret_type = $path_item.GetType()
  }
  return $ret_type
}