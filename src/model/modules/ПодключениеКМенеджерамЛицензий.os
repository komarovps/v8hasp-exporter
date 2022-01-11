#Использовать logos
#Использовать v8haspmonitor
#Использовать ReadParams

Перем МониторАппаратныхКлючей;
Перем Лог;

Процедура Инициализировать()

    Лог = Логирование.ПолучитьЛог("oscript.webapp.v8hasp-exporter");
    Лог.УстановитьУровень(УровниЛога.Отладка);

    Параметры = Параметры();
    ПутьКФайлуНастроек = Параметры["nethasp-path"];
    ПутьКИсполняемомуФайлу = Параметры["hsmon-path"];

    МониторАппаратныхКлючей = Новый МониторАппаратныхКлючей(ПутьКФайлуНастроек, ПутьКИсполняемомуФайлу);

КонецПроцедуры

Функция ТаблицыМетрикДляPrometheus(Знач ПолучатьПодключения = Ложь) Экспорт

    ТаблицыМетрик = Новый Структура();

    МенеджерыЛицензий = МониторАппаратныхКлючей.СписокМенеджеровЛицензий();
    АппаратныеКлючи = НоваяТаблицаКлючей();
    Подключения = НоваяТаблицаПодключений();

    Для Каждого МенеджерЛицензий Из МенеджерыЛицензий Цикл

        КлючиТекущегоМенеджера = МониторАппаратныхКлючей.СписокМодулейМенеджераЛицензий(
            МенеджерЛицензий.Идентификатор);

        Для Каждого Ключ Из КлючиТекущегоМенеджера Цикл
            НоваяСтрока = АппаратныеКлючи.Добавить();
            НоваяСтрока.Менеджер = МенеджерЛицензий;
            ЗаполнитьЗначенияСвойств(НоваяСтрока, Ключ);

            Если НЕ ПолучатьПодключения Тогда
                Продолжить;
            КонецЕсли;
            
            ТаблицаПодключений = МониторАппаратныхКлючей.СписокПодключений(Ключ);

            Для Каждого Подключение Из ТаблицаПодключений Цикл
                НоваяСтрока = Подключения.Добавить();
                НоваяСтрока.Менеджер = МенеджерЛицензий;
                НоваяСтрока.Ключ = Ключ;
                НоваяСтрока.Количество = 1;
                ЗаполнитьЗначенияСвойств(НоваяСтрока, Подключение);
            КонецЦикла;

        КонецЦикла;

    КонецЦикла;

    ТаблицыМетрик.Вставить("МенеджерыЛицензий", МенеджерыЛицензий);
    ТаблицыМетрик.Вставить("АппаратныеКлючи", АппаратныеКлючи);
    ТаблицыМетрик.Вставить("Подключения", Подключения);

    Возврат ТаблицыМетрик;

КонецФункции

Функция СписокМенеджеровЛицензий() Экспорт

    МенеджерыЛицензий = МониторАппаратныхКлючей.СписокМенеджеровЛицензий();

    Возврат МенеджерыЛицензий;

КонецФункции

Функция НоваяТаблицаКлючей()
    
    ТаблицаКлючей = Новый ТаблицаЗначений;
    ТаблицаКлючей.Колонки.Добавить("Менеджер");
    ТаблицаКлючей.Колонки.Добавить("АдресМодуля");
    ТаблицаКлючей.Колонки.Добавить("Тип");
    ТаблицаКлючей.Колонки.Добавить("МаксимальноеКоличествоПодключений");
    ТаблицаКлючей.Колонки.Добавить("ТекущееКоличествоПодключений");
    
    Возврат ТаблицаКлючей;

КонецФункции

Функция НоваяТаблицаПодключений()

    ТаблицаПодключений = Новый ТаблицаЗначений;
    ТаблицаПодключений.Колонки.Добавить("Менеджер");
    ТаблицаПодключений.Колонки.Добавить("Ключ");
    ТаблицаПодключений.Колонки.Добавить("Номер");
    ТаблицаПодключений.Колонки.Добавить("АдресХоста");
    ТаблицаПодключений.Колонки.Добавить("ИмяХоста");
    ТаблицаПодключений.Колонки.Добавить("Протокол");
    ТаблицаПодключений.Колонки.Добавить("Таймаут");
    ТаблицаПодключений.Колонки.Добавить("Количество");
    
    Возврат ТаблицаПодключений;

КонецФункции

Функция Параметры()

    ФайлПараметров = ОбъединитьПути(ТекущийКаталог(), "..", "params.json");
        
    ОшибкиЧтения = Неопределено;
    Параметры = ЧтениеПараметров.Прочитать(ФайлПараметров, ОшибкиЧтения);

    Для каждого КлючЗначение Из ОшибкиЧтения Цикл		
        Лог.Ошибка( "Ошибка чтения файла params.json " + КлючЗначение.Ключ + ": " + КлючЗначение.Значение );
    КонецЦикла;
    
    Лог.ПоляИз(Параметры).Отладка("Параметры из params.json");

    Возврат Параметры;

КонецФункции

Инициализировать();