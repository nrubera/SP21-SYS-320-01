 # Stroyline: Send an email

 # Body of the email
 $msg = "Hello There."

 # Email from address
 $email = "nicholas.rubera@mymail.champlain.edu"

 # To address
 $toEmail = "deployer@csi-web"

 # Send the email
 Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -body $msg -SmtpServer 192.168.6.71