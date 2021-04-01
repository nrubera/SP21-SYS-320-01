# Storyline: View the event logs, check for a valid log, and print the results

function select_log() {
    
    cls
    # List all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host

    # Initialize the array to stroe the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {
        
        # Add each log to the array
        # NOTE: These are stored in the array as a hastable in the format:
        # @{Log=LOGNAME}
        $arrLog += $tempLog
    }

    # Prompt the user for the log to view or quit
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if the user wants to quit
    if ($readLog -match "^[qQ]$"){

        break
    }

    log_check -logToSearch $readLog
}


function log_check() {

    # String user types in within the select_log function
    Param([string]$logToSearch)

    # Format the user's input
    $theLog = "^@[Log=" + $logToSearch + "]$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog){

        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to get the log entries"
        sleep 2

        # Call the function to view the log
        view_log -logToSearch $logToSearch

    } else {

        write-host -BackgroundColor red -ForegroundColor White "The log does not exist"
        sleep 2

        select_log

    }


}


function view_log(){

    cls

    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "3/31/2021"

    # Pause the screen adn wait until the user is ready to proceed
    read-host -Prompt "Press enter when you are done"

    # Go back to select_log
    select_log

}

# Run the select_log function first
select_log