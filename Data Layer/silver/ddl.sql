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
    "total population" double precision,
    "median age" double precision,
    "per capita income" double precision,
    "total families below poverty" double precision,
    "total housing units" double precision,
    "median rent" double precision,
    "median home value" double precision,
    "total labor force" double precision,
    "unemployed population" double precision,
    "total school age population" double precision,
    "total school enrollment" double precision,
    "median commute time" double precision,
    price double precision,
    city_full text COLLATE pg_catalog."default",
    month integer,
    season text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.silver_houses
    OWNER to postgres;