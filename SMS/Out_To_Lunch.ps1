###########################################################
# AUTHOR  : Chase Dudas
# CREATED : 7/5/2018
# Title   : Out to Lunch 
# COMMENT : Sends SMS messages via Twilio  
###########################################################
# ENVIRONMENTAL
###########################################################

[Environment]::SetEnvironmentVariable("TWILIO_ACCOUNT_SID", "ACb92d9e645f10846539fb7d466b9c08fe", "User")
[Environment]::SetEnvironmentVariable("TWILIO_AUTH_TOKEN", "292ee2e6c53f42a39989f660641d2541", "User")
[Environment]::SetEnvironmentVariable("USERNAME", "127983", "User")

###########################################################
# PARAMETERS
###########################################################

$DAYOFWEEK = (Get-Date).DayOfWeek.value__;
$KNum = "+18185196042"
$RNum = "+18056039403"
$CNum = "+18053900337"
$DNum = "+17192003890"
$HNum = "+17204419601"
$MyTwilNum = "+14243690755"
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