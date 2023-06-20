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
| Customer ID                     | Customer_ID                 | ---                              | ---                                                                   |
| Transaction ID                  | Transaction_ID              | ---                              | ---                                                                   |
| Transaction date                | Transaction_DateTime        | dd.mm.yyyyy hh:mm:ss.0000000     | The date when the transaction was made                                                                                                                                                                                             |
| SKU group                       | Group_ID                    | ---                              | The ID of the group of related products to which the product belongs (for example, same type of yogurt of the same manufacturer and volume, but different flavors). One identifier is specified for all products in the group  |
| Prime cost                      | Group_Cost                  | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |
| Base retail price               | Group_Summ                  | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |
| Actual cost paid                | Group_Summ_Paid             | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |

#### Представление Periods

| **Поле**                                     | **Имя системного поля**       | **Формат/возможные значения**     | **Описание**                                                                                                                                                                                                 |
|:---------------------------------------------:|:---------------------------:|:--------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Customer ID                                   | Customer_ID                 | ---                              | ---                                                                                                                                                                                                          |
| SKU group                                     | Group_ID                    | ---                              | The ID of the group of related products to which the product belongs (for example, same type of yogurt of the same manufacturer and volume, but different flavors). One identifier is specified for all products in the group |
| Date of first purchase of the group           | First_Group_Purchase_Date   | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Date of last purchase of the group            | Last_Group_Purchase_Date    | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Number of transactions with the group         | Group_Purchase              | Arabic numeral, decimal          | ---                                                                                                                                                                                                          |
| Intensity of group purchases                  | Group_Frequency             | Arabic numeral, decimal          | ---                                                                                                                                                                                                          |
| Minimum group discount                        | Group_Min_Discount          | Arabic numeral, decimal | ---                                                                                                                                                                                                          |

#### Представление Groups

| **Поле**                              | **Имя системного поля**       | **Формат/возможные значения**     | **Описание**                                                                                                                        |
|:--------------------------------------:|:---------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------:|
| Customer ID                            | Customer_ID                 | ---                              | ---                                                                                                                                 |
| Group ID                               | Group_ID                    | ---                              | ---                                                                                                                                 |
| Affinity index                         | Group_Affinity_Index        | Arabic numeral, decimal          | Customer affinity index for this group                                                                                 |
| Churn index                            | Group_Churn_Rate            | Arabic numeral, decimal          | Customer churn index for a specific group                                                                                          |
| Stability index                        | Group_Stability_Index       | Arabic numeral, decimal          | Indicator demonstrating the stability of the customer consumption of the group                                                                |
| Actual margin for the group            | Group_Margin                | Arabic numeral, decimal          | Indicator of the actual margin for the group for a particular customer                                                                       |
| Share of transactions with a discount  | Group_Discount_Share        | Arabic numeral, decimal          | Share of purchasing transactions of the group by a customer, within which the discount was applied (excluding the loyalty program bonuses) |
| Minimum size of the discount           | Group_Minimum_Discount      | Arabic numeral, decimal          | Minimum size of the group discount for the customer                                                                    |
| Average discount                       | Group_Average_Discount      | Arabic numeral, decimal          | Average size of the group discount for the customer                                                                                         |


## Chapter III

## Part 1. Creating a database

Write a *part1.sql* script that creates the database and tables described above in the [Input data](#input-data).

Also, add procedures to the script that allow you to import and export data for each table from/to a file with *.csv* and *.tsv* extensions. 
    
A separator is specified as a parameter of each procedure for importing from a *csv* file.

Enter at least 5 records in every table.
As you progress through the task, you will need new data to test all of your choices.
This new data should also be added to this script. 
    
Some test data could be found in the *datasets* folder.

If *csv* or *tsv* files were used to add data to the tables, they must also be uploaded to the GIT repository.

## Part 2. Creating views

Create a *part2.sql* script and write the views described above in the [Output data](#output-data). Also add test queries for each view. It is acceptable to create a separate script starting with *part2_* for each view.

You can find more information for each field in the materials.

## Part 3. Role model

Create roles in the *part3.sql* script and give them permissions as described below.

#### Administrator
The administrator has full permissions to edit and view any information, start and stop the processing.

#### Visitor
Only view information of all tables.

## Part 4. Forming personal offers aimed at the growth of the average check

Create a *part4.sql* script, in which you should add the following function.

### Write a function that determines offers that aimed at the growth of the average check
Function parameters:
- average check calculation method (1 - per period, 2 - per quantity)
- first and last dates of the period (for method 1)
- number of transactions (for method 2)
- coefficient of average check increase
- maximum churn index
- maximum share of transactions with a discount (in percent)
- allowable share of margin (in percent)

##### Offer condition determination

1.  **Choosing the method of calculating the average check.**
    There is an option to choose a method of calculating an average check - for a certain period of time or for a certain number of recent transactions. The calculation method *manually determined* by the user.

    1. The user selects the calculation method **by period**, and then specifies the first and last dates of the period for which you want to calculate the average check for the entire population of customers in the sample. Here, the last date of the specified period must be later than the first one, and the specified period must be within the total analyzed period. If the date is too early or too late, the system automatically substitutes the date of the beginning or the end of the analyzed period respectively. All transactions made by each specific customer during a given period are considered for the calculation.

    2. The user selects the calculation method **by the number of recent transactions**, and then manually specifies the number of transactions for which it is necessary to calculate the average check. To calculate the average check, we take the user-specified number of transactions, starting with the most recent one in reverse chronological order. In case any customer from the sample makes less than the specified number of transactions during the whole analyzed period, the available number of transactions is used for the analysis.

2.  **Determination of the average check.** For each customer, the current value of the average check is determined according to the method selected in step 1. This is done by dividing the total turnover of all transactions of a customer in the sample by the number of these transactions. The final value is saved in the table as the current value of the average check.

3.  **Determination of the target value of the average check.** The calculated value of the average check is multiplied by the coefficient set by the user. The received value is saved in the system as a target value of the average check of the customer and further is used to form the offer condition, which must be fulfilled by the customer to get the reward.

##### Reward determination

4.  **Determination of the group to form the reward.** A group that meets the following criteria in sequence is selected to form the reward:

    -  The affinity index of the group is the highest possible.

- The churn index for this group should not exceed the value set by the user. If the churn index exceeds the set value, the next group by the affinity index is used;

    - The share of transactions with a discount for this group is less than the value set by the user. If the selected group exceeds the set value, the next group by the affinity index that also meets the churn criterion is used. 

5.  **Determination of the maximum allowable size of a discount for the reward.**

The user manually determines the share of margin (in percent) that is allowed to be used to provide a reward for the group. The final value of the maximum allowable discount is calculated by multiplying the set value by the average customer margin for the group.

6.  **Determination of the discount size**. The value obtained at step 5 is compared to the minimum discount that was fixed for the customer for the given group, rounded up in increments of 5%. If the minimum discount after rounding is less than the value obtained at step 5, it is set as a discount for the group within the offer for the customer. Otherwise, this group is excluded from consideration, and to form an offer for the customer the process is repeated, starting with step 4 (the next appropriate group according to the described criteria is used).

Function output:

| **Поле**                      | **Имя системного поля**      | **Формат/возможные значения**                | **Описание**                                                                               |
|--------------------------------|-----------------------------|--------------------------------------------|----------------------------------------------------------------------------------------------|
| Customer ID                    | Customer_ID                 |                                            |                                                                                               |
| Average check target value     | Required_Check_Measure      | Arabic numeral (decimal)                   | Target value of the average check required to receive a reward                               |
| Offer group                    | Group_Name                  |                                            | The name of the offer group, for which the reward is accrued when the condition is met.   |
| Maximum discount depth         | Offer_Discount_Depth        | Arabic numeral (decimal), percent          | The maximum possible discount for the offer                                                   |


## Part 5. Forming personal offers aimed at increasing the frequency of visits

Create a *part5.sql* script and add the following function to it.

### Write a function that determines offers aimed at increasing the frequency of visits
Function parameters:
- first and last dates of the period
- added number of transactions
- maximum churn index
- maximum share of transactions with a discount (in percent)
- allowable margin share (in percent)

##### Offer condition determination

1. **Period determination**.
   The user manually sets the period of validity of the developing offer, specifying its start and end dates.

2. **Determination of the current frequency of customer visits in the specified period.**
   The start date is subtracted from the end date of the specified period, after which the received value is divided by the average intensity of customer transactions (`Customer_Frequency` of the [Customers Table](#customers-view)). The final result is saved as the base intensity of customer transactions during the specified period.

3. **Determination of the reward transaction.**
   The system determines the serial number of the transaction within the specified period, for which the reward should be accrued. For this, the value obtained at step 2 is rounded according to arithmetic rules to an integer, and then the number of transactions specified by the user is added to it. The final value is the target number of transactions that the customer must make to receive the reward.

##### Reward determination

4.  **Determination of the group to form the reward.** A group that meets the following criteria in sequence is selected to form the reward:

    -  The affinity index of the group is the highest possible.

    -  The churn index for this group should not exceed the value set by the user. If the churn rate exceeds the set value, the next group according to the affinity index is selected;

    -  The share of transactions with a discount for this group is less than the user-defined value. If the selected group exceeds the set value, the next group is selected according to the affinity index, which also meets the churn criterion.

5.  **Determination of the maximum allowable discount for the reward.** The user manually determines the share of margin (in percent) that is allowed to be used to provide a reward for the group. The final value of the maximum allowable discount is calculated by multiplying the set value by the average customer margin for the group.

6.  **Determination of the discount size**. The value obtained at step 5 is compared to the minimum discount that was fixed for the customer for the given group, rounded up in increments of 5%. If the minimum discount after rounding is less than the value obtained at step 5, it is set as a discount for the group within the offer for the customer. Otherwise, this group is excluded from consideration, and to form an offer for the customer the process is repeated, starting with step 4 (the next appropriate group according to the described criteria is used).

Function output:

| **Поле**                     | **Имя системного поля**       | **Формат/возможные значения**      | **Описание**
|-------------------------------|-----------------------------|-----------------------------------|--------------------------------------------------------------------------------------------|
| Customer ID                   | Customer_ID                 |                                   |                                                                                            |
| Period start date             | Start_Date                  | yyyy-mm-dd hh:mm:ss.0000000       | The start date of the period during which transactions must be made
| Period end date               | End_Date                    | yyyy-mm-dd hh:mm:ss.0000000       | The end date of the period during which transactions must be made                 |
| Target number of transactions | Required_Transactions_Count | Arabic numeral (decimal)          | Serial number of the transaction to which the reward is accrued                         |
| Offer group                   | Group_Name                  |                                   | The name of the offer group, to which the reward is accrued when the condition is met. |
| Maximum discount depth        | Offer_Discount_Depth        | Arabic numeral (decimal), percent | The maximum possible discount for the offer                                        |


## Part 6. Forming personal offers aimed at cross-selling

Create a *part6.sql* script and add the following function to it.

### Write a function that determines offers aimed at cross-selling (margin growth)
Function parameters:
- number of groups
- maximum churn index
- maximum consumption stability index
- maximum SKU share (in percent)
- allowable margin share (in percent)

Offers aimed at margin growth due to cross-sales involve switching the customer to the highest margin SKU within the demanded group.

1.  **Group selection.** To form offers aimed at margin growth due to cross-sales, several groups  with the maximum affinity index (the number is *set* by the user) are selected for each customer and meet the following conditions:

    1. The churn index for the group is not more than the value set by the user.

    2. The consumption stability index is less than the value set by the user.

2.  **Determination of SKU with maximum margin.** SKU with the maximum margin is determined in each group (in rubles).This is done by subtracting the purchase price (`SKU_Purchase_Price`) from retail price of the product (`SKU_Retail_Price`)  for all SKUs of the group represented in the store, and then selecting one SKU with the maximum value of the specified difference.

3.  **Determination of the SKU share in a group.** The share of transactions where the analyzed SKU is present is determined. This is done by dividing the number of transactions containing this SKU by the number of transactions containing the group as a whole (for the analyzed period). SKU is used to form an offer only if the resulting value does not exceed the value set by the user.

4.  **Determination of the margin share for discount calculation.** The user *manually determines* the margin share (in percent) that is allowable to be used to provide rewards for SKU (a single value is set for the whole set of customers).

5.  **Discount calculation.** The value *set* by the user at step 4 is multiplied by the difference between the retail (`SKU_Retail_Price`) and purchase (`SKU_Purchase_Price`) prices, and the resulting value is divided by the retail SKU price (`SKU_Retail_Price`). All prices are for the customer's main store. If the resulting value is equal to or greater than the minimum user discount for the analyzed group rounded up in increments of 5%, the minimum discount for the group rounded up in increments of 5% is set as a discount for the given SKU for the customer. Otherwise, no offer is formed for the customer for this group.

Function output:

| **Поле**              | **Имя системного поля** | **Формат/возможные значения**       | **Описание**                                                |
|------------------------|-----------------------|------------------------------------|-----------------------------------------------------------------------------------------|
| Customer ID            | Customer_ID           |                                    |                                                       |
| SKU offers             | SKU_Name              |                                    | The name of the SKU offer, to which the reward is accrued when the condition is met. |
| Maximum discount depth | Offer_Discount_Depth  | Arabic numeral (decimal), percent  | The maximum possible discount for the offer                                    |


## Chapter IV

Chuck had been staring at the screen for hours and couldn't figure it out. A certain \"AID\" department disappears from the statements as fast as appears, literally in the blink of an eye.
All expenses are written off for the development of smart vacuum cleaners, something only the household department has been doing for a long time. Yes, there was a new SP-21 model released at the same time, but still what is this: an innocent typo in the name or an opportune moment? The question that will haunt Chuck in the near future...


💡 [Tap here](https://forms.yandex.ru/u/635ab5be84227c207a24b1b6/) **to leave your feedback on the project**. Pedago Team really tries to make your educational experience better.
