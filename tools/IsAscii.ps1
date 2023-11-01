function IsAscii([System.IO.FileInfo]$item)
{

# https://stackoverflow.com/a/1078277/3208373
# /!\ returns 'False' if text file contains UTF-8 (i.e. non ASCII) chracaters.
# Has instant result for large (binary) files, through (tested with 9.5GB vhdx file)

    begin 
    { 
        #$validList = new-list byte
        [System.Collections.Generic.List[byte]]$validList = @()
        $validList.AddRange([byte[]] (10,13) )
        $validList.AddRange([byte[]] (31..127) )
    }

    process
    {
        try 
        {
            $reader = $item.Open([System.IO.FileMode]::Open)
            $bytes = new-object byte[] 1024
            $numRead = $reader.Read($bytes, 0, $bytes.Count)

            for($i=0; $i -lt $numRead; ++$i)
            {
                if (!$validList.Contains($bytes[$i]))
                    { return $false }
            }
            $true
        }
        finally
        {
            if ($reader)
                { $reader.Dispose() }
        }
    }
}