#  This script will read in a CSV containing a list of Display Names, and query AD for their corresponding UPN.
#  Error handling includes; user's with the same display name, being unable to query AD for a specified Display Name.

function TerminalLog ($warning, $text)
{

  switch ($warning)
  {
    #  Each switch statement has it's own name to call, is fed in it's own unique text, and is provided a color for easy identification.
    "Info" {Write-Host "[INFO] - $text `n" -ForegroundColor White}
    "Success" {Write-Host "[Success] - $text `n" -ForegroundColor Green}
    "Warning" {Write-Host "[INFO] - $text `n" -ForegroundColor Yellow}
    "Error" {Write-Host "[INFO] - $text `n" -ForegroundColor Red}
    "Testing" {Write-Host "[INFO] - $text `n" -ForegroundColor DarkMagenta}

  }

function WorkingDirectory
{

  #  Getting current directory
  $directory = Get-Location
  #  Creating a variable that we can more easily use to point to the required file.
  $directoryPath = $directory.Path + "\"

  return $directoryPath

}

function CSVImport ($directoryPath, $csvName)
{

  #  Creating the full path to the file we want to read, including the name.
  $csvPath = $directoryPath + $csvName
  #  Importing the file and saving it's content to a variable. (Currently only looking at a comma to delimit, this should be changed later.)
  $csvIle = Import-Csv $csvPath -Delimiter ","

  return $csvFile

}

function CSVReader ($csvFile, $headerName)
{

  $csvList = @()
  #  Reading the CSV and adding the specified $headerName to a variable we can return.
  foreach ($entry in $csvFile)
  {

    $csvList += $entry.$headerName

  }

  return $csvList

}

function DisplayName_To_UPN ($csvList)
{

  $upnList = @("UPN,"
  $List = @("DisplayName,"

  foreach ($entry in $csvlist)
  {

    TerminalLog "Info" "Getting UPN information for $entry ."

    try
    {

      $fullUPN = Get-ADUser -Filter "DisplayName -eq '$entry'" -Properties DisplayName | Select-Object UserPrincipalName

      #   handling in case there are multiple people with the same name. Requires manual intervention.
      if ($fullUPN.couunt -ne 1)
      {

        TerminalLog "Error" "Too many returned values for $entry"
        $errorList += $entry

      }

      else
      {

        $upn = $fullUPN.UserPrincipalName
        $upnList += $upn

      }

    }

    catch
    {

      TerminalLog "Error" "An error occurred while searching for $entry ."
      $errorList += $entry

    }

  }

  return $upnList, $errorList

}


function ExportFile ($directoryPath, $upnList, $errorList)
{

  #  Getting the current date and time for the export file.
  $currentTime = Get-Date -Format "MM-dd-yyyy-HHmm"

  #      Exporting the UPN list.
  #  File path for export.
  $exportPath = $directoryPath + "upnList_$currentTime.csv"
  #  Exporting the data to a file.
  $upnList | Out-File -FilePath $exportPath

  #      Exporting the Error list.
  #  File path for export.
  $exportPath = $directoryPath + "errorList_$currentTime.csv"
  #  Exporting the data to a file.
  $errorList | Out-File -FilePath $exportPath
  
}

function Stats ($csvList, $upnList, $errorList)
{

  $totalCount = $csvList.count
  $successCount = $upnList.count - 1 #  Subtracting 1 for the header we add to the list for later use.
  $errorCount = $errorList.count - 1 #  Subtracting 1 for the header we add to the list for later use.
  $processedCount = $successCount + $errorCount

  TerminalLog "Info "
  ===== Stats =====
  Total Names: $totalCount
  Successful: $successCount
  Errors: $errorCount
  Processed: $processCount
  =================
  "

}

$csvName = Read-Host ("What is the name of the files you wish to open? (Include .csv)")

$directoryPath = WorkingDirectory

$csvFile = CSVImport $directoryPath $csvName

$csvHeader = "What is the name of the column we will be reading in? (This columns should contain the DisplayNames)"

$csvList = CSVReader $csvFile $headerName

$upnList, $errorList = DisplayName_To_UPN $csvList

ExportFile $directoryPath $upnList $errorList

Stats $csvList $upnList $errorList

Read-Host "Press any key to close this program."
