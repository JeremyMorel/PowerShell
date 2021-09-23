#Get all MSTeams with Guest Users and output the results

##Cleaninguptheteamscloset##
Install-Module MicrosoftTeams
Install-Module PSWriteHTML -Force

#1. Connect to Microsoft Teams
Connect-MicrosoftTeams

#2. generate Arrays and Counter
$teams = @()
$externalteams = @()
$counter = 0

#3. Get all teams and pass them to $Teams
$Teams = Get-Team

#4. Create Progress bar for script
foreach ($team in $teams){
$counter++
Write-Output $counter
Write-Progress -Activity 'Processing Teams' -CurrentOperation $team -PercentComplete (($counter / $teams.count) * 100)
  
# 5. Get the groupid and pass it to $GroupID
 $GroupID = $_.GroupID

# 6. Get Team Users "name" who have a role of "Guest" and pass it to $users
# 7. Get Team Users "name" who have a role of "Owner" and pass it to $teamowner
  $users = (Get-TeamUser -GroupId $team.groupid | Where-Object {$_.Role -eq "Guest"})
  $teamowners = (Get-TeamUser -groupid $team.groupid | Where-Object {$_.Role -eq "Owner"})

#For each external user in users we will go ahead and get the following information
# Get the teamid and pass it to the variable $id
# Get the displayname and convert it to a string
# Get the external user and pass them to the variable $ext
# Get the team owners and pass them to the variable $extown

  foreach ($extuser in $users){

    #group id 
    $id = $team.groupid
    #get displayname from team
    $teamext = ((Get-Team | Where-Object {$_.groupid -eq "$id"}).DisplayName).ToString()
    #get the external users 
    $ext = $extuser.User
    $extown = $teamowners.User
    
#Within the foreach loop we will create a custom object and pass our variables to it.

    $externalteams += [pscustomobject]@{
      GroupID   = $id
      TeamName  = $teamext
      ExtUser   = $ext
      Owner     = (@($extown) -join ',')
       } 
      }
     }

#This now calls out custom object and prints it using the glorious out-htmlview.
$externalteams | Out-HtmlView -Title "external members in Teams"
