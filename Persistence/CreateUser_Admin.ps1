# This Version also adds the defined user to Local Admin Group
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