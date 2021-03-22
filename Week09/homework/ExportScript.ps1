# Storyline: Using the Get-Process and Get-Service

# Gets Processes and prints them out to csv
Get-Process | Select-Object ProcessName, Path, ID | ` 
Export-csv -Path "C:\users\nicholas.rubera\Desktop\myProcesses.csv" -NoTypeInformation

#Prints out running services to a csv
Get-Service | where { $_.Status -eq "Running" } | `
Export-csv -Path "C:\users\nicholas.rubera\Desktop\myServices.csv" -NoTypeInformation
