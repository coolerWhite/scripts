# Установка данных для отправки уведомления по почте
#$from = "отправитель@example.com"
#$to = "получатель@example.com"
#$subject = "Уведомление: Файлы .cer были скачаны"
#$body = "Файлы .cer были успешно скачаны с сайта."

$date = Get-Date

# списко директорий где лежат скрипты 
$scripts = @(
    "fssp"
    "nalog"
    "roskazna_anul"
    "roskazna_korn"
)

# Адрес SMTP сервера не обязательно указывать, если вы задали адрес почтового сервера в переменной окружения $PSEmailServer:
#$PSEmailServer = ""

# Для удобства редактирования
#Send-MailMessage `
#-SmtpServer smtp.winitpro.ru `
#-To 'admin@winitpro.ru','manager@winitpro.ru' `
#-From 'server@winitpro.ru' `
#-Subject "test" `
#-Body "Тема письма на русском" `
#-Encoding 'UTF8'

# цикл для захода в каждую директорию и запуск
foreach ( $script in $scripts ){
    Set-Location $script
    try {
        ./parsing.ps1
    }
    catch {
        # запись в log.txt ошибки
        Write-Output "$date Один из скриптов не отработал" >> log.txt
    }
    finally {
        # Отправка уведомления по почте о загрузке файлов и запись в log.txt о отработке одного скрипта
        #Send-MailMessage -From $from -To $to -Subject $subject -Body $body 
        Write-Output "$date Все скрипты отработали" >> log.txt 
        Set-Location ..
    }
}

