-- Table: dw.dim_infra

-- DROP TABLE IF EXISTS dw.dim_infra;

CREATE TABLE IF NOT EXISTS dw.dim_infra
(
    "SRK_INFRA" bigint,
    "BNK" double precision,
    "BUS" double precision,
    "HSP" double precision,
    "MAL" double precision,
    "PRK" double precision,
    "RST" double precision,
    "SCH" double precision,
    "STN" double precision,
    "SUP" double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_infra
    OWNER to postgres;

-- Table: dw.dim_local

-- DROP TABLE IF EXISTS dw.dim_local;

CREATE TABLE IF NOT EXISTS dw.dim_local
(
    "SRK_LOCAL" bigint,
    "ZIP" bigint,
    "CTY" text COLLATE pg_catalog."default",
    "CTY_FUL" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_local
    OWNER to postgres;

-- Table: dw.dim_socio

-- DROP TABLE IF EXISTS dw.dim_socio;

CREATE TABLE IF NOT EXISTS dw.dim_socio
(
    "SRK_SOCIO" bigint,
    "TOT_POP" double precision,
    "MED_AGE" double precision,
    "PER_INC" double precision,
    "TOT_FAM_POV" double precision,
    "TOT_HOU_UNT" double precision,
    "TOT_LAB_FOR" double precision,
    "UNE_POP" double precision,
    "TOT_SCH_AGE" double precision,
    "TOT_SCH_ENR" double precision,
    "MED_COM_TIM" double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_socio
    OWNER to postgres;

-- Table: dw.dim_tempo

-- DROP TABLE IF EXISTS dw.dim_tempo;

CREATE TABLE IF NOT EXISTS dw.dim_tempo
(
    "SRK_TEMPO" bigint,
    "DAT" timestamp without time zone,
    "YEA" bigint,
    "MON" bigint,
    "SEA" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_tempo
    OWNER to postgres;

-- Table: dw.fat_houses

-- DROP TABLE IF EXISTS dw.fat_houses;

CREATE TABLE IF NOT EXISTS dw.fat_houses
(
    "SRK_TEMPO" bigint,
    "SRK_LOCAL" bigint,
    "SRK_INFRA" bigint,
    "SRK_SOCIO" bigint,
    "MED_SAL_PRC" double precision,
    "MED_LST_PRC" double precision,
    "AVG_PRC" double precision,
    "MED_PSF" double precision,
    "MED_LST_PSF" double precision,
    "MED_RNT" double precision,
    "MED_HOM_VAL" double precision,
    "HOM_SOL" double precision,
    "PEN_SAL" double precision,
    "NEW_LST" double precision,
    "INV" double precision,
    "MED_DOM" double precision,
    "AVG_SAL_LST" double precision,
    "SOL_ABV_LST" double precision,
    "OFF_MKT_TWK" double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.fat_houses
    OWNER to postgres;