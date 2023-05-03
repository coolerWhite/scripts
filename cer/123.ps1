# Установка данных для отправки уведомления по почте
#$from = "отправитель@example.com"
#$to = "получатель@example.com"
#$subject = "Уведомление: Файлы .cer были скачаны"
#$body = "Файлы .cer были успешно скачаны с сайта."

$resources = @(
    "https://www.nalog.gov.ru/rn77/related_activities/ucfns/ccenter_res/"
    "https://fssp.gov.ru/sertif/"
    "https://www.gosuslugi.ru/crt"
)

$ext = @(
    "*.crl"
    "*.crt"
    "*.srf"
    "*.cer")

foreach($urls in $resources){
    $link = wget -Uri $urls -UseBasicParsing

    foreach ($extens in $ext){
        $link.Links.Href | Where-Object { $_ -like $extens } > file1.txt

        $linkurl = $link.Links.Href | Where-Object { $_ -like $extens}

        $cerFiles = Get-ChildItem -Path $PWD -Filter $extens
        if ($cerFiles.Count -eq 0) {
            foreach ($url in $linkurl){
                $urlname = ($url -split '/')[-1]
                wget -Uri $url -OutFile "C:\Users\vic\scripts\cer\$urlname" -Verbose
                echo "file dowload $urlname"
            }
        # Отправка уведомления по почте о загрузке файлов
        #Send-MailMessage -From $from -To $to -Subject $subject -Body $body    
        }
        else {
            Write-Host "Files dowload before $extens"
        }
    }
}