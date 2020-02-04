TRUNCATE TABLE "ORDER";
TRUNCATE TABLE "INTERESTED_LIST";
TRUNCATE TABLE "COLLECTION";
TRUNCATE TABLE "EVENT_LOCATION";
TRUNCATE TABLE "EVENT";
TRUNCATE TABLE "ARTWORK";
TRUNCATE TABLE "EVENT_ARTWORK";
TRUNCATE TABLE "COLLECTION_ARTWORK";
TRUNCATE TABLE "SIZE_CATEGORY";
TRUNCATE TABLE "MEDIUM";
TRUNCATE TABLE "ARTIST";
TRUNCATE TABLE "ADDRESS_INFO";
TRUNCATE TABLE "ADDRESS";
TRUNCATE TABLE "REGION";
TRUNCATE TABLE "CREDIT_CARD_ACCOUNT";
TRUNCATE TABLE "CREDIT_CARD";
TRUNCATE TABLE "PERSONAL_INFO";
TRUNCATE TABLE "ACCOUNT";

INSERT INTO "ACCOUNT" VALUES ('mons@mail.com', 'Mons', 'Monsen', 'encrypted');
INSERT INTO "ACCOUNT" VALUES ('bob@mail.se', 'Bob', 'Bobsen', 'secret');
INSERT INTO "ACCOUNT" VALUES ('lisa@mail.se', 'Lisa', 'Hansen', 'xxxx');

INSERT INTO personal_info VALUES ('mons@mail.com', 'mason', 'www.mons.com', 'Carl I', 'Paintings by Munch and Pichasso');
INSERT INTO personal_info VALUES ('lisa@mail.se', 'hair dresser', 'www.haircut.se', 'Mons Hansen', 'Nupen');
INSERT INTO personal_info VALUES ('bob@mail.se', 'account manager', null, null, null);

INSERT INTO Credit_card VALUES ('225545347655', 323, TO_DATE('2022-04-26', 'yyyy-mm-dd'));
INSERT INTO Credit_card VALUES ('338845347655', 123, TO_DATE('2021-08-09', 'yyyy-mm-dd'));

INSERT INTO credit_card_account VALUES ('225545347655', 'bob@mail.se');
INSERT INTO credit_card_account VALUES ('338845347655', 'mons@mail.com');

INSERT INTO region(region_postal_code, region_country, region_city) VALUES ('4790', 'Norway', 'Kristiansand');
INSERT INTO region(region_postal_code, region_country, region_city) VALUES ('1221', 'Sweden', 'Malmo');

INSERT INTO address(address_address1, address_address2, region_postal_code, region_country) VALUES ('fugleveien 2', '8', '4790', 'Norway');
INSERT INTO address(address_address1, address_address2, region_postal_code, region_country) VALUES ('blomsterveien 1', null, '1221', 'Sweden'); 

INSERT INTO address_info(address_info_first_name, address_info_last_name, address_info_phone, address_id) VALUES ('Lars', 'Larsen', '004711223344', 1);
INSERT INTO address_info(address_info_first_name, address_info_last_name, address_info_phone, address_id) VALUES ('Lisa', 'Hansen', '004900000000', 2);

INSERT INTO artist VALUES ('Artist1', 'Edvard', 'Munch', 'Oil paintings', TO_DATE('1974','yyyy'), '123456789', 'xxxxx', 1);
INSERT INTO artist VALUES ('Artist2', 'Siri', 'Klausen', 'Sculptures', TO_DATE('1984','yyyy'), '22335446', 'xxxxx', 2);

INSERT INTO "MEDIUM" VALUES ('Painting');
INSERT INTO "MEDIUM" VALUES ('Sculpture');

INSERT INTO size_category VALUES ('small', 20, 1);
INSERT INTO size_category VALUES ('medium', 30, 21);
INSERT INTO size_category VALUES ('large', 40, 31);

INSERT INTO size_category(size_category_name, size_category_min_size) VALUES ('oversized', 41);

INSERT INTO artwork(artwork_title, artwork_price, artwork_creation_year, artwork_material_description, artwork_frame_description,
	artwork_date_acquired, artwork_status, artwork_photo, artwork_copies, medium_name, size_category_name, artwork_size_depth, artwork_size_width, artwork_size_height, artist_display_name) 
    VALUES ('Deplorables', 600, TO_DATE('2016','yyyy'), 'Fabric and polyfill', 'N/A', TO_DATE('2011-11-27','yyyy-mm-dd'), 'available', 'deplo.jpg', 2, 'Sculpture', 'medium', 20, 10, 18, 'Artist2');
INSERT INTO artwork(artwork_title, artwork_price, artwork_creation_year, artwork_material_description, artwork_frame_description,
	artwork_date_acquired, artwork_status, artwork_photo, artwork_copies, medium_name, size_category_name, artwork_size_depth, artwork_size_width, artwork_size_height, artist_display_name) 
    VALUES('Low Tide', 700, TO_DATE('2019','yyyy'), 'Oil and acrylic on canvas diptych', 'N/A', TO_DATE('1998-01-13','yyyy-mm-dd'), 'on event', 'lowtide.jpg', 1, 'Painting', 'oversized', 20, 40, 18, 'Artist1');

INSERT INTO "EVENT"(event_name, event_type, event_start_date, event_end_date, event_description) 
    VALUES ('The Uprise Art Loft', 'exhibition', TO_DATE('2020-01-01','yyyy-mm-dd'), TO_DATE('2020-01-28','yyyy-mm-dd'), 'Expertly curated, entirely unique.');
INSERT INTO "EVENT"(event_name, event_type, event_start_date, event_end_date, event_description) 
    VALUES ('PULSE, Miami Beach', 'Art fairs', TO_DATE('2019-05-12','yyyy-mm-dd'), TO_DATE('2019-08-12','yyyy-mm-dd'), 'Uprise Art presents the latest works from Angel Oloshove, Clay Mahn, Rachel Mica Weiss, and Ruth Freeman.');

INSERT INTO event_location VALUES (1, 'Porter James', 'New York');
INSERT INTO event_location VALUES (2, 'Miami Beach', 'Miami'); 

INSERT INTO event_artwork VALUES (1, 1);
INSERT INTO event_artwork VALUES (2, 2);

INSERT INTO collection VALUES ('Night Mode', 'over 500$', 'Easy on the eyes. A collection of paintings, photographs, and objects that find light in its absence.');
INSERT INTO collection VALUES ('Figurative', 'bodies', 'From the abstract outline of a nude body to the minutiae of a shadow, these figurative works focus on a familiar sight: the human form.');

INSERT INTO collection_artwork VALUES ('Night Mode', 2);
INSERT INTO collection_artwork VALUES ('Figurative', 1);

INSERT INTO interested_list VALUES (1, 'email@post.no', 'Bob', 'bob@mail.se');
INSERT INTO interested_list VALUES (1, 'email1@post.com', 'Mons', 'mons@mail.com');

INSERT INTO "ORDER"(order_payment_recieved, order_special_instructions, order_pickup, order_quick_delivery, order_billing_type, address_info_id_billing, address_info_id_delivery, account_email) 
    VALUES (1, 'nothing special', 0, 0, 'invoice', 1, 2, 'lisa@mail.se');
INSERT INTO "ORDER"(order_payment_recieved, order_special_instructions, order_pickup, order_quick_delivery, order_billing_type, address_info_id_billing, address_info_id_delivery, account_email) 
    VALUES (0, 'fragile', 1, 1, 'creditcard', 2, 1, 'mons@mail.com');
