# T1136.001
# Purpose: This script demonstrates addition of a new local administrator without leveraging the net/net1 binaries.
Write-Host "This script creates a new user, adds it to a local administrator group and then deletes the user."
$userName = "NewLocalUser"
$password = "P@ssw0rd123456789!"

Add-Type -AssemblyName System.DirectoryServices.AccountManagement

$localContext = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList ([System.DirectoryServices.AccountManagement.ContextType]::Machine)

$existingUser = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($localContext, $userName)

if ($existingUser -eq $null) {
    $newUser = New-Object -TypeName System.DirectoryServices.AccountManagement.UserPrincipal -ArgumentList ($localContext)

    $newUser.Name = $userName
    $newUser.SetPassword($password)
    $newUser.UserCannotChangePassword = $true
    $newUser.PasswordNeverExpires = $true
    $newUser.Enabled = $true

    $newUser.Save()

    Write-Host "User '$userName' created successfully."

} else {

    Write-Host "User '$userName' already exists."
}

$adminGroupName = "Administrators"
$adminGroup = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($localContext, $adminGroupName)

if ($adminGroup -ne $null) {
    $adminGroup.Members.Add($localContext, [System.DirectoryServices.AccountManagement.IdentityType]::Name, $userName)
    $adminGroup.Save()

    Write-Host "User '$userName' added to the '$adminGroupName' group."

} else {
    Write-Host "Group '$adminGroupName' not found."
}

# Enumerate User info for validation
Write-Host "Newly Created User Info:"
net user $userName

# Cleanup Command for ART
$deleteUser = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($localContext, $userName)

if ($deleteUser -ne $null) {
    $deleteUser.Delete()
    Write-Host "User '$userName' deleted successfully."
} else {
    Write-Host "User '$userName' not found for deletion."
}
