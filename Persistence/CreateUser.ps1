# Define the user information
$userName = "NewLocalUser"
$password = "P@ssw0rd123456789!"

# Load the necessary .NET assemblies
Add-Type -AssemblyName System.DirectoryServices.AccountManagement

# Create a new PrincipalContext for the local machine
$localContext = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList ([System.DirectoryServices.AccountManagement.ContextType]::Machine)

# Check if the user already exists
$existingUser = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($localContext, $userName)

if ($existingUser -eq $null) {
    # Create a new UserPrincipal
    $newUser = New-Object -TypeName System.DirectoryServices.AccountManagement.UserPrincipal -ArgumentList ($localContext)

    # Set the user's properties
    $newUser.Name = $userName
    $newUser.SetPassword($password)
    $newUser.UserCannotChangePassword = $true
    $newUser.PasswordNeverExpires = $true
    $newUser.Enabled = $true

    # Save the new user
    $newUser.Save()
    Write-Host "User '$userName' created successfully."
} else {
    Write-Host "User '$userName' already exists."
}