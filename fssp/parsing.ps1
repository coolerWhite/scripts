# Установка данных для отправки уведомления по почте
#$from = "отправитель@example.com"
#$to = "получатель@example.com"
#$subject = "Уведомление: Файлы .cer были скачаны"
#$body = "Файлы .cer были успешно скачаны с сайта."

$resources = @(
    "https://fssp.gov.ru/sertif/"
)

$ext = @(
    "*.crl"
    "*.crt"
    "*.srf"
    "*.cer")

$date = Get-Date     

foreach($urls in $resources){
    $link = wget -Uri $urls -UseBasicParsing

    foreach ($extens in $ext){
        $linkurl = $link.Links.Href | Where-Object { $_ -like $extens}        
        $cerFiles = Get-ChildItem -Path $PWD -Filter $extens

        if ($cerFiles.Count -eq 0) {
            foreach ($url in $linkurl){
                $urlname = ($url -split '/')[-1]
                $url_add = "https://fssp.gov.ru/" + $url
                wget -Uri $url_add -OutFile "$urlname" -Verbose
                echo "$date file dowload $urlname" >> C:\Users\vic\scripts\log.txt
            }
        # Отправка уведомления по почте о загрузке файлов
        #Send-MailMessage -From $from -To $to -Subject $subject -Body $body    
        }
        else {
            Write-Host "$date Files dowload before $extens" >> C:\Users\vic\scripts\log.txt
        }
    }
}
