﻿#language: ru

Функционал: Формирование отчёта Анализ выставленных актов

Как Бухгалтер
Я хочу сформировать отчёт Анализ выставленных актов за декабрь 2023 года
Чтобы проанализировать все ли документы выставлены 

Контекст: 
	
Сценарий: Формирование отчёта Анализ выставленных актов
    Тогда я подключаю TestClient "ТестКлиент" логин "Бухгалтер" пароль ""
	И В командном интерфейсе я выбираю 'Добавленные объекты' 'Анализ выставленных актов'
	Тогда открылось окно 'Анализ выставленных актов'
	И я нажимаю на кнопку с именем 'ВыбратьПериод1'
	Тогда открылось окно 'Выберите период'
	И я нажимаю на гиперссылку с именем "SwitchText"
	И я перехожу к закладке с именем "GroupStandardPeriod"
	И я нажимаю на кнопку с именем 'MonthPeriod'
	И в таблице "PeriodVariantTable" я перехожу к строке:
		| 'Значение'      |
		| 'Прошлый месяц' |
	И я нажимаю на кнопку с именем 'Select'
	Тогда открылось окно 'Анализ выставленных актов'
	И я нажимаю на кнопку с именем 'СформироватьОтчет'
				