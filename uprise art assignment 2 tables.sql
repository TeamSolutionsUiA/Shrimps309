--/*

DROP TABLE UA_ORDER_DETAIL CASCADE CONSTRAINTS;
DROP TABLE UA_ORDER_TRANSACTION CASCADE CONSTRAINTS;
DROP TABLE UA_INTEREST CASCADE CONSTRAINTS;
DROP TABLE UA_ART_EVENT CASCADE CONSTRAINTS;
DROP TABLE UA_EVENT CASCADE CONSTRAINTS;
DROP TABLE UA_CREDIT_CARD CASCADE CONSTRAINTS;
DROP TABLE UA_ART_COLLECTION CASCADE CONSTRAINTS;
DROP TABLE UA_COLLECTION CASCADE CONSTRAINTS;
DROP TABLE UA_ARTWORK CASCADE CONSTRAINTS;
DROP TABLE UA_ARTIST CASCADE CONSTRAINTS;
DROP TABLE UA_ADDRESS CASCADE CONSTRAINTS;
DROP TABLE UA_ACCOUNT CASCADE CONSTRAINTS;
DROP TABLE UA_MEDIUM CASCADE CONSTRAINTS;

--*/

--------------------------------------------------------
--  DDL for Table UA_MEDIUM
--------------------------------------------------------

  CREATE TABLE "UA_MEDIUM" 
   (	"MEDIUM_NAME" VARCHAR2(50)
   ) ;
REM INSERTING into UA_MEDIUM
SET DEFINE OFF;
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Drawing');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Installation');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Mixed Media');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Painting');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Photography');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Print');
Insert into UA_MEDIUM (MEDIUM_NAME) values ('Sculpture');
--------------------------------------------------------
--  DDL for Index UA_MEDIUM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_MEDIUM_PK" ON "UA_MEDIUM" ("MEDIUM_NAME") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_MEDIUM
--------------------------------------------------------

  ALTER TABLE "UA_MEDIUM" MODIFY ("MEDIUM_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_MEDIUM" ADD CONSTRAINT "UA_MEDIUM_PK" PRIMARY KEY ("MEDIUM_NAME")
  USING INDEX  ENABLE;


--------------------------------------------------------
--  DDL for Table UA_ACCOUNT
--------------------------------------------------------

CREATE TABLE "UA_ACCOUNT" ("ACCOUNT_ID" NUMBER(*,0), "ACCOUNT_FIRST_NAME" VARCHAR2(50), "ACCOUNT_LAST_NAME" VARCHAR2(50), "ACCOUNT_EMAIL" VARCHAR2(50), "ACCOUNT_PASSWORD" VARCHAR2(50), "ACCOUNT_OCCUPATION" VARCHAR2(50), "ACCOUNT_WEBSITE" VARCHAR2(100), "ACCOUNT_REFERRED_BY" VARCHAR2(80), "ACCOUNT_ARTWORK_LOVED" VARCHAR2(255)) ;
REM INSERTING into UA_ACCOUNT
SET DEFINE OFF;
Insert into UA_ACCOUNT (ACCOUNT_ID,ACCOUNT_FIRST_NAME,ACCOUNT_LAST_NAME,ACCOUNT_EMAIL,ACCOUNT_PASSWORD,ACCOUNT_OCCUPATION,ACCOUNT_WEBSITE,ACCOUNT_REFERRED_BY,ACCOUNT_ARTWORK_LOVED) values (1,'Henrik','Michelsen','hmich@gmail.com','Thsi*aj5','lawyer',null,null,'anything with bright colors');
Insert into UA_ACCOUNT (ACCOUNT_ID,ACCOUNT_FIRST_NAME,ACCOUNT_LAST_NAME,ACCOUNT_EMAIL,ACCOUNT_PASSWORD,ACCOUNT_OCCUPATION,ACCOUNT_WEBSITE,ACCOUNT_REFERRED_BY,ACCOUNT_ARTWORK_LOVED) values (2,'Kristin','Løvland','kristin.l@yahoo.com','Kje34!#g','chief executive officer',null,'Henrik Michelsen','ceramics');
Insert into UA_ACCOUNT (ACCOUNT_ID,ACCOUNT_FIRST_NAME,ACCOUNT_LAST_NAME,ACCOUNT_EMAIL,ACCOUNT_PASSWORD,ACCOUNT_OCCUPATION,ACCOUNT_WEBSITE,ACCOUNT_REFERRED_BY,ACCOUNT_ARTWORK_LOVED) values (3,'Michelle','Knudsen','mfk@knudsenholdings.com','7^^#3wty!','business owner','http://knudsenholdings.com','Henrik Michelsen',null);
--------------------------------------------------------
--  DDL for Index UA_ACCOUNT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ACCOUNT_PK" ON "UA_ACCOUNT" ("ACCOUNT_ID") ;
--------------------------------------------------------
--  DDL for Index UA_ACCOUNT_ACCOUNT_EMAIL_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ACCOUNT_ACCOUNT_EMAIL_UN" ON "UA_ACCOUNT" ("ACCOUNT_EMAIL") ;
--------------------------------------------------------
--  Constraints for Table UA_ACCOUNT
--------------------------------------------------------

  ALTER TABLE "UA_ACCOUNT" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ACCOUNT" MODIFY ("ACCOUNT_FIRST_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_ACCOUNT" MODIFY ("ACCOUNT_LAST_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_ACCOUNT" MODIFY ("ACCOUNT_EMAIL" NOT NULL ENABLE);
  ALTER TABLE "UA_ACCOUNT" MODIFY ("ACCOUNT_PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "UA_ACCOUNT" ADD CONSTRAINT "UA_ACCOUNT_ACCOUNT_EMAIL_UN" UNIQUE ("ACCOUNT_EMAIL") USING INDEX  ENABLE;
  ALTER TABLE "UA_ACCOUNT" ADD CONSTRAINT "UA_ACCOUNT_PK" PRIMARY KEY ("ACCOUNT_ID") USING INDEX  ENABLE;


--------------------------------------------------------
--  DDL for Table UA_ADDRESS
--------------------------------------------------------

  CREATE TABLE "UA_ADDRESS" 
   (	"ADDRESS_ID" NUMBER(*,0), 
	"ADDRESS_FIRST_NAME" VARCHAR2(50), 
	"ADDRESS_LAST_NAME" VARCHAR2(50), 
	"ADDRESS_LINE_1" VARCHAR2(80), 
	"ADDRESS_LINE_2" VARCHAR2(80), 
	"ADDRESS_CITY" VARCHAR2(50), 
	"ADDRESS_STATE_PROVINCE" VARCHAR2(50), 
	"ADDRESS_POSTAL_CODE" VARCHAR2(25), 
	"ADDRESS_COUNTRY" VARCHAR2(50), 
	"ADDRESS_PHONE" VARCHAR2(15), 
	"ACCOUNT_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_ADDRESS
SET DEFINE OFF;
Insert into UA_ADDRESS (ADDRESS_ID,ADDRESS_FIRST_NAME,ADDRESS_LAST_NAME,ADDRESS_LINE_1,ADDRESS_LINE_2,ADDRESS_CITY,ADDRESS_STATE_PROVINCE,ADDRESS_POSTAL_CODE,ADDRESS_COUNTRY,ADDRESS_PHONE,ACCOUNT_ID) values (20,'Henrik','Michelsen','274 W. 21st Street',null,'Houston','TX','77008','United States','713.869.2993',1);
Insert into UA_ADDRESS (ADDRESS_ID,ADDRESS_FIRST_NAME,ADDRESS_LAST_NAME,ADDRESS_LINE_1,ADDRESS_LINE_2,ADDRESS_CITY,ADDRESS_STATE_PROVINCE,ADDRESS_POSTAL_CODE,ADDRESS_COUNTRY,ADDRESS_PHONE,ACCOUNT_ID) values (21,'Hannah','Konow','457 Pine Street',null,'Seattle','WA','98101','United States','206.988.2283',1);
--------------------------------------------------------
--  DDL for Index UA_ADDRESS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ADDRESS_PK" ON "UA_ADDRESS" ("ADDRESS_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ADDRESS
--------------------------------------------------------

  ALTER TABLE "UA_ADDRESS" MODIFY ("ADDRESS_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ADDRESS" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ADDRESS" ADD CONSTRAINT "UA_ADDRESS_PK" PRIMARY KEY ("ADDRESS_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ADDRESS
--------------------------------------------------------

  ALTER TABLE "UA_ADDRESS" ADD CONSTRAINT "UA_ADDRESS_ACCOUNT_FK" FOREIGN KEY ("ACCOUNT_ID")
	  REFERENCES "UA_ACCOUNT" ("ACCOUNT_ID") ENABLE;
      
      
--------------------------------------------------------
--  DDL for Table UA_ARTIST
--------------------------------------------------------

  CREATE TABLE "UA_ARTIST" 
   (	"ARTIST_ID" NUMBER(*,0), 
	"ARTIST_TAX_ID" VARCHAR2(25), 
	"ARTIST_GIVEN_NAME" VARCHAR2(50), 
	"ARTIST_SURNAME" VARCHAR2(50), 
	"ARTIST_DISPLAY_NAME" VARCHAR2(50), 
	"ARTIST_BIRTH_YEAR" NUMBER(*,0), 
	"ARTIST_PHOTO_URL" VARCHAR2(100), 
	"ARTIST_BIOSKETCH" CLOB, 
	"ARTIST_STREET_1" VARCHAR2(80), 
	"ARTIST_STREET_2" VARCHAR2(80), 
	"ARTIST_CITY" VARCHAR2(50), 
	"ARTIST_STATE_PROVINCE" VARCHAR2(25), 
	"ARTIST_POSTAL_CODE" VARCHAR2(25), 
	"ARTIST_COUNTRY" VARCHAR2(25)
   ) ;
REM INSERTING into UA_ARTIST
SET DEFINE OFF;
Insert into UA_ARTIST (ARTIST_ID,ARTIST_TAX_ID,ARTIST_GIVEN_NAME,ARTIST_SURNAME,ARTIST_DISPLAY_NAME,ARTIST_BIRTH_YEAR,ARTIST_PHOTO_URL,ARTIST_BIOSKETCH,ARTIST_STREET_1,ARTIST_STREET_2,ARTIST_CITY,ARTIST_STATE_PROVINCE,ARTIST_POSTAL_CODE,ARTIST_COUNTRY) 
   values (51,'772883716','Dana','Bechert','Dana Bechert',1990,'https://uprise-art.s3.amazonaws.com/artist_headshots/9cf5c9fd-d093-4331-ae5c-bf56aa67162a.jpg',
   'Dana Bechert (b. 1990) is a Pennsylvania-based ceramicist. Dana''s works have been featured in T magazine, Nylon, Architectural Digest, and Refinery 29. She holds a degree from the Maryland Institute College of Arts.',
   '88 E. Camino Real',null,'Tucson','AZ','85720','United States');
Insert into UA_ARTIST (ARTIST_ID,ARTIST_TAX_ID,ARTIST_GIVEN_NAME,ARTIST_SURNAME,ARTIST_DISPLAY_NAME,ARTIST_BIRTH_YEAR,ARTIST_PHOTO_URL,ARTIST_BIOSKETCH,ARTIST_STREET_1,ARTIST_STREET_2,ARTIST_CITY,ARTIST_STATE_PROVINCE,ARTIST_POSTAL_CODE,ARTIST_COUNTRY) 
   values (52,'777288199','Eddie','Kalowski','Eddie K',1983,'https://uprise-art.s3.amazonaws.com/artist_headshots/a09e6a40-ff3f-4944-8e95-cc94238e46f7.jpg',
   'Eddie K (b. 1983) is an East London-based painter whose works picture fictive, often futuristic spaces. His most recent series, "BeachLand" depicts a resort built in the year 2061. Eddie K studied at Leeds College of Art and Design and Heatherley''s School of Fine Art.',
   '221 Church Road','Leyton','London',null,'E10 7BQ','United Kingdom');
Insert into UA_ARTIST (ARTIST_ID,ARTIST_TAX_ID,ARTIST_GIVEN_NAME,ARTIST_SURNAME,ARTIST_DISPLAY_NAME,ARTIST_BIRTH_YEAR,ARTIST_PHOTO_URL,ARTIST_BIOSKETCH,ARTIST_STREET_1,ARTIST_STREET_2,ARTIST_CITY,ARTIST_STATE_PROVINCE,ARTIST_POSTAL_CODE,ARTIST_COUNTRY) 
   values (50,'595662889','Misato','Suzuki','Misato Suzuki',1975,'https://uprise-art.s3.amazonaws.com/artist_headshots/misato-suzuki.jpg',
   'Misato Suzuki (b. 1975) currently lives and works in Los Angeles, CA. Her delicate, abstract style integrates organic form and recognizable forms. She combines the use of unique mediums such as coffee and walnut ink onto her canvas, creating a unique conversation between colors and depths. Misato has exhibited nationally and internationally, throughout the United States, Europe, Australia, Canada and Japan. Most recently, her work has been exhibited in the US Consulate Dubai, United Arab Emirates. In 2013, Misato exhibited at The First 20 Years, Known Gallery, Los Angeles, CA. Misato received her BA form Central Washington University, Ellensburg, WA and her MFA from Claremont Graduate University, Claremont, CA.',
   '4478 E. Main Street',null,'Los Angeles','CA','90005','United States');
--------------------------------------------------------
--  DDL for Index UA_ARTIST_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ARTIST_PK" ON "UA_ARTIST" ("ARTIST_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ARTIST
--------------------------------------------------------

  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_TAX_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_DISPLAY_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_STREET_1" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_CITY" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_POSTAL_CODE" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" MODIFY ("ARTIST_COUNTRY" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTIST" ADD CHECK ( artist_birth_year BETWEEN 1900 AND 2050 ) ENABLE;
  ALTER TABLE "UA_ARTIST" ADD CONSTRAINT "UA_ARTIST_PK" PRIMARY KEY ("ARTIST_ID")
  USING INDEX  ENABLE;

--------------------------------------------------------
--  DDL for Table UA_ARTWORK
--------------------------------------------------------

  CREATE TABLE "UA_ARTWORK" 
   (	"ARTWORK_ID" NUMBER(*,0), 
	"ARTWORK_TITLE" VARCHAR2(255), 
	"ARTWORK_PRICE" NUMBER, 
	"ARTWORK_SIZE_HEIGHT" NUMBER(*,0), 
	"ARTWORK_SIZE_WIDTH" NUMBER(*,0), 
	"ARTWORK_SIZE_DEPTH" NUMBER(*,0), 
	"ARTWORK_SIZE_CATEGORY" VARCHAR2(15), 
	"ARTWORK_CREATION_YEAR" NUMBER(*,0), 
	"ARTWORK_ACQUISITION_DATE" DATE, 
	"ARTWORK_MATERIALS" VARCHAR2(50), 
	"ARTWORK_FRAMED" VARCHAR2(50), 
	"MEDIUM_NAME" VARCHAR2(50), 
	"ARTWORK_PHOTO_URL" VARCHAR2(100), 
	"ARTWORK_QUANTITY_ON_HAND" NUMBER(*,0), 
	"ARTWORK_STATUS" VARCHAR2(25), 
	"ARTIST_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_ARTWORK
SET DEFINE OFF;
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (31,'Ripple',5500,36,48,null,'Oversized',2018,to_date('02-NOV-19','DD-MON-RR'),'Acrylic on canvas',null,'Painting','https://uprise-art.s3.amazonaws.com/artwork_detail_images/96aed4fb-906c-4eb9-a403-51dbac07b98e.jpg',1,'For sale',50);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (32,'Big Fineline Vase',1200,12,7,7,'Small',2018,to_date('15-JUL-19','DD-MON-RR'),'Carved English porcelain with glazed interior',null,'Sculpture','https://uprise-art.s3.amazonaws.com/artwork_detail_images/d217542d-1719-4f4b-aa89-6568c66f593e.jpg',1,'For sale',51);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (33,'Whirl Vase',1400,12,5,5,'Small',2019,to_date('15-JUL-19','DD-MON-RR'),'Carved English porcelain with glaze',null,'Sculpture','https://uprise-art.s3.amazonaws.com/artwork_detail_images/b8dd927a-15f2-41db-a335-04c45ab0f7be.jpg',1,'For sale',51);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (34,'Pools A 27-30',null,48,61,2,'Oversized',2019,to_date('01-OCT-19','DD-MON-RR'),'Oil on canvas',null,'Painting','https://uprise-art.s3.amazonaws.com/artwork_detail_images/16873466-258f-4ea9-b50b-46e78d5489c8.jpg',0,'Sold out',52);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (35,'Pools R 38-39',2300,44,72,2,'Oversized',2019,to_date('01-OCT-19','DD-MON-RR'),'Charcoal and acrylic on paper','In white','Drawing','https://uprise-art.s3.amazonaws.com/artwork_detail_images/96f9358d-4adc-4ac3-ab33-c4c7999f0019.jpg',0,'Sold out',52);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (36,'Pool E 10',3425,40,40,2,'Large',2019,to_date('01-OCT-19','DD-MON-RR'),'Oil on canvas',null,'Painting','https://uprise-art.s3.amazonaws.com/artwork_detail_images/059d32fd-5324-4741-a6cb-3b0f953cef86.jpg',1,'For sale',52);
Insert into UA_ARTWORK (ARTWORK_ID,ARTWORK_TITLE,ARTWORK_PRICE,ARTWORK_SIZE_HEIGHT,ARTWORK_SIZE_WIDTH,ARTWORK_SIZE_DEPTH,ARTWORK_SIZE_CATEGORY,ARTWORK_CREATION_YEAR,ARTWORK_ACQUISITION_DATE,ARTWORK_MATERIALS,ARTWORK_FRAMED,MEDIUM_NAME,ARTWORK_PHOTO_URL,ARTWORK_QUANTITY_ON_HAND,ARTWORK_STATUS,ARTIST_ID) values (30,'Milky Way',null,48,36,3,'Oversized',2018,to_date('02-NOV-19','DD-MON-RR'),'Acrylic on canvas',null,'Painting','https://uprise-art.s3.amazonaws.com/artwork_detail_images/4771563f-a934-4d24-972e-c0d99f76a1e4.jpg',1,'For sale',50);
--------------------------------------------------------
--  DDL for Index UA_ARTWORK_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ARTWORK_PK" ON "UA_ARTWORK" ("ARTWORK_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ARTWORK
--------------------------------------------------------

  ALTER TABLE "UA_ARTWORK" MODIFY ("ARTWORK_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" MODIFY ("ARTWORK_TITLE" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" MODIFY ("ARTWORK_ACQUISITION_DATE" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" MODIFY ("MEDIUM_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" MODIFY ("ARTWORK_STATUS" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" MODIFY ("ARTIST_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ARTWORK" ADD CHECK ( artwork_size_category IN (
        'Large',
        'Medium',
        'Oversized',
        'Small'
    ) ) ENABLE;
  ALTER TABLE "UA_ARTWORK" ADD CHECK ( artwork_creation_year BETWEEN 2000 AND 2050 ) ENABLE;
  ALTER TABLE "UA_ARTWORK" ADD CHECK ( artwork_status IN (
        'For sale',
        'Sold out',
        'Unavailable'
    ) ) ENABLE;
  ALTER TABLE "UA_ARTWORK" ADD CONSTRAINT "UA_ARTWORK_PK" PRIMARY KEY ("ARTWORK_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ARTWORK
--------------------------------------------------------

  ALTER TABLE "UA_ARTWORK" ADD CONSTRAINT "UA_ARTWORK_ARTIST_FK" FOREIGN KEY ("ARTIST_ID")
	  REFERENCES "UA_ARTIST" ("ARTIST_ID") ENABLE;
  ALTER TABLE "UA_ARTWORK" ADD CONSTRAINT "UA_ARTWORK_MEDIUM_FK" FOREIGN KEY ("MEDIUM_NAME")
	  REFERENCES "UA_MEDIUM" ("MEDIUM_NAME") ENABLE;

--------------------------------------------------------
--  DDL for Table UA_COLLECTION
--------------------------------------------------------

  CREATE TABLE "UA_COLLECTION" 
   (	"COLLECTION_ID" NUMBER(*,0), 
	"COLLECTION_NAME" VARCHAR2(255), 
	"COLLECTION_DESCRIPTION" CLOB, 
	"COLLECTION_CREATE_DATE" DATE
   ) ;
REM INSERTING into UA_COLLECTION
SET DEFINE OFF;
Insert into UA_COLLECTION (COLLECTION_ID,COLLECTION_NAME,COLLECTION_DESCRIPTION,COLLECTION_CREATE_DATE) 
   values (25,'Show Stoppers',
   'These large-scale artworks are what we dub show stoppers. Allow your collection to come together around these bold centerpieces.',
   to_date('23-JUL-17','DD-MON-RR'));
Insert into UA_COLLECTION (COLLECTION_ID,COLLECTION_NAME,COLLECTION_DESCRIPTION,COLLECTION_CREATE_DATE) 
   values (26,'Gifts for You | Treat Yourself',
   'Take a break from your list, and listen to your wishes. Original artwork, all your own, to crystallize the end of this amazing decade.',
   to_date('15-JAN-18','DD-MON-RR'));
--------------------------------------------------------
--  DDL for Index UA_COLLECTION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_COLLECTION_PK" ON "UA_COLLECTION" ("COLLECTION_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_COLLECTION
--------------------------------------------------------

  ALTER TABLE "UA_COLLECTION" MODIFY ("COLLECTION_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_COLLECTION" MODIFY ("COLLECTION_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_COLLECTION" ADD CONSTRAINT "UA_COLLECTION_PK" PRIMARY KEY ("COLLECTION_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "UA_COLLECTION" ADD CONSTRAINT "UA_COLLECTION_NAME_UNIQUE" UNIQUE ("COLLECTION_NAME");
  
  --------------------------------------------------------
--  DDL for Table UA_ART_COLLECTION
--------------------------------------------------------

  CREATE TABLE "UA_ART_COLLECTION" 
   (	"COLLECTION_ID" NUMBER(*,0), 
	"ARTWORK_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_ART_COLLECTION
SET DEFINE OFF;
Insert into UA_ART_COLLECTION (COLLECTION_ID,ARTWORK_ID) values (25,31);
Insert into UA_ART_COLLECTION (COLLECTION_ID,ARTWORK_ID) values (25,36);
Insert into UA_ART_COLLECTION (COLLECTION_ID,ARTWORK_ID) values (26,33);
Insert into UA_ART_COLLECTION (COLLECTION_ID,ARTWORK_ID) values (26,36);
--------------------------------------------------------
--  DDL for Index UA_ART_COLLECCTION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ART_COLLECCTION_PK" ON "UA_ART_COLLECTION" ("COLLECTION_ID", "ARTWORK_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ART_COLLECTION
--------------------------------------------------------

  ALTER TABLE "UA_ART_COLLECTION" MODIFY ("COLLECTION_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ART_COLLECTION" MODIFY ("ARTWORK_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ART_COLLECTION" ADD CONSTRAINT "UA_ART_COLLECCTION_PK" PRIMARY KEY ("COLLECTION_ID", "ARTWORK_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ART_COLLECTION
--------------------------------------------------------

  ALTER TABLE "UA_ART_COLLECTION" ADD CONSTRAINT "UA_ART_COLLECTION_ART_FK" FOREIGN KEY ("ARTWORK_ID")
	  REFERENCES "UA_ARTWORK" ("ARTWORK_ID") ENABLE;
  ALTER TABLE "UA_ART_COLLECTION" ADD CONSTRAINT "UA_ART_COLL_COLLECTION_FK" FOREIGN KEY ("COLLECTION_ID")
	  REFERENCES "UA_COLLECTION" ("COLLECTION_ID") ENABLE;

--------------------------------------------------------
--  DDL for Table UA_CREDIT_CARD
--------------------------------------------------------

  CREATE TABLE "UA_CREDIT_CARD" 
   (	"CREDIT_CARD_ID" NUMBER(*,0), 
	"CREDIT_CARD_NAME" VARCHAR2(50), 
	"CREDIT_CARD_NUMBER" CHAR(16), 
	"CREDIT_CARD_CVC" NUMBER(*,0), 
	"CREDIT_CARD_EXPIRATION_MONTH" NUMBER(*,0), 
	"CREDIT_CARD_EXPIRATION_YEAR" NUMBER(*,0), 
	"ACCOUNT_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_CREDIT_CARD
SET DEFINE OFF;
Insert into UA_CREDIT_CARD (CREDIT_CARD_ID,CREDIT_CARD_NAME,CREDIT_CARD_NUMBER,CREDIT_CARD_CVC,CREDIT_CARD_EXPIRATION_MONTH,CREDIT_CARD_EXPIRATION_YEAR,ACCOUNT_ID) values (30,'visa','7384228510092769',786,10,2022,1);
Insert into UA_CREDIT_CARD (CREDIT_CARD_ID,CREDIT_CARD_NAME,CREDIT_CARD_NUMBER,CREDIT_CARD_CVC,CREDIT_CARD_EXPIRATION_MONTH,CREDIT_CARD_EXPIRATION_YEAR,ACCOUNT_ID) values (31,'mastercard','7789433955581200',313,8,2023,1);
--------------------------------------------------------
--  DDL for Index CREDIT_CARD_PKV2
--------------------------------------------------------

  CREATE UNIQUE INDEX "CREDIT_CARD_PKV2" ON "UA_CREDIT_CARD" ("CREDIT_CARD_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_CREDIT_CARD
--------------------------------------------------------

  ALTER TABLE "UA_CREDIT_CARD" ADD CONSTRAINT "CREDIT_CARD_PKV2" PRIMARY KEY ("CREDIT_CARD_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_CVC" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_EXPIRATION_MONTH" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("CREDIT_CARD_EXPIRATION_YEAR" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_CREDIT_CARD" ADD CHECK ( credit_card_expiration_month BETWEEN 1 AND 12 ) ENABLE;
  ALTER TABLE "UA_CREDIT_CARD" ADD CHECK ( credit_card_expiration_year BETWEEN 2000 AND 2050 ) ENABLE;
ALTER TABLE "UA_CREDIT_CARD"
    ADD CONSTRAINT "CREDIT_CARD_ACCOUNT_FK" FOREIGN KEY ( "ACCOUNT_ID" )
        REFERENCES "UA_ACCOUNT" ( "ACCOUNT_ID" );

--------------------------------------------------------
--  DDL for Table UA_EVENT
--------------------------------------------------------

  CREATE TABLE "UA_EVENT" 
   (	"EVENT_ID" NUMBER(*,0), 
	"EVENT_NAME" VARCHAR2(100), 
	"EVENT_TYPE" VARCHAR2(25), 
	"EVENT_DESCRIPTION" CLOB, 
	"EVENT_LOCATION" VARCHAR2(100), 
	"EVENT_CITY" VARCHAR2(50), 
	"EVENT_STATE" VARCHAR2(50), 
	"EVENT_COUNTRY" VARCHAR2(25), 
	"EVENT_START_DATE" DATE, 
	"EVENT_END_DATE" DATE
   ) ;
REM INSERTING into UA_EVENT
SET DEFINE OFF;
Insert into UA_EVENT (EVENT_ID,EVENT_NAME,EVENT_TYPE,EVENT_LOCATION,EVENT_CITY,EVENT_STATE,EVENT_COUNTRY,EVENT_START_DATE,EVENT_END_DATE) values (10,'The Uprise Art Loft','Exhibitions','264 Canal Street, No. 4W','New York','NY','United States',to_date('01-JAN-20','DD-MON-RR'),null);
Insert into UA_EVENT (EVENT_ID,EVENT_NAME,EVENT_TYPE,EVENT_LOCATION,EVENT_CITY,EVENT_STATE,EVENT_COUNTRY,EVENT_START_DATE,EVENT_END_DATE) values (11,'Nook','Showcases','Arlington','Washington','DC','United States',to_date('23-AUG-19','DD-MON-RR'),to_date('22-NOV-19','DD-MON-RR'));
Insert into UA_EVENT (EVENT_ID,EVENT_NAME,EVENT_TYPE,EVENT_LOCATION,EVENT_CITY,EVENT_STATE,EVENT_COUNTRY,EVENT_START_DATE,EVENT_END_DATE) values (12,'Seattle Art Fair','Art Fairs','Harris Harvey Gallery','Seattle','WA','United States',to_date('01-AUG-19','DD-MON-RR'),to_date('04-AUG-19','DD-MON-RR'));
--------------------------------------------------------
--  DDL for Index UA_EVENT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_EVENT_PK" ON "UA_EVENT" ("EVENT_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_EVENT
--------------------------------------------------------

  ALTER TABLE "UA_EVENT" MODIFY ("EVENT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_EVENT" MODIFY ("EVENT_NAME" NOT NULL ENABLE);
  ALTER TABLE "UA_EVENT" MODIFY ("EVENT_TYPE" NOT NULL ENABLE);
  ALTER TABLE "UA_EVENT" MODIFY ("EVENT_LOCATION" NOT NULL ENABLE);
  ALTER TABLE "UA_EVENT" ADD CHECK ( event_type IN (
        'Art Fairs',
        'Events',
        'Exhibitions',
        'Other',
        'Showcases',
        'Studio Visits'
    ) ) ENABLE;
  ALTER TABLE "UA_EVENT" ADD CONSTRAINT "UA_EVENT_PK" PRIMARY KEY ("EVENT_ID")
  USING INDEX  ENABLE;

--------------------------------------------------------
--  DDL for Table UA_ART_EVENT
--------------------------------------------------------

  CREATE TABLE "UA_ART_EVENT" 
   (	"EVENT_ID" NUMBER(*,0), 
	"ARTWORK_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_ART_EVENT
SET DEFINE OFF;
Insert into UA_ART_EVENT (EVENT_ID,ARTWORK_ID) values (11,31);
Insert into UA_ART_EVENT (EVENT_ID,ARTWORK_ID) values (11,34);
Insert into UA_ART_EVENT (EVENT_ID,ARTWORK_ID) values (12,32);
Insert into UA_ART_EVENT (EVENT_ID,ARTWORK_ID) values (12,34);
--------------------------------------------------------
--  DDL for Index UA_ART_EVENT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ART_EVENT_PK" ON "UA_ART_EVENT" ("EVENT_ID", "ARTWORK_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ART_EVENT
--------------------------------------------------------

  ALTER TABLE "UA_ART_EVENT" MODIFY ("EVENT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ART_EVENT" MODIFY ("ARTWORK_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ART_EVENT" ADD CONSTRAINT "UA_ART_EVENT_PK" PRIMARY KEY ("EVENT_ID", "ARTWORK_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ART_EVENT
--------------------------------------------------------

  ALTER TABLE "UA_ART_EVENT" ADD CONSTRAINT "UA_ART_EVENT_ARTWORK_FK" FOREIGN KEY ("ARTWORK_ID")
	  REFERENCES "UA_ARTWORK" ("ARTWORK_ID") ENABLE;
  ALTER TABLE "UA_ART_EVENT" ADD CONSTRAINT "UA_ART_EVENT_EVENT_FK" FOREIGN KEY ("EVENT_ID")
	  REFERENCES "UA_EVENT" ("EVENT_ID") ENABLE;
      
      --------------------------------------------------------
--  DDL for Table UA_INTEREST
--------------------------------------------------------

  CREATE TABLE "UA_INTEREST" 
   (	"INTEREST_NAME" VARCHAR2(50), 
	"INTEREST_EMAIL" VARCHAR2(50), 
	"ARTWORK_ID" NUMBER(*,0), 
	"ACCOUNT_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_INTEREST
SET DEFINE OFF;
Insert into UA_INTEREST (INTEREST_NAME,INTEREST_EMAIL,ARTWORK_ID,ACCOUNT_ID) values ('Hannah','Michelsen',34,1);
Insert into UA_INTEREST (INTEREST_NAME,INTEREST_EMAIL,ARTWORK_ID,ACCOUNT_ID) values ('Henrik','Michelsen',35,1);
Insert into UA_INTEREST (INTEREST_NAME,INTEREST_EMAIL,ARTWORK_ID,ACCOUNT_ID) values ('Michelle','Knudsen',35,3);
--------------------------------------------------------
--  DDL for Index UA_INTEREST_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_INTEREST_PK" ON "UA_INTEREST" ("ARTWORK_ID", "ACCOUNT_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_INTEREST
--------------------------------------------------------

  ALTER TABLE "UA_INTEREST" MODIFY ("ARTWORK_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_INTEREST" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_INTEREST" ADD CONSTRAINT "UA_INTEREST_PK" PRIMARY KEY ("ARTWORK_ID", "ACCOUNT_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_INTEREST
--------------------------------------------------------

  ALTER TABLE "UA_INTEREST" ADD CONSTRAINT "UA_INTEREST_ACCOUNT_FK" FOREIGN KEY ("ACCOUNT_ID")
	  REFERENCES "UA_ACCOUNT" ("ACCOUNT_ID") ENABLE;
  ALTER TABLE "UA_INTEREST" ADD CONSTRAINT "UA_INTEREST_ARTWORK_FK" FOREIGN KEY ("ARTWORK_ID")
	  REFERENCES "UA_ARTWORK" ("ARTWORK_ID") ENABLE;

--------------------------------------------------------
--  DDL for Table UA_ORDER_TRANSACTION
--------------------------------------------------------

  CREATE TABLE "UA_ORDER_TRANSACTION" 
   (	"ORDER_ID" NUMBER(*,0), 
	"ORDER_DATE" DATE, 
	"ORDER_SUBTOTAL" NUMBER, 
	"ORDER_TAX" NUMBER, 
	"ORDER_SHIPPING_COST" NUMBER, 
	"ORDER_TOTAL" NUMBER, 
	"ORDER_SPECIAL_INSTRUCTIONS" VARCHAR2(255), 
	"ORDER_BILLING_TYPE" VARCHAR2(15), 
	"ORDER_PAYMENT_STATUS" VARCHAR2(15), 
	"ACCOUNT_ID" NUMBER(*,0), 
	"SHIPPING_ADDRESS_ID" NUMBER(*,0), 
	"BILLING_ADDRESS_ID" NUMBER(*,0)
   ) ;
REM INSERTING into UA_ORDER_TRANSACTION
SET DEFINE OFF;
Insert into UA_ORDER_TRANSACTION (ORDER_ID,ORDER_DATE,ORDER_SUBTOTAL,ORDER_TAX,ORDER_SHIPPING_COST,ORDER_TOTAL,ORDER_SPECIAL_INSTRUCTIONS,ORDER_BILLING_TYPE,ORDER_PAYMENT_STATUS,ACCOUNT_ID,SHIPPING_ADDRESS_ID,BILLING_ADDRESS_ID) values (60,to_date('11-DEC-19','DD-MON-RR'),5500,385,120,6005,'Always store on edge','Credit Card','received',1,21,20);
--------------------------------------------------------
--  DDL for Index UA_ORDER_TRANSACTION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ORDER_TRANSACTION_PK" ON "UA_ORDER_TRANSACTION" ("ORDER_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ORDER_TRANSACTION
--------------------------------------------------------

  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ORDER_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ORDER_DATE" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ORDER_TAX" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ORDER_SHIPPING_COST" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ORDER_TOTAL" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" MODIFY ("BILLING_ADDRESS_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CHECK ( order_billing_type IN (
        'Bank Wire',
        'Check',
        'Credit Card'
    ) ) ENABLE;
  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CHECK ( order_payment_status IN (
        'not received',
        'received'
    ) ) ENABLE;
  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CONSTRAINT "UA_ORDER_TRANSACTION_PK" PRIMARY KEY ("ORDER_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ORDER_TRANSACTION
--------------------------------------------------------

  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CONSTRAINT "UA_ORDER_ACCOUNT_FK" FOREIGN KEY ("ACCOUNT_ID")
	  REFERENCES "UA_ACCOUNT" ("ACCOUNT_ID") ENABLE;
  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CONSTRAINT "UA_ORDER_SHIPPING_FK" FOREIGN KEY ("SHIPPING_ADDRESS_ID")
	  REFERENCES "UA_ADDRESS" ("ADDRESS_ID") ENABLE;
  ALTER TABLE "UA_ORDER_TRANSACTION" ADD CONSTRAINT "UA_ORDER_BILLING_FK" FOREIGN KEY ("BILLING_ADDRESS_ID")
	  REFERENCES "UA_ADDRESS" ("ADDRESS_ID") ENABLE;

--------------------------------------------------------
--  DDL for Table UA_ORDER_DETAIL
--------------------------------------------------------

  CREATE TABLE "UA_ORDER_DETAIL" 
   (	"ORDER_DETAIL_ID" NUMBER(*,0), 
	"ORDER_ID" NUMBER(*,0), 
	"ARTWORK_ID" NUMBER(*,0), 
	"ORDER_DETAIL_PRICE" NUMBER
   ) ;
REM INSERTING into UA_ORDER_DETAIL
SET DEFINE OFF;
Insert into UA_ORDER_DETAIL (ORDER_DETAIL_ID,ORDER_ID,ARTWORK_ID,ORDER_DETAIL_PRICE) values (100,60,34,3200);
Insert into UA_ORDER_DETAIL (ORDER_DETAIL_ID,ORDER_ID,ARTWORK_ID,ORDER_DETAIL_PRICE) values (101,60,35,2300);
--------------------------------------------------------
--  DDL for Index UA_ORDER_DETAIL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UA_ORDER_DETAIL_PK" ON "UA_ORDER_DETAIL" ("ORDER_DETAIL_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table UA_ORDER_DETAIL
--------------------------------------------------------

  ALTER TABLE "UA_ORDER_DETAIL" MODIFY ("ORDER_DETAIL_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_DETAIL" MODIFY ("ORDER_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_DETAIL" MODIFY ("ARTWORK_ID" NOT NULL ENABLE);
  ALTER TABLE "UA_ORDER_DETAIL" ADD CONSTRAINT "UA_ORDER_DETAIL_PK" PRIMARY KEY ("ORDER_DETAIL_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UA_ORDER_DETAIL
--------------------------------------------------------

  ALTER TABLE "UA_ORDER_DETAIL" ADD CONSTRAINT "UA_ORDER_DETAIL_ARTWORK_FK" FOREIGN KEY ("ARTWORK_ID")
	  REFERENCES "UA_ARTWORK" ("ARTWORK_ID") ENABLE;
  ALTER TABLE "UA_ORDER_DETAIL" ADD CONSTRAINT "UA_ORDER_DETAIL_ORDER_FK" FOREIGN KEY ("ORDER_ID")
	  REFERENCES "UA_ORDER_TRANSACTION" ("ORDER_ID") ENABLE;
      
COMMIT;
