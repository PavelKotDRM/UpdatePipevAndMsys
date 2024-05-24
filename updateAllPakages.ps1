$PathPowerShellV7 = "C:\Program Files\PowerShell\7\pwsh.exe"
$PathMsys = "D:\msys64\msys2"
if ($PathPowerShellV7) {
    Write-host "Powershell 7 есть"
    if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Start-Process -FilePath $PathPowerShellV7 -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
        Exit
    }
}
else {
    Write-host "Используем powershell доступной версии"
    if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
        Exit
    }
}
$path_work = Get-Location
$time = [System.Diagnostics.Stopwatch]::StartNew()
$time.Start() #Запуск таймера
python -m pip install --upgrade pip
pip freeze | ForEach-Object{$_.split('==')[0]} | ForEach-Object{pip install --upgrade $_}
poetry self update
Start-Process -FilePath $PathMsys -ArgumentList "pacman -Suy"
$time.Stop() 
$out_str = "Заняло времени: " + $time.Elapsed
Write-Host $out_str
$file = Get-Content .\updateVenv.txt
if (!(Test-Path -Path $file)){
    Write-Error "Нет скрипта"
    Write-Host "Нажмите любую клавишу..."
    [void][System.Console]::ReadKey($true)
    Exit
}
Write-Host ("Работаем в " + $path_work)
$script_path = ($pwd.path + "\chekUpdate.ps1")
if (!(Test-Path -Path $script_path)){
    Write-Error "Нет скрипта"
    Write-Host "Нажмите любую клавишу..."
    [void][System.Console]::ReadKey($true)
    Exit
}
$argum_for_com = ("-File " + $script_path)
foreach ($item in $file) {
    if (Test-Path -Path $item){
        Start-Process -FilePath $PathPowerShellV7 -ArgumentList $argum_for_com -WorkingDirectory $item
    }
  }
Write-Host "Нажмите любую клавишу..."
[void][System.Console]::ReadKey($true)