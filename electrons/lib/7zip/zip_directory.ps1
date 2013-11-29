$SCRIPT:seven_zip_bin_path="C:\Program Files\7-Zip\"

Function zip_directory ( $directory_path_to_zip )
{
    write-host "zip_directory - BEGIN | $($directory_path_to_zip.FullName)" 
    
    $seven_z = "$($SCRIPT:seven_zip_bin_path)\7z.exe"
    $zip_args = @('a', "$($directory_path_to_zip.FullName).7z", "-r" , ($directory_path_to_zip.FullName) )

    write-host "zip_directory - zipping directory | $($directory_path_to_zip.FullName)" 
    write-host "$seven_z  $zip_args"



    $zip_results = (& "$seven_z" $zip_args )




    write-host "zip_directory - zipped=[$($zip_results)] | $($directory_path_to_zip.FullName)" 
    if ( ( "$zip_results".Contains("Everything is Ok") ) -eq $true )
    {
        write-host "zip_directory - zip results say 'Everything is Ok', so removing directory. | $($directory_path_to_zip.FullName)" 
        Remove-Item $($directory_path_to_zip.FullName) -Recurse
    }
    else 
    {
      if ( $zip_results -eq $null )
      {
       write-host "------------------------------  DAMN 7 zip results NULL bug -----------------------------------" 
      }
      write-host "zip_directory - zip results did NOT say 'Everything is Ok', so we left the directory alone..... | $($directory_path_to_zip.FullName)"   
    }
    write-host "zip_directory - END | $($directory_path_to_zip.FullName)" 
    return $null
}