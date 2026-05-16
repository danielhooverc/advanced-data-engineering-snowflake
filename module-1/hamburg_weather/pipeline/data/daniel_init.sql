use warehouse compute_wh;
use role accountadmin;


create or alter database {{env}}_demo;

create or alter schema {{env}}_demo.raw_data;



CREATE OR ALTER FILE FORMAT {{env}}_demo.raw_data.csv_ff
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';


CREATE OR REPLACE STAGE {{env}}_demo.raw_data.s3load
storage_integration = S3_ROLE_INTEGRATION
url= 's3://daniel-snowflake-demo/'
file_format = {{env}}_demo.raw_data.csv_ff;


CREATE TABLE IF NOT EXISTS {{env}}_demo.raw_data.customers(
customer_sk number autoincrement start 1 increment 1,
customer_id varchar,
customer_name varchar,
customer_segment varchar,
customer_city varchar,
customer_state varchar,
signup_date DATE,
is_active boolean
);

create or alter warehouse demo_build_wh
   WAREHOUSE_SIZE = 'xsmall'
   WAREHOUSE_TYPE = 'standard'
   AUTO_SUSPEND = 60
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED = TRUE;
;
--只是为了大规模数据上传；用完即删
USE WAREHOUSE demo_build_wh;


COPY INTO {{env}}_demo.raw_data.customers (
    customer_id ,
    customer_name ,
    customer_segment ,
    customer_city ,
    customer_state ,
    signup_date ,
    is_active 
)
FROM (
    SELECT
        $1::VARCHAR,
        $2::VARCHAR,
        $3::VARCHAR,
        $4::VARCHAR,
        $5::VARCHAR,
        TO_DATE($6, 'YYYY-MM-DD'),
        $7::BOOLEAN
    FROM @{{env}}_demo.raw_data.s3load/raw_customers.csv
);


drop warehouse demo_build_wh;
