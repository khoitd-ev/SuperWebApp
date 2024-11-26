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
('MSI', ''),
('GIGABYTE', '');

-- Thêm dữ liệu mẫu vào Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Laptop', ''),
('PC', ''),
('Màn Hình', ''),
('Bàn Phím', ''),
('Chuột', ''),
('Tai Nghe', ''),
('Card màn hình', '');

-- thêm dữ liệu cho OrderStatus
INSERT INTO OrderStatus (StatusID, StatusName) VALUES 
(1, 'Processing'),
(2, 'Shipped'),
(3, 'Delivered');


-- Thêm tài khoản Admin
INSERT INTO Users (UserName, Email, PasswordHash, PhoneNumber, ShippingAddress, DateJoined, UserType)
VALUES ('admin', 'admin@example.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '123456789', 'Admin Address', CURRENT_TIMESTAMP, 'Admin');

-- Thêm một vài sản phẩm 

-- Card màn hình
INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'VGA Radeon RX6600 8G GDDR6 Gigabyte Eagle GV-R66EAGLE-8GD',
    18, 
    7, 
    5350000,
    22,
    'Vẻ đẹp và sức mạnh hội tụ, thiết kế đẳng cấp, trải nghiệm gaming mượt mà',
    'https://product.hstatic.net/200000420363/product/_2023_-khung-sp-_1__e4dabe2bd54c49d39705d76f02e03c54_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Card màn hình VGA GIGABYTE GeForce RTX 4090 WindForce V2 24GB (GV-N4090WF3V2-24GD)',
    18, 
    7, 
    58850000,
    20,
    'Siêu phẩm hiệu năng, thiết kế đỉnh cao, dành cho game thủ và người dùng chuyên nghiệp',
    'https://product.hstatic.net/200000420363/product/geforce_rtx__4090_windforce_v2_24g-01_be1f63e9424b4f0eb87f358912f5023d_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Vga Gigabyte RTX 4090 Aorus Xtreme Waterforce 24GB GDDR6X (GV-N4090AORUSX W-24GD)',
    18, 
    7, 
    57900000,
    8,
    'Siêu phẩm hiệu năng, thiết kế đỉnh cao, dành cho game thủ và người dùng chuyên nghiệp',
    'https://product.hstatic.net/200000420363/product/_2023_-khung-sp-_1__2529f6d38cd24bf6b3bf806d67226946_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'VGA Gigabyte RTX 4080 AERO OC 16GB GDDR6X 3Fan (GV-N4080AERO OC-16GD)',
    18, 
    7, 
    39900000,
    19,
    'Sở hữu kiến trúc Ada Lovelace mới của Nvidia, VGA RTX 4080 16GB AERO OC mang lại hiệu suất cao với các tính năng làm thỏa mãn mọi yêu cầu nâng cao từ các nhà sáng tạo và game thủ.',
    'https://product.hstatic.net/200000420363/product/_2023_-khung-sp-_1__a16b7a5445fd43ec94961bf1268905ed_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Card màn hình VGA GIGABYTE GeForce RTX 4070 Ti SUPER AI TOP 16GB (GV-N407TSAI TOP-16GD)',
    18, 
    7, 
    27990000,
    10,
    'RTX 4070 Ti SUPER AI TOP 16GB',
    'https://product.hstatic.net/200000420363/product/geforce_rtx__4070_ti_super_ai_top_16g-01_169e0d442f6f4074bf9afe24412124ac_master.png'
);

-- Bàn phím
INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Bàn phím cơ Akko 3098B Multi modes Blue on White | Akko CS Switch - Jelly Pink',
    1, 
    4, 
    1689000,
    18,
    '98 phím với kích thước nhỏ gọn nhưng vẫn đầy đủ cụm phím số bên phải',
    'https://product.hstatic.net/200000420363/product/tinhocngoisao.com1__64__61216db1d48b4e309c8335f16840e05b_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Bàn Phím Corsair K68 Red Led - MX Red (Đen)',
    2, 
    4, 
    1690000,
    10,
    '',
    'https://product.hstatic.net/200000420363/product/ban-phim-corsair-k68-red-led---mx-red-_den_-1__1__8e2ab237f56d4b2b80fcf8b533163f07_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Bàn Phím Fuhlen Destroyer Nhập khẩu - Đen',
    4, 
    4, 
    790000,
    17,
    'Bàn phím cơ gaming Fuhlen Destroyer - Trải nghiệm gõ phím đỉnh cao, cân mọi trận game',
    'https://product.hstatic.net/200000420363/product/ban-phim-fuhlen-destroyer-nhap-khau---den5_7df0d8dcf596482b8ee7b30abc0c2b01_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Bàn phím cơ Dare-U EK75 Pro WBC | Wireless, triple mode, gasket mount, RGB, Dream Switch',
    3, 
    4, 
    1090000,
    12,
    'USB / Bluetooth / 2.4GHz, cho phép kết nối linh hoạt.',
    'https://product.hstatic.net/200000420363/product/ban-phim-co-khong-day-dareu-ek75-pro---wbc-3_32c310a06f814256ada5ce74347db8f7_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Bàn phím cơ Rapoo V510C Black | Led Rainbow, Blue Switch',
    7, 
    4, 
    1690000,
    16,
    'Bàn phím cơ gaming Fuhlen Destroyer - Trải nghiệm gõ phím đỉnh cao, cân mọi trận game',
    'https://product.hstatic.net/200000420363/product/1694405274801_f57bff7f7faa4a8fbb94cc50a89a5e0f_master.jpg'
);


-- Chuột

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Chuột Gaming Không Dây Logitech G304 Lightspeed (Đen)',
    5, 
    5, 
    735000,
    22,
    'Thiết kế đối xứng, nhỏ gọn, nhẹ nhàng',
    'https://product.hstatic.net/200000420363/product/_new_-anh-sp-web_35d2974a577b404f9a366e8dc33e3cd8_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Chuột Gaming Razer Cobra Black (RZ01-04650100-R3M1)',
    8, 
    5, 
    839000,
    16,
    'Thiết kế nhỏ gọn, gọn gàng cùng trọng lượng siêu nhẹ, chuột Razer Cobra mang đến cảm giác cầm nắm thoải mái, phù hợp với nhiều tư thế cầm chuột khác nhau',
    'https://product.hstatic.net/200000420363/product/chuot-gaming-razer-cobra-black-_rz01-04650100-r3m1_3_2182bcc2bae3423d80abe22511097004_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Chuột gaming Attack Shark X6 | Wireless, Pixart 3395, 3 mode, black',
    13, 
    5, 
    649000,
    14,
    'Chuột Gaming Attack Shark X6: Trải nghiệm hoàn hảo cho game thủ',
    'https://product.hstatic.net/200000420363/product/tinhocngoisao.com1__3__be3d6ae9f7b646edaf93e4dfe20e3ce5_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Chuột Gaming Razer DeathAdder Essential - Ergonomic Đen (RZ01-03850100-R3M1)',
    8, 
    5, 
    399000,
    20,
    'Chuột Gaming Razer DeathAdder Essential : Chiến binh bất bại, thống trị mọi trận chiến',
    'https://product.hstatic.net/200000420363/product/chuot-gaming-razer-deathadder-essential-ergonomic-3_c4574016e8e94ba1aea1ec7e2a9dd70f_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Chuột DareU EM901X RGB Superlight Wireless Black',
    3, 
    5, 
    699000,
    22,
    'Chuột DareU EM901X RGB Superlight Wireless Black: Chuột không dây nhẹ, hiệu năng ấn tượng, giá cả phải chăng',
    'https://product.hstatic.net/200000420363/product/1_d41e719e8fe44190a9fe06d3f00d70ab_master.jpg'
);

-- Tai nghe 

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Tai nghe Gaming Corsair Virtuoso RGB Wireless High Fidelity - Pearl (AP)',
    2, 
    6, 
    3590000,
    20,
    'Tai nghe Gaming ',
    'https://product.hstatic.net/200000420363/product/tai_xuong_-_2023-11-27t134612.350_4c6ef5575693433e939732fc84802a94_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Tai nghe Dare-U Eh925L RGB 7.1 | Black - Red',
    3, 
    6, 
    699000,
    20,
    'Tai nghe Gaming ',
    'https://product.hstatic.net/200000420363/product/tai_xuong_-_2023-11-27t134612.350_4c6ef5575693433e939732fc84802a94_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Tai nghe gaming ASUS ROG Cetra II Core | Đen (90YH0360-B2UA00)',
    12, 
    6, 
    835000,
    17,
    'Thiết kế công thái học với đệm tai siêu mềm tạo cảm giác vừa vặn và thoải mái',
    'https://product.hstatic.net/200000420363/product/tai-nghe-gaming-asus-rog-cetra-ii-core-11_6e386d7b27124ffbac84203d3f3be519_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Tai Nghe HP HyperX Cloud Earbuds II - Màu đỏ (705L8AA)',
    14, 
    6, 
    819000,
    14,
    'Tai nghe HP HyperX Cloud Earbuds II là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, tiện lợi và chất lượng âm thanh vượt trội, mang đến trải nghiệm chơi game đỉnh cao cho các game thủ',
    'https://product.hstatic.net/200000420363/product/tai-nghe-hp-hyperx-cloud-earbuds-ii---mau-do-_705l8aa_4_17b90ed8cf6b4de59727f546f88c1d9a_master.jpg'
);


INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Tai nghe Gaming XIBERIA S19 | Đen đỏ, USB 2.2m',
    11, 
    6, 
    980000,
    12,
    'XIBERIA S19 là một chiếc tai nghe gaming đầy ấn tượng, với thiết kế hầm hố, chất âm sống động, và micro lọc tiếng ồn hiệu quả, mang đến trải nghiệm chơi game tuyệt vời.',
    'https://product.hstatic.net/200000420363/product/tai-nghe-gaming-xiberia-s19-6_61a1557dddad41a8b76d5f924743248b_master.jpg'
);


-- Màn hình

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Màn hình Gaming MSI Pro MP251 | 24.5 inch, Full HD, IPS, 100Hz, 1ms, phẳng',
    17, 
    3, 
    2090000,
    16,
    'MSI Pro MP251: Đỉnh cao trải nghiệm thị giác cho doanh nghiệp và chuyên gia',
    'https://product.hstatic.net/200000420363/product/man-hinh-gaming-msi-pro-mp251-4_2a8cbd585acf4735ad35187cf045b149_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Màn hình LCD 27 inch Asus VG279QM TUF Gaming FHD IPS 280Hz 1ms HDR G-Sync Chính Hãng',
    12, 
    3, 
    6550000,
    17,
    'Màn hình chơi game 24,5 inch Full HD (1920 x 1080) với tấm nền Fast IPS có tốc độ làm mới siêu nhanh 280*Hz được thiết kế dành cho các game thủ chuyên nghiệp và mang tới trải nghiệm chơi game đắm chìm',
    'https://product.hstatic.net/200000420363/product/vg279qm_ab8c3f8589c14429acbed777e7dc1648_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Màn hình Đồ Họa Asus ProArt PA248QV | 24 inch, FHD, IPS, 75Hz, 100% sRGB, Phẳng',
    12, 
    3, 
    4920000,
    18,
    'ASUS ProArt PA248QV – Màu sắc vượt trội. Sáng tạo không giới hạn.',
    'https://product.hstatic.net/200000420363/product/man-hinh-lcd-24-asus-proart-pa248qv_84dea8aca5564b9283d13ecab0ef49aa_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Màn hình Gaming MSI MAG G256F | 24.5 inch, Full HD, IPS, 180Hz, 1ms, phẳng',
    17, 
    3, 
    2990000,
    16,
    'Màn hình Gaming MSI MAG G256F: Trải nghiệm chơi game mượt mà và sống động',
    'https://product.hstatic.net/200000420363/product/man-hinh-gaming-msi-mag-g256f-5_b1a7683143d848ac8d28b6b825f6835a_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Màn hình MSI G244F E2 | 23.8 inch, Full HD, IPS, 180Hz, 1ms, phẳng',
    17, 
    3, 
    3300000,
    16,
    ' ',
    'https://product.hstatic.net/200000420363/product/g244f-e2-4_0f50608792ad4cc98766614c74062b6e_master.png'
);


-- PC

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'PC Gaming STAR ASUS ROG White | Intel I5 14400F/ RTX 4060/ B760 WIFI/ RAM 32GB/ SSD 500GB',
    12, 
    2, 
    24037000,
    7,
    ' ',
    'https://product.hstatic.net/200000420363/product/3222_bef3e1f1432d4e3db0506f145b86a8d0_master_02e88f15ce8d4e6bab1a435dd6f3c9a2_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'PC Gaming STAR Yone | AMD R7 9700X\ RTX 4070S\ B650M Wifi\ RAM 32GB\ SSD 500GB',
    12, 
    2, 
    38010000,
    10,
    ' ',
    'https://product.hstatic.net/200000420363/product/yone_55c0c1ad05b844b892fa136cf4333eae_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'PC Gaming STAR ASUS TUF Black | Intel I5 14400F/ RTX 4060/ B760 WIFI/ RAM 32GB/ SSD 500GB',
    12, 
    2, 
    22768000,
    5,
    ' ',
    'https://product.hstatic.net/200000420363/product/3_fcfc2cd4503e4fc28b34cdc274413917_master_ddd7ace6a0534202b58015f6ac177918_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'PC Gaming STAR Sev7n | Intel i5 12400F\ RTX 3060 12G\ B760M WIFI\ RAM 16GB\ SSD 512GB',
    12, 
    2, 
    18457000,
    3,
    'PC GAMING STAR SEV7N - RTX KHÔNG GIỚI HẠN ',
    'https://product.hstatic.net/200000420363/product/12123123_45c449859f364c23a0189cef5c87b22c_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'PC Gaming STAR Battle while | Intel i3 12100F\ GTX 1660S 6G\ H610M WIFI\ RAM 16GB\ SSD 512GB',
    12, 
    2, 
    11416000,
    7,
    ' ',
    'https://product.hstatic.net/200000420363/product/11_31ec19e8b61d4ce58de81c23a2004bc3_master.png'
);

-- Laptop

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Laptop Gaming ASUS ROG Strix G16 G614JU N3135W',
    12, 
    1, 
    27890000,
    20,
    'Tăng lực cho cuộc chơi của bạn ',
    'https://product.hstatic.net/200000420363/product/g614ju-n3135w_058071f16f6c4e70a19c84aaf23dddfe_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Laptop MSI Modern 15 B13M 297VN',
    17, 
    1, 
    14990000,
    21,
    'Laptop MSI Modern 15 B13M 297VN: Năng suất & Giải trí Hoàn hảo ',
    'https://product.hstatic.net/200000420363/product/laptop-msi-modern-15-b13m-297vn-4_1e8725ff2b2d4ed19a5c1dec4148ea35_master.jpg'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Laptop MSI Thin 15 B12UCX 1419VN',
    17, 
    1, 
    15190000,
    20,
    'MSI Thin 15 B12UCX 1419VN - Laptop mỏng nhẹ, hiệu năng mạnh mẽ dành cho game thủ và người dùng chuyên nghiệp',
    'https://product.hstatic.net/200000420363/product/laptop-msi-thin-15-b12ucx-1419vn-6_50296bb1315446c1a6109c59b81861f5_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Laptop Gaming Gigabyte G5 MF5 H2VN353KH',
    18, 
    1, 
    23990000,
    20,
    'Laptop Gaming Gigabyte G5 MF5 H2VN353KH - Trải nghiệm đỉnh cao hiệu năng và thiết kế',
    'https://product.hstatic.net/200000420363/product/laptop-gaming-gigabyte-g5-mf5-h2vn353kh-6_d3474b1f713d4033a6a952df1729f14c_master.png'
);

INSERT INTO Products (ProductName, BrandID, CategoryID, Price, StockQuantity, Description, ImageURL)
VALUES (
    'Laptop Gaming GIGABYTE Aorus 15 9MF E2VN583SH',
    18, 
    1, 
    25900000,
    20,
    ' ',
    'https://product.hstatic.net/200000420363/product/aorus_15__intel_13th_gen_-1_834b9d53548146a693203087e0f29088_master_b8a6f93113d54a15a4e14e144cc4a87b_master.png'
);