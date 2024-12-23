create database SaleOrderQuiz ;
use SaleOrderQuiz ;
create table Customer (
    CustomerID INT NOT null AUTO_INCREMENT PRIMARY key ,
    CustomerFirstName VARCHAR(50) NOT NULL,
    CustomerLastName VARCHAR(50) NOT NULL,
    CustomerAddress VARCHAR(50) NOT NULL,
    CustomerCity VARCHAR(50) NOT NULL,
    CustomerPostCode CHAR(4),
    CustomerPhoneNumber CHAR(12)
);

create table Inventory (
   InventoryID TINYINT NOT null AUTO_INCREMENT PRIMARY KEY,
   InventoryName VARCHAR(50) NOT NULL,
   InventoryDescription VARCHAR(255)
)

create table Employee (
  EmployeeID TINYINT NOT null AUTO_INCREMENT PRIMARY KEY,
  EmployeeFirstName VARCHAR(50) NOT NULL,
  EmployeeLastName VARCHAR(50) NOT NULL,
  EmployeeExtension CHAR(4)
)

CREATE TABLE Sale (
    SaleID TINYINT NOT null AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    InventoryID TINYINT NOT NULL,
    EmployeeID TINYINT NOT NULL,
    SaleDate DATE NOT NULL,
    SaleQuantity INT NOT NULL,
    SaleUnitPrice INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Data Manipulation

INSERT INTO Customer (CustomerFirstName, CustomerLastName, CustomerAddress, CustomerCity, CustomerPostCode, CustomerPhoneNumber) VALUES 
('Yassir', 'Zbida', '145 massira', 'Safi', '2201', '772508881'),
('Rachid', 'Smayta', 'Jnan Ilane', 'Sabt Gzoula', '8009', '0685411236'),
('Hamid', 'Jmilla', 'Sania', 'Rabat', '4566', '0645127810');

INSERT INTO Inventory (InventoryName, InventoryDescription) VALUES 
('Tanjra', '16 L Turkey'),
('Table', 'Samsung 30 inch'),
('Vase', '2 M');

INSERT INTO Employee (EmployeeFirstName, EmployeeLastName, EmployeeExtension) VALUES 
('Zbida', 'Yassir', '10'),
('Achraf', 'Hnazaz', '11'),
('Mahjoub', 'Charkaoui', '13');

INSERT INTO Sale (CustomerID, InventoryID, EmployeeID, SaleDate, SaleQuantity, SaleUnitPrice) VALUES 
(1, 2, 3, '2023-05-25', 2, 1000.00),
(1, 2, 1, '2024-02-23', 1, 800.00),
(3, 2, 1, '2024-08-01', 3, 500.00);

-- Display All Customers 

SELECT * FROM Customers ;

-- Display All Sales Depends on SaleQuantity * SaleUnitPrice

SELECT SaleID, CustomerID, InventoryID, EmployeeID, SaleDate, SaleQuantity, SaleUnitPrice, 
       (SaleQuantity * SaleUnitPrice) AS TotalAmount FROM Sale
ORDER BY TotalAmount DESC;

-- Display Employees that complete one sale and also order by sales number 

SELECT Employee.EmployeeID, 
       Employee.EmployeeFirstName, 
       Employee.EmployeeLastName, 
       SUM(Sale.SaleQuantity * Sale.SaleUnitPrice) AS TotalSales
FROM Employee
JOIN Sale ON Employee.EmployeeID = Sale.EmployeeID
GROUP BY Employee.EmployeeID, Employee.EmployeeFirstName, Employee.EmployeeLastName
HAVING COUNT(Sale.SaleID) > 0;

-- Tables Edits 


-- Add New Column 

ALTER TABLE Customer ADD CustomerEmail VARCHAR(100);

-- Update Email Column for the First Customer

UPDATE Customer SET CustomerEmail = 'zbidayassir10@gmail.com' WHERE CustomerID = 1;

-- Delete Customer Depends on Customer City

DELETE FROM Customer WHERE CustomerCity = 'Rabat';

-- Advanced Queries

-- Display Sales on these last 30 days

SELECT * FROM Sale
WHERE SaleDate >= CURDATE() - INTERVAL 30 DAY;


--  Display customer that buy more 5 products in one order

SELECT C.CustomerID, C.CustomerFirstName, C.CustomerLastName, 
       S.SaleID, S.SaleQuantity
FROM Customer C
JOIN Sale S ON C.CustomerID = S.CustomerID
WHERE S.SaleQuantity > 5;

-- Total Inventory Revenue Sales

SELECT I.InventoryName, SUM(S.SaleQuantity * S.SaleUnitPrice) AS TotalRevenue
FROM Inventory I
JOIN Sale S ON I.InventoryID = S.InventoryID
GROUP BY I.InventoryName;



