# Установка данных для отправки уведомления по почте
#$from = "отправитель@example.com"
#$to = "получатель@example.com"
#$subject = "Уведомление: Файлы .cer были скачаны"
#$body = "Файлы .cer были успешно скачаны с сайта."

# название ресураса
$resources = @(
    "https://roskazna.gov.ru/gis/udostoveryayushhij-centr/kornevye-sertifikaty/"
)

# список расширений которые будем искать
$ext = @(
    "*.crl"
    "*.crt"
    "*.srf"
    "*.cer")

$date = Get-Date    

# цикл общий
foreach($urls in $resources){
    $link = wget -Uri $urls -UseBasicParsing

    #цикл получения расширений из найденых ссылок
    foreach ($extens in $ext){
        $linkurl = $link.Links.Href | Where-Object { $_ -like $extens}
        # переменная для проверки файлов с расширениями
        $cerFiles = Get-ChildItem -Path $PWD -Filter $extens
        
        # условие скачивания новых файлов (если его не будет)
        if ($cerFiles.Count -eq 0) {

            # цикл скачивания новых файлов
            foreach ($url in $linkurl){
                
                # убираем все что не является названием файла
                $urlname = ($url -split '/')[-1]
                
                # т.к у Росказный ссылки на внутрений ресурс, то надо добавить к относительному путь основной сайт
                $url_add = "https://roskazna.gov.ru/" + $url
                wget -Uri $url_add -OutFile "$urlname" -Verbose
                # запись в log.txt о скаченном файле
                echo "$date file dowload $urlname" >> C:\Users\vic\scripts\log.txt
            }
        # Отправка уведомления по почте о загрузке файлов
        #Send-MailMessage -From $from -To $to -Subject $subject -Body $body    
        }
        else {
            # если файл уже есть, то он не скачивается и записывается в log.txt
            echo "$date Files dowload before $extens" >> C:\Users\vic\scripts\log.txt
        }
    }
}
