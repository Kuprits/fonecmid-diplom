
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если Не ЗначениеЗаполнено(Константы.ВКМ_НоменклатураРаботыСпециалиста.Получить()) Тогда
	Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа Номенклатура Работы специалиста.");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Константы.ВКМ_НоменклатураАбонентскаяПлата.Получить()) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа Номенклатура Абонентская плата.");
		Возврат;
	КонецЕсли;

	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "ВидДоговора, ВКМ_ДатаНачалаДействия, ВКМ_ДатаОкончанияДействия, ВКМ_СтоимостьЧасаРаботыСпециалиста"); 
	
	Если РеквизитыДоговора.ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Договор не является договором на абонентское обслуживание. Выберите другой договор или измените Вид договора на Абонентское обслуживание.");
		Возврат;
	КонецЕсли;
		
	Если РеквизитыДоговора.ВКМ_ДатаНачалаДействия > Дата 
		ИЛИ РеквизитыДоговора.ВКМ_ДатаОкончанияДействия < Дата Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Дата документа не попадает в период действия договора. Укажите другую дату.");
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ПроцентОтРабот КАК ПроцентОтРабот
	               |ИЗ
	               |	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&Дата, Сотрудник = &Сотрудник) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних";
	
	Запрос.УстановитьПараметр("Сотрудник", Специалист);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Выборка = Запрос.Выполнить();
	
	Если Выборка.Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Не заполнены условия оплаты сотруднику.");
		Возврат;
	КонецЕсли; 
	
	РезультатЗапроса = Выборка.Выбрать();
	Пока РезультатЗапроса.Следующий() Цикл
		УсловияОплатыСотрудников = РезультатЗапроса.ПроцентОтРабот;
	КонецЦикла;
	
    Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;
	Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записывать = Истина;
	Для Каждого ТекСтрокаВыполненныеРаботы из ВыполненныеРаботы Цикл
		СтоимостьЧасаРаботыСпециалиста = РеквизитыДоговора.ВКМ_СтоимостьЧасаРаботыСпециалиста;
		
		//движения по регистру ВКМ_ВыполненныеКлиентуРаботы
		Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Договор = Договор;
		Движение.КоличествоЧасов = ТекСтрокаВыполненныеРаботы.ЧасыКОплатеКлиенту;
		Движение.СуммаКОплате = СтоимостьЧасаРаботыСпециалиста * ТекСтрокаВыполненныеРаботы.ЧасыКОплатеКлиенту;
		
		//движения по регистру ВКМ_ВыполненныеСотрудникомРаботы
        Движение = Движения.ВКМ_ВыполненныеСотрудникомРаботы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = Специалист;
		Движение.ЧасовКОплате = ТекСтрокаВыполненныеРаботы.ЧасыКОплатеКлиенту;
		Движение.СуммаКОплате = СтоимостьЧасаРаботыСпециалиста * УсловияОплатыСотрудников * ТекСтрокаВыполненныеРаботы.ЧасыКОплатеКлиенту / 100;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ЭтоНовыйОбъект", ЭтоНовый());
	
	ТекстУведомления = "";
	
	СтарыйРеквизит = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ДатаПроведенияРабот, ВремяНачалаРаботПлан, ВремяОкончанияРаботПлан, Специалист");
	ПроверитьИзменениеРеквизитов(ТекстУведомления, ДатаПроведенияРабот, СтарыйРеквизит.ДатаПроведенияРабот, "ДатаПроведенияРабот"); 
	ПроверитьИзменениеРеквизитов(ТекстУведомления, ВремяНачалаРаботПлан, СтарыйРеквизит.ВремяНачалаРаботПлан, "ВремяНачалаРаботПлан");
	ПроверитьИзменениеРеквизитов(ТекстУведомления, ВремяОкончанияРаботПлан, СтарыйРеквизит.ВремяОкончанияРаботПлан, "ВремяОкончанияРаботПлан");
	ПроверитьИзменениеРеквизитов(ТекстУведомления, Специалист, СтарыйРеквизит.Специалист, "Специалист");
	
	Если ЗначениеЗаполнено(ТекстУведомления) Тогда
		ТекстУведомленияДок = СтрШаблон("В заявке №%1 от %2 на обслуживание клиента ""%3"" внесены изменения.", 
			ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Номер), Формат(Дата, "ДЛФ=DD"), Клиент);
			
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(ТекстУведомленияДок);
		МассивСтрок.Добавить(ТекстУведомления);
		ТекстУведомления = СтрСоединить(МассивСтрок, Символы.ПС);
		
		ДополнительныеСвойства.Вставить("ТекстУведомления", ТекстУведомления);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовыйОбъект Тогда
		ТекстУведомления = СтрШаблон("Получена заявка №%1 от %2 на обслуживание клиента ""%3"". 
			|Исполнителем назначен специалист: %4. 
			|Планируемый период проведения работ: %5 с %6 до %7.",
			ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Номер), 
			Формат(Дата, "ДЛФ=DD"), Клиент, Специалист, Формат(ДатаПроведенияРабот, "ДЛФ=DD"), 
			Формат(ВремяНачалаРаботПлан, "ДЛФ=T"), Формат(ВремяОкончанияРаботПлан, "ДЛФ=T"));
		СформироватьУведомление(ТекстУведомления);
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ТекстУведомления") Тогда
		СформироватьУведомление(ДополнительныеСвойства.ТекстУведомления);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьИзменениеРеквизитов(ТекстУведомления, ПроверяемыйРеквизит, СтарыйРеквизит, НаименованиеРеквизита)
	
	Если ПроверяемыйРеквизит <> СтарыйРеквизит Тогда
		Если НаименованиеРеквизита = "Специалист" Тогда	
			НовыйТекстУведомления = СтрШаблон("Изменен исполнитель проведения работ. Новый исполнитель: %1.", Специалист); 
		ИначеЕсли НаименованиеРеквизита = "ДатаПроведенияРабот" Тогда
			НовыйТекстУведомления = СтрШаблон("Изменена планируемая дата проведения работ. Новая дата: %1", Формат(Дата, "ДЛФ=DD"));
		ИначеЕсли НаименованиеРеквизита = "ВремяНачалаРаботПлан" Тогда
			НовыйТекстУведомления = СтрШаблон("Изменено планируемое время начала проведения работ. Новое время с: %1.", Формат(ВремяНачалаРаботПлан, "ДЛФ=T"));
		ИначеЕсли НаименованиеРеквизита = "ВремяОкончанияРаботПлан" Тогда
			НовыйТекстУведомления = СтрШаблон("Изменено планируемое время окончания проведения работ. Новое время до: %1.", Формат(ВремяОкончанияРаботПлан, "ДЛФ=T"));
		КонецЕсли;	
		
		Если ТекстУведомления = "" Тогда
			ТекстУведомления = НовыйТекстУведомления;
		Иначе
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить(ТекстУведомления);
			МассивСтрок.Добавить(НовыйТекстУведомления);
			ТекстУведомления = СтрСоединить(МассивСтрок, Символы.ПС);
		КонецЕсли;			 
	КонецЕсли;

КонецПроцедуры

Процедура СформироватьУведомление(ТекстУведомления)

	НовоеУведомление = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
	НовоеУведомление.Текст = ТекстУведомления;
	НовоеУведомление.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли