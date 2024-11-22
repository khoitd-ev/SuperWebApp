-- Tạo cơ sở dữ liệu
CREATE DATABASE Webapp;
USE Webapp;

-- Bảng thương hiệu (Brands Table)
CREATE TABLE Brands (
    BrandID INT PRIMARY KEY AUTO_INCREMENT,
    BrandName VARCHAR(255) NOT NULL,
    Description TEXT
);

-- Bảng danh mục (Categories Table)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255) NOT NULL,
    Description TEXT
);

-- Bảng sản phẩm (Products Table)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) NOT NULL,
    BrandID INT,
    CategoryID INT,
    Price DECIMAL(10,0) NOT NULL,
    StockQuantity INT NOT NULL,
    Description TEXT,
    ImageURL VARCHAR(255),
    DateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Bảng người dùng (Users Table)
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15),
    ShippingAddress TEXT,
    DateJoined DATETIME DEFAULT CURRENT_TIMESTAMP,
    UserType ENUM('Admin', 'Customer') NOT NULL
);

-- Bảng trạng thái đơn hàng (OrderStatus Table)
CREATE TABLE OrderStatus (
    StatusID INT PRIMARY KEY AUTO_INCREMENT,
    StatusName VARCHAR(50) NOT NULL,
    Description TEXT
);

-- Bảng đơn hàng (Orders Table)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 0) NOT NULL,
    ShippingAddress TEXT,
    PaymentMethod ENUM('Credit Card', 'E-Wallet') NOT NULL,
    ShippingStatus INT,
    TrackingNumber VARCHAR(50),
    EstimatedDeliveryDate DATETIME,
    DeliveryDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ShippingStatus) REFERENCES OrderStatus(StatusID)
);

-- Bảng chi tiết đơn hàng (OrderDetails Table)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Bảng lịch sử giao dịch (TransactionHistory Table)
CREATE TABLE TransactionHistory (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod ENUM('Credit Card', 'E-Wallet'),
    TransactionAmount DECIMAL(10, 0) NOT NULL,
    TransactionStatus ENUM('Thành công', 'Thất bại', 'Đang xử lý'),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Bảng giỏ hàng (ShoppingCart Table)
CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    AddedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Thêm chỉ mục vào bảng Products
CREATE INDEX idx_products_brand_category ON Products (BrandID, CategoryID);

-- Thêm chỉ mục vào bảng Users
CREATE INDEX idx_users_email ON Users (Email);

-- Thêm chỉ mục vào bảng Orders
CREATE INDEX idx_orders_user_orderdate ON Orders (UserID, OrderDate);

-- Thêm chỉ mục vào bảng OrderDetails
CREATE INDEX idx_orderdetails_orderid ON OrderDetails (OrderID);

-- Thêm chỉ mục vào bảng TransactionHistory
CREATE INDEX idx_transactionhistory_orderid_date ON TransactionHistory (OrderID, TransactionDate);

-- Thêm chỉ mục vào bảng ShoppingCart
CREATE INDEX idx_shoppingcart_user_product ON ShoppingCart (UserID, ProductID);

-- Thêm dữ liệu mẫu vào Brands
INSERT INTO Brands (BrandName, Description) VALUES
('Akko', ''),
('Corsair', ''),
('DareU', ''),
('Fuhlen', ''),
('Logitech', ''),
('Machenike', ''),
('Rapoo', ''),
('Razer', ''),
('Redragon', ''),
('SPARTAN', ''),
('Xiberia', ''),
('Asus', ''),
('Attack Shark', ''),
('HyperX', ''),
('Royal Kludge', ''),
('Zidli', ''),
('MSI', '');

-- Thêm dữ liệu mẫu vào Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Laptop', ''),
('PC', ''),
('Màn Hình', ''),
('Bàn Phím', ''),
('Chuột', ''),
('Tai Nghe', '');

-- Thêm tài khoản Admin
INSERT INTO Users (UserName, Email, PasswordHash, PhoneNumber, ShippingAddress, DateJoined, UserType)
VALUES ('admin', 'admin@example.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '123456789', 'Admin Address', CURRENT_TIMESTAMP, 'Admin');
