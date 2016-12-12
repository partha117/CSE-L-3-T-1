CREATE TABLE GUEST
(

    GUEST_ID INTEGER ,
	FIRST_NAME VARCHAR2(15) NOT NULL,
	LAST_NAME VARCHAR2(15),
	ADDRESS VARCHAR2(30) NOT NULL,
	CONTACT_NO VARCHAR2(15),
	TOTAL_PERSON INTEGER,
	PASSPORT_NO VARCHAR2(30),
	NID VARCHAR2(20),
	

	PRIMARY KEY (GUEST_ID),

	CHECK(PASSPORT_NO IS NOT NULL OR NID IS NOT NULL)
	
	
);
CREATE TABLE BOOKING
(
   DATE_FROM DATE NOT NULL,
   DATE_TO DATE ,
   BOOKING_ID INTEGER,
   
   BOOKED_BY_GUEST INTEGER,


	 PRIMARY KEY(BOOKING_ID),
	 FOREIGN KEY(BOOKED_BY_GUEST) REFERENCES GUEST(GUEST_ID)
);
CREATE TABLE EMPLOYEE
(
	EMPLOYEE_ID INTEGER,
	EMAIL VARCHAR2(80),
	CONTACT_NO VARCHAR2(15),
	EMPLOYEE_FIRST_NAME VARCHAR2(15),
	EMPLOYEE_LAST_NAME VARCHAR2(15),
	DEPARTMENT VARCHAR2(20),
	DESIGNATION VARCHAR2(20),


	PRIMARY KEY(EMPLOYEE_ID)
);

CREATE TABLE ROOM
(
	ROOM_NO INTEGER,
	FLOOR_NO INTEGER,
	STATUS VARCHAR2(15),
	ROOM_COST FLOAT,
	WI_FI VARCHAR2(15),
	AIR_CONDITIONER VARCHAR2(15),
	SPECALITY VARCHAR2(50),
	CAPACITY INTEGER,
	ROOM_EMPLOYEE_ID INTEGER,
	PAY_STATE VARCHAR2(15),
	
	PRIMARY KEY(ROOM_NO),
	
	FOREIGN KEY(ROOM_EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)
);
CREATE TABLE ROOM_BOOKING
(
 ROOM_BOOKING_ID INTEGER,
 ROOM_NO INTEGER,
 BOOKING_ID INTEGER,
 PRIMARY KEY(ROOM_NO,BOOKING_ID),
 FOREIGN KEY(BOOKING_ID) REFERENCES BOOKING(BOOKING_ID),
 FOREIGN KEY(ROOM_NO) REFERENCES ROOM(ROOM_NO)
 
	
);


CREATE TABLE BILL_AUTHORIZATION
(
	BILL_EMPLOYEE_ID INTEGER,
	BILL_DESIGNATION VARCHAR2(20),
	BILL_AUTHORIZATION VARCHAR2(20),

	PRIMARY KEY(BILL_EMPLOYEE_ID),
	FOREIGN KEY(BILL_EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
	CHECK (BILL_DESIGNATION = 'ACCOUNTANT')
	
	
);
CREATE TABLE BILL
(	
	BILL_ID INTEGER,
	REFUNDABLE VARCHAR2(15),
	BILL_DATE DATE,
	AMOUNT FLOAT,
	EMPLOYEE_ID INTEGER,
	GUEST_ID INTEGER,
	PAYMENT_METHOD VARCHAR2 (20),
  
	PRIMARY KEY(BILL_ID),
	FOREIGN KEY(GUEST_ID) REFERENCES GUEST(GUEST_ID),
	FOREIGN KEY(EMPLOYEE_ID) REFERENCES BILL_AUTHORIZATION(BILL_EMPLOYEE_ID)
	
 

);




CREATE TABLE FACILITY
(
	FACILITY_ID INTEGER ,
	PRICE FLOAT,
	FACILITY_TYPE VARCHAR2(60),
	PAY_STATE VARCHAR2(20),
	ASSIGNED_EMPLOYEE_ID INTEGER,
	PRIMARY KEY(FACILITY_ID),
	FOREIGN KEY(ASSIGNED_EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)
);

CREATE TABLE FACILITY_BOOKING
(
 FACILITY_BOOKING_ID INTEGER,
 FACILITY_ID INTEGER,
 BOOKING_ID INTEGER,
 PRIMARY KEY(FACILITY_ID,BOOKING_ID),
 FOREIGN KEY(BOOKING_ID) REFERENCES BOOKING(BOOKING_ID),
 FOREIGN KEY(FACILITY_ID) REFERENCES FACILITY(FACILITY_ID)
 
	
);


CREATE TABLE CHECK_IN_CONFIRMATION
(
	CHECK_IN_TIME DATE,
	CHECK_IN_GUEST_ID ,
	CHECK_IN_EMPLOYEE_ID INTEGER,
	CHECK_IN_ROOM_NO INTEGER,
PRIMARY KEY(CHECK_IN_GUEST_ID,CHECK_IN_EMPLOYEE_ID,CHECK_IN_ROOM_NO),
FOREIGN KEY(CHECK_IN_GUEST_ID) REFERENCES GUEST(GUEST_ID),
FOREIGN KEY(CHECK_IN_EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
FOREIGN KEY(CHECK_IN_ROOM_NO) REFERENCES ROOM(ROOM_NO)

);


CREATE TABLE DISCOUNT
(
	DISCOUNT_RATE FLOAT,
	DISCOUNT_MEMBER_TYPE VARCHAR2(20),
	DISCOUNT_FACILITY_ID INTEGER,
PRIMARY KEY(DISCOUNT_MEMBER_TYPE),
FOREIGN KEY(DISCOUNT_FACILITY_ID) REFERENCES FACILITY(FACILITY_ID)
);

CREATE TABLE CLUB_MEMBER
(
	MEMBER_TYPE VARCHAR2(20),
	MEMBER_ID INTEGER,
	MEMBER_GUEST_ID INTEGER,

	PRIMARY KEY(MEMBER_GUEST_ID),
FOREIGN KEY(MEMBER_GUEST_ID) REFERENCES GUEST(GUEST_ID)
);

CREATE SEQUENCE GUEST_ID_SEQ
INCREMENT BY 1
START WITH 10001
MAXVALUE 99999999999
NOCYCLE ;

CREATE SEQUENCE BOOKING_ID_SEQ
INCREMENT BY 1
START WITH 1000101
MAXVALUE 99999999999
NOCYCLE ;


CREATE SEQUENCE EMPLOYEE_ID_SEQ
INCREMENT BY 1
START WITH 110101
MAXVALUE 99999999999
NOCYCLE ;

CREATE SEQUENCE BILL_ID_SEQ
INCREMENT BY 1
START WITH 9999
MAXVALUE 99999999999
NOCYCLE ;

CREATE SEQUENCE FACILITY_ID_SEQ
INCREMENT BY 1
START WITH 199991
MAXVALUE 99999999999
NOCYCLE ;
CREATE SEQUENCE ROOM_BOOKING_ID_SEQ
INCREMENT BY 1
START WITH 1099
MAXVALUE 99999999999
NOCYCLE ;


CREATE OR REPLACE 
FUNCTION INSERT_BOOKING(DF IN VARCHAR2,DT in VARCHAR2,GID NUMBER ) 
RETURN NUMBER
IS
BID NUMBER;
BEGIN
	-- routine body goes here, e.g.
	-- DBMS_OUTPUT.PUT_LINE('Navicat for Oracle');
	BID:=BOOKING_ID_SEQ.NEXTVAL;
	INSERT INTO BOOKING (DATE_FROM,DATE_TO,BOOKING_ID,BOOKED_BY_GUEST) VALUES(TO_DATE(DF,'YYYY-MM-DD'),TO_DATE(DT,'YYYY-MM-DD'),BID,GID);
	
	RETURN BID;
END;


CREATE OR REPLACE 
FUNCTION INSERT_GUEST(FNAME IN VARCHAR2,LNAME IN VARCHAR2,G_ADDRESS IN VARCHAR2,CON IN VARCHAR2,TP IN NUMBER,PASSPORT IN VARCHAR2,NID_NO IN VARCHAR2)
 RETURN NUMBER
IS
GID NUMBER;
BEGIN
-- routine body goes here, e.g.
-- DBMS_OUTPUT.PUT_LINE('Navicat for Oracle');
GID:=GUEST_ID_SEQ.NEXTVAL;
INSERT INTO GUEST (GUEST_ID,FIRST_NAME,LAST_NAME,ADDRESS,CONTACT_NO,TOTAL_PERSON,PASSPORT_NO,NID)VALUES(GID,FNAME,LNAME,G_ADDRESS,CON,TP,PASSPORT,NID_NO);
RETURN GID;
END;


CREATE OR REPLACE 
FUNCTION INSERT_BOOKING_FACILITY(DF IN VARCHAR2,GID NUMBER ) 
RETURN NUMBER
IS
BID NUMBER;
BEGIN
	-- routine body goes here, e.g.
	-- DBMS_OUTPUT.PUT_LINE('Navicat for Oracle');
	BID:=BOOKING_ID_SEQ.NEXTVAL;
	INSERT INTO BOOKING (DATE_FROM,BOOKING_ID,BOOKED_BY_GUEST) VALUES(TO_DATE(DF,'YYYY-MM-DD'),BID,GID);
	
	RETURN BID;
END;



DROP TABLE CLUB_MEMBER;
DROP TABLE DISCOUNT;
DROP TABLE CHECK_IN_CONFIRMATION;
DROP TABLE ROOM_BOOKING;
DROP TABLE FACILITY_BOOKING;
DROP TABLE ROOM ;
DROP TABLE BILL;
DROP TABLE BILL_AUTHORIZATION;
DROP TABLE FACILITY;
DROP TABLE EMPLOYEE;
DROP TABLE BOOKING;
DROP TABLE GUEST;


INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(101,1,'VACCANT',1200,'YES','YES','No Speciality',2);

INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(102,1,'VACCANT',1100,'YES','NO','No Speciality',2);

INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(201,2,'VACCANT',1100,'NO','YES','No Speciality',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(404,4,'VACCANT',1150,'YES','YES','No Speciality',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(203,2,'VACCANT',1000,'NO','NO','No Speciality',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(303,3,'VACCANT',1100,'NO','NO','No Speciality',3);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(304,3,'VACCANT',2000,'YES','YES','Sea facing',3);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(305,3,'VACCANT',1800,'YES','YES','Sea facing',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(405,4,'VACCANT',1800,'YES','NO','Sea facing',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(406,4,'VACCANT',1700,'NO','YES','Sea facing',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(204,4,'VACCANT',1600,'YES','YES','Garden facing',2);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(205,4,'VACCANT',1600,'YES','NO','Garden facing',3);
INSERT INTO ROOM (ROOM_NO,
	FLOOR_NO,
	STATUS,
	ROOM_COST, 
	WI_FI, 
	AIR_CONDITIONER, 
	SPECALITY,
	CAPACITY
) VALUES(207,4,'VACCANT',1600,'NO','YES','Garden facing',2);
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10023,20000,'Conference room');
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10025,20000,'Conference room');
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10027,20000,'Conference room');
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10030,12000,'Restaurant');
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10035,12000,'Restaurant');
INSERT INTO FACILITY (FACILITY_ID,PRICE,FACILITY_TYPE) VALUES(10040,12000,'Restaurant');



