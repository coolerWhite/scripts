# Установка данных для отправки уведомления по почте
#$from = "отправитель@example.com"
#$to = "получатель@example.com"
#$subject = "Уведомление: Файлы .cer были скачаны"
#$body = "Файлы .cer были успешно скачаны с сайта."

$date = Get-Date

$scripts = @(
    "fssp"
    "nalog"
    "roskazna_anul"
    "roskazna_korn"
)

foreach ( $script in $scripts ){
    Set-Location $script
    try {
        ./parsing.ps1
    }
    catch {
        Write-Output "$date Один из скриптов не отработал" >> log.txt
    }
    finally {
        # Отправка уведомления по почте о загрузке файлов
        #Send-MailMessage -From $from -To $to -Subject $subject -Body $body 
        Write-Output "$date Все скрипты отработали" >> log.txt 
        Set-Location ..
    }
}

