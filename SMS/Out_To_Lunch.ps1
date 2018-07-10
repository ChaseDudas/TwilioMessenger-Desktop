###########################################################
# AUTHOR  : Chase Dudas
# CREATED : 7/5/2018
# Title   : Twilio Messenger - Desktop 
# COMMENT : Sends SMS messages via Twilio  
###########################################################
# ENVIRONMENTAL
###########################################################

[Environment]::SetEnvironmentVariable("TWILIO_ACCOUNT_SID", "#Your Twilio SID", "User")
[Environment]::SetEnvironmentVariable("TWILIO_AUTH_TOKEN", " Your Twilio Token", "User")
[Environment]::SetEnvironmentVariable("USERNAME", "127983", "User")

###########################################################
# PARAMETERS
###########################################################

$DAYOFWEEK = (Get-Date).DayOfWeek.value__;
#Fill the numbers you would like to message in the "+1----------"
#$KNum = ""
#$RNum = ""
#$CNum = ""
#$DNum = ""
#$HNum = ""
#Put your twilio number in here
$MyTwilNum = ""
$messageUser = ""
$InNum = ""
$bodyMessage = ""

###########################################################
# DIALOG INPUT
###########################################################

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$messageUser = [Microsoft.VisualBasic.Interaction]::InputBox("Who shall I message? (K, C, R, D, H)", "Contact", " ")

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$bodyMessage = [Microsoft.VisualBasic.Interaction]::InputBox("What do you want the message to say?", "Body", " ")

###########################################################
# MAIN FUNCTION
###########################################################

#Switch statement to set the InNum variable to the phone number you selected
switch ($messageUser)
{
    K
    {
        $InNum = $KNum
    }
    C
    {
        $InNum = $CNum
    }
    D
    {
        $InNum = $DNum
    }
    R
    {
        $InNum = $RNum
    }
    H
    {
        $InNum = $HNum
    }
    default
    {
        $InNum = $CNum
    }
}

Write-Host "Sending to: " $messageUser $InNum

# Pull in Twilio account info, previously set as environment variables
$sid = $env:TWILIO_ACCOUNT_SID
$token = $env:TWILIO_AUTH_TOKEN

# Twilio API endpoint and POST params
$url = "https://api.twilio.com/2010-04-01/Accounts/$sid/Messages.json"
$params = @{ To = $InNum ; From = $MyTwilNum ; Body = $bodyMessage }

# Create a credential object for HTTP basic auth
$p = $token | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($sid, $p)

try
{
    # Make API request, selecting JSON properties from response
    Invoke-WebRequest $url -Method Post -Credential $credential -Body $params -UseBasicParsing| ConvertFrom-Json | Select sid, body
}
catch
{
    Write-Host "Failed to send SMS: $_"
}
###########################################################
# END FUNCTION
###########################################################
