DROP SCHEMA upriseart;
CREATE SCHEMA upriseart;
USE upriseart;

CREATE TABLE `account` (
    account_email VARCHAR(40),
    account_first_name VARCHAR(40) NOT NULL,
    account_last_name VARCHAR(15) NOT NULL,
    account_password CHAR(40) NOT NULL,
    CONSTRAINT pk_account PRIMARY KEY (account_email)
);

CREATE TABLE personal_info (
    account_email VARCHAR(40),
    personal_info_occupation VARCHAR(25),
    personal_info_website VARCHAR(40),
    personal_info_referred_by VARCHAR(40),
    personal_info_artwork_you_love VARCHAR(200),
    CONSTRAINT pk_personal_info PRIMARY KEY (account_email),
    CONSTRAINT fk_personal_info_account FOREIGN KEY (account_email)
        REFERENCES `account` (account_email)
);

CREATE TABLE credit_card (
    credit_card_number VARCHAR(19),
    credit_card_cvc VARCHAR(4) NOT NULL,
    credit_card_month VARCHAR(2) NOT NULL,
    credit_card_year YEAR NOT NULL,
    CONSTRAINT pk_credit_card PRIMARY KEY (credit_card_number)
);

CREATE TABLE credit_card_account (
    credit_card_number VARCHAR(19),
    account_email VARCHAR(40),
    CONSTRAINT pk_credit_card_account PRIMARY KEY (credit_card_number , account_email),
    CONSTRAINT fk_credit_card_account_credit_card FOREIGN KEY (credit_card_number)
        REFERENCES credit_card (credit_card_number),
    CONSTRAINT fk_credit_card_account_account FOREIGN KEY (account_email)
        REFERENCES `account` (account_email)
);

CREATE TABLE region (
    region_postal_code VARCHAR(10),
    region_country VARCHAR(50),
    region_city VARCHAR(50) NOT NULL,
    region_state VARCHAR(20),
    CONSTRAINT pk_region PRIMARY KEY (region_postal_code , region_country)
);

CREATE TABLE address (
    address_id INT AUTO_INCREMENT,
    address_address1 VARCHAR(30) NOT NULL,
    address_address2 VARCHAR(30),
    region_postal_code VARCHAR(10) NOT NULL,
    region_country VARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (address_id),
    CONSTRAINT fk_address_region FOREIGN KEY (region_postal_code , region_country)
        REFERENCES region (region_postal_code , region_country)
);

CREATE TABLE address_info (
    address_info_id INT AUTO_INCREMENT,
    address_info_first_name VARCHAR(40) NOT NULL,
    address_info_last_name VARCHAR(15) NOT NULL,
    address_info_phone VARCHAR(20),
    address_id INT,
    account_email VARCHAR(40),
    CONSTRAINT pk_address_info PRIMARY KEY (address_info_id),
    CONSTRAINT fk_address_info_address FOREIGN KEY (address_id)
        REFERENCES address (address_id),
    CONSTRAINT fk_address_info_account FOREIGN KEY (account_email)
        REFERENCES `account` (account_email)
);

CREATE TABLE artist (
    artist_display_name VARCHAR(20),
    artist_name VARCHAR(40),
    artist_surname VARCHAR(15),
    artist_bio_sketch VARCHAR(200),
    artist_bith_year YEAR,
    artist_tax_id VARCHAR(9),
    artist_photo VARCHAR(50),
    address_info_id INT NOT NULL,
    CONSTRAINT pk_arist PRIMARY KEY (artist_display_name),
    CONSTRAINT fk_artist_address_info FOREIGN KEY (address_info_id)
        REFERENCES address_info (address_info_id)
);

CREATE TABLE `medium` (
    medium_name VARCHAR(12),
    CONSTRAINT pk_medium PRIMARY KEY (medium_name)
);

CREATE TABLE size_category (
    size_category_name VARCHAR(10),
    size_category_max_size TINYINT,
    size_category_min_size TINYINT NOT NULL,
    CONSTRAINT pk_size_category PRIMARY KEY (size_category_name)
);

CREATE TABLE artwork (
    artwork_id INT AUTO_INCREMENT,
    artwork_title VARCHAR(20) NOT NULL,
    artwork_price SMALLINT,
    artwork_creation_year YEAR,
    artwork_material_description VARCHAR(50),
    artwork_frame_description VARCHAR(50),
    artwork_date_acquired DATE NOT NULL,
    artwork_status VARCHAR(20) NOT NULL,
    artwork_photo VARCHAR(50),
    artwork_copies SMALLINT NOT NULL,
    medium_name VARCHAR(12) NOT NULL,
    size_category_name VARCHAR(10) NOT NULL,
    CONSTRAINT pk_artwork PRIMARY KEY (artwork_ID),
    CONSTRAINT fk_artwork_medium FOREIGN KEY (medium_name)
        REFERENCES `medium` (medium_name),
    CONSTRAINT fk_artwork_size_category FOREIGN KEY (size_category_name)
        REFERENCES size_category (size_category_name)
);

CREATE TABLE size (
	artwork_id INT,
	size_depth DEC(7,4) NOT NULL,
    size_width DEC(7,4) NOT NULL,
    size_height DEC(7,4) NOT NULL,
    CONSTRAINT pk_size PRIMARY KEY (artwork_id),
    CONSTRAINT fk_size_artwork FOREIGN KEY (artwork_id)
		REFERENCES artwork (artwork_id)
);

CREATE TABLE `event` (
	event_id INT AUTO_INCREMENT,
    event_name VARCHAR(20) NOT NULL,
    event_type VARCHAR(20) NOT NULL,
    event_start_date DATE,
    event_end_date DATE,
    event_description VARCHAR(200) NOT NULL,
    CONSTRAINT pk_event PRIMARY KEY (event_id) 
);

CREATE TABLE event_location (
	event_id INT,
	event_location_name VARCHAR(20) NOT NULL,
    event_location_geo_place VARCHAR(40) NOT NULL,
    CONSTRAINT pk_event_location PRIMARY KEY (event_id),
    CONSTRAINT fk_event_location_event FOREIGN KEY (event_id)
		REFERENCES `event` (event_id)
);

CREATE TABLE event_artwork (
	artwork_id INT,
    event_id INT,
    CONSTRAINT pk_event_artwork PRIMARY KEY (artwork_id, event_id),
    CONSTRAINT fk_event_artwork_artwork FOREIGN KEY (artwork_id)
		REFERENCES artwork (artwork_id),
	CONSTRAINT fk_event_artwork_event FOREIGN KEY (event_id)
		REFERENCES `event` (event_id)
);

CREATE TABLE collection (
    collection_name VARCHAR(20),
    collection_description VARCHAR(100) NOT NULL,
    collection_criteria VARBINARY(50),
    CONSTRAINT pk_collection PRIMARY KEY (collection_name)
);

CREATE TABLE collection_artwork (
	collection_name VARCHAR(20),
    artwork_id INT,
    CONSTRAINT pk_collection_artwork PRIMARY KEY (collection_name, artwork_id),
    CONSTRAINT fk_collection_artwork_collection FOREIGN KEY (collection_name)
		REFERENCES collection (collection_name),
	CONSTRAINT fk_collection_artwork_artwork FOREIGN KEY (artwork_id)
		REFERENCES artwork (artwork_id)
);

CREATE TABLE interested_list (
	artwork_id INT NOT NULL,
    interested_list_email VARCHAR(40),
    interested_list_name VARCHAR(60) NOT NULL,
    account_email VARCHAR(40) NOT NULL,
    CONSTRAINT pk_interested_list PRIMARY KEY (interested_list_email, artwork_id),
    CONSTRAINT fk_interested_list_artwork FOREIGN KEY (artwork_id)
		REFERENCES artwork (artwork_id),
	CONSTRAINT fk_interested_list_account FOREIGN KEY (account_email)
		REFERENCES `account` (account_email)
);

CREATE TABLE `order` (
	order_number INT AUTO_INCREMENT,
    order_payment_recieved BOOL NOT NULL,
    order_special_instructions VARCHAR(100),
    order_pickup BOOL NOT NULL,
    order_quick_delivery BOOL NOT NULL,
    order_billing_type VARCHAR(10),
    address_info_id_billing INT NOT NULL,
    address_info_id_delivery INT,
    account_email VARCHAR(40) NOT NULL,
    CONSTRAINT pk_order PRIMARY KEY (order_number),
    CONSTRAINT fk_order_billing_address FOREIGN KEY (address_info_id_billing)
		REFERENCES address_info (address_info_id),
	CONSTRAINT fk_order_delivery_address FOREIGN KEY (address_info_id_delivery)
		REFERENCES address_info (address_info_id),
	CONSTRAINT fk_order_account FOREIGN KEY (account_email)
		REFERENCES `account` (account_email)
);