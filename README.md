# Инструкция по начальной настройке

## Доработки конфигурации «Управление IT-фирмой для компании «Ваш компьютерный мастер»

------

### Введение

По техническому заданию Заказчика был разработан новый функциональный модуль по обслуживанию клиентов и модуль для расчёта управленческой заработной платы. 
Все добавленные константы, справочники, документы, обработки и отчеты в рамках разработанных модулей размещены в новой служебной подсистеме Добавленные объекты.

В конфигурацию добавлены следующие константы:
- Токен управления Телеграм-Ботом
- Идентификатор группы оповещения
- Номенклатура Абонентская плата
- Номенклатура Работы специалиста

В конфигурацию добавлены следующие документы:
- Обслуживание клиента
- Выплата зарплаты
- График Отпусков
- Начисление фиксированной премии
- Начисление зарплаты

В конфигурацию добавлены следующие обработки:
- Заполнение графика работы
- Массовое создание актов

В конфигурацию добавлены следующие отчёты:
- Анализ выставленных актов
- Выработка специалиста
- Расход запланированных отпусков
- Расчеты с сотрудниками

В конфигурацию добавлены роли:
- Бухгалтер ИТ фирмы
- Кадровик расчетчик
- Менеджер
- Специалист

Для того, чтобы начать работу с новым функционалом необходимо Администратору произвести предварительные настройки:
- произвести Интеграцию с Телеграм и заполнить константы для интеграции с 1С
- заполнить константы для расчетов услуг по Обслуживанию клиентов
- настроить права доступа сотрудникам

------

### Интеграция с Телеграм и заполнение констант для интеграции с 1С

Создание бота
1. Напишете в Телеграм https://t.me/BotFather команду "/start"
2. Напишите команду "/newbot"
3. Выберите имя вашего бота, которое будут видеть пользователи
4. Выберите идентификатор вашего бота (он должен заканчиваться на "bot")
5. Скопируйте токен, который пришлет BotFather
6. В 1С откройте подсистему Добавленные объекты подраздел Сервис и сохраните скопированный токен в константу "Токен управления Телеграм-Ботом".

Создание группы
1. Создайте группу в Телеграм
2. Добавьте в группу только что созданного бота
3. Назначьте боту права администратора
4. Добавьте в группу специалистов

Получите идентификатор группы
1. Напишите любое сообщение в группу
2. С помощью браузера или Postman выполните запрос https://api.telegram.org/bot[ВашТокен]/getUpdates. 
3. В полученном JSON найдите идентификатор группы, в которой получено сообщение и скопируйте его
4. В 1С откройте подсистему Добавленные объекты подраздел Сервис и сохраните скопированный идентификатор в константу "Идентификатор группы оповещения".

------

### Настройка констант для расчетов услуг по Обслуживанию клиентов

1. В 1С откройте подсистему Добавленные объекты подраздел Сервис и заполните константу "Номенклатура Абонентская плата". В дальнейшем из данной константы будет проставляться по умолчанию услуга в качестве Абонентской платы в документ Реализация товаров и услуг.
2. В 1С откройте подсистему Добавленные объекты подраздел Сервис и заполните константу "Номенклатура Работы специалиста". В дальнейшем из данной константы будет проставляться по умолчанию услуга в качестве Работ специалиста в документ Реализация товаров и услуг.

------

### Настройка прав доступа сотрудникам
- Для Бухгалтрера установите права Бухгалтер ИТ фирмы. Под данными правами доступна обработка для Массового создания документов Реализация товаров и услуг и Отчёт по анализу выставленных актов.
- Для Кадровика установите права Кадровик расчетчик. Данные права позволяют производить начисления заработной платы, премий, отпускных, выплаты всех начислений, удержания НДФЛ, учёт отпусков, доступны Отчёты по расчетам с сотрудниками, по выработке специалистов  и по отпускам. 
- Для Менеджеров установите права Менеджер. Данные права позволяют работать с документами Обслуживание, Реализация, справочником Клиенты, Номенклатура. 
- Для Специалистов установите права Специалист. Данные права позволяют работать с документом Обслуживание. Доступен отчёт по выработке специалистов. 
  
------