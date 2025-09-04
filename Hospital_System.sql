CREATE DATABASE HospitalSystem;
USE HospitalSystem;
CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    medical_record_number VARCHAR(50),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    sex VARCHAR(10),
    marital_status VARCHAR(20),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    status VARCHAR(20)
);

CREATE TABLE Contact (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    name VARCHAR(100),
    relation VARCHAR(50),
    phone VARCHAR(20),
    type VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Allergy (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    substance VARCHAR(100),
    reaction VARCHAR(100),
    severity VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);
CREATE TABLE Provider (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100),
    license_number VARCHAR(50),
    status VARCHAR(20)
);

CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100),
    department_type VARCHAR(50)
);
CREATE TABLE Bed (
    bed_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20),
    status VARCHAR(20)
);

CREATE TABLE Appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    department_id INT,
    bed_id INT,
    start_time DATETIME,
    end_time DATETIME,
    reason VARCHAR(255),
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (provider_id) REFERENCES Provider(provider_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (bed_id) REFERENCES Bed(bed_id)
);
CREATE TABLE Encounter (
    encounter_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    department_id INT,
    type VARCHAR(50),
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Admission (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT UNIQUE,
    admit_date DATE,
    discharge_date DATE,
    attending_provider_id INT,
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id),
    FOREIGN KEY (attending_provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE BedAssignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id INT,
    bed_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (admission_id) REFERENCES Admission(admission_id),
    FOREIGN KEY (bed_id) REFERENCES Bed(bed_id)
);
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT,
    type VARCHAR(50),
    priority VARCHAR(50),
    ordered_by VARCHAR(100),
    status VARCHAR(20),
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);

CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    service_id INT,
    quantity INT,
    notes VARCHAR(500),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

CREATE TABLE Result (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT,
    value VARCHAR(100),
    units VARCHAR(50),
    abnormal_flag BOOLEAN,
    timestamp DATETIME,
    FOREIGN KEY (order_item_id) REFERENCES OrderItem(order_item_id)
);

CREATE TABLE Service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50),
    description VARCHAR(255),
    price DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);
CREATE TABLE Prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT,
    prescriber_id INT,
    status VARCHAR(20),
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id),
    FOREIGN KEY (prescriber_id) REFERENCES Provider(provider_id)
);

CREATE TABLE Drug (
    drug_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    strength VARCHAR(50),
    form VARCHAR(50),
    atc_code VARCHAR(50)
);

CREATE TABLE PrescriptionLine (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT,
    drug_id INT,
    dose VARCHAR(50),
    route VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    notes VARCHAR(500),
    FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id),
    FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
);

CREATE TABLE DispenseRecord (
    dispense_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_line_id INT,
    quantity INT,
    lot_number VARCHAR(50),
    expiry_date DATE,
    timestamp DATETIME,
    FOREIGN KEY (prescription_line_id) REFERENCES PrescriptionLine(line_id)
);

CREATE TABLE Note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT,
    author VARCHAR(100),
    type VARCHAR(50),
    text VARCHAR(700),
    timestamp DATETIME,
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);

CREATE TABLE Vital (
    vital_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT,
    type VARCHAR(50),
    value VARCHAR(50),
    units VARCHAR(20),
    measurement_time DATETIME,
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);

CREATE TABLE Diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT,
    code VARCHAR(50),
    description VARCHAR(255),
    type VARCHAR(50),
    onset_date DATE,
    FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);
CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    patient_responsibility DECIMAL(10,2),
    payer_responsibility DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Charge (
    charge_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    service_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    amount DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    amount DECIMAL(10,2),
    method VARCHAR(50),
    date DATE,
    receipt_number VARCHAR(50),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

CREATE TABLE Payer (
    payer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    contact_information VARCHAR(255)
);

CREATE TABLE Claim (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payer_id INT,
    status VARCHAR(20),
    submitted_date DATE,
    reference_number VARCHAR(50),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
    FOREIGN KEY (payer_id) REFERENCES Payer(payer_id)
);

CREATE TABLE InventoryItem (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    SKU VARCHAR(50),
    name VARCHAR(100),
    type VARCHAR(50),
    unit_of_measure VARCHAR(20),
    minimum_level INT,
    reorder_level INT
);

CREATE TABLE StockLot (
    lot_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    lot_number VARCHAR(50),
    expiry_date DATE,
    quantity_on_hand INT,
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id)
);

CREATE TABLE StockTransaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    purchase_order_id INT,
    type VARCHAR(50),
    quantity INT,
    date DATE,
    reference_information VARCHAR(255),
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id),
    FOREIGN KEY (purchase_order_id) REFERENCES PurchaseOrder(purchase_order_id)
);

CREATE TABLE Supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    contact_details VARCHAR(255)
);

CREATE TABLE PurchaseOrder (
    purchase_order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    status VARCHAR(20),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

CREATE TABLE PurchaseOrderLine (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT,
    item_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (purchase_order_id) REFERENCES PurchaseOrder(purchase_order_id),
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id)
);

CREATE TABLE OperatingRoomSchedule (
    or_schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE ConsumableUsed (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    or_schedule_id INT,
    item_id INT,
    quantity_used INT,
    FOREIGN KEY (or_schedule_id) REFERENCES OperatingRoomSchedule(or_schedule_id),
    FOREIGN KEY (item_id) REFERENCES InventoryItem(item_id)
);
CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password_hash VARCHAR(255),
    provider_id INT,
    email VARCHAR(100),
    status VARCHAR(20),
    FOREIGN KEY (provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50)
);

CREATE TABLE UserRole (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE AuditEvent (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    invoice_id INT,
    action VARCHAR(100),
    entity_type VARCHAR(50),
    entity_id INT,
    timestamp DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);
CREATE TABLE Document (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    document_type VARCHAR(50),
    uri VARCHAR(255),
    creation_timestamp DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
