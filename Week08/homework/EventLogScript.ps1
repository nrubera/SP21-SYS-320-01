# Storyline: Review the Security Event Log

# List all the avaliable Windows Event Logs
Get-EventLog -List

# Create a prompt to allow user to select log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above:"

# Creates a prompt to allow user to enter a search phrase
$readPhrase = Read-Host -Prompt "Please enter search phrase for log:"

#Print the log (Video 2 challenge)
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike $readPhrase } | export-csv -NoTypeInformation `
-Path "C:\Users\nicholas.rubera\Desktop\logs.csv"