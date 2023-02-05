using System;
using System.Diagnostics;

namespace ProcDeny
{
    internal class Deny
    {
        static void Main(string[] args)
        {
            // Initialize an array of all current running processes
            Process[] localProcs = Process.GetProcesses();
            // Attempt to get SeDebugPrivilege for our current running process
            Process.EnterDebugMode();
            while (true)
            {
                // iterate through array of process objects
                foreach (Process proc in localProcs)
                {
                    // If array contains process with given name, kill it.
                    if (proc.ProcessName == "firefox")
                    {
                        Console.WriteLine(proc.ProcessName + " found.\t\nKilling pid: " + proc.Id);
                        proc.Kill();
                    }
                }
                // Continous Scanning of all processes
                localProcs = Process.GetProcesses();
            }
        }
    }
}