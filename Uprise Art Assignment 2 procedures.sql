/*
CREATE_ARTIST_SP.  Add a new artist to the UA_ARTIST table.  This procedure should take as input 
artist-related attributes and create a new artist.  The procedure returns the identifier for the 
new artist. Duplicate tax id values are not permitted.  

PARAMETERS:  Described below
RETURNS:  A new artist_id, using teh p_artist_id output parameter.
ERROR MESSAGES:
    Error text:  "Missing mandatory value for parameter (x) in CREATE_ARTIST_SP.  No artist added."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandator value is not provided, no data are inserted into the UA_ARTIST table.  The 
       p_artist_id value returned is NULL.
       
    Error text: "Invalid value (x) for birth year in CREATE_ARTIST_SP."
    Error meaning:  The birth year is not valid, not between 1900 and 2050.  Here, x=the value sent into the procedure.
    Error effect:  No new artist inserted into the UA_ARTIST table.  The value of p_artist_id is NULL.
       
    Error text:  "Tax ID (x) is already used."
    Error meaning:  Because the Tax ID must be unique, trying to insert a new artist with the same tax ID is not allowed.
    Error effect:  No new artist inserted into the UA_ARTIST table.  The value of p_artist_id is NULL.
*/
/*create sequence atrist_seq 
START WITH 52 
INCREMENT BY 1;*/
create or replace procedure CREATE_ARTIST_SP (
 p_artist_id        OUT INTEGER,        -- an output parameter
 p_tax_id           IN VARCHAR,         -- must not be NULL.  Must be UNIQUE.
 p_given_name       IN VARCHAR,
 p_surname          IN VARCHAR,
 p_display_name     IN VARCHAR,         -- If NULL, then use the concatenation ('||') of p_given_name and p_surname
 p_birth_year       IN INTEGER,         -- value must be between 1900 and 2050
 p_photo_url        IN VARCHAR,
 p_biosketch        IN CLOB,
 p_street_1         IN VARCHAR,         -- must not be NULL.
 p_street_2         IN VARCHAR,
 p_city             IN VARCHAR,         -- must not be NULL.
 p_state_province   IN VARCHAR,
 p_postal_code      IN VARCHAR,         -- must not be NULL.
 p_country          IN VARCHAR          -- must not be NULL.
)
IS
    l_error varchar(20);
    l_display_name UA_ARTIST.artist_display_name%TYPE;
    l_exst number(1);
    ex_null_value EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_null_value, -20001 );
    ex_invalid_date EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_invalid_date, -20002 );
    ex_invalid_fk EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_invalid_fk, -20003 );
BEGIN
    l_display_name := p_display_name;
    IF p_tax_id IS NULL THEN
        l_error := 'p_tax_id';
        raise ex_null_value;
    ELSIF p_street_1 IS NULL THEN
        l_error := 'p_street_1';
        raise ex_null_value;
    ELSIF p_city IS NULL THEN
        l_error := 'p_city';
        raise ex_null_value;
    ELSIF p_postal_code IS NULL THEN
        l_error := 'p_postal_code';
        raise ex_null_value;
    ELSIF p_country IS NULL THEN
        l_error := 'p_postal_code';
        raise ex_null_value;
    ELSIF ( p_birth_year < 1900 OR p_birth_year > 2050 ) THEN
        l_error := p_birth_year;
        raise ex_invalid_date;
    ELSIF l_display_name IS NULL THEN
        l_display_name := p_given_name || p_surname;
        IF l_display_name IS NULL THEN
            l_error := 'p_display_name';
            raise ex_null_value;
        END IF;
    END IF;

    SELECT
        COUNT(*)
    INTO l_exst
    FROM
        ua_artist
    WHERE
        artist_tax_id = p_tax_id;

    IF l_exst != 0 THEN
        l_error := p_tax_id;
        raise ex_invalid_fk;
    END IF;
    p_artist_id := atrist_seq.nextval;
    
    INSERT INTO ua_artist (
        artist_id,
        artist_tax_id,
        artist_given_name,
        artist_surname,
        artist_display_name,
        artist_birth_year,
        artist_photo_url,
        artist_biosketch,
        artist_street_1,
        artist_street_2,
        artist_city,
        artist_state_province,
        artist_postal_code,
        artist_country
    ) VALUES (
        p_artist_id,
        p_tax_id,
        p_given_name,
        p_surname,
        l_display_name,
        p_birth_year,
        p_photo_url,
        p_biosketch,
        p_street_1,
        p_street_2,
        p_city,
        p_state_province,
        p_postal_code,
        p_country
    );

    COMMIT;
EXCEPTION
    WHEN ex_null_value THEN
        dbms_output.put_line('Missing mandatory value for parameter '
                             || l_error
                             || ' in CREATE_ARTIST_SP.  No artist added.');
    WHEN ex_invalid_date THEN
        dbms_output.put_line('Invalid value '
                             || l_error
                             || ' for birth year in CREATE_ARTIST_SP.');
    WHEN ex_invalid_fk THEN
        dbms_output.put_line('Tax ID '
                             || l_error
                             || ' is already used.');
END;
/

/*
CREATE_ARTWORK_SP.  Add a new work of art for a given artist to the UA_ARTWORK table. If the artist 
associated with the work of art is not found, the work of art is not added to the database.  The procedure 
returns the identifier for the new work of art.

    Error text:  "Missing mandatory value for parameter (x) in CREATE_ARTIST_SP.  No artwork added."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandator value is not provided, no data are inserted into the UA_ARTWORK table.  The 
       p_artwork_id value returned is NULL.
       
    Error text:  "Tax ID (x) is already used."
    Error meaning:  Because the Tax ID must be unique, trying to insert a new artist with the same tax ID is not allowed.
    Error effect:  No new artist inserted into the UA_ARTIST table.  The value of p_artist_id is NULL.
    
    Error text: "Invalid artist (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_artist_id passed into the procedure.  The p_artist_id value does not match 
        a value found in the UA_ARTIST.ARTIST_ID column. 
    Error effect:   No work of art is added to the UA_ARTWORK table.
    
    Error text: "Invalid artwork size category (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_size_category passed into the procedure.  The p_size_category value does not match 
        the domaain of UA_ARTWORK.ARTWORK_SIZE_CATEGORY. 
    Error effect:   No work of art is added to the UA_ARTWORK table.
    
    Error text: "Invalid artwork status (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_status passed into the procedure.  The p_status value does not match 
        the domaain of UA_ARTWORK.ARTWORK_STATUS. 
    Error effect:   No work of art is added to the UA_ARTWORK table.
    
    Error text: "Invalid artwork medium (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_medium_name passed into the procedure.  The p_medium_name value does not match 
        a value in the UA_MEDIUM table. 
    Error effect:   No work of art is added to the UA_ARTWORK table.
    
    Error text:  "Invalid creation year (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_creation_year passed into the procedure.  The p_creation_year is either before
        2000 or later than the current year.   Hint:  Learn about the EXTRACT function in Oracle, and the CURRENT_DATE variable.
    Error effect:   No work of art is added to the UA_ARTWORK table.

    Error text:  "Invalid acquisition date (x) in CREATE_ARTWORK_SP."
    Error meaning:  Here, x = the value of p_acquisition_date passed into the procedure.  The p_acquisition_date must not be 
        greater than the current date.   
    Error effect:   No work of art is added to the UA_ARTWORK table.
    
    
*/

create or replace procedure create_artwork_sp (
 p_artwork_id       OUT INTEGER,        -- an output parameter.  Value generated by the procedure.
 p_title            IN VARCHAR,         -- must not be NULL
 p_price            IN NUMBER,
 p_size_height      IN DECIMAL,         -- must not be a negative number
 p_size_width       IN DECIMAL,         -- must not be a negative number
 p_size_depth       IN DECIMAL,         -- must not be a negative number
 p_size_category    IN VARCHAR,         -- must be one of {'Large', 'Medium', 'Oversized', 'Small'}
 p_creation_year    IN INTEGER,         -- must be between 2000 and the current year
 p_aquisition_date  IN DATE,            -- must not be NULL.  Must not be in the future.
 p_materials        IN VARCHAR,
 p_framed           IN VARCHAR,
 p_medium_name      IN VARCHAR,         -- must match a value found in the UA_MEDIUM table
 p_photo_url        IN VARCHAR,         -- must not be NULL
 p_quantity_on_hand IN INTEGER,
 p_status           IN VARCHAR,         -- must not be NULL.  Must be one of:  {'For sale', 'Sold out', 'Unavailable'}
 p_artist_id        IN INTEGER          -- must not be NULL.  Must match a value found in the UA_ARTIST table 
)
IS
BEGIN
    NULL;
END;
/

/*
CREATE_ACCOUNT_SP.  Add a new account to the UA_ACCOUNT table.  This procedure returns the identifier for the new account 
holder.  Duplicate email addresses are not permitted.  

    Error text:  "Missing mandatory value for parameter (x) in CREATE_ACCOUNT_SP.  No account added."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandator value is not provided, no data are inserted into the UA_ACCOUNT table.  The 
       p_account_id value returned is NULL.
       
    Error text:  "Email (x) is already used."
    Error meaning:  Because the email must be unique, trying to insert a new account with the same email is not allowed.
    Error effect:  No new account inserted into the UA_ACCOUNT table.  The value of p_account_id is NULL.
*/

create or replace procedure create_account_sp(
 p_account_id       OUT INTEGER,            -- an output parameter.  Value generated by the procedure.
 p_first_name       IN VARCHAR,             -- must not be NULL
 p_last_name        IN VARCHAR,             -- must not be NULL
 p_email            IN VARCHAR,             -- must not be NULL.   Must be unique.
 p_password         IN VARCHAR,             -- must not be NULL
 p_occupation       IN VARCHAR,
 p_website          IN VARCHAR,
 p_referred_by      IN VARCHAR,
 p_artwork_loved    IN VARCHAR
)
IS
BEGIN
    NULL;
END;
/

/*
ADD_ADDRESS_SP.  Add a new address for a given account holder to the UA_ADDRESS table.  Given the account holder�s email 
address, this procedure looks up the appropriate identifier for the account holder and uses it when adding a new address.

    Error text:  "Missing mandatory value for parameter (x) in ADD_ADDRESS_SP.  No address added."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandatory value is not provided, no data are inserted into the UA_ADDRESS table.  The 
       p_address_id value returned is NULL.
       
    Error text:  "Account (x) was not found."
    Error meaning:  Because the address must be associated with an existing address, trying to insert a new address with 
        an account_id that is missing is not allowed.  Here x = the account_id that is missing.  
    Error effect:  No new address inserted into the UA_ADDRESS table.  The value of p_address_id is NULL.
*/
/* To make this work, we had to make a sequence to generate id`s:
create sequence address_seq 
START WITH 22 
INCREMENT BY 1;
(then we start from the last inserted row + 1).
*/
create or replace procedure add_address_sp (

 p_address_id       OUT INTEGER,            -- an output parameter.  Value generated by the procedure.
 p_first_name       IN VARCHAR,
 p_last_name        IN VARCHAR,
 p_line_1           IN VARCHAR,
 p_line_2           IN VARCHAR,
 p_city             IN VARCHAR,
 p_state_province   IN VARCHAR,
 p_postal_code      IN VARCHAR,
 p_country          IN VARCHAR,
 p_phone            IN VARCHAR,
 p_account_ID       IN INTEGER              -- must not be NULL
 )
IS
    l_error          VARCHAR(20);
    l_account_exists NUMBER(1);
    l_new_address_id UA_ADDRESS.address_id%TYPE;
    
    ex_null_value EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_null_value, -20001);
    ex_account_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_account_not_found, -20002);
--
BEGIN
    -- Input parameter checks:
    IF p_account_ID IS NULL THEN
        l_error := 'p_account_ID';
        raise ex_null_value;
    END IF;
    
    -- Check if account exists:
    SELECT COUNT(*) INTO l_account_exists
    FROM ua_account
    WHERE account_id = p_account_ID;
    IF l_account_exists = 0 THEN
        raise ex_account_not_found;
    END IF;
    
    -- Getting the next sequence id value for the output paramater "p_address_id":
    p_address_id := ADDRESS_SEQ.nextval;
    
    INSERT INTO ua_address (
        address_id,
        address_first_name,
        address_last_name,
        address_line_1,
        address_line_2,
        address_city,
        address_state_province,
        address_postal_code,
        address_country,
        address_phone,
        account_id
    ) VALUES (
        p_address_id,
        p_first_name,
        p_last_name,
        p_line_1,
        p_line_2,
        p_city,
        p_state_province,
        p_postal_code,
        p_country,
        p_phone,
        p_account_ID
     );
    
    COMMIT;
    
    EXCEPTION
        WHEN ex_null_value THEN
            dbms_output.put_line('Missing mandatory value for parameter: ' 
                                || l_error
                                || ' in ADD_ADDRESS_SP.  No ADDRESS added.');
        WHEN ex_account_not_found THEN
            dbms_output.put_line('Account: ' || p_account_ID || ' was not found!');
        
END;
/

/*
CREATE_COLLECTION_SP.  Create a new collection in the UA_COLLECTION table.  This procedure returns the identifier 
for the new collection.  Duplicate collection names are not permitted.

    Error text:  "Missing mandatory value for parameter (x) in CREATE_COLLECTION_SP.  No collection added."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandatory value is not provided, no data are inserted into the UA_COLLECTION table.  The 
       p_collection_id value returned is NULL.
       
    Error text:  "Collection name (x) is already used."
    Error meaning:  Because the collection name must be unique, trying to insert a new collection with the same 
        name is not allowed.  Here x = the name of the collection being created.
    Error effect:  No new collection inserted into the UA_COLLECTION table.  The value of p_collection_id is NULL.
*/

create or replace procedure create_collection_sp (
 p_collection_id    OUT INTEGER,            -- an output parameter.  Value generated by the procedure.
 p_name             IN VARCHAR,             -- must not be NULL.  Must be UNIQUE
 p_description      IN CLOB,
 p_create_date      IN DATE
)
IS
BEGIN
    NULL;
END;
/

/*
ADD_ART_COLLECTION_SP.  Add a work of art to a collection in the UA_ART_COLLECTION.  Given the identifier of a work of art 
and the name of a collection, add the work of art to the collection.

    Error text:  "Missing mandatory value for parameter (x) in ADD_ART_COLLECTION_SP."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandatory value is not provided, no data are inserted into the UA_ART_COLLECTION table.  
       
    Error text:  "Collection (x) was not found."
    Error meaning:  The row must be associated with an existing collection.  Here x = the collection_id that is missing.  
    Error effect:  No new row inserted into the UA_ART_COLLECTION table.  
    
    Error text:  "Artwork (x) was not found."
    Error meaning:  The row must be associated with an existing work of art.  Here x = the artwork_id that is missing.  
    Error effect:  No new row inserted into the UA_ART_COLLECTION table.  
*/
create or replace procedure add_art_collection_sp (
 p_collection_id    IN INTEGER,             -- must not be NULL.
 p_artwork_id       IN INTEGER              -- must not be NULL.
)
IS
BEGIN
    NULL;
END;
/
/*
REMOVE_ART_COLLECTION_SP.  Remove a work of art from a collection, using the UA_ART_COLLECTION table.  Given the identifier 
of a work of art and the name of a collection, remove the work of art from the collection.  If a work of art is not 
part of a given collection, no action is taken.

    Error text:  "Missing mandatory value for parameter (x) in REMOVE_ART_COLLECTION_SP."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  No change is made to the UA_ART_COLLECTION.  
       
*/
create or replace procedure remove_art_collection_sp (
 p_collection_id IN INTEGER,             -- must not be NULL.
 p_artwork_id    IN INTEGER              -- must not be NULL.
)
IS
BEGIN
    NULL;
END;
/

/*
ADD_INTEREST_SP.  Add an expression of interest. Given the identifier of a work of art, the name and email of the 
interested party (which could be different from the account holder name and email), this procedure inserts a row 
in the UA_INTEREST table.

    Error text:  "Missing mandatory value for parameter (x) in ADD_INTEREST_SP."
    Error meaning:  A mandatory value is missing.  Here x = the name of the parameter whose value is missing.
    Error effect:  Because a mandatory value is not provided, no data are inserted into the UA_INTEREST table.  
       
    Error text:  "Account (x) was not found."
    Error meaning:  The row must be associated with an existing account.  Here x = the account_id that is not found.  
    Error effect:  No new row inserted into the UA_INTEREST table.  
    
    Error text:  "Artwork (x) was not found."
    Error meaning:  The row must be associated with an existing work of art.  Here x = the artwork_id that is missing.  
    Error effect:  No new row inserted into the UA_INTEREST table.  
*/

create or replace procedure add_interest_sp (

 p_artwork_id       IN INTEGER,             -- must not be NULL.
 p_account_id       IN INTEGER,             -- must not be NULL.
 p_name             IN VARCHAR,
 p_email            IN VARCHAR
)
IS
    l_artwork_exists        NUMBER(1);
    l_account_exists        NUMBER(1);
    l_interest_exists       NUMBER(1);
    l_error                 VARCHAR(30);
    
    ex_null_value           EXCEPTION;
    ex_artwork_not_found    EXCEPTION;
    ex_account_not_found    EXCEPTION;
    ex_interest_not_unique  EXCEPTION; -- To handle exceptions with not unique primary key.

    PRAGMA EXCEPTION_INIT(ex_null_value, -20020);
    PRAGMA EXCEPTION_INIT(ex_account_not_found, -20021);
    PRAGMA EXCEPTION_INIT(ex_artwork_not_found, -20022); 
    
BEGIN
    -- Checking input parameters
    IF p_artwork_id IS NULL THEN 
        l_error := 'p_artwork_id';
        raise ex_null_value;
   
    ELSIF p_account_id IS NULL THEN
        l_error := 'p_account_id';
        raise ex_null_value;
    
    END IF;
    -- Checking if artwork and account exists in database.
    SELECT COUNT(*) INTO l_artwork_exists
    FROM ua_artwork
    WHERE artwork_id = p_artwork_id;
    
    SELECT COUNT(*) INTO l_account_exists
    FROM ua_account
    WHERE account_id = p_account_id;
    
    -- Checking if this interest allready exists in database (extra check- not a part of assignment 2). 
    SELECT COUNT(*) INTO l_interest_exists
    FROM ua_interest
    WHERE artwork_id = p_artwork_id AND account_id = p_account_id;
    
    IF l_artwork_exists = 0 THEN
        l_error := 'p_artwork_id';
        raise ex_artwork_not_found;
    
    ELSIF l_account_exists = 0 THEN
        l_error := 'p_account';
        raise ex_account_not_found;
        
    ELSIF l_interest_exists != 0 THEN
        l_error := 'p_artwork_id/p_account_id';
        raise ex_interest_not_unique;
    END IF;
    
    INSERT INTO ua_interest (
        interest_name,
        interest_email,
        artwork_id,
        account_id
        ) VALUES (
            p_name,
            p_email,
            p_artwork_id,
            p_account_id
    );
    COMMIT;

EXCEPTION
    WHEN ex_null_value THEN
        dbms_output.put_line('Missing mandatory value for parameter: ' 
                                || l_error
                                || ' in ADD_INTEREST_SP.  No interest added.');
    WHEN ex_artwork_not_found THEN 
        dbms_output.put_line('Artwork: ' || p_artwork_id || ' was not found!');
        
    WHEN ex_account_not_found THEN
        dbms_output.put_line('Artwork: ' || p_account_id || ' was not found!');
        
    WHEN ex_interest_not_unique THEN
        dbms_output.put_line('Account: ' || p_account_id || ' is allready registered as interested in Artwork: '
                                         || p_artwork_id);                           
    
END;
/