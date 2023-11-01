function IsBinary {

# Checks for ASCII NUL Byte or UTF-8 Overlong, and returns 'True' (i.e the file is binary) if they exist
# Inspired from: https://stackoverflow.com/questions/1077634/powershell-search-script-that-ignores-binary-files
# Limited to supporting files less than 2 gigabytes in size.

    param(
        [string]$filePath
    )

    # Read the file as a byte array
    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

    # Function to check for ASCII NUL byte
    function ContainsNullByte($bytes) {
        foreach ($byte in $bytes) {
            if ($byte -eq 0) {
                return $true
            }
        }
        return $false
    }

    # Function to check for UTF-8 overlong sequences
    function ContainsOverlongUTF8($bytes) {
        $index = 0
        while ($index -lt $bytes.Length) {
            $byte = $bytes[$index]

            if ($byte -le 0x7F) {
                # ASCII character, continue
                $index++
            } elseif ($byte -ge 0xC0 -and $byte -le 0xDF) {
                # 2-byte sequence
                if ($index + 1 -ge $bytes.Length -or $bytes[$index + 1] -lt 0x80 -or $bytes[$index + 1] -gt 0xBF) {
                    return $true
                }
                $index += 2
            } elseif ($byte -ge 0xE0 -and $byte -le 0xEF) {
                # 3-byte sequence
                if ($index + 2 -ge $bytes.Length -or $bytes[$index + 1] -lt 0x80 -or $bytes[$index + 1] -gt 0xBF -or $bytes[$index + 2] -lt 0x80 -or $bytes[$index + 2] -gt 0xBF) {
                    return $true
                }
                $index += 3
            } elseif ($byte -ge 0xF0 -and $byte -le 0xF4) {
                # 4-byte sequence
                if ($index + 3 -ge $bytes.Length -or $bytes[$index + 1] -lt 0x80 -or $bytes[$index + 1] -gt 0xBF -or $bytes[$index + 2] -lt 0x80 -or $bytes[$index + 2] -gt 0xBF -or $bytes[$index + 3] -lt 0x80 -or $bytes[$index + 3] -gt 0xBF) {
                    return $true
                }
                $index += 4
            } else {
                return $true
            }
        }
        return $false
    }

    # Check for NUL byte
    $containsNullByte = ContainsNullByte($fileBytes)

    # Check for overlong UTF-8 sequences
    $containsOverlongUTF8 = ContainsOverlongUTF8($fileBytes)

    return ($containsNullByte -or $containsOverlongUTF8)
}