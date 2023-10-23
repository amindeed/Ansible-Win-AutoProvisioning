###
#
# Helper functions for Windows Server 2019 systems
###


<#
	Reloads environement variables accross user's programs to propagate any recent changes.
	- http://stackoverflow.com/questions/6979741/setting-environment-variables-requires-reboot-on-64-bit
	- https://www.powershellgallery.com/packages/PSCI/1.0.4/Content/core%5Cutils%5CUpdate-EnvironmentVariables.ps1
#>
function Update-EnvironmentVariables {
	[CmdletBinding()]
	[OutputType([void])]
	param()

	if (-not ("win32.nativemethods" -As [type])) {
		# import sendmessagetimeout from win32
		Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
	}

	$HWND_BROADCAST = [intptr]0xffff;
	$WM_SETTINGCHANGE = 0x1a;
	$result = [uintptr]::zero

	# notify all windows of environment block change
	[void]([win32.nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [uintptr]::Zero, "Environment", 2, 5000, [ref]$result))

	if ($result -eq 0) {
		throw "Failed to reload environment variables."
	}
}


<#
	Sets an environment variable and reloads to propagate the change.
	Usage:
	Set-EnvironmentVariable -envVarName "NODEJS_HOME" -envVarValue "D:\AppServ\nodejs\node-v18.18.0-win-x64" -pathExists
#>
function Set-EnvironmentVariable {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [string]$envVarName,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline)]
        [string]$envVarValue,

        [switch]$pathExists = $false
    )

    $envVarPath = [System.Environment]::GetEnvironmentVariable($envVarName, [System.EnvironmentVariableTarget]::User)

    if ($pathExists -and (-not (Test-Path -Path $envVarValue))) {
		$errorMessage = "Path '$envVarValue' does not exist. Environment variable not set."
		throw [System.Management.Automation.ItemNotFoundException]::new($errorMessage)
    } else {
        New-ItemProperty -Path "HKCU:\Environment" -Name $envVarName -Value $envVarValue -PropertyType String -Force
        Update-EnvironmentVariables		
    }
}


<#
	Adds an environment variable (as a directory path) to user's "PATH" environment
	variable, and optionally checks if the path is valid.
	Usage:
	Add-NewEnvValueToPath "NODEJS_HOME" -pathExists
	Add-NewEnvValueToPath "NODEJS_HOME" "D:\AppServ\nodejs\node-x64" -pathExists
	Add-NewEnvValueToPath "NODEJS_HOME" "D:\AppServ\nodejs\node-v18.18.0-win-x64"
	Add-NewEnvValueToPath "NODEJS_HOME"
#>
function Add-NewEnvValueToPath {
	[CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]$newValue,

        [Parameter(Position = 1)]
        [string]$envVarValueAsPath,

        [switch]$pathExists = $false
    )
	
	$CurrentPATHValue = (Get-Item -Path HKCU:\Environment).GetValue('PATH',$null,'DoNotExpandEnvironmentNames')

	if ($PSCmdlet.MyInvocation.BoundParameters['envVarValueAsPath']) {

		# Value provided to 'envVarValueAsPath' parameter
		# Check if '$envVarValueAsPath' is a valid path, and set it as a value to '$newValue'
		if ($pathExists -and -not (Test-Path -Path $envVarValueAsPath -PathType Container)) {
			$errorMessage = "'$envVarValueAsPath' is not a valid path."
			throw [System.Management.Automation.ItemNotFoundException]::new($errorMessage)
		} else {
			New-ItemProperty -Path "HKCU:\Environment" -Name $newValue -Value $envVarValueAsPath -PropertyType String -Force
			Update-EnvironmentVariables
		}

	} else {

		# No value provided to 'envVarValueAsPath' parameter.
		# Check if '%$newValue%' expands to a valid path
		$newValueExpanded = [System.Environment]::ExpandEnvironmentVariables("%$newValue%")

		if ($pathExists -and (("%$newValue%" -eq $newValueExpanded) -or -not (Test-Path -Path $newValueExpanded -PathType Container))) {
			$errorMessage = "'$newValue' does not expand to a valid path."
			throw [System.Management.Automation.ItemNotFoundException]::new($errorMessage)
		} 
	}

	# Append '%$newValue%' to user's "PATH" if it does not exist
	if ($CurrentPATHValue -notlike "*%$newValue%*") {

		$FullNewPATHValue = "$CurrentPATHValue%$newValue%;"
		New-ItemProperty -Path "HKCU:\Environment" -Name "Path" -Value $FullNewPATHValue -PropertyType ExpandString -Force
		Update-EnvironmentVariables
	}
}