CREATE TABLE "ACCOUNT" (
    ACCOUNT_EMAIL VARCHAR2(40),
    ACCOUNT_FIRST_NAME VARCHAR2(40) NOT NULL,
    ACCOUNT_LAST_NAME VARCHAR2(15) NOT NULL,
    ACCOUNT_PASSWORD CHAR(40) NOT NULL,
    CONSTRAINT PK_ACCOUNT PRIMARY KEY (ACCOUNT_EMAIL),
    CONSTRAINT MAILCHCK CHECK (REGEXP_LIKE (ACCOUNT_EMAIL, '^(\S+)@(\S+).(\S+)$'))
);

CREATE TABLE PERSONAL_INFO (
    ACCOUNT_EMAIL VARCHAR2(40),
    PERSONAL_INFO_OCCUPATION VARCHAR2(25),
    PERSONAL_INFO_WEBSITE VARCHAR2(40),
    PERSONAL_INFO_REFERRED_BY VARCHAR2(40),
    PERSONAL_INFO_ARTWORK_YOU_LOVE VARCHAR2(200),
    CONSTRAINT PK_PERSONAL_INFO PRIMARY KEY (ACCOUNT_EMAIL),
    CONSTRAINT FK_PERSONAL_INFO_ACCOUNT FOREIGN KEY (ACCOUNT_EMAIL)
        REFERENCES "ACCOUNT" (ACCOUNT_EMAIL)
);

CREATE TABLE CREDIT_CARD (
    CREDIT_CARD_NUMBER VARCHAR2(19),
    CREDIT_CARD_CVC VARCHAR2(4) NOT NULL,
    CREDIT_CARD_EXPIRE_DATE DATE NOT NULL,
    CONSTRAINT PK_CREDIT_CARD PRIMARY KEY (CREDIT_CARD_NUMBER),
    CONSTRAINT EXPIRECHCK CHECK (CREDIT_CARD_EXPIRE_DATE > TRUNC(SYSDATE))
);

CREATE TABLE CREDIT_CARD_ACCOUNT (
    CREDIT_CARD_NUMBER VARCHAR2(19),
    ACCOUNT_EMAIL VARCHAR2(40),
    CONSTRAINT PK_CREDIT_CARD_ACCOUNT PRIMARY KEY (CREDIT_CARD_NUMBER , ACCOUNT_EMAIL),
    CONSTRAINT FK_CREDIT_CARD_ACCOUNT_CREDIT_CARD FOREIGN KEY (CREDIT_CARD_NUMBER)
        REFERENCES CREDIT_CARD (CREDIT_CARD_NUMBER),
    CONSTRAINT FK_CREDIT_CARD_ACCOUNT_ACCOUNT FOREIGN KEY (ACCOUNT_EMAIL)
        REFERENCES "ACCOUNT" (ACCOUNT_EMAIL)
);

CREATE TABLE REGION (
    REGION_POSTAL_CODE VARCHAR2(10),
    REGION_COUNTRY VARCHAR2(50),
    REGION_CITY VARCHAR2(50) NOT NULL,
    REGION_STATE VARCHAR2(20),
    CONSTRAINT PK_REGION PRIMARY KEY (REGION_POSTAL_CODE , REGION_COUNTRY)
);

CREATE TABLE ADDRESS (
    ADDRESS_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ADDRESS_ADDRESS1 VARCHAR2(30) NOT NULL,
    ADDRESS_ADDRESS2 VARCHAR2(30),
    REGION_POSTAL_CODE VARCHAR2(10) NOT NULL,
    REGION_COUNTRY VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_ADDRESS PRIMARY KEY (ADDRESS_ID),
    CONSTRAINT FK_ADDRESS_REGION FOREIGN KEY (REGION_POSTAL_CODE , REGION_COUNTRY)
        REFERENCES REGION (REGION_POSTAL_CODE , REGION_COUNTRY)
);

CREATE TABLE ADDRESS_INFO (
    ADDRESS_INFO_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ADDRESS_INFO_FIRST_NAME VARCHAR2(40) NOT NULL,
    ADDRESS_INFO_LAST_NAME VARCHAR2(15) NOT NULL,
    ADDRESS_INFO_PHONE VARCHAR2(20),
    ADDRESS_ID NUMBER,
    ACCOUNT_EMAIL VARCHAR2(40),
    CONSTRAINT PK_ADDRESS_INFO PRIMARY KEY (ADDRESS_INFO_ID),
    CONSTRAINT FK_ADDRESS_INFO_ADDRESS FOREIGN KEY (ADDRESS_ID)
        REFERENCES ADDRESS (ADDRESS_ID),
    CONSTRAINT FK_ADDRESS_INFO_ACCOUNT FOREIGN KEY (ACCOUNT_EMAIL)
        REFERENCES "ACCOUNT" (ACCOUNT_EMAIL)
);

CREATE TABLE ARTIST (
    ARTIST_DISPLAY_NAME VARCHAR2(20),
    ARTIST_NAME VARCHAR2(40),
    ARTIST_SURNAME VARCHAR2(15),
    ARTIST_BIO_SKETCH VARCHAR2(200),
    ARTIST_BITH_YEAR DATE,
    ARTIST_TAX_ID VARCHAR2(9),
    ARTIST_PHOTO VARCHAR2(50),
    ADDRESS_INFO_ID NUMBER NOT NULL,
    CONSTRAINT PK_ARIST PRIMARY KEY (ARTIST_DISPLAY_NAME),
    CONSTRAINT FK_ARTIST_ADDRESS_INFO FOREIGN KEY (ADDRESS_INFO_ID)
        REFERENCES ADDRESS_INFO (ADDRESS_INFO_ID)
);

CREATE TABLE "MEDIUM" (
    MEDIUM_NAME VARCHAR2(12),
    CONSTRAINT PK_MEDIUM PRIMARY KEY (MEDIUM_NAME)
);

CREATE TABLE SIZE_CATEGORY (
    SIZE_CATEGORY_NAME VARCHAR2(10),
    SIZE_CATEGORY_MAX_SIZE NUMBER(3),
    SIZE_CATEGORY_MIN_SIZE NUMBER(3) NOT NULL,
    CONSTRAINT PK_SIZE_CATEGORY PRIMARY KEY (SIZE_CATEGORY_NAME)
);

CREATE TABLE ARTWORK (
    ARTWORK_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ARTWORK_TITLE VARCHAR2(20) NOT NULL,
    ARTWORK_PRICE NUMBER(6),
    ARTWORK_CREATION_YEAR DATE,
    ARTWORK_MATERIAL_DESCRIPTION VARCHAR2(50),
    ARTWORK_FRAME_DESCRIPTION VARCHAR2(50),
    ARTWORK_DATE_ACQUIRED DATE NOT NULL,
    ARTWORK_STATUS VARCHAR2(20) NOT NULL,
    ARTWORK_PHOTO VARCHAR2(50),
    ARTWORK_COPIES NUMBER(4) NOT NULL,
    MEDIUM_NAME VARCHAR2(12) NOT NULL,
    SIZE_CATEGORY_NAME VARCHAR2(10) NOT NULL,
    SIZE_DEPTH NUMBER(7,4),
    SIZE_WIDTH NUMBER(7,4),
    SIZE_HEIGHT NUMBER(7,4),
    CONSTRAINT PK_ARTWORK PRIMARY KEY (ARTWORK_ID),
    CONSTRAINT FK_ARTWORK_MEDIUM FOREIGN KEY (MEDIUM_NAME)
        REFERENCES "MEDIUM" (MEDIUM_NAME),
    CONSTRAINT FK_ARTWORK_SIZE_CATEGORY FOREIGN KEY (SIZE_CATEGORY_NAME)
        REFERENCES SIZE_CATEGORY (SIZE_CATEGORY_NAME)
);

CREATE TABLE "EVENT" (
	EVENT_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    EVENT_NAME VARCHAR2(20) NOT NULL,
    EVENT_TYPE VARCHAR2(20) NOT NULL,
    EVENT_START_DATE DATE,
    EVENT_END_DATE DATE,
    EVENT_DESCRIPTION VARCHAR2(200) NOT NULL,
    CONSTRAINT PK_EVENT PRIMARY KEY (EVENT_ID) 
);

CREATE TABLE EVENT_LOCATION (
	EVENT_ID NUMBER,
	EVENT_LOCATION_NAME VARCHAR2(20) NOT NULL,
    EVENT_LOCATION_GEO_PLACE VARCHAR2(40) NOT NULL,
    CONSTRAINT PK_EVENT_LOCATION PRIMARY KEY (EVENT_ID),
    CONSTRAINT FK_EVENT_LOCATION_EVENT FOREIGN KEY (EVENT_ID)
		REFERENCES "EVENT" (EVENT_ID)
);

CREATE TABLE EVENT_ARTWORK (
	ARTWORK_ID NUMBER,
    EVENT_ID NUMBER,
    CONSTRAINT PK_EVENT_ARTWORK PRIMARY KEY (ARTWORK_ID, EVENT_ID),
    CONSTRAINT FK_EVENT_ARTWORK_ARTWORK FOREIGN KEY (ARTWORK_ID)
		REFERENCES ARTWORK (ARTWORK_ID),
	CONSTRAINT FK_EVENT_ARTWORK_EVENT FOREIGN KEY (EVENT_ID)
		REFERENCES "EVENT" (EVENT_ID)
);

CREATE TABLE COLLECTION (
    COLLECTION_NAME VARCHAR2(20),
    COLLECTION_DESCRIPTION VARCHAR2(100) NOT NULL,
    COLLECTION_CRITERIA VARCHAR2(50),
    CONSTRAINT PK_COLLECTION PRIMARY KEY (COLLECTION_NAME)
);

CREATE TABLE COLLECTION_ARTWORK (
	COLLECTION_NAME VARCHAR2(20),
    ARTWORK_ID NUMBER,
    CONSTRAINT PK_COLLECTION_ARTWORK PRIMARY KEY (COLLECTION_NAME, ARTWORK_ID),
    CONSTRAINT FK_COLLECTION_ARTWORK_COLLECTION FOREIGN KEY (COLLECTION_NAME)
		REFERENCES COLLECTION (COLLECTION_NAME),
	CONSTRAINT FK_COLLECTION_ARTWORK_ARTWORK FOREIGN KEY (ARTWORK_ID)
		REFERENCES ARTWORK (ARTWORK_ID)
);

CREATE TABLE INTERESTED_LIST (
	ARTWORK_ID NUMBER NOT NULL,
    INTERESTED_LIST_EMAIL VARCHAR2(40),
    INTERESTED_LIST_NAME VARCHAR2(60) NOT NULL,
    ACCOUNT_EMAIL VARCHAR2(40) NOT NULL,
    CONSTRAINT PK_INTERESTED_LIST PRIMARY KEY (INTERESTED_LIST_EMAIL, ARTWORK_ID),
    CONSTRAINT FK_INTERESTED_LIST_ARTWORK FOREIGN KEY (ARTWORK_ID)
		REFERENCES ARTWORK (ARTWORK_ID),
	CONSTRAINT FK_INTERESTED_LIST_ACCOUNT FOREIGN KEY (ACCOUNT_EMAIL)
		REFERENCES "ACCOUNT" (ACCOUNT_EMAIL),
    CONSTRAINT MAILCHCK CHECK (REGEXP_LIKE (INTERESTED_LIST_EMAIL, '^(\S+)@(\S+).(\S+)$'))
);

CREATE TABLE "ORDER" (
	ORDER_NUMBER NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ORDER_PAYMENT_RECIEVED NUMBER(1) NOT NULL,
    ORDER_SPECIAL_INSTRUCTIONS VARCHAR2(100),
    ORDER_PICKUP NUMBER(1) NOT NULL,
    ORDER_QUICK_DELIVERY NUMBER(1) NOT NULL,
    ORDER_BILLING_TYPE VARCHAR2(10),
    ADDRESS_INFO_ID_BILLING NUMBER NOT NULL,
    ADDRESS_INFO_ID_DELIVERY NUMBER,
    ACCOUNT_EMAIL VARCHAR2(40) NOT NULL,
    CONSTRAINT PK_ORDER PRIMARY KEY (ORDER_NUMBER),
    CONSTRAINT FK_ORDER_BILLING_ADDRESS FOREIGN KEY (ADDRESS_INFO_ID_BILLING)
		REFERENCES ADDRESS_INFO (ADDRESS_INFO_ID),
	CONSTRAINT FK_ORDER_DELIVERY_ADDRESS FOREIGN KEY (ADDRESS_INFO_ID_DELIVERY)
		REFERENCES ADDRESS_INFO (ADDRESS_INFO_ID),
	CONSTRAINT FK_ORDER_ACCOUNT FOREIGN KEY (ACCOUNT_EMAIL)
		REFERENCES "ACCOUNT" (ACCOUNT_EMAIL)
);