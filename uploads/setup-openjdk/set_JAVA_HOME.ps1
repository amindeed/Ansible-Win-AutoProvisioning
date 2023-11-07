$envvar = 'JAVA_HOME'
$exePath = "D:\AppServ\Java\Eclipse Temurin JDK with Hotspot 11.0.20.1+1 (x64)\bin\java.exe"  # Replace with the path to your executable
$iconIndex = 0
$items = @("D:\AppServ\Java\Eclipse Temurin JDK with Hotspot 8u382-b05 (x64)\bin", "D:\AppServ\Java\Eclipse Temurin JDK with Hotspot 11.0.20.1+1 (x64)\bin", "D:\AppServ\Java\Eclipse Temurin JDK with Hotspot 17.0.8.1+1 (x64)\bin")
#$preselectedIndex = 0
$windowTitle = "Select JAVA version"
$actionDescription = "Select JAVA version :"
$postMsgBoxTitle = "Selected JAVA directory"
$postMsgText = "Relaunch any running console app (e.g. CMD, Git Bash). `n`nSelected:"


function execAction($arg1, $arg2) {
    # Requires AWAP Modules to be already installed
    Set-EnvironmentVariable -envVarName $arg1 -envVarValue $arg2
}

# -------------------- DO NOT CHANGE CODE BELOW --------------------

# Load the Windows Forms assembly
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Create a variable to store the main form handle
$mainFormHandle = $null

# Load the IconLib library
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class IconExtractor {
        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr ExtractIcon(IntPtr hInst, string lpszExe, int nIconIndex);
    }
"@

# Extract the specified icon from the executable
$icon = [System.Drawing.Icon]::FromHandle([IconExtractor]::ExtractIcon([IntPtr]::Zero, $exePath, $iconIndex))

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = $windowTitle
$form.Size = New-Object System.Drawing.Size(400, 150)
$form.Icon = $icon
$form.StartPosition = "CenterScreen"

# Create label
$label = New-Object System.Windows.Forms.Label
$label.Text = $actionDescription
$label.Location = New-Object System.Drawing.Point(10, 10)
$label.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($label)

# Create dropdown list
$dropdown = New-Object System.Windows.Forms.ComboBox
$dropdown.Location = New-Object System.Drawing.Point(10, 30)
$dropdown.Size = New-Object System.Drawing.Size(300, 20)

# Add items to the dropdown list
foreach ($item in $items) {
    $dropdown.Items.Add($item)
}

## Set the index of the item you want to pre-select (e.g., Option 2)
#$dropdown.SelectedIndex = $preselectedIndex

$form.Controls.Add($dropdown)

# Create OK button
$button = New-Object System.Windows.Forms.Button
$button.Text = "OK"
$button.Location = New-Object System.Drawing.Point(10, 70)
$button.Add_Click({
    $selectedItem = $dropdown.SelectedItem
    execAction $envvar $selectedItem
    #execAction $selectedItem
    [System.Windows.Forms.MessageBox]::Show("$postMsgText `n$selectedItem", $postMsgBoxTitle)
    
    # Close both the main form and the message box
    if ($mainFormHandle) {
        $form.Close()
        [System.Windows.Forms.Application]::Exit()
    }
})
$form.Controls.Add($button)

# Store the main form's handle
$mainFormHandle = $form.Handle

# Show the form
$form.ShowDialog()

# Dispose of the form and the icon
$form.Dispose()
$icon.Dispose()
