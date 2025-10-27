create database elevatelabs;
use elevatelabs;

-- Create tables
CREATE TABLE Agents (
    agent_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Buyers (
    buyer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Properties (
    property_id SERIAL PRIMARY KEY,
    address VARCHAR(200),
    region VARCHAR(100),
    price DECIMAL(12,2),
    listed_date DATE,
    agent_id INT REFERENCES Agents(agent_id)
);

CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    property_id INT REFERENCES Properties(property_id),
    buyer_id INT REFERENCES Buyers(buyer_id),
    sale_price DECIMAL(12,2),
    sale_date DATE
);

-- Insert mock data
INSERT INTO Agents (name, email, phone) VALUES
('John Doe', 'john@example.com', '9876543210'),
('Sarah Lee', 'sarah@example.com', '9876543211');

INSERT INTO Buyers (name, email, phone) VALUES
('Alice', 'alice@example.com', '9876543212'),
('Bob', 'bob@example.com', '9876543213');

INSERT INTO Properties (address, region, price, listed_date, agent_id) VALUES
('123 Park St', 'Pune', 7500000, '2025-01-10', 1),
('45 MG Road', 'Mumbai', 12000000, '2025-02-05', 2),
('78 Hill View', 'Pune', 6800000, '2025-03-15', 1),
('90 Ocean Drive', 'Goa', 9500000, '2025-04-20', 2);

INSERT INTO Transactions (property_id, buyer_id, sale_price, sale_date) VALUES
(1, 1, 7400000, '2025-02-20'),
(2, 2, 11800000, '2025-03-10'),
(3, 1, 7000000, '2025-04-25');

-- Average price by region
SELECT region, ROUND(AVG(price),2) AS avg_price
FROM Properties
GROUP BY region;

-- Create view for high-demand areas (more than 1 property sold)
CREATE VIEW high_demand_areas AS
SELECT p.region, COUNT(t.transaction_id) AS total_sales
FROM Properties p
JOIN Transactions t ON p.property_id = t.property_id
GROUP BY p.region
HAVING COUNT(t.transaction_id) > 1;

-- Price trend report using window functions
SELECT region, listed_date, price,
       ROUND(AVG(price) OVER (PARTITION BY region ORDER BY listed_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_price
FROM Properties
ORDER BY region, listed_date;

SELECT * FROM high_demand_areas;
SELECT region, ROUND(AVG(price),2) AS avg_price
FROM Properties
GROUP BY region;

SELECT * FROM Properties;

SELECT region, listed_date, price,
       ROUND(AVG(price) OVER (PARTITION BY region ORDER BY listed_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_price
FROM Properties
ORDER BY region, listed_date;




