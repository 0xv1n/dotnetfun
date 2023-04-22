Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class NativeMethods {
        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenThread(int dwDesiredAccess, bool bInheritHandle, uint dwThreadId);

        [DllImport("kernel32.dll")]
        public static extern uint SuspendThread(IntPtr hThread);

        [DllImport("kernel32.dll")]
        public static extern uint ResumeThread(IntPtr hThread);

        public const int THREAD_SUSPEND_RESUME = 0x0002;
    }
"@

$notepadStartInfo = New-Object System.Diagnostics.ProcessStartInfo -ArgumentList "notepad.exe", "111111"
$notepadStartInfo.CreateNoWindow = $false
$notepadStartInfo.UseShellExecute = $false

$notepadProcess = New-Object System.Diagnostics.Process
$notepadProcess.StartInfo = $notepadStartInfo
$notepadProcess.EnableRaisingEvents = $true

try {
    $notepadProcess.Start() | Out-Null

    $threadHandle = [NativeMethods]::OpenThread([NativeMethods]::THREAD_SUSPEND_RESUME, $false, $notepadProcess.Threads[0].Id)
    [NativeMethods]::SuspendThread($threadHandle) | Out-Null

    Write-Host "Notepad started in a suspended state. Press any key to resume."
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null

    [NativeMethods]::ResumeThread($threadHandle) | Out-Null
}
catch {
    Write-Host "Error starting Notepad: $_"
}
