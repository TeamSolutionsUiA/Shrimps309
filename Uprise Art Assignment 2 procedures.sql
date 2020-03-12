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
/*
sequence artist_seq 
	START WITH 54 
	INCREMENT BY 1;
*/
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
    ex_invalid_date EXCEPTION;
    ex_invalid_uk EXCEPTION;
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
        raise ex_invalid_uk;
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
        ROLLBACK;
        
    WHEN ex_invalid_date THEN
        dbms_output.put_line('Invalid value '
                             || l_error
                             || ' for birth year in CREATE_ARTIST_SP.');
        ROLLBACK;
        
    WHEN ex_invalid_uk THEN
        dbms_output.put_line('Tax ID '
                             || l_error
                             || ' is already used.');
        ROLLBACK;                     
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

-- Ole Christian
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
    l_error          VARCHAR(200);
    l_rows          NUMBER(1);
    
    ex_null_value EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_null_value, -20001);
    ex_negative_num EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_negative_num, -20002);
    ex_invalid_size EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_invalid_size, -20003);
    ex_invalid_creation_year EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_invalid_creation_year, -20004);
    ex_date_not_in_past EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_date_not_in_past, -20005);
    
    ex_no_matching_medium EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_no_matching_medium, -20006);
    ex_no_matching_artist EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_no_matching_artist, -20007);
    ex_invalid_status EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_invalid_status, -20008);
    
    CHECK_CONSTRAINT_VIOLATED EXCEPTION;
      PRAGMA EXCEPTION_INIT(CHECK_CONSTRAINT_VIOLATED, -2290);
BEGIN
    -- Exception handling:
    -- Ex1: Input parameter checks: not null
    IF p_title IS NULL THEN
        l_error := 'p_title';
        raise ex_null_value;
    ELSIF p_aquisition_date IS NULL THEN
        l_error := 'p_aquisition_date';
        raise ex_null_value;
    ELSIF p_photo_url IS NULL THEN
        l_error := 'p_photo_url';
        raise ex_null_value;
    ELSIF p_status IS NULL THEN
        l_error := 'p_status';
        raise ex_null_value;
    ELSIF p_artist_id IS NULL THEN
        l_error := 'p_artist_id';
        raise ex_null_value;
    END IF;
    
    -- Ex2: Artist check
    SELECT COUNT(*) INTO l_rows FROM ua_artist
    WHERE artist_id = p_artist_id;
    IF l_rows != 1 THEN
        l_error := p_artist_id;
        raise ex_no_matching_artist;
    END IF;
    
    -- Ex3: Medium
    SELECT COUNT(*) INTO l_rows FROM ua_medium
    WHERE medium_name = p_medium_name;
    IF l_rows != 1 THEN
        l_error := p_medium_name;
        raise ex_no_matching_medium;
    END IF;
    
    -- Ex4: current_date year >= creation year >= 2000
    IF (p_creation_year <= 2000 AND  p_creation_year <= EXTRACT(YEAR FROM CURRENT_DATE())) THEN
        raise ex_invalid_creation_year;
    END IF;
    
    -- Ex5: acquisition date is not in past
    IF (p_aquisition_date > CURRENT_DATE()) THEN
        raise ex_date_not_in_past;
    END IF;
    
    -- Ex6: negative numbers
    IF (p_size_height IS NOT NULL AND p_size_height < 0) 
        OR (p_size_width IS NOT NULL AND p_size_width < 0) 
        OR (p_size_depth IS NOT NULL AND p_size_depth < 0) THEN
        
        raise ex_negative_num;
    END IF;
    
    -- Ex7: size category validation
    IF p_size_category NOT IN ('Large', 'Medium', 'Oversized', 'Small') THEN
        raise ex_invalid_size;
    END IF;
    
    -- Ex8: artwork status validation
    IF p_status NOT IN ('For sale', 'Sold out', 'Unavailable') THEN
        raise ex_invalid_status;
    END IF;
    
    p_artwork_id := ARTWORK_SEQ.nextval;
    
    INSERT INTO ua_artwork (
        artwork_id,
        artwork_title,
        artwork_price,
        artwork_size_height,
        artwork_size_width,
        artwork_size_depth,
        artwork_size_category,
        artwork_creation_year,
        artwork_acquisition_date,
        artwork_materials,
        artwork_framed,
        medium_name,
        artwork_photo_url,
        artwork_quantity_on_hand,
        artwork_status,
        artist_id
    ) VALUES (
        p_artwork_id,
         p_title,
         p_price,
         p_size_height,
         p_size_width,
         p_size_depth,
         p_size_category,
         p_creation_year,
         p_aquisition_date,
         p_materials,
         p_framed,
         p_medium_name,
         p_photo_url,
         p_quantity_on_hand,
         p_status,
         p_artist_id
    );
    COMMIT;
EXCEPTION
    WHEN ex_null_value THEN
        dbms_output.put_line('Missing mandatory value for parameter ' || l_error || ' in CREATE_ACCOUNT_SP. No account added.');
        ROLLBACK;
    WHEN ex_no_matching_artist THEN
        dbms_output.put_line('Invalid artist (' || l_error || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_no_matching_medium THEN
        dbms_output.put_line('Invalid medium (' || l_error || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_invalid_creation_year THEN
        dbms_output.put_line('Invalid creation year (' || p_creation_year || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_date_not_in_past THEN
        dbms_output.put_line('Invalid acquisition date (' || p_aquisition_date || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_negative_num THEN
        dbms_output.put_line('All size parameters must be 0 or greater (or null) in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_invalid_size THEN
        dbms_output.put_line('Invalid artwork size category (' || p_size_category || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    WHEN ex_invalid_status THEN
        dbms_output.put_line('Invalid artwork status (' || p_status || ') in CREATE_ARTWORK_SP.');
        ROLLBACK;
    
    WHEN CHECK_CONSTRAINT_VIOLATED THEN
        dbms_output.put_line('INSERT failed due to check constraint violation');
        ROLLBACK;
    WHEN OTHERS THEN                  
        dbms_output.put_line('Something else went wrong - ' || SQLCODE || ' : ' || SQLERRM);
        ROLLBACK;
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

-- Ole Christian
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
    l_error         VARCHAR(20);
    l_rows          NUMBER(1);
    ex_null_value   EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_null_value, -20001);
    ex_not_unique   EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_not_unique, -20002);
BEGIN
    -- Input parameter checks:
    IF p_first_name IS NULL THEN
        l_error := 'p_first_name';
        raise ex_null_value;
    ELSIF p_last_name IS NULL THEN
        l_error := 'p_last_name';
        raise ex_null_value;
    ELSIF p_email IS NULL THEN
        l_error := 'p_email';
        raise ex_null_value;
    ELSIF p_password IS NULL THEN
        l_error := 'p_password';
        raise ex_null_value;
    END IF;
    
    
    --Check if email is unique
    SELECT COUNT(*) INTO l_rows
    FROM ua_account
    WHERE account_email = p_email;
    
    IF l_rows != 0 THEN
        l_error := p_email;
        raise ex_not_unique;
        p_account_id := NULL;
    ELSE
        -- Get next index in the sequence and 
        p_account_id := ACCOUNT_SEQ.nextval;
    END IF;
    
    
    
    --Insert
    INSERT INTO ua_account (
        account_id,
        account_first_name,
        account_last_name,
        account_email,
        account_password,
        account_occupation,
        account_website,
        account_referred_by,
        account_artwork_loved
    ) VALUES (
        p_account_id,
        p_first_name,
        p_last_name,
        p_email,
        p_password,
        p_occupation,
        p_website,
        p_referred_by,
        p_artwork_loved
    );
    COMMIT;
    
EXCEPTION
    WHEN ex_null_value THEN
        dbms_output.put_line('Missing mandatory value for parameter ' || l_error || ' in CREATE_ACCOUNT_SP. No account added.'); 
        ROLBACK;
        
    WHEN ex_not_unique THEN
        dbms_output.put_line('Email ' || l_error || ' is already used ');
        ROLLBACK;
    
    WHEN OTHERS THEN                  
        dbms_output.put_line('Something else went wrong - ' || SQLCODE || ' : ' || SQLERRM);
        ROLLBACK;
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
            ROLLBACK;
            
        WHEN ex_account_not_found THEN
            dbms_output.put_line('Account: ' || p_account_ID || ' was not found!');
            ROLLBACK;
        
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
test_exst number(1);
ID_return UA_COLLECTION.COLLECTION_ID%TYPE;

    NO_DATA_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(NO_DATA_FOUND, -20001);
    NAME_EXSIStS EXCEPTION;
    PRAGMA EXCEPTION_INIT(NAME_EXSIStS, -20002);

BEGIN
  -- no null values 
    IF p_name IS NULL THEN
        raise NO_DATA_FOUND;
    ELSIF p_description IS NULL THEN
        raise NO_DATA_FOUND;
    ELSIF p_create_date IS NULL THEN
        raise NO_DATA_FOUND;
    END IF;
-- Not same name
    SELECT COUNT(*)
    into test_exst
    FROM
     UA_COLLECTION
    WHERE
       UA_COLLECTION.COLLECTION_NAME = p_name;

--not same name if
    IF test_exst !=0 then
    raise NAME_EXSIStS;
    END IF;
    p_collection_id:=COLLECTION_SEQ.nextval;

--insert
    INSERT INTO UA_COLLECTION (
    COLLECTION_ID,
    COLLECTION_NAME,
    COLLECTION_DESCRIPTION,
    COLLECTION_CREATE_DATE
    ) VALUES (
    p_collection_id,
    p_name,
    p_description,
    p_create_date
    );
    COMMIT;
 -- ADD ID FOR the new colletion  
    select COLLECTION_ID into ID_return
    from UA_COLLECTION
    where COLLECTION_NAME=p_name;
 dbms_output.put_line('Colletion have been added whit the following id'||ID_return); 


--Exception not wokring?
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('Missing mandatory value for parameter'
    ||'All data filed have too be filed'||'no data added');
    ROLLBACK;
        
    WHEN NAME_EXSIStS THEN
    dbms_output.put_line('Missing mandatory value for parameter '
    ||'COLLATION NAME IS ALLREADY IN USE'||'no data added. Please pick a diffrent name then:'||p_name);
   ROLLBACK;

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
    l_error varchar(20);
    l_exst number(1);
    ex_null_value EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_null_value, -20001 );
    ex_collection_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_collection_not_found, -20002 );
    ex_artwork_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_artwork_not_found, -20003 );
BEGIN
    IF p_collection_id IS NULL THEN
        l_error := 'p_collection_id';
        raise ex_null_value;
    ELSIF p_artwork_id IS NULL THEN
        l_error := 'p_artwork_id';
        raise ex_null_value;
    END IF;
    
    SELECT
        COUNT(*)
    INTO l_exst
    FROM
        ua_collection
    WHERE
        collection_id = p_collection_id;
    IF l_exst != 1 THEN
        l_error := p_collection_id;
        raise ex_collection_not_found;
    END IF;
    
    l_exst := 0;
    SELECT
        COUNT(*)
    INTO l_exst
    FROM
        ua_artwork
    WHERE
        artwork_id = p_artwork_id;
    IF l_exst != 1 THEN
        l_error := p_artwork_id;
        raise ex_artwork_not_found;
    END IF;
    
    INSERT INTO 
        ua_art_collection 
    VALUES (
        p_collection_id,
        p_artwork_id
    );
    
    COMMIT;
EXCEPTION
    WHEN ex_null_value THEN
        dbms_output.put_line('Missing mandatory value for parameter '
                             || l_error
                             || ' in ADD_ART_COLLECTION_SP.');
        ROLLBACK;
        
    WHEN ex_collection_not_found THEN
        dbms_output.put_line('Collection '
                             || l_error
                             || ' was not found.');
        ROLLBACK;
        
    WHEN ex_artwork_not_found THEN
        dbms_output.put_line('Artwork '
                             || l_error
                             || ' was not found.');
        ROLLBACK;                     
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
create or replace procedure         remove_art_collection_sp (
             -- must not be NULL.
 p_artwork_id    UA_ART_COLLECTION.ARTWORK_ID%TYPE,              -- must not be NULL.
 p_collection_id  UA_COLLECTION.COLLECTION_ID%TYPE  --NOTE!!  This should be COLLECTION_ID, not _NAME
)
IS
p_collection_id_test  number(1);
p_artwork_id_test    number(1);   
p_artwork_id_in_collection_test    number(1);
NO_DATA_FOUND EXCEPTION;
PRAGMA EXCEPTION_INIT(NO_DATA_FOUND, -20001);
COLLETCION_NOT_FOUND EXCEPTION;
PRAGMA EXCEPTION_INIT(COLLETCION_NOT_FOUND, -20002);
ARTWORK_NOT_FOUND EXCEPTION;
PRAGMA EXCEPTION_INIT(ARTWORK_NOT_FOUND, -20003);
ARTWORK_NOT_FOUND_IN_COLLECTION EXCEPTION;
PRAGMA EXCEPTION_INIT(ARTWORK_NOT_FOUND, -20004);
BEGIN
    IF p_collection_id IS NULL THEN
        raise NO_DATA_FOUND;
    ELSIF p_artwork_id IS NULL THEN
        raise NO_DATA_FOUND;
    END IF;   
    
    select COUNT(*) into p_collection_id_test
    from UA_COLLECTION
    where p_collection_id =COLLECTION_ID;
    
    select COUNT(*) into p_artwork_id_test
    from UA_ARTWORK
    where p_artwork_id =ARTWORK_ID;
    
    select COUNT(*) into p_artwork_id_in_collection_test
    from UA_ART_COLLECTION
    where p_artwork_id =ARTWORK_ID AND p_collection_id =COLLECTION_ID;
    
    IF p_artwork_id_test =0 then
    raise ARTWORK_NOT_FOUND;
    END IF;
    
    
    IF p_collection_id_test =0 then
    raise COLLETCION_NOT_FOUND;
    END IF;
    
    IF p_artwork_id_in_collection_test =0 then
    raise ARTWORK_NOT_FOUND_IN_COLLECTION;
    END IF;
    DELETE FROM UA_ART_COLLECTION
    where p_collection_id = UA_ART_COLLECTION.COLLECTION_ID AND UA_ART_COLLECTION.ARTWORK_ID = p_artwork_id;
    
    
-- DELETE
   
    dbms_output.put_line('ARTWORK Whit the follwing id '||p_artwork_id||' is removed from '||p_collection_id); 
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('Missing mandatory value for parameter'||'All data filed have too be filed '||'no data Removed ');
    ROLLBACK;
    WHEN COLLETCION_NOT_FOUND THEN
    dbms_output.put_line('Collection dose not exsist'||'no data Removed ');
    ROLLBACK;
   
    WHEN ARTWORK_NOT_FOUND THEN
    dbms_output.put_line('Artwork dose not exsist'||'no data Removed ');
    ROLLBACK;
    
    WHEN ARTWORK_NOT_FOUND_IN_COLLECTION THEN
    dbms_output.put_line('Artwork dose not exsist in collection'||'no data Removed ');
    ROLLBACK;

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
        ROLLBACK;
        
    WHEN ex_artwork_not_found THEN 
        dbms_output.put_line('Artwork: ' || p_artwork_id || ' was not found!');
        ROLLBACK;
        
    WHEN ex_account_not_found THEN
        dbms_output.put_line('Artwork: ' || p_account_id || ' was not found!');
        ROLLBACK;
        
    WHEN ex_interest_not_unique THEN
        dbms_output.put_line('Account: ' || p_account_id || ' is allready registered as interested in Artwork: '
                                         || p_artwork_id);
        ROLLBACK;                                 
    
END;
/