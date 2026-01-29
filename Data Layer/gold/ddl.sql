/* =========================================================
   DIM_INF – Dimensão Infraestrutura
   ========================================================= */

CREATE TABLE IF NOT EXISTS dw.dim_inf
(
    "SRK_INF" bigint NOT NULL,
    "BNK" double precision,
    "BUS" double precision,
    "HSP" double precision,
    "MAL" double precision,
    "PRK" double precision,
    "RST" double precision,
    "SCH" double precision,
    "STN" double precision,
    "SUP" double precision,
    CONSTRAINT pk_dim_inf PRIMARY KEY ("SRK_INF")
);

ALTER TABLE dw.dim_inf OWNER TO postgres;


/* =========================================================
   DIM_LOC – Dimensão Local
   ========================================================= */

CREATE TABLE IF NOT EXISTS dw.dim_loc
(
    "SRK_LOC" bigint NOT NULL,
    "ZIP" bigint,
    "CTY" text,
    "CTY_FUL" text,
    CONSTRAINT pk_dim_loc PRIMARY KEY ("SRK_LOC")
);

ALTER TABLE dw.dim_loc OWNER TO postgres;


/* =========================================================
   DIM_SOC – Dimensão Socioeconômica
   ========================================================= */

CREATE TABLE IF NOT EXISTS dw.dim_soc
(
    "SRK_SOC" bigint NOT NULL,
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
    CONSTRAINT pk_dim_soc PRIMARY KEY ("SRK_SOC")
);

ALTER TABLE dw.dim_soc OWNER TO postgres;


/* =========================================================
   DIM_TMP – Dimensão Tempo
   ========================================================= */

CREATE TABLE IF NOT EXISTS dw.dim_tmp
(
    "SRK_TMP" bigint NOT NULL,
    "DAT" timestamp without time zone,
    "YEA" bigint,
    "MON" bigint,
    "SEA" text,
    CONSTRAINT pk_dim_tmp PRIMARY KEY ("SRK_TMP")
);

ALTER TABLE dw.dim_tmp OWNER TO postgres;


/* =========================================================
   FAT_HOU – Tabela Fato Imobiliária
   ========================================================= */

CREATE TABLE IF NOT EXISTS dw.fat_hou
(
    "SRK_TMP" bigint,
    "SRK_LOC" bigint,
    "SRK_INF" bigint,
    "SRK_SOC" bigint,

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

    CONSTRAINT fk_fat_tmp FOREIGN KEY ("SRK_TMP")
        REFERENCES dw.dim_tmp ("SRK_TMP"),

    CONSTRAINT fk_fat_loc FOREIGN KEY ("SRK_LOC")
        REFERENCES dw.dim_loc ("SRK_LOC"),

    CONSTRAINT fk_fat_inf FOREIGN KEY ("SRK_INF")
        REFERENCES dw.dim_inf ("SRK_INF"),

    CONSTRAINT fk_fat_soc FOREIGN KEY ("SRK_SOC")
        REFERENCES dw.dim_soc ("SRK_SOC")
);

ALTER TABLE dw.fat_hou OWNER TO postgres;


/* =========================================================
   Índices – Otimização de JOINs
   ========================================================= */

CREATE INDEX IF NOT EXISTS idx_fat_hou_srk_tmp
    ON dw.fat_hou ("SRK_TMP");

CREATE INDEX IF NOT EXISTS idx_fat_hou_srk_loc
    ON dw.fat_hou ("SRK_LOC");

CREATE INDEX IF NOT EXISTS idx_fat_hou_srk_inf
    ON dw.fat_hou ("SRK_INF");

CREATE INDEX IF NOT EXISTS idx_fat_hou_srk_soc
    ON dw.fat_hou ("SRK_SOC");
