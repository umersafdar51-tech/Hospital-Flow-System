CREATE DATABASE HospitalSystemDB;
GO

USE HospitalSystemDB;
GO

CREATE TABLE PATIENTS (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    cnic VARCHAR(15) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    dob DATE,
    contact VARCHAR(20),
    blood_group VARCHAR(5)
);


CREATE TABLE INSURANCE_PANELS (
    panel_id INT IDENTITY(1,1) PRIMARY KEY,
    panel_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    contact_phone VARCHAR(20)
);

CREATE TABLE USERS (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(30),
    is_active BIT DEFAULT 1
);

CREATE TABLE DEPARTMENTS (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    ward_code VARCHAR(20)
);

CREATE TABLE SERVICES (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_code VARCHAR(20) UNIQUE,
    service_name VARCHAR(100),
    standard_rate DECIMAL(10,2)
);

CREATE TABLE ADMISSIONS (
    admission_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    panel_id INT,
    admitted_on DATETIME NOT NULL,
    discharge_date DATETIME,
    episode_status VARCHAR(30),

    FOREIGN KEY (patient_id)
        REFERENCES PATIENTS(patient_id),

    FOREIGN KEY (panel_id)
        REFERENCES INSURANCE_PANELS(panel_id)
);

CREATE TABLE DEPARTMENT_STAYS (
    stay_id INT IDENTITY(1,1) PRIMARY KEY,
    admission_id INT NOT NULL,
    department_id INT NOT NULL,
    start_datetime DATETIME,
    end_datetime DATETIME,

    FOREIGN KEY (admission_id)
        REFERENCES ADMISSIONS(admission_id),

    FOREIGN KEY (department_id)
        REFERENCES DEPARTMENTS(department_id)
);


CREATE TABLE PRE_AUTHORIZATIONS (
    auth_id INT IDENTITY(1,1) PRIMARY KEY,
    admission_id INT NOT NULL,
    panel_id INT NOT NULL,
    authorized_limit DECIMAL(12,2),
    status VARCHAR(30),

    FOREIGN KEY (admission_id)
        REFERENCES ADMISSIONS(admission_id),

    FOREIGN KEY (panel_id)
        REFERENCES INSURANCE_PANELS(panel_id)
);

CREATE TABLE TARIFF_RATES (
    tariff_id INT IDENTITY(1,1) PRIMARY KEY,
    panel_id INT NOT NULL,
    service_id INT NOT NULL,
    tariff_amount DECIMAL(10,2),
    effective_from DATE,
    effective_to DATE,

    FOREIGN KEY (panel_id)
        REFERENCES INSURANCE_PANELS(panel_id),

    FOREIGN KEY (service_id)
        REFERENCES SERVICES(service_id)
);


CREATE TABLE BILLING_ITEMS (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    stay_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    charged_amount DECIMAL(10,2),
    posted_by INT,
    posted_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (stay_id)
        REFERENCES DEPARTMENT_STAYS(stay_id),

    FOREIGN KEY (service_id)
        REFERENCES SERVICES(service_id),

    FOREIGN KEY (posted_by)
        REFERENCES USERS(user_id)
);

CREATE TABLE BILLING_AUDIT_LOG (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    item_id INT,
    changed_by INT,
    table_name VARCHAR(100),
    record_id INT,
    changed_at DATETIME DEFAULT GETDATE(),
    old_value VARCHAR(MAX),
    new_value VARCHAR(MAX),

    FOREIGN KEY (item_id)
        REFERENCES BILLING_ITEMS(item_id),

    FOREIGN KEY (changed_by)
        REFERENCES USERS(user_id)
);

--INSERT DATA
INSERT INTO USERS (username, password_hash, full_name, role)
VALUES
('admin1','pass123','System Admin','Admin'),
('nurse1','pass123','Ayesha Khan','Nurse'),
('billing1','pass123','Ali Raza','BillingStaff'),
('doctor1','pass123','Dr Ahmed','Doctor');


INSERT INTO INSURANCE_PANELS
(panel_name, contact_person, contact_phone)
VALUES
('State Life','Usman Tariq','03001234567'),
('EFU Health','Hassan Ali','03111234567');


INSERT INTO DEPARTMENTS
(department_name, ward_code)
VALUES
('Cardiology','CARD'),
('ICU','ICU'),
('General Ward','GW'),
('Pediatrics','PED'),
('Orthopedics','ORTH');


INSERT INTO SERVICES
(service_code, service_name, standard_rate)
VALUES
('ECG001','ECG',1500),
('XR001','X-Ray',3000),
('BT001','Blood Test',1000),
('ICU001','ICU Charges',10000),
('BED001','Bed Charges',2500);


INSERT INTO PATIENTS
(cnic, full_name, dob, contact, blood_group)
VALUES
('35202-1234567-1','Ali Ahmed','2000-05-10','03005551234','A+'),
('35202-7654321-2','Sara Khan','2002-08-15','03105551234','B+'),
('35202-1111111-3','Ahmed Raza','1999-12-20','03215551234','O+');


INSERT INTO ADMISSIONS
(patient_id, panel_id, admitted_on, discharge_date, episode_status)
VALUES
(1,1,'2026-06-01',NULL,'Active'),
(2,2,'2026-06-05',NULL,'Active'),
(3,1,'2026-06-07',NULL,'Active');


INSERT INTO DEPARTMENT_STAYS
(admission_id, department_id, start_datetime, end_datetime)
VALUES
(1,1,'2026-06-01 09:00','2026-06-02 10:00'),
(1,2,'2026-06-02 10:00','2026-06-04 08:00'),
(1,3,'2026-06-04 08:00',NULL);

INSERT INTO DEPARTMENT_STAYS
(admission_id, department_id, start_datetime, end_datetime)
VALUES
(2,4,'2026-06-05 10:00',NULL);

INSERT INTO DEPARTMENT_STAYS
(admission_id, department_id, start_datetime, end_datetime)
VALUES
(3,5,'2026-06-07 09:00',NULL);


INSERT INTO PRE_AUTHORIZATIONS
(admission_id, panel_id, authorized_limit, status)
VALUES
(1,1,50000,'Approved'),
(2,2,25000,'Approved'),
(3,1,30000,'Approved');

INSERT INTO TARIFF_RATES
(panel_id, service_id, tariff_amount, effective_from, effective_to)
VALUES
(1,1,1200,'2026-01-01','2026-12-31'),
(1,2,2500,'2026-01-01','2026-12-31'),
(2,1,1300,'2026-01-01','2026-12-31'),
(2,2,2800,'2026-01-01','2026-12-31');

INSERT INTO BILLING_ITEMS
(stay_id, service_id, quantity, charged_amount, posted_by)
VALUES
(1,1,1,1500,2),
(1,3,2,2000,2),
(2,4,2,20000,2),
(3,5,3,7500,2),
(4,1,1,1500,2),
(5,2,1,3000,2);

SELECT * FROM PATIENTS;
SELECT * FROM ADMISSIONS;
SELECT * FROM DEPARTMENT_STAYS;
SELECT * FROM BILLING_ITEMS;


CREATE VIEW vw_patient_episode_summary
AS
SELECT
    p.patient_id,
    p.full_name,
    a.admission_id,
    d.department_name,
    s.service_name,
    b.quantity,
    b.charged_amount
FROM PATIENTS p
JOIN ADMISSIONS a
    ON p.patient_id = a.patient_id
JOIN DEPARTMENT_STAYS ds
    ON a.admission_id = ds.admission_id
JOIN DEPARTMENTS d
    ON ds.department_id = d.department_id
JOIN BILLING_ITEMS b
    ON ds.stay_id = b.stay_id
JOIN SERVICES s
    ON b.service_id = s.service_id;

CREATE PROCEDURE sp_generate_episode_bill
    @AdmissionID INT
AS
BEGIN
    SELECT
        a.admission_id,
        p.full_name,
        SUM(b.charged_amount) AS Total_Bill
    FROM ADMISSIONS a
    JOIN PATIENTS p
        ON a.patient_id = p.patient_id
    JOIN DEPARTMENT_STAYS ds
        ON a.admission_id = ds.admission_id
    JOIN BILLING_ITEMS b
        ON ds.stay_id = b.stay_id
    WHERE a.admission_id = @AdmissionID
    GROUP BY
        a.admission_id,
        p.full_name;
END;
GO

EXEC sp_generate_episode_bill 1;


CREATE TRIGGER trg_billing_audit
ON BILLING_ITEMS
AFTER UPDATE
AS
BEGIN
    INSERT INTO BILLING_AUDIT_LOG
    (
        item_id,
        table_name,
        record_id,
        changed_at,
        old_value,
        new_value
    )
    SELECT
        d.item_id,
        'BILLING_ITEMS',
        d.item_id,
        GETDATE(),
        CAST(d.charged_amount AS VARCHAR(50)),
        CAST(i.charged_amount AS VARCHAR(50))
    FROM deleted d
    JOIN inserted i
        ON d.item_id = i.item_id;
END;
GO

UPDATE BILLING_ITEMS
SET charged_amount = 5000
WHERE item_id = 1;

SELECT * FROM BILLING_AUDIT_LOG;



BEGIN TRANSACTION;
UPDATE ADMISSIONS
SET
    discharge_date = GETDATE(),
    episode_status = 'Discharged'
WHERE admission_id = 1;

COMMIT TRANSACTION;

SELECT * FROM ADMISSIONS
WHERE admission_id = 1;


SELECT * FROM PATIENTS;

SELECT * FROM ADMISSIONS;

SELECT * FROM SERVICES;

SELECT COUNT(*) AS TotalPatients
FROM PATIENTS;

SELECT full_name
FROM PATIENTS
WHERE blood_group='A+';

