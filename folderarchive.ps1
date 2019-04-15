#!/bin/pwsh
# moves all contents from one directory into another directory, contained within a timestamped archive folder
# replace:
# C:\from\ and C:\to\ with actual source and destination dirs
# noreply@chadg.net with an actual recipient
# smtp.chadg.net with an actual smtp server
# $env:UserName@chadg.net with a real domain

# define source and destination (with timestamp)
$sourcecontent = "C:\from\*"
$destinationpath = "C:\to\"
$destinationname = "archive$(Get-Date -UFormat `"%Y-%m-%d-%H-%M-%S`")"

# source content objects
$sourcecontentobjects = Get-ChildItem -Recurse -Path $sourcecontent

# source content count
$sourcecount = $sourcecontentobjects | Measure-Object | Select Count

# stop if empty
if ( $sourcecount.Count -eq 0 ) {
Write-Host 'No objects to move, exiting'
exit
}

# create destination directory
New-Item -Path $destinationpath -Name $destinationname -ItemType "directory"

# move source content into destination directory
Move-Item -Path $sourcecontent -Destination $destinationpath$destinationname

# count dirs
$sourcecountdirs = $sourcecontentobjects | Where-Object {$_.PSIsContainer} | Measure-Object | Select Count

# count not dirs (files)
$sourcecountfiles = $sourcecontentobjects | Where-Object {!$_.PSIsContainer} | Measure-Object | Select Count

# mail it
Send-MailMessage -To noreply@chadg.net -SmtpServer smtp.chadg.net `
-From $env:UserName@chadg.net -Subject "SCRIPT: $env:ComputerName folderarchive.ps1" `
-Body "sourcecontent: $sourcecontent
destination: $destinationpath$destinationname

dir count:
$sourcecountdirs

file count:
$sourcecountfiles"

