# pr_07
# Практическая работа 7. Импорт и экспорт данных в SQL. Работа с внешними источниками данных
Цель: научиться импортировать и экспортировать данные в базу данных SQL. Работа включает в себя загрузку данных из внешних источников в таблицы базы данных, а также экспорт данных из базы данных в различные форматы. Студенты научатся работать с внешними данными, преобразовывать их в нужный формат и интегрировать с существующими таблицами в базе данных.
# Задачи:
Создание ERD диаграммы для базы данных.
Разработка SQL-скриптов для создания базы данных и таблиц.
Реализация заданий в Jupyter Notebook с подключением к базе данных, вставкой и обновлением данных, а также визуализацией информации.
# Индивидуальные задания (вариант 10):
Создайте таблицу "Patient" с полями "ID", "NAME", "AGE", "DIAGNOSIS".	

Вставьте 10 записей о пациентах.	

Обновите рабочие часы врача с ID=102.	

Обновите специальность врача с ID=104.

Постройте столбчатую диаграмму для анализа распределения зарплат по врачам.
# ход работы
установливаем библиотеку psycopg2 
````
%pip install psycopg2
````
# Задание 1 Создайте таблицу "Patient" с полями "ID", "NAME", "AGE", "DIAGNOSIS".	
````
import psycopg2

def get_connection(database_name):
    # Функция для получения подключения к базе данных
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    # Функция для закрытия подключения к базе данных
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

# Подключение к базе данных
try:
    database_name = 'medical_db'
    connection = get_connection(database_name)
    cursor = connection.cursor()

    # SQL-запрос для создания таблицы
    create_table_query = """
    CREATE TABLE Patient (
        ID SERIAL PRIMARY KEY,
        NAME VARCHAR(100) NOT NULL,
        AGE INT CHECK (AGE > 0),
        DIAGNOSIS TEXT
    );
    """

    # Выполнение запроса
    cursor.execute(create_table_query)
    connection.commit()
    print("Таблица 'Patient' успешно создана!")

except Exception as e:
    print(f"Ошибка: {e}")

finally:
    if connection:
        cursor.close()
        connection.close()
````
![image](https://github.com/user-attachments/assets/74210612-8c85-4a9c-bb14-c8724d041ee0)

![image](https://github.com/user-attachments/assets/753b9e65-793f-4be5-ab8c-6853ac3f8be6)

# Задание 2 Вставьте 10 записей о пациентах.	
````
import psycopg2

def add_new_patients():
    try:
        # Подключение к базе данных
        connection = psycopg2.connect(
            user="postgres",
            password="1",
            host="localhost",
            port="5432",
            database="medical_db"
        )
        cursor = connection.cursor()

        # SQL-запрос для добавления данных в таблицу Patient
        insert_query = '''
        INSERT INTO Patient (ID, NAME, AGE, DIAGNOSIS)
        VALUES
            (1, 'Alice Johnson', 30, 'Hypertension'),
            (2, 'Bob Smith', 25, 'Diabetes'),
            (3, 'Charlie Brown', 35, 'Asthma'),
            (4, 'Diana Prince', 40, 'Arthritis'),
            (5, 'Evan Williams', 50, 'Heart Disease');
        '''
        cursor.execute(insert_query)
        connection.commit()
        print("5 новых пациентов успешно добавлены в таблицу 'Patient'")

    except psycopg2.Error as error:
        print("Ошибка при работе с PostgreSQL:", error)
        if connection:
            connection.rollback()
    finally:
        # Закрытие соединения
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто")

# Вызов функции
add_new_patients()
````

![image](https://github.com/user-attachments/assets/3e354f51-50ac-4ecc-9447-c3810b439a89)

# Задание 3 Обновите специальность врача с ID=104.
````
import psycopg2

def update_doctor_working_hours():
    try:
        # Подключение к базе данных
        connection = psycopg2.connect(
            user="postgres",
            password="1",
            host="localhost",
            port="5432",
            database="medical_db"
        )
        cursor = connection.cursor()

        # 1. Добавление нового столбца "Working_Hours" в таблицу Doctor
        add_column_query = '''
        ALTER TABLE Doctor
        ADD COLUMN IF NOT EXISTS Working_Hours VARCHAR(50);
        '''
        cursor.execute(add_column_query)
        print("Столбец 'Working_Hours' успешно добавлен (если его не было).")

        # 2. Обновление рабочих часов врача с ID=2
        update_query = '''
        UPDATE Doctor
        SET Working_Hours = %s
        WHERE Doctor_Id = %s;
        '''
        new_working_hours = "9:00 AM - 5:00 PM"  # Новые рабочие часы
        doctor_id = 102
        cursor.execute(update_query, (new_working_hours, doctor_id))
        connection.commit()

        # Проверка количества обновленных строк
        if cursor.rowcount > 0:
            print(f"Рабочие часы врача с ID={doctor_id} успешно обновлены на '{new_working_hours}'.")
        else:
            print(f"Врач с ID={doctor_id} не найден.")

    except psycopg2.Error as error:
        print("Ошибка при работе с PostgreSQL:", error)
        if connection:
            connection.rollback()
    finally:
        # Закрытие соединения
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто")

# Вызов функции
update_doctor_working_hours()
````
![image](https://github.com/user-attachments/assets/08f4ac5d-0e23-4e22-b9bf-c1be0dc26f0d)

# Задание 4 Обновите специальность врача с ID=104.
````
import psycopg2

def update_doctor_speciality():
    try:
        # Подключение к базе данных
        connection = psycopg2.connect(
            user="postgres",
            password="1",
            host="localhost",
            port="5432",
            database="medical_db"
        )
        cursor = connection.cursor()

        # SQL-запрос для обновления специальности врача с ID=104
        new_speciality = "Cardiologist"  # Новая специальность
        update_query = '''
        UPDATE Doctor
        SET Speciality = %s
        WHERE Doctor_Id = %s;
        '''
        cursor.execute(update_query, (new_speciality, 104))
        connection.commit()

        # Проверка количества обновленных строк
        if cursor.rowcount > 0:
            print(f"Специальность врача с ID=104 успешно обновлена на '{new_speciality}'.")
        else:
            print("Врач с ID=104 не найден.")

    except psycopg2.Error as error:
        print("Ошибка при работе с PostgreSQL:", error)
        if connection:
            connection.rollback()
    finally:
        # Закрытие соединения
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто")

# Вызов функции
update_doctor_speciality()
````

![image](https://github.com/user-attachments/assets/56ee3716-024f-41f4-9b52-e253cbb2b4c0)

# Задание 5 Постройте столбчатую диаграмму для анализа распределения зарплат по врачам
````
import psycopg2
import matplotlib.pyplot as plt

def plot_salary_distribution():
    try:
        # Подключение к базе данных
        connection = psycopg2.connect(
            user="postgres",
            password="1",  # Замените на ваш пароль
            host="localhost",
            port="5432",
            database="medical_db"
        )
        cursor = connection.cursor()

        # SQL-запрос для получения данных о зарплатах врачей
        query = '''
        SELECT Doctor_Name, Salary
        FROM Doctor;
        '''
        cursor.execute(query)
        data = cursor.fetchall()

        # Разделение данных на имена врачей и их зарплаты
        doctor_names = [row[0] for row in data]
        salaries = [row[1] for row in data]

        # Построение столбчатой диаграммы
        plt.figure(figsize=(10, 6))
        plt.bar(doctor_names, salaries, color='skyblue', edgecolor='black')

        # Настройка графика
        plt.title('Распределение зарплат по врачам', fontsize=16)
        plt.xlabel('Имена врачей', fontsize=12)
        plt.ylabel('Зарплата (USD)', fontsize=12)
        plt.xticks(rotation=45, ha='right')  # Поворот подписей оси X для удобства чтения
        plt.grid(axis='y', linestyle='--', alpha=0.7)

        # Отображение графика
        plt.tight_layout()
        plt.show()

    except psycopg2.Error as error:
        print("Ошибка при работе с PostgreSQL:", error)
    finally:
        # Закрытие соединения
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто")

# Вызов функции
plot_salary_distribution()
````
![image](https://github.com/user-attachments/assets/1fac2779-fe08-4fce-861b-63d87fde29c1)

# Вывод
Научились импортировать и экспортировать данные в базу данных SQL, научились работать с внешними данными, преобразовывать их в нужный формат и интегрировать с существующими таблицами в базе данных.
# Структура репозитория:
erd_diagram.png — ERD диаграмма схемы базы данных.
create_db_and_tables.sql — SQL скрипт для создания базы данных и таблиц.
Dolzhenkova_Polina_Victorovna.ipynb — Jupyter Notebook с выполнением всех заданий.
# Как запустить:
Установите PostgreSQL и настройте доступ к базе данных.
Выполните SQL-скрипт create_db_and_tables.sql для создания базы данных и таблиц.
Откройте и выполните Jupyter Notebook для проверки выполнения заданий.





