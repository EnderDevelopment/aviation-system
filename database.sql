CREATE TABLE IF NOT EXISTS aviation_licenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    license_type VARCHAR(50) NOT NULL,
    UNIQUE KEY unique_license (identifier, license_type)
);

CREATE TABLE IF NOT EXISTS aviation_jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    job_name VARCHAR(50) NOT NULL,
    grade INT NOT NULL,
    UNIQUE KEY unique_job (identifier, job_name)
);

CREATE TABLE IF NOT EXISTS aviation_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(60) NOT NULL,
    model VARCHAR(50) NOT NULL,
    plate VARCHAR(10) NOT NULL,
    UNIQUE KEY unique_vehicle (owner, plate)
);