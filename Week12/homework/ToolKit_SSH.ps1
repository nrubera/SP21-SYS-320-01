# Storyline: Script that contains cmdlets that would be helpful during and incident response

function tool_kit(){

# Prompts user for location path to save exported files
$savePath = Read-Host -Prompt "Please create a folder on your desktop and then enter file path to that folder. Example: C:\Users\Bob\Desktop\files"

# Gets Processes and prints them out to csv
Get-Process | Select-Object ProcessName, Path, ID | ` 
Export-csv -Path $savePath"\process.csv" -NoTypeInformation

# Gets registered services
Get-WmiObject win32_service | Select Name,StartMode, PathName | `
Export-csv -Path $savePath"\services.csv" -NoTypeInformation

# Gets all TCP network sockets
Get-NetTCPConnection | `
Export-csv -Path $savePath"\tcpsocket.csv" -NoTypeInformation

# Gets all user account info (output on this is a little funky becuase this was done on a SKIFF machine and my persoanl user account is a domain one not saved locally)
Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | `
Export-csv -Path $savePath"\userinfo.csv" -NoTypeInformation

# Gets all NetworkAdapterConfig info
Get-NetAdapter -Name * | `
Export-csv -Path $savePath"\netinfo.csv" -NoTypeInformation

# Get-Content is a cmdlet that allows you to check the contents of a file. This can be useful to check the contents of a config file for example.
# For this script I will have it print out the contents of a test file I will make to show functionality.
Get-Content -Path C:\Users\nrube\Desktop\test\sample.txt | `
Export-csv -Path $savePath"\contents.csv" -NoTypeInformation

# Get-Process | Where-Object is a cmdlet that will search for a process when you give it the specfic process name. It will create a list of how many instances of that
# proccess ir running. For this example I will use iexplore
Get-Process | Where-Object {$_.Name –eq “iexplore”} | `
Export-csv -Path $savePath"\where.csv" -NoTypeInformation

# Get-ExecutionPolicy cmdlet is a cmdlet that lets the user see what the execution policy for scripts.
# This could help to see if the execution policy is loose and that might be a lead on if a malicious script had been run.
Get-ExecutionPolicy | `
Export-Csv -Path $savePath"\executionPolicy.csv" -NoTypeInformation

# Test-Connection is a cmdlet that tests network connectivity. I used it to ping google for this example
# I thought this was a good test just to see if outbound network connectivity was a thing.
Test-Connection 8.8.8.8 -Count 2 -Delay 2 | `
Export-Csv -Path $savePath"\networkConnection.csv"


# Creating FileHash for each file in folder
Get-FileHash C:\Users\nrube\Desktop\test\*.csv | `
Export-Csv -Path C:\Users\nrube\Desktop\test\FileHashes\hash.csv

}

# Calling function and compressing files into a zip file
tool_kit 
Compress-Archive -Path C:\Users\nrube\Desktop\test -DestinationPath C:\Users\nrube\Desktop\results.zip

# Start SSH session
New-SSHSession -ComputerName '192.168.4.50' -Credential (Get-Credential nicholas.rubera@cyber.local)

# SCP file
Set-SCPFile -ComputerName '192.168.4.50' -Credential (Get-Credential nicholas.rubera@cyber.local) `
-RemotePath '/home/nicholas.rubera@cyber.local' -LocalFile 'C:\Users\nrube\Desktop\results.zip'

# Check to see if file was sent
(Invoke-SSHCommand -index 0 'ls -l').output