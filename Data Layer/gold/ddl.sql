-- Table: dw.dim_infra

-- DROP TABLE IF EXISTS dw.dim_infra;

CREATE TABLE IF NOT EXISTS dw.dim_infra
(
    "SRK_INFRA" bigint NOT NULL,
    "BNK" double precision,
    "BUS" double precision,
    "HSP" double precision,
    "MAL" double precision,
    "PRK" double precision,
    "RST" double precision,
    "SCH" double precision,
    "STN" double precision,
    "SUP" double precision,
    CONSTRAINT pk_dim_infra PRIMARY KEY ("SRK_INFRA")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_infra
    OWNER to postgres;

    -- Table: dw.dim_local

-- DROP TABLE IF EXISTS dw.dim_local;

CREATE TABLE IF NOT EXISTS dw.dim_local
(
    "SRK_LOCAL" bigint NOT NULL,
    "ZIP" bigint,
    "CTY" text COLLATE pg_catalog."default",
    "CTY_FUL" text COLLATE pg_catalog."default",
    CONSTRAINT pk_dim_local PRIMARY KEY ("SRK_LOCAL")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_local
    OWNER to postgres;

    -- Table: dw.dim_socio

-- DROP TABLE IF EXISTS dw.dim_socio;

CREATE TABLE IF NOT EXISTS dw.dim_socio
(
    "SRK_SOCIO" bigint NOT NULL,
    "TOT_POP" double precision,
    "MED_AGE" double precision,
    "PER_INC" double precision,
    "TOT_FAM_POV" double precision,
    "TOT_HOU_UNT" double precision,
    "TOT_LAB_FOR" double precision,
    "UNE_POP" double precision,
    "TOT_SCH_AGE" double precision,
    "TOT_SCH_ENR" double precision,
    "MED_COM_TIM" double precision,
    CONSTRAINT pk_dim_socio PRIMARY KEY ("SRK_SOCIO")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.dim_socio
    OWNER to postgres;

    -- Table: dw.dim_tempo

-- DROP TABLE IF EXISTS dw.dim_tempo;

CREATE TABLE IF NOT EXISTS dw.dim_tempo
(
    "SRK_TEMPO" bigint NOT NULL,
    "DAT" timestamp without time zone,
    "YEA" bigint,
    "MON" bigint,
    "SEA" text COLLATE pg_catalog."default",
    CONSTRAINT pk_dim_tempo PRIMARY KEY ("SRK_TEMPO")
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
    "OFF_MKT_TWK" double precision,
    CONSTRAINT fk_fato_infra FOREIGN KEY ("SRK_INFRA")
        REFERENCES dw.dim_infra ("SRK_INFRA") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_fato_local FOREIGN KEY ("SRK_LOCAL")
        REFERENCES dw.dim_local ("SRK_LOCAL") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_fato_socio FOREIGN KEY ("SRK_SOCIO")
        REFERENCES dw.dim_socio ("SRK_SOCIO") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_fato_tempo FOREIGN KEY ("SRK_TEMPO")
        REFERENCES dw.dim_tempo ("SRK_TEMPO") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS dw.fat_houses
    OWNER to postgres;
-- Index: idx_fato_srk_infra

-- DROP INDEX IF EXISTS dw.idx_fato_srk_infra;

CREATE INDEX IF NOT EXISTS idx_fato_srk_infra
    ON dw.fat_houses USING btree
    ("SRK_INFRA" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_fato_srk_local

-- DROP INDEX IF EXISTS dw.idx_fato_srk_local;

CREATE INDEX IF NOT EXISTS idx_fato_srk_local
    ON dw.fat_houses USING btree
    ("SRK_LOCAL" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_fato_srk_socio

-- DROP INDEX IF EXISTS dw.idx_fato_srk_socio;

CREATE INDEX IF NOT EXISTS idx_fato_srk_socio
    ON dw.fat_houses USING btree
    ("SRK_SOCIO" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: idx_fato_srk_tempo

-- DROP INDEX IF EXISTS dw.idx_fato_srk_tempo;

CREATE INDEX IF NOT EXISTS idx_fato_srk_tempo
    ON dw.fat_houses USING btree
    ("SRK_TEMPO" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;