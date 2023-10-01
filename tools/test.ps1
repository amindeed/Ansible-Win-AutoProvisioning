$randomNumber = Get-Random -Minimum 0 -Maximum 4
$outcomes = @("OK_NO_CHANGE", "OK_CHANGE", "KO_FAILURE")
$outcome = "OK_NO_CHANGE"
Write-Output "$outcome    $(get-date)" >> heloo.txt
try {
    if ($outcome -eq "OK_NO_CHANGE") {
        Write-Output "[OK_NO_CHANGE] Fake 'OK status with no change made'"
        exit 0
    }
    elseif ($outcome -eq "OK_CHANGE") {
        Write-Output "[OK_CHANGE] Fake 'OK status with change'"
        exit 0
    }
    elseif ($outcome -eq "KO_FAILURE") {
        Write-Output "[KO_FAILURE] Fake 'failure triggered by user-defined condition'"
        exit 1
    } else {
        throw "Fake unexpected error."
    }
} catch {
    Write-Output "Unexpected error: $_"
    exit 1
}