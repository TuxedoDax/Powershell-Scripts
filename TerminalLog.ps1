#  Script shows a clean way to write to terminal for bigger scripts, which allows for easy identification of output types.

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

#  Showing the different types of output that the previous switch function creates.
TerminalLog "Info" "This switch statement can easily be copied around for logging purposes."
TerminalLog "Success" "Things are going exactly as planned."
TerminalLog "Warning" "If you're seeing this, then something is happening you should know about."
TerminalLog "Error" "This means that you've encountered an unexpected error, and we need to figure out what that is."
TerminalLog "Testing" "This is just a test. You should never see this in production."
