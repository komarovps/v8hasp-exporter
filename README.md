# Prometheus экспортер для HASP License Manager

Prometheus экспортер для HASP License Manager

## Требования
* [OneScript.Web](https://github.com/EvilBeaver/OneScript.Web)
* Библиотека [v8haspmonitor](https://github.com/oscript-library/v8haspmonitor)

## Запуск
```
git clone https://github.com/oscript-library/v8hasp-exporter.git
cd v8hasp-exporter/src
omp install -l
<путь к OneScript.Web>\OneScript.WebHost.exe
```
 
В корне репозитория лежит файл `nethasp.ini`, который будет использован в `v8haspmonitor`.
По умолчанию в нем указан 1 адрес: `NH_SERVER_ADDR = 127.0.0.1`.
Путь к файлу `nethasp.ini` можно переопределить в файле `params.json`.

После запуска метрики станут доступны по адресу: `http://localhost:5000/hasp_metrics`

Остается добавить scrape config в `prometheus.yml`

Prometheus можно быстро развернуть в [docker](https://prometheus.io/docs/prometheus/latest/installation/#using-docker)

### Пример `prometheus.yml`
```yml
global:
  scrape_interval:     1m
  scrape_timeout:      10s
  evaluation_interval: 1m

scrape_configs:
  - job_name: 'hasp keys metrics'
    scrape_interval: 1m
    scrape_timeout: 45s
    metrics_path: '/hasp_metrics'
    static_configs:
      - targets:
        - '1ckey01.local.ru:5000'
        - '1ckey02.local.ru:5000'
        - '1ckey03.local.ru:5000'
        - '1ckey04.local.ru:5000'
```
## Метрики

### hasp_lm_info
Информация о менеджерах лицензий
```
# HELP hasp_lm_info Information about HASP license managers
# TYPE hasp_lm_info gauge
hasp_lm_info{id="-1963291233",name="1ckey.local.ru",protocol="UDP(127.0.0.1)"} 1
```

### hasp_cur_load
Сводная информация о текущей утилизации лицензий
```
# HELP hasp_cur_load Information about current keys load
# TYPE hasp_cur_load gauge
hasp_cur_load{lm_name="1ckey.local.ru",ma="1",type="HASPHL",max_users="500"} 478
```

### hasp_sessions_info
Утилизация лицензий по сеансам
```
# HELP hasp_sessions_info Information about key sessions
# TYPE hasp_sessions_info gauge
hasp_sessions_info{lm_name="1ckey01.local.ru",ma="1",host_address="1.2.11.85",host_name="srv.local.ru"} 1
hasp_sessions_info{lm_name="1ckey01.local.ru",ma="1",host_address="1.2.11.18",host_name="pc.local.ru"} 1
hasp_sessions_info{lm_name="1ckey01.local.ru",ma="1",host_address="1.2.10.47",host_name="term.local.ru"} 5

```

## Отключение вывода списка подключений
На больших ключах получение списка подключений может занимать продолжительное время. Если подключения не нужны их можно отключить передав в запрос параметр `nologins`.
```
http://localhost:5000/hasp_metrics?nologins
```