DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Animals'); 		-- 1
INSERT INTO category(categoryName) VALUES ('Body');			-- 2
INSERT INTO category(categoryName) VALUES ('Disasters');	-- 3
INSERT INTO category(categoryName) VALUES ('Events');		-- 4
INSERT INTO category(categoryName) VALUES ('Feelings');		-- 5
INSERT INTO category(categoryName) VALUES ('Food');			-- 6
INSERT INTO category(categoryName) VALUES ('Travel');		-- 7
INSERT INTO category(categoryName) VALUES ('Fantasy');		-- 8


INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('A Pet of Your Own', 1, 'Try taking care of a pet. The type of pet depends on what you choose. We recommend choosing an animal.',18.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Watch Wildlife',1 ,'Find yourself in a place of your choosing around the world observing wildlife.',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('The Body You Want',2 ,'Find out what it would be like to have the body you want.',10.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Earthquake',3,'Experience a natural disaster. Warning: emotional distress may occur.',97.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hurricane',3,'Experience a natural disaster. Warning: emotional distress may occur.',31.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Volcanic Eruption',3,'Experience a natural disaster. Warning: emotional distress may occur.',21.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('First Day of School',4,'Relive or re-invent that first day of school',38.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Graduation',4,'Experience the achievement',38.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Wedding Day',4,'Prepare for, re-live, or re-invent a wedding experience',38.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Family Gathering',4,'Bring the family together',38.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Amorous',5,'Focus on emotions rather than sensations.',38.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Annoyed',5,'Focus on emotions rather than sensations.',23.25);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Depression',5,'Focus on emotions rather than sensations. For educational purposes only.',17.45);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Embarassment',5,'Focus on emotions rather than sensations',39.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Envy',5,'Focus on emotions rather than sensations.',62.50);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Joy',5,'Focus on emotions rather than sensations.',9.20);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Pride',5,'Focus on emotions rather than sensations.',81.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Your Favorite Meal',6,'Re-live or re-invent your favorite meal',21.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Family Dinner',6,'Sometimes it''s not just the food. It''s the people you''re eating with.',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Savory Cuisine',6,'Try some new food or enjoy what you love',18.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fine Cuisine',6, 'Try some new food or enjoy what you love',19.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Baked Goods',6,'Try some new food or enjoy what you love',18.40);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Breakfast',6,'Try something new or enjoy what you love',9.65);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Vacation',7,'Go on the vacation of your dreams',21.05);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Business Trip',7,'Practice for that important business trip',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fly on a Plane',7,'Experience flight',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Ride a Train',7,'Experience a train ride',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sail on a Boat',7,'Experience sailing',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Drive a Vehicle',7,'Go for a test drive',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Superpower ',8,'Try out different superpowers',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fantasy World',8,'Experience the world of one or a combination of your favorite books or games',14.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Flying',8,'Try flying with no help from planes or other devices',50.00);


INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Katrina', 'M', 'Katrina@visionaries.dreamweavers.com', '250-123-1234', '123 Cloud Ave', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'katrina' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Tatiana', 'U', 'Tatiana@visionaries.dreamweavers.com', '250-123-1234', '123 Hallucinating Ave', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'tatiana' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Veronica', 'J', 'Veronica@visionaries.dreamweavers.com', '250-123-1234', 'Hole 11', 'Shire', 'ME', 'Z1V 2X9', 'Canada', 'veronica' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Jeff', 'H', 'Jeff@visionaries.dreamweavers.com', '250-123-1234', '123 Aspiration Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'jeff' , 'pw');

-- Start: ENTRIES FOR TESTING PURPOSES
INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (3, '2019-11-25', 1, 1, "It was alright.");

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);
-- End: DATA FOR TESTING PURPOSES

-- Product images
UPDATE Product SET productImageURL = 'img/petOfOwn.gif' WHERE productId = 1;
UPDATE Product SET productImageURL = 'img/watchingWildlife.gif' WHERE productId = 2;
UPDATE Product SET productImageURL = 'img/bodyYouWant.gif' WHERE productId = 3;
UPDATE Product SET productImageURL = 'img/earthquake.gif' WHERE productId = 4;
UPDATE Product SET productImageURL = 'img/hurricane.gif' WHERE productId = 5;
UPDATE Product SET productImageURL = 'img/volcano.gif' WHERE productId = 6;
UPDATE Product SET productImageURL = 'img/firstDaySchool.gif' WHERE productId = 7;
UPDATE Product SET productImageURL = 'img/graduation.gif' WHERE productId = 8;
UPDATE Product SET productImageURL = 'img/wedding.gif' WHERE productId = 9;
UPDATE Product SET productImageURL = 'img/familyGathering.gif' WHERE productId = 10;
UPDATE Product SET productImageURL = 'img/amorous.gif' WHERE productId = 11;
UPDATE Product SET productImageURL = 'img/annoyed.gif' WHERE productId = 12;
UPDATE Product SET productImageURL = 'img/depression.gif' WHERE productId = 13;
UPDATE Product SET productImageURL = 'img/embarassment.gif' WHERE productId = 14;
UPDATE Product SET productImageURL = 'img/envy.gif' WHERE productId = 15;
UPDATE Product SET productImageURL = 'img/joy.gif' WHERE productId = 16;
UPDATE Product SET productImageURL = 'img/pride.gif' WHERE productId = 17;
UPDATE Product SET productImageURL = 'img/hotDog.gif' WHERE productId = 18;
UPDATE Product SET productImageURL = 'img/familyDinner.gif' WHERE productId = 19;
UPDATE Product SET productImageURL = 'img/savoryCuisine.gif' WHERE productId = 20;
UPDATE Product SET productImageURL = 'img/fineCuisine.gif' WHERE productId = 21;
UPDATE Product SET productImageURL = 'img/bakedGoods.gif' WHERE productId = 22;
UPDATE Product SET productImageURL = 'img/breakfast.gif' WHERE productId = 23;
UPDATE Product SET productImageURL = 'img/vacation.gif' WHERE productId = 24;
UPDATE Product SET productImageURL = 'img/businessTrip.gif' WHERE productId = 25;
UPDATE Product SET productImageURL = 'img/flyPlane.gif' WHERE productId = 26;
UPDATE Product SET productImageURL = 'img/rideTrain.gif' WHERE productId = 27;
UPDATE Product SET productImageURL = 'img/sailBoat.gif' WHERE productId = 28;
UPDATE Product SET productImageURL = 'img/driveVehicle.gif' WHERE productId = 29;
UPDATE Product SET productImageURL = 'img/superpower.gif' WHERE productId = 30;
UPDATE Product SET productImageURL = 'img/fantasyWorld.gif' WHERE productId = 31;
UPDATE Product SET productImageURL = 'img/flying.gif' WHERE productId = 32;