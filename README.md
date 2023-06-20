Розничная аналитика v1.0

Выгрузка данных розничной аналитики, их простой анализ, статистика, сегментация клиентов и создание персональных предложений.

## Содержание

1. [Глава I](#chapter-i) 
    
   1.1. [Введение](#introduction)
2. [Глава II](#chapter-ii) 
    
   2.1. [Информация](#information)
3. [Глава III](#chapter-iii) 
    
   3.1. [Часть 1. Создание базы данных](#part-1-creating-a-database)  
   3.2. [Часть 2. Создание представлений](#part-2-creating-views)  
   3.3. [Часть 3. Ролевая модель](#part-3-role-model)  
   3.4. [Часть 4. Формирование персональных предложений, направленных на рост среднего чека](#part-4-forming-personal-offers-aimed-at-the-growth-of-the-average-check)  
   3.5. [Часть 5. Формирование персональных предложений, направленных на увеличение частоты посещений](#part-5-forming-personal-offers-aimed-at-increasing-the-frequency-of-visits)  
   3.6. [Часть 6. Формирование персональных предложений, направленных на кросс-продажи](#part-6-forming-personal-offers-aimed-at-cross-selling)
4. [Глава IV](#chapter-iv)


## Глава I

![SQL3_RetailAnalytics_v1.0](https://edu.21-school.ru/services/storage/download/public_any/182e845c-6712-4356-814d-7295dc8afe30?path=tenantId/96098f4b-5708-4c42-a62c-6893419169b3/gitlab/content_versions/356303/a48ef565-0ca6-3d96-b763-420bd6c26918.PNG)

Чак держал в руках уже слегка помятую финансовую отчетность за прошедший период и пытался понять написанные там цифры. Он слишком долго откладывал их обработку, анализ и согласование. И бумажная работа, казалось, росла с каждым днем ​​все больше и больше, пока, наконец, количество бумаг не превысило критического значения, когда справляться с этим в одиночку уже нельзя. Чак сидел один в офисе, беспомощно играя с листами в руках, перелистывая страницы, словно надеясь, что это поможет сократить их количество, пытаясь понять, какие самолеты из них можно сделать. Он задавался вопросом, сможет ли он сделать из этого количества бумажный боинг. Он даже гуглил инструкции, как это сделать.

Но это не решило проблему, и перед ним все еще стояли утверждения с числами.
    
`-` \"Кажется, пора начать использовать свои знания SQL,\" подумал про себя Чак. - \"Если я смогу автоматизировать обработку и анализ, мне не понадобится чья-либо помощь. В конце концов, знание SQL не было пустой тратой времени”

Так что Чаку оставалось сделать всего несколько вещей: формализовать структуру данных, алгоритмы обработки и поместить все это в код. Главное не отвлекаться лишний раз где-то в процессе...

## Введение

В этом проекте вы примените на практике свои знания SQL. Вам нужно будет создать базу данных со сведениями о клиентах розничных продавцов и написать представления и процедуры, необходимые для создания персональных предложений.

## Глава II

## Основные правила

- Пожалуйста, убедитесь, что вы используете последнюю версию PostgreSQL.
- Это совершенно нормально, если вы используете IDE для написания исходного кода (он же SQL-скрипт).
- Для оценки ваше решение должно находиться в вашем репозитории GIT.
- Ваши решения будут оценены коллегами.
- Вы не должны оставлять в своем каталоге никаких других файлов, кроме sql-скриптов или CSV-файлов. Рекомендуется изменить его `.gitignore`, чтобы избежать несчастных случаев.
- У вас есть вопрос? Спросите у соседа справа. Так же попробуйте с соседом слева.
- Ваш справочник: коллеги/интернет/гугл.
- И да прибудет с вами SQL-Force!
- Абсолютно все можно представить в SQL! Давайте начнем и получайте удовольствие!

## Логическое представление модели базы данных

Данные, описанные в таблицах [Входные данные](#input-data), заполняются пользователем.

Данные, описанные в представлениях [Выходные данные](#output-data), рассчитываются программой.
    
Более подробное описание заполнения этих представлений будет дано ниже.

### Входные данные

#### Таблица Personal information

| **Поле**                   | **Имя системного поля**       | **Формат/возможные значения**                                                     | **Описание**                                                                                              |
|:---------------------------:|:---------------------------:|:--------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------:|
| Пользовательский ID                 | Customer_ID                 | ---                                                                              | ---                                                                                                       |
| Имя                        | Customer_Name               | Кириллица или латиница, первая буква заглавная, остальные прописные, допускаются тире и пробелы | ---                                                                                                       |
| Фамилия                     | Customer_Surname            | Кириллица или латиница, первая буква заглавная, остальные прописные, допускаются тире и пробелы | ---                                                                                                       |
| Электронная почта клиента             | Customer_Primary_Email      | Формат электронной почты E-mail format                                                                    | ---                                                                                                                             |
| Номер телефона клиента      | Customer_Primary_Phone      | +7 и 10 арабских цифр                                                           | ---                                                                                                       |

#### Таблица Cards

| **Поле**   | **Имя системного поля**       | **Формат/возможные значения**    | **Описание**                    |
|:-----------:|:---------------------------:|:-------------------------------:|:----------------------------------:|
| ID карты     | Customer_Card_ID            | ---                             | ---                                |
| Пользовательский ID | Customer_ID                 | ---                             | Один клиент может владеть несколькими картами |

#### Таблица Transactions

| **Поле**                | **Имя системного поля**       | **Формат/возможные значения**    | **Описание**                                               |
|:------------------------:|:---------------------------:|:-------------------------------:|:-------------------------------------------------------------------------:|
| ID транзакции            | Transaction_ID              | ---                             | Уникальное значение value                                                               |
| ID карты                 | Customer_Card_ID            | ---                             | ---                                                                        |
| Сумма транзакции         | Transaction_Summ            | арабские цифры                  | Сумма сделки в рублях(полная стоимость покупки без скидки) |
| Дата транзакции          | Transaction_DateTime        | dd.mm.yyyy hh:mm:ss             | Дата и время совершения транзакции                                |
| Магазин                  | Transaction_Store_ID        | ID Магазина                        | Магазин, в котором была совершена сделка                                   |

#### Таблица Checks

| **Поле**                                        | **Имя системного поля**  | **Формат/возможные значения** | **Описание**                                                                                                                  |
|:------------------------------------------------:|:----------------------:|:----------------------------:|:----------------------------------------------------------------------------------------------------------------:|
| ID транзакции                                    | Transaction_ID         | ---                          | Идентификатор транзакции указан для всех товаров в чеке                                                         |
| Товар в чеке                                     | SKU_ID                 | ---                          | ---                                                                                                               |
| Количество штук или килограммов                  | SKU_Amount             | арабские цифры               | Количество приобретаемого товара                                                                             |
| Общая сумма, на которую был приобретен товар     | SKU_Summ               | арабские цифры               | Сумма покупки реального объема данного товара в рублях (полная цена без скидок и бонусов) |
| Оплаченная цена продукта                         | SKU_Summ_Paid          | арабские цифры               | Сумма, фактически уплаченная за товар, без учета скидки                                            |
| Скидка предоставлена                             | SKU_Discount           | арабские цифры               | Размер предоставляемой скидки на товар в рублях                                                 |

#### Таблица Product grid

| **Поле**                     | **Имя системного поля**       | **Формат/возможные значения**                  | **Описание**                                                                                                                                                                                                |
|:-----------------------------:|:---------------------------:|:---------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| ID Товара                    | SKU_ID                      | ---                                           | ---                                                                                                                                                                                                            |
| Наименование товара          | SKU_Name                    | Кириллица или латиница, арабские цифры, специальные символы | ---                                                                                                                                                                                                            |
| Группа SKU                   | Group_ID                    | ---                                           | ID группы сопутствующих товаров, к которой относится товар (например, однотипный йогурт одного производителя и объема, но разных вкусов). Для всех товаров в группе указан один идентификатор |
| Цена покупки продукта        | SKU_Purchase_Price          | арабские цифры                                       | Цена покупки товара для этого магазина                                                                                                                                                       |
| Розничная цена продукта      | SKU_Retail_Price            | арабские цифры                                       | Цена продажи товара без учета скидки для этого магазина                                                                                                                               |

#### Таблица Stores

| **Поле**              | **Имя системного поля**    | **Формат/возможные значения** | **Описание**                                                  |
|:----------------------:|:------------------------:|:----------------------------:|:----------------------------------------------------------------:|
| Магазин                | Transaction_Store_ID     | ---                          | ---                                                              |
| ID товара              | SKU_ID                   | ---                          | ---                                                              |
| Цена покупки продукта  | SKU_Purchase_Price       | арабские цифры               | Закупочная цена товаров для этого магазина                     |
| Розничная цена продукта  | SKU_Retail_Price         | арабские цифры               | Цена продажи товара без учета скидки для этого магазина |


#### Таблица SKU group

| **Поле**         | **Имя системного поля** | **Формат/возможные значения**                  | **Описание** |
|:-----------------:|:---------------------:|:---------------------------------------------:|:---------------:|
| Группа SKU        | Group_ID              | ---                                           | ---             |
| Имя группы        | Group_Name            | Кириллица или латиница, арабские цифры, специальные символы | ---             | 

#### Таблица Date of analysis formation

| **Field**         | **Имя системного поля** | **Формат/возможные значения**                  | **Описание** |
|:-----------------:|:---------------------:|:---------------------------------------------:|:---------------:|
| Дата анализа      | Analysis_Formation              | dd.mm.yyyy hh:mm:ss                                           | ---             |


### Выходные данные

#### Представление Customers

| **Поле**                                     | **Имя системного поля**          | **Формат/возможные значения**     | **Описание**                                                                  |
|:---------------------------------------------:|:------------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------:|
| Пользовательский ID                                   | Customer_ID                    | ---                              | Unique value                                                                   |
| Стоимость среднего чека                    | Customer_Average_Check         | арабские цифры, десятичные          | Value of the average check in rubles for the analyzed period                 |
| Сегмент среднего чека                         | Customer_Average_Check_Segment | Высокий, Средний, Низкий         | Segment description                                                            |
| Значение частоты транзакций                   | Customer_Frequency             | арабские цифры, десятичные       | Value of customer visit frequency in the average number of days between transactions |
| Сегмент частоты транзакций                    | Customer_Frequency_Segment     | Часто; Иногда; Редко      | Описание сегмента                                                            |
| Количество дней с момента предыдущей транзакции | Customer_Inactive_Period       | арабские цифры, десятичные           | Количество дней, прошедших с даты предыдущей транзакции               |
| Скорость оттока                               | Customer_Churn_Rate            | арабские цифры, десятичные           | Значение коэффициента оттока клиентов                                               |
| Сегмент коэффициента оттока                   | Customer_Churn_Segment         | Высокий, Средний, Низкий                | Описание сегмента                                                            |
| Номер сегмента                                | Customer_Segment               | арабские цифры                   | Номер сегмента, к которому относится клиент                        |
| ID основного магазина                         | Customer_Primary_Store         | ---                              | ---                                                                            |

#### Представление Purchase history

| **Поле**                       | **Имя системного поля**       | **Формат/возможные значения**     | **Описание**                                                       |
|:-------------------------------:|:---------------------------:|:--------------------------------:|:--------------------------------------------------------------------:|
| Пользовательский ID             | Customer_ID                 | ---                              | ---                                                                   |
| ID транзакции                   | Transaction_ID              | ---                              | ---                                                                   |
| Дата транзакции                 | Transaction_DateTime        | dd.mm.yyyyy hh:mm:ss.0000000     | Дата совершения сделки                                                                                                                                                                                             |
| Группа SKU                      | Group_ID                    | ---                              | ID группы сопутствующих товаров, к которой относится товар (например, однотипный йогурт одного производителя и объема, но разных вкусов). Для всех товаров в группе указан один идентификатор  |
| Себестоимость                   | Group_Cost                  | арабские цифры, десятичные | ---                                                                                                                                                                                                                                         |
| Базовая розничная цена          | Group_Summ                  | арабские цифры, десятичные | ---                                                                                                                                                                                                                                         |
| Фактическая стоимость оплачена  | Group_Summ_Paid             | арабские цифры, десятичные | ---                                                                                                                                                                                                                                         |

#### Представление Periods

| **Поле**                                     | **Имя системного поля**       | **Формат/возможные значения**     | **Описание**                                                                                                                                                                                                 |
|:---------------------------------------------:|:---------------------------:|:--------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Пользовательский ID                           | Customer_ID                 | ---                              | ---                                                                                                                                                                                                          |
| Группа SKU                                    | Group_ID                    | ---                              | ID группы сопутствующих товаров, к которой относится товар (например, однотипный йогурт одного производителя и объема, но разных вкусов). Для всех товаров в группе указан один идентификатор |
| Дата первой покупки группы                    | First_Group_Purchase_Date   | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Дата последней покупки группы                 | Last_Group_Purchase_Date    | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Количество сделок с группой                   | Group_Purchase              | арабские цифры, десятичные       | ---                                                                                                                                                                                                          |
| Интенсивность групповых покупок               | Group_Frequency             | арабские цифры, десятичные       | ---                                                                                                                                                                                                          |
| Минимальная групповая скидка                  | Group_Min_Discount          | арабские цифры, десятичные       | ---                                                                                                                                                                                                          |

#### Представление Groups

| **Поле**                              | **Имя системного поля**       | **Формат/возможные значения**     | **Описание**                                                                                                                        |
|:--------------------------------------:|:---------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------:|
| Пользовательский ID                    | Customer_ID                 | ---                              | ---                                                                                                                                 |
| ID группы                              | Group_ID                    | ---                              | ---                                                                                                                                 |
| Индекс сходства                        | Group_Affinity_Index        | арабские цифры, десятичные          | Индекс близости клиентов для этой группы                                                                                |
| Индекс оттока                          | Group_Churn_Rate            | арабские цифры, десятичные          | Индекс оттока клиентов для определенной группы                                                                                          |
| Индекс стабильности                    | Group_Stability_Index       | арабские цифры, десятичные          | Индикатор, демонстрирующий стабильность потребительского потребления группы                                                                |
| Фактическая маржа для группы           | Group_Margin                | арабские цифры, десятичные          | Индикатор фактической маржи по группе для конкретного клиента                                                                       |
| Доля сделок со скидкой                 | Group_Discount_Share        | арабские цифры, десятичные          | Доля покупок группы покупателем, в рамках которой применялась скидка (без учета бонусов по программе лояльности) |
| Минимальный размер скидки              | Group_Minimum_Discount      | арабские цифры, десятичные          | Минимальный размер групповой скидки для клиента                                                                   |
| Средняя скидка                         | Group_Average_Discount      | арабские цифры, десятичные          | Средний размер групповой скидки для клиента                                                                                         |


## Глава III

## Часть 1. Создание базы данных

Напишите сценарий **part1.sql**, который создает базу данных и таблицы, описанные выше во [входных данных](#input-data).

Также добавьте в скрипт процедуры, позволяющие импортировать и экспортировать данные для каждой таблицы из/в файл с расширениями .csv и .tsv. 
    
В качестве параметра каждой процедуры импорта из csv- файла указывается разделитель.

Введите не менее 5 записей в каждую таблицу. По мере выполнения задания вам потребуются новые данные, чтобы проверить все ваши варианты. Эти новые данные также должны быть добавлены в этот сценарий.
    
Некоторые тестовые данные можно найти в папке *datasets*.

Если для добавления данных в таблицы использовались файлы csv или tsv , их также необходимо загрузить в репозиторий GIT.

## Часть 2. Создание представлений

Создайте скрипт part2.sql и пропишите представления, описанные выше, в [Output data](#output-data). Также добавьте тестовые запросы для каждого представления. Для каждого вида допустимо создавать отдельный скрипт, начинающийся с part2_.

Более подробную информацию по каждому полю можно найти в материалах.

## Часть 3. Модель ролей

Создайте роли в сценарии part3.sql и предоставьте им разрешения, как описано ниже.

#### Администратор
Администратор имеет полные права на редактирование и просмотр любой информации, запуск и остановку обработки.

#### Посетитель
Только просмотр информации всех таблиц.

## Часть 4. Формирование персональных предложений, направленных на рост среднего чека

Создайте скрипт part4.sql , в который вы должны добавить следующую функцию.

### Написать функцию, определяющую предложения, направленные на рост среднего чека

Параметры функции:
- метод расчета среднего чека (1 - за период, 2 - за количество)
- первая и последняя даты периода (для метода 1)
- количество транзакций (для метода 2)
- коэффициент увеличения среднего чека
- максимальный индекс оттока
- максимальная доля сделок со скидкой (в процентах)
- допустимая доля маржи (в процентах)

##### Определение условия предложения

1.  **Выбор метода расчета среднего чека.**

    Есть возможность выбрать способ начисления среднего чека - за определенный период времени или за определенное количество последних транзакций. Метод расчета вручную определяется пользователем.

    1. Пользователь выбирает метод расчета **по периодам**, а затем указывает первую и последнюю даты периода, за который требуется рассчитать средний чек для всей совокупности клиентов выборки. При этом последняя дата указанного периода должна быть позже первой, а указанный период должен находиться в пределах всего анализируемого периода. Если дата слишком ранняя или слишком поздняя, ​​система автоматически подставляет дату начала или окончания анализируемого периода соответственно. Для расчета учитываются все транзакции, совершенные каждым конкретным клиентом в течение заданного периода.

    2. Пользователь выбирает способ расчета **по количеству последних транзакций**, а затем вручную указывает количество транзакций, по которым необходимо рассчитать средний чек. Для расчета среднего чека мы берем заданное пользователем количество транзакций, начиная с самой последней в обратном хронологическом порядке. В случае, если какой-либо клиент из выборки совершает меньше указанного количества транзакций за весь анализируемый период, для анализа используется доступное количество транзакций.

2.  **Определение среднего чека**. По каждому покупателю определяется текущая величина среднего чека по методу, выбранному на шаге 1. Это делается путем деления общего оборота всех сделок клиента в выборке на количество этих сделок. Итоговое значение сохраняется в таблице как текущее значение среднего чека.


3.  **Определение целевого значения среднего чека**. Рассчитанное значение среднего чека умножается на установленный пользователем коэффициент. Полученное значение сохраняется в системе как целевое значение среднего чека покупателя и в дальнейшем используется для формирования условия предложения, которое необходимо выполнить покупателю для получения вознаграждения.

##### Определение вознаграждения

4.  **Определение группы для формирования вознаграждения**. Для формирования награды выбирается группа, последовательно отвечающая следующим критериям:

    -  Индекс близости группы максимально возможный.

- Индекс оттока для этой группы не должен превышать значение, установленное пользователем. Если показатель оттока превышает установленное значение, используется следующая группа по показателю сходства;

    - Доля транзакций со скидкой для данной группы меньше установленного пользователем значения. Если выбранная группа превышает установленное значение, используется следующая группа по индексу сходства, которая также соответствует критерию оттока.

5.  **Определение максимально допустимого размера скидки на вознаграждение.**

Пользователь вручную определяет долю маржи (в процентах), которую разрешено использовать для предоставления вознаграждения группе. Окончательное значение максимально допустимой скидки рассчитывается путем умножения установленного значения на среднюю наценку клиента по группе.

6.  **Определение размера скидки**. Значение, полученное на шаге 5, сравнивается с минимальной скидкой, которая была установлена ​​для покупателя для данной группы, округленной в большую сторону с шагом 5%. Если минимальная скидка после округления меньше значения, полученного на шаге 5, она устанавливается как скидка для группы в рамках предложения для клиента. В противном случае данная группа исключается из рассмотрения, а для формирования предложения покупателю процесс повторяется, начиная с шага 4 (используется следующая подходящая группа по описанным критериям).

Вывод функции:

| **Поле**                      | **Имя системного поля**      | **Формат/возможные значения**                | **Описание**                                                                               |
|--------------------------------|-----------------------------|--------------------------------------------|----------------------------------------------------------------------------------------------|
| Пользовательский ID                    | Customer_ID                 |                                            |                                                                                               |
| Среднее целевое значение чека  | Required_Check_Measure      | арабские цифры (десятичные)                   | Целевое значение среднего чека, необходимого для получения вознаграждения                               |
| Группа предложений             | Group_Name                  |                                            | 	Название группы предложений, по которой начисляется вознаграждение при выполнении условия.   |
| Максимальная глубина скидки    | Offer_Discount_Depth        | арабские цифры (десятичные), процент          | Максимально возможная скидка на предложение                                                   |


## Часть 5. Формирование персональных предложений, направленных на увеличение частоты посещений

Создайте сценарий *part5.sql* и добавьте в него следующую функцию.

### Напишите функцию, определяющую предложения, направленные на увеличение частоты посещений

Параметры функции:
- первая и последняя даты периода
- добавлено количество транзакций
- максимальный индекс оттока
- максимальная доля сделок со скидкой (в процентах)
- допустимая доля маржи (в процентах)

##### Определение условия предложения

1. **Определение периода**.
   Пользователь вручную устанавливает срок действия разрабатываемого предложения, указывая даты его начала и окончания.

2. **Определение текущей частоты визитов клиентов в указанный период**
   Дата начала вычитается из даты окончания указанного периода, после чего полученное значение делится на среднюю интенсивность транзакций клиентов (`Customer_Frequency` Таблицы [Customers Table](#customers-view)). Итоговый результат сохраняется как базовая интенсивность транзакций клиентов за указанный период.

3. **Определение вознаграждения за транзакцию**
   Система определяет порядковый номер сделки за указанный период, за которую должно быть начислено вознаграждение. Для этого значение, полученное на шаге 2, округляется по арифметическим правилам до целого числа, а затем к нему прибавляется указанное пользователем количество транзакций. Окончательное значение — это целевое количество транзакций, которые клиент должен совершить, чтобы получить вознаграждение.

##### Определение вознаграждения

4.  **Определение группы для формирования вознаграждения** Для формирования награды выбирается группа, последовательно отвечающая следующим критериям:

    -  Индекс близости группы максимально возможный.

    -  The churn index for this group should not exceed the value set by the user. If the churn rate exceeds the set value, the next group according to the affinity index is selected;

    -  Доля сделок со скидкой для данной группы меньше заданного пользователем значения. Если выбранная группа превышает установленное значение, выбирается следующая группа по индексу сходства, который также соответствует критерию оттока.

5.  **Определение максимально допустимой скидки на вознаграждение** Пользователь вручную определяет долю маржи (в процентах), которую разрешено использовать для предоставления вознаграждения группе. Окончательное значение максимально допустимой скидки рассчитывается путем умножения установленного значения на среднюю наценку клиента по группе.

6.  **Определение размера скидки**. Значение, полученное на шаге 5, сравнивается с минимальной скидкой, которая была установлена ​​для покупателя для данной группы, округленной в большую сторону с шагом 5%. Если минимальная скидка после округления меньше значения, полученного на шаге 5, она устанавливается как скидка для группы в рамках предложения для клиента. В противном случае данная группа исключается из рассмотрения, а для формирования предложения покупателю процесс повторяется, начиная с шага 4 (используется следующая подходящая группа по описанным критериям).




Вывод функции:

| **Поле**                     | **Имя системного поля**       | **Формат/возможные значения**      | **Описание**
|-------------------------------|-----------------------------|-----------------------------------|--------------------------------------------------------------------------------------------|
| Пользовательский ID           | Customer_ID                 |                                   |                                                                                            |
| Дата начала периода           | Start_Date                  | yyyy-mm-dd hh:mm:ss.0000000       | Дата начала периода, в течение которого должны быть совершены транзакции
| Дата окончания периода        | End_Date                    | yyyy-mm-dd hh:mm:ss.0000000       | Дата окончания периода, в течение которого должны быть совершены сделки                 |
| Целевое количество транзакций | Required_Transactions_Count | арабские цифры (десятичные)          | Серийный номер транзакции, на которую начисляется вознаграждение                         |
| Группа предложений            | Group_Name                  |                                   | Название группы предложений, на которую начисляется вознаграждение при выполнении условия. |
| Максимальная глубина скидки   | Offer_Discount_Depth        | арабские цифры (десятичные), проценты | Максимально возможная скидка на предложение                                      |


## Part 6. Формирование персональных предложений, направленных на кросс-продажи

Создайте сценарий *part6.sql* и добавьте в него следующую функцию.

### Напишите функцию, определяющую предложения, направленные на кросс-продажи (рост маржи)

Параметры функции:
- количество групп
- максимальный индекс оттока
- индекс стабильности максимального потребления
- максимальная доля SKU (в процентах)
- допустимая доля маржи (в процентах)

Предложения, направленные на рост маржи за счет кросс-продаж, предполагают переключение покупателя на наиболее маржинальный SKU внутри востребованной группы.

1.  **Выбор группы** Для формирования предложений, направленных на рост маржи за счет кросс-продаж, для каждого клиента выбираются несколько групп с максимальным индексом аффинити (количество задается пользователем ) и отвечающих следующим условиям:

    1. Индекс оттока для группы не превышает значения, установленного пользователем.

    2. Индекс стабильности потребления меньше установленного пользователем значения.

2.  **Определение SKU с максимальной наценкой** В каждой группе определяется артикул с максимальной наценкой (в рублях). Это делается путем вычитания закупочной цены (`SKU_Purchase_Price`) из розничной цены товара (`SKU_Retail_Price`) для всех артикулов группы, представленных в магазине, и последующего выбора одного артикула с максимальное значение указанной разницы.

3.  **Определение доли SKU в группе** Определяется доля транзакций, в которых присутствует анализируемый SKU. Это делается путем деления количества транзакций, содержащих этот SKU, на количество транзакций, содержащих группу в целом (за анализируемый период). Артикул используется для формирования предложения только в том случае, если полученное значение не превышает значение, установленное пользователем.

4.  **Определение доли маржи для расчета скидки.** Пользователь вручную определяет долю маржи (в процентах), которую допустимо использовать для предоставления вознаграждений за SKU (для всего набора клиентов устанавливается единое значение).

5.  **Расчет скидки** Значение, заданное пользователем на шаге 4, умножается на разницу между розничной (`SKU_Retail_Price`) и закупочной ( `SKU_Purchase_Price`) ценами, а полученное значение делится на розничную цену артикула (`SKU_Retail_Price`). Все цены указаны для основного магазина заказчика. Если полученное значение равно или превышает минимальную скидку пользователя для анализируемой группы с округлением в большую сторону с шагом 5%, в качестве скидки по данной SKU для клиент. В противном случае предложение для заказчика по данной группе не формируется.

Вывод функции:

| **Поле**              | **Имя системного поля** | **Формат/возможные значения**       | **Описание**                                                |
|------------------------|-----------------------|------------------------------------|-----------------------------------------------------------------------------------------|
| Пользовательский ID    | Customer_ID           |                                    |                                                       |
| SKU предложения        | SKU_Name              |                                    | Название SKU-предложения, на которое начисляется вознаграждение при выполнении условия. |
| Максимальная глубина скидки | Offer_Discount_Depth  | арабские цифры (десятичные), проценты  | Максимально возможная скидка на предложение                                    |


## Глава IV

Чак часами смотрел на экран и не мог понять. Некий отдел "ПОМОЩЬ" исчезает из ведомостей так же быстро, как и появляется, буквально в мгновение ока. Все расходы списаны на разработку умных пылесосов, чем давно занимается только хозотдел. Да, тогда же была выпущена новая модель СП-21, но все же что это: невинная опечатка в названии или удачный момент? Вопрос, который будет преследовать Чака в ближайшем будущем...


💡 [Нажмите здесь](https://forms.yandex.ru/u/635ab5be84227c207a24b1b6/) ** чтобы оставить свой отзыв о проекте**. Команда Pedago действительно старается сделать ваш образовательный опыт лучше.