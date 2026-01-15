-- Table: silver.silver_houses

-- DROP TABLE IF EXISTS silver.silver_houses;

CREATE TABLE IF NOT EXISTS silver.silver_houses
(
    date timestamp without time zone,
    median_sale_price double precision,
    median_list_price double precision,
    median_ppsf double precision,
    median_list_ppsf double precision,
    homes_sold double precision,
    pending_sales double precision,
    new_listings double precision,
    inventory double precision,
    median_dom double precision,
    avg_sale_to_list double precision,
    sold_above_list double precision,
    off_market_in_two_weeks double precision,
    city text COLLATE pg_catalog."default",
    zipcode bigint,
    year bigint,
    bank double precision,
    bus double precision,
    hospital double precision,
    mall double precision,
    park double precision,
    restaurant double precision,
    school double precision,
    station double precision,
    supermarket double precision,
    total_population double precision,
    median_age double precision,
    per_capita_income double precision,
    total_families_below_poverty double precision,
    total_housing_units double precision,
    median_rent double precision,
    median_home_value double precision,
    total_labor_force double precision,
    unemployed_population double precision,
    total_school_age_population double precision,
    total_school_enrollment double precision,
    median_commute_time double precision,
    price double precision,
    city_full text COLLATE pg_catalog."default",
    month integer,
    season text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.silver_houses
    OWNER to postgres;