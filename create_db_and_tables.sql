1.Создайте таблицу "Patient" с полями "ID", "NAME", "AGE", "DIAGNOSIS".
CREATE TABLE Patient (
        ID SERIAL PRIMARY KEY,
        NAME VARCHAR(100) NOT NULL,
        AGE INT CHECK (AGE > 0),
        DIAGNOSIS TEXT
    );
2.Вставьте 10 записей о пациентах.
INSERT INTO Patient (ID, NAME, AGE, DIAGNOSIS)
        VALUES
            (1, 'Alice Johnson', 30, 'Hypertension'),
            (2, 'Bob Smith', 25, 'Diabetes'),
            (3, 'Charlie Brown', 35, 'Asthma'),
            (4, 'Diana Prince', 40, 'Arthritis'),
            (5, 'Evan Williams', 50, 'Heart Disease');
3.Обновите рабочие часы врача с ID=102.
UPDATE Doctor
SET Working_Hours = '9:00 AM - 5:00 PM'
WHERE Doctor_Id = 102;
4.Обновите специальность врача с ID=104.
UPDATE Doctor
SET Speciality = 'Cardiologist'
WHERE Doctor_Id = 104;
5.Постройте столбчатую диаграмму для анализа распределения зарплат по врачам.
SELECT Doctor_Name, Salary
        FROM Doctor;
