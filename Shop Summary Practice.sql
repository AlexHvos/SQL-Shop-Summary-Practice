--1)
CREATE DATABASE Shop;

USE Shop;

CREATE TABLE Customers
(
CustomerID INT PRIMARY KEY,
CustomerName VARCHAR(256) UNIQUE,
);

CREATE TABLE Products
(
ProductID INT NOT NULL PRIMARY KEY,
ProductName VARCHAR(256) UNIQUE,
Price MONEY CHECK (Price > 0) 
);

CREATE TABLE OrdersCustomers
(
OrderID INT PRIMARY KEY,
CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
DateCreated DATETIME DEFAULT Getdate()
);

CREATE TABLE OrdersProducts
(
OrderID INT NOT NULL FOREIGN KEY REFERENCES OrdersCustomers(OrderID),
ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
Quantity INT,
CONSTRAINT op Primary Key (OrderID, ProductID)
);


-- 2)
BEGIN TRY
  BEGIN TRAN
  INSERT INTO Customers VALUES (1, 'DavidLynch')
  INSERT INTO Customers VALUES (2, 'EdgarWright')
  INSERT INTO Customers VALUES (3, 'RidleyScott')
  INSERT INTO Customers VALUES (4, 'DenisVilleneuve')
  -- INSERT INTO Customers VALUES (5, 'David Lynch')
  INSERT INTO Products VALUES (1, 'Camera', 25)
  INSERT INTO Products VALUES (2, 'Microphone', 13)
  INSERT INTO Products VALUES (3, 'Charger', 7)
  INSERT INTO Products VALUES (4, 'Headphones', 18)
  INSERT INTO Products VALUES (5, 'Speakers', 10)
  --INSERT INTO Products VALUES (6, 'Laptop', 0)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (1,3)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (2,1)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (3,3)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (4,4)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (5,2)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (6,1)
  INSERT INTO OrdersCustomers (OrderID, CustomerID) VALUES (7,4)


  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (1,3,5)
  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (2,2,9)
  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (3,5,2)
  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (4,1,10)
  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (5,4,0)
  INSERT INTO OrdersProducts (OrderID, ProductID, Quantity) VALUES (7,5,8)
  COMMIT TRAN
  PRINT('Transaction succeeded')
END TRY

BEGIN CATCH
  ROLLBACK TRAN
  PRINT('Transaction failed,' + ERROR_MESSAGE())
END CATCH

--3)
SELECT * 
FROM Customers c JOIN OrdersCustomers oc ON c.CustomerID = oc.CustomerID 
                 JOIN OrdersProducts op ON op.OrderID = oc.OrderID
				 JOIN Products p ON p.ProductID = op.ProductID;

--4)
SELECT c.CustomerID, c.CustomerName, op.OrderID, SUM(Quantity * Price) AS Value
FROM Customers c JOIN OrdersCustomers oc ON c.CustomerID = oc.CustomerID
                 JOIN OrdersProducts op ON op.OrderID = oc.OrderID
				 JOIN Products p ON p.ProductID = op.ProductID
				 GROUP BY c.CustomerID, c.CustomerName, op.OrderID;

--5)
SELECT *
FROM Customers c JOIN OrdersCustomers oc ON c.CustomerID = oc.CustomerID
                 LEFT JOIN OrdersProducts op ON op.OrderID = oc.OrderID
				 LEFT JOIN Products p ON p.ProductID = op.ProductID
				 WHERE op.ProductID IS NULL;

--6)
SELECT TOP 1 ProductName, COUNT(*) AS OrderCount
FROM Products join OrdersProducts ON Products.ProductID = OrdersProducts.ProductID
GROUP BY ProductName
ORDER BY OrderCount DESC;