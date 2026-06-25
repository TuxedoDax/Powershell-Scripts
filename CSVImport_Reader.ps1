#  This script is intended to be used as a plug and play way to read in a CSV file to powershell.

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

#  Main Script

#  Getting the current working directory.
$directoryPath = WorkingDirectory

#  Name of the CSV file.
$csvName = Read-Host "What is the name of the file you want to read in? (include '.csv')"

#  Import the CSV
$csvFile = CSVImport $directoryPath $csvName

#  Getting the name of the column we wnat to read in.
$headerName = Read-Host "What is the name of the column that will be read in?"

#  Read the csvFile and store the column data specified in $headerName .
$csvList = CSVReader $csvFile $headerName
