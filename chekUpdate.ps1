$time = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Обновление в:"
$work_dir = Get-Location
Write-Host $work_dir
$time.Start() #Запуск таймера
pipenv update
$time.Stop() 
$out_str = "Заняло времени: " + $time.Elapsed
Write-Host $out_str
Write-Host "Нажмите любую клавишу..."
[void][System.Console]::ReadKey($true)