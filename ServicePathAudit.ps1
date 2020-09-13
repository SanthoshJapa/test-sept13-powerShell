# Adding some comments about the script 
# Script goes to every services, If service path have any spaces and the path is not included in Quotes, 
# the script will write the service name and path to output file 

$ResultsLogFile = "C:\Temp\results.log"
$HostName = $env:COMPUTERNAME
$counter = 2

# Gather Services information from WMI
$Services = Get-WmiObject -Class win32_service -Property name,pathname
    
# Filter out services that have been enclosed with quotations
$UnquotedPath = $Services | Where-Object {$_.PathName -notmatch '"'} | Select Name,PathName

# Loop through services without quotations
foreach ($Path in $UnquotedPath){
        
    $Drive = $Path.PathName | Split-Path -Qualifier
    $Executable = $Path.PathName | Split-Path -Leaf

    ## the logic below will exclude spaces used in any parameters
    if( ($Path.PathName -match ' ') -and ($Executable -notmatch ' ') -and ($Path.PathName -notmatch './') ){
        # Vulnerability Found
        Write-output ("Unquoted Service Path Discovered for " + $Path.Name + "    PATH: " + $Path.PathName + " on " + $HostName )   | Out-File $ResultsLogFile -Append
        $counter = 1
    } # End conditional operators
} # End Foreach Path in UnquotedPath

# sample instruction
dir c:\temp

if ($counter -ne 1)
{
Write-output ("No vulnerabilites found on $hostname")   | Out-File $ResultsLogFile -Append
}
 

 
