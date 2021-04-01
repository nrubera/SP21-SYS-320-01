# Stroyline: List all services running, stopped, or all services

function get_service() {
$arrService =@('All', 'Stopped', 'Running')

$readService = Read-Host -Prompt "Please enter a service state (Running, Stopped, All) or 'q' to quit"

if ($readService -match "^[qQ]$"){ # Quits program
    
      break
}

if ($readService -match "Running"){ # Prints only running services

     Get-WmiObject win32_service |  where {$_.State -eq $arrService[2]
} | Select Name, DisplayName, StartMode | sort Name

}

if ($readService -match "Stopped"){ # Prints only stopped services

     Get-WmiObject win32_service |  where {$_.State -eq $arrService[1]
} | Select Name, DisplayName, StartMode | sort Name


}


if ($readService -match "All"){ # Prints All services

     Get-WmiObject win32_service | Select Name, DisplayName, StartMode | sort Name

}

if ($readService -notmatch "Running","Stopped","All","q","Q"){

    write-host -BackgroundColor red -ForegroundColor White "Please enter as valid state."
       sleep 2
       get_service

}

} # end function

get_service


