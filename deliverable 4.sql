-- Task 2A and 2B
-- Size = Initial size + 2 years growth.
CREATE TABLESPACE UA_64
DATAFILE '/u01/app/oracle/oradata/WOLCOTTDB/Shrimps_UA_64.dbf'
SIZE 2112K AUTOEXTEND ON
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE UA_128
DATAFILE '/u01/app/oracle/oradata/WOLCOTTDB/Shrimps_UA_128.dbf'
SIZE 4736K AUTOEXTEND ON
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE UA_256
DATAFILE '/u01/app/oracle/oradata/WOLCOTTDB/Shrimps_UA_256.dbf'
SIZE 12544K AUTOEXTEND ON
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE UA_512
DATAFILE '/u01/app/oracle/oradata/WOLCOTTDB/Shrimps_UA_512.dbf'
SIZE 40M AUTOEXTEND ON
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 512K
SEGMENT SPACE MANAGEMENT AUTO;

-- Give Quotas to user on the tablespaces:
ALTER USER shrimps QUOTA 100M ON UA_64;
ALTER USER shrimps QUOTA 100M ON UA_128;
ALTER USER shrimps QUOTA 100M ON UA_256;
ALTER USER shrimps QUOTA 100M ON UA_512;

ALTER USER shrimps QUOTA 100M ON users;
ALTER USER shrimps QUOTA 100M ON indx;

--TASK 3
--Move tables to correct tablespace
ALTER TABLE ua_account MOVE
PCTFREE 20
STORAGE(INITIAL 6656K NEXT 512K)
TABLESPACE UA_512;

ALTER TABLE ua_address MOVE
PCTFREE 5
STORAGE(INITIAL 9216K NEXT 512K)
TABLESPACE UA_512;

ALTER TABLE ua_art_collection MOVE
PCTFREE 0
STORAGE(INITIAL 128K NEXT 64K)
TABLESPACE UA_64;

ALTER TABLE ua_art_event MOVE
PCTFREE 0
STORAGE(INITIAL 384K NEXT 64K)
TABLESPACE UA_64;

ALTER TABLE ua_artist MOVE
PCTFREE 10
STORAGE(INITIAL 6144K NEXT 256K)
TABLESPACE UA_256;

ALTER TABLE ua_artwork MOVE
PCTFREE 5
STORAGE(INITIAL 11264K NEXT 512K)
TABLESPACE UA_512;

ALTER TABLE ua_collection MOVE
PCTFREE 5
STORAGE(INITIAL 128K NEXT 64K)
TABLESPACE UA_64;

ALTER TABLE ua_credit_card MOVE
PCTFREE 0
STORAGE(INITIAL 2048K NEXT 128K)
TABLESPACE UA_128;

ALTER TABLE ua_event MOVE
PCTFREE 20
STORAGE(INITIAL 128K NEXT 64K)
TABLESPACE UA_64;

ALTER TABLE ua_interest MOVE
PCTFREE 0
STORAGE(INITIAL 4352K NEXT 256K)
TABLESPACE UA_256;

ALTER TABLE ua_medium MOVE
PCTFREE 0
STORAGE(INITIAL 64K NEXT 64K)
TABLESPACE UA_64;

ALTER TABLE ua_order_detail MOVE
PCTFREE 0
STORAGE(INITIAL 1664K NEXT 128K)
TABLESPACE UA_128;

ALTER TABLE ua_order_transaction MOVE
PCTFREE 5
STORAGE(INITIAL 5632K NEXT 512K)
TABLESPACE UA_512;

-- task 4
-- checking tablespace status:
SELECT table_name, index_name, status, tablespace_name FROM user_indexes;
-- The status on the tables that has been moved is "unusable"

--Moving all indexes to new index table
ALTER INDEX UA_ACCOUNT_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ACCOUNT_ACCOUNT_EMAIL_UN
REBUILD TABLESPACE indx;

ALTER INDEX UA_ADDRESS_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ARTIST_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ARTWORK_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ART_COLLECCTION_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ART_EVENT_PK
REBUILD TABLESPACE indx;

ALTER INDEX PK_CART_ITEM
REBUILD TABLESPACE indx;

ALTER INDEX UA_COLLECTION_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_COLLECTION_NAME_UNIQUE
REBUILD TABLESPACE indx;

ALTER INDEX CREDIT_CARD_PKV2
REBUILD TABLESPACE indx;

ALTER INDEX UA_EVENT_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_INTEREST_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_MEDIUM_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ORDER_DETAIL_PK
REBUILD TABLESPACE indx;

ALTER INDEX UA_ORDER_TRANSACTION_PK
REBUILD TABLESPACE indx;

-- checking tablespace status again:
SELECT table_name, index_name, status, tablespace_name FROM user_indexes;
-- The status on all tables in index is now updated and valid.

--Task 5A:
-- Create reader role, with privileges to login and read all tables in shrimps schema.
CREATE ROLE role_reader;
GRANT CREATE SESSION TO role_reader;

BEGIN
    FOR o IN (SELECT * FROM user_tables)
    LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || o.table_name || ' TO role_reader';
    END LOOP;
END;

--     5B:
CREATE ROLE role_uprise_art_admin;
GRANT EXECUTE ON upriseart3B_pkg TO role_uprise_art_admin; 

--     5C:
CREATE ROLE role_artist_admin; 
--GRANT EXECUTE ON upriseart3B_pkg.create_collection_pp TO role_artist_admin; 
--GRANT EXECUTE ON upriseart3B_pkg.create_artist_pp TO role_artist_admin;
--GRANT EXECUTE ON upriseart3B_pkg.create_artwork_pp TO role_artist_admin;
--GRANT EXECUTE ON upriseart3B_pkg.add_art_collection_pp TO role_artist_admin; 

--    5D:
        -- The Create_event procedure is not created in the package.
        -- It`s not possible to grant privileges to single procedures in a package.
--    5E:
        -- Solution: Make a new package with wrapper procedures for the needed procedures and then grant excecute 
        -- privileges to that package.

--Task 6:
--Create default profile:
CREATE PROFILE profile_default 
LIMIT 
   SESSIONS_PER_USER          5 
   CPU_PER_SESSION            10000
   IDLE_TIME                  30
   CONNECT_TIME               720
   CPU_PER_CALL               1000;

CREATE USER shrimps_1
IDENTIFIED BY shrimpspw
DEFAULT TABLESPACE users
QUOTA 0M ON users
PROFILE profile_default;
GRANT role_reader TO shrimps_1;

CREATE USER shrimps_2
IDENTIFIED BY shrimpspw2
DEFAULT TABLESPACE users
QUOTA 150M ON users
PROFILE profile_default;
GRANT role_uprise_art_admin TO shrimps_2;





