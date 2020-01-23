TRUNCATE TABLE "ACCOUNT";
INSERT INTO "ACCOUNT"
VALUES
('mons@mail.com', 'Mons', 'Monsen', 'encrypted'),
('bob@mail.se', 'Bob', 'Bobsen', 'secret'),
('lisa@mail.se', 'Lisa', 'Hansen', 'xxxx');

TRUNCATE TABLE personal_info;
INSERT INTO personal_info
VALUES
('mons@mail.com', 'mason', 'www.mons.com', 'Carl I', 'Paintings by Munch and Pichasso'); 

TRUNCATE TABLE region;
INSERT INTO region(region_postal_code, region_country, region_city)
VALUES
('4790', 'Norway', 'Kristiansand');

TRUNCATE TABLE address;
INSERT INTO address(address_address1, address_address2, region_postal_code, region_country)
VALUES
('fugleveien 2', '8', '4790', 'Norway'),
('blomsterveien 1', null, '1221', 'Sweden'); 

TRUNCATE TABLE address_info;
INSERT INTO address_info(address_info_first_name, address_info_last_name, address_info_phone, address_id)
VALUES
('Lars', 'Larsen', '004711223344', 1),
('Lisa', 'Hansen', '004900000000', 2);

TRUNCATE TABLE artist;
INSERT INTO artist
VALUES
('Artist1', 'Edvard', 'Munch', 'Famous painter. Oil paintings', '1974', '123456789', 'xxxxx', 1);

TRUNCATE TABLE "MEDIUM"
INSERT INTO "MEDIUM"
VALUES
('Painting'),
('Sculpture');

TRUNCATE TABLE size_category;
INSERT INTO size_category
VALUES
('small', 20, 1),
('medium', 30, 21),
('large', 40, 31);

TRUNCATE TABLE size_category;
INSERT INTO size_category(size_category_name, size_category_min_size)
VALUES
('oversized', 41);

TRUNCATE TABLE artwork;
INSERT INTO artwork(artwork_title, artwork_price, artwork_creation_year, artwork_material_description, artwork_frame_description,
	artwork_date_acquired, artwork_status, artwork_photo, artwork_copies, medium_name, size_category_name, artwork_size_depth, artwork_size_width, artwork_size_height)
VALUES
('Deplorables', 600, '2016', 'Fabric and polyfill', 'N/A', '2017-01-27', 'available', 'deplo.jpg', 2, 'Sculpture', 'medium', 20, 10, 18),
('Low Tide', 700, '2019', 'Oil and acrylic on canvas diptych', 'N/A', '2020-01-10', 'on event', 'lowtide.jpg', 1, 'painting', 'oversized', 20, 40, 18);

TRUNCATE TABLE "EVENT";
INSERT INTO "EVENT"(event_name, event_type, event_start_date, event_end_date, event_description)
VALUES
('The Uprise Art Loft', 'exhibition', '2020-01-01', '2020-01-28', 'Expertly curated, entirely unique.'),
('PULSE, Miami Beach', 'Art fairs', '2019-05-12', '2019-08-12', 'Uprise Art presents the latest works from Angel Oloshove, Clay Mahn, Rachel Mica Weiss, and Ruth Freeman.');

TRUNCATE TABLE event_location;
INSERT INTO event_location
VALUES
(1, 'Porter James', 'New York'),
(2, 'Miami Beach', 'Miami'); 

TRUNCATE TABLE event_artwork;
INSERT INTO event_artwork
VALUES
(1, 1),
(2, 2);

TRUNCATE TABLE collection;
INSERT INTO collection
VALUES
('Night Mode', 'over 500$', 'Easy on the eyes. A collection of paintings, photographs, and objects that find light in its absence.'),
('Figurative', 'bodies', 'From the abstract outline of a nude body to the minutiae of a shadow, these figurative works focus on a familiar sight: the human form.');

TRUNCATE TABLE collection_artwork;
INSERT INTO collection_artwork
VALUES
('Night Mode', 2),
('Figurative', 1);

TTRUNCATE TABLE interested_list;
INSERT INTO interested_list
VALUES
(1, 'email', 'Bob', 'bob@mail.se'),
(1, null, 'Mons', 'mons@mail.com');

TRUNCATE TABLE "ORDER";
INSERT INTO "ORDER"(order_payment_recieved, order_special_instructions, order_pickup, order_quick_delivery, order_billing_type, address_info_id_billing, address_info_id_delivery, account_email)
VALUES
(1, 'nothing special', 0, 0, 'invoice', 1, 2, 'lisa@mail.se'),
(0, 'fragile', 1, 1, 'credit card', 2, 1, 'mons@mail.com');
