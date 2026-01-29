/* =========================================================
   CONSULTA 1 - As 5 cidades MAIS BARATAS para comprar imóvel
   ========================================================= */


SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."MED_HOM_VAL") AS preco_medio_imovel
FROM dw.fat_hou f
JOIN dw.dim_loc l
    ON f."SRK_LOC" = l."SRK_LOC"
GROUP BY l."CTY_FUL"
ORDER BY preco_medio_imovel ASC
LIMIT 5;


/* =========================================================
   CONSULTA 2 - As 5 cidades MAIS CARAS para comprar imóvel
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."MED_HOM_VAL") AS preco_medio_imovel
FROM dw.fat_hou f
JOIN dw.dim_loc l
    ON f."SRK_LOC" = l."SRK_LOC"
GROUP BY l."CTY_FUL"
ORDER BY preco_medio_imovel DESC
LIMIT 5;


/* =========================================================
   CONSULTA 3 - As 5 Cidades com melhor custo 
   benefício em relação a infraestrutura. 
   ========================================================= */

WITH infra_preco AS (
    SELECT
        l."CTY_FUL" AS cidade,
        AVG(i."BNK"+i."BUS"+i."HSP"+i."MAL"+i."PRK"+i."RST"+i."SCH"+i."STN"+i."SUP") AS score_infra,
        AVG(f."MED_HOM_VAL") AS preco
    FROM dw.fat_hou f
    JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
    JOIN dw.dim_inf i ON f."SRK_INF" = i."SRK_INF"
    GROUP BY l."CTY_FUL"
),
normalizado AS (
    SELECT
        cidade,
        100 * (score_infra / NULLIF(preco,0))
        / MAX(score_infra / NULLIF(preco,0)) OVER () AS indice
    FROM infra_preco
)
SELECT
    cidade,
    ROUND(indice::numeric,2) AS indice_custo_beneficio
FROM normalizado
ORDER BY indice DESC
LIMIT 5;

/* =========================================================
   CONSULTA 4 - Taxa de imóveis vendidos acima do preço
   por cidade
   ========================================================= */
SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."SOL_ABV_LST") * 100 AS percentual
FROM dw.fat_hou f
JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
GROUP BY l."CTY_FUL"
ORDER BY percentual DESC;


/* =========================================================
   CONSULTA 5- O mês com a maior média de preço para cada ano 
   no período de 2019 a 2023 na cidade de Nova Iorque
   ========================================================= */

SELECT *
FROM (
    SELECT
        t."YEA",
        t."MON",
        l."CTY_FUL",
        AVG(f."AVG_PRC") AS preco,
        RANK() OVER (PARTITION BY t."YEA" ORDER BY AVG(f."AVG_PRC") DESC) AS rk
    FROM dw.fat_hou f
    JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
    JOIN dw.dim_tmp t ON f."SRK_TMP" = t."SRK_TMP"
    WHERE l."CTY_FUL" ILIKE '%new york%'
      AND t."YEA" BETWEEN 2019 AND 2023
    GROUP BY t."YEA", t."MON", l."CTY_FUL"
) x
WHERE rk = 1
ORDER BY "YEA" DESC;


/* =========================================================
   CONSULTA 6 - As 5 cidades com maior volume
   de vendas de imóveis
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    SUM(f."HOM_SOL") AS total_vendas
FROM dw.fat_hou f
JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
GROUP BY l."CTY_FUL"
ORDER BY total_vendas DESC
LIMIT 5;


/* =========================================================
   CONSULTA 7 - As 5 cidades com maior renda média
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    AVG(s."PER_INC") AS renda_media
FROM dw.fat_hou f
JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
JOIN dw.dim_soc s ON f."SRK_SOC" = s."SRK_SOC"
GROUP BY l."CTY_FUL"
ORDER BY renda_media DESC
LIMIT 5;


/* =========================================================
   CONSULTA 8 - Evolução do preço dos imóveis vs 
   infraestrutura ao longo do tempo
   ========================================================= */
WITH base AS (
    SELECT
        t."YEA" AS ano,
        l."CTY_FUL" AS cidade,
        AVG(f."MED_HOM_VAL") AS preco,
        AVG(i."BNK"+i."BUS"+i."HSP"+i."SCH"+i."SUP") AS infra
    FROM dw.fat_hou f
    JOIN dw.dim_tmp t ON f."SRK_TMP" = t."SRK_TMP"
    JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
    JOIN dw.dim_inf i ON f."SRK_INF" = i."SRK_INF"
    GROUP BY t."YEA", l."CTY_FUL"
)
SELECT
    ano,
    cidade,
    ROUND(preco::numeric,2) AS preco_medio,
    ROUND(infra::numeric,2) AS score_infra
FROM base
ORDER BY ano, preco_medio DESC;

/* =========================================================
   CONSULTA 9 - Eficiência urbana: cidades com boa 
   infraestrutura, renda média e baixo tempo de deslocamento
   ========================================================= */
WITH base AS (
    SELECT
        l."CTY_FUL" AS cidade,
        AVG(f."MED_HOM_VAL") AS preco,
        AVG(s."PER_INC") AS renda,
        AVG(s."MED_COM_TIM") AS deslocamento,
        AVG(i."BNK"+i."BUS"+i."HSP"+i."PRK"+i."SCH"+i."SUP") AS infra
    FROM dw.fat_hou f
    JOIN dw.dim_tmp t ON f."SRK_TMP" = t."SRK_TMP"
    JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
    JOIN dw.dim_soc s ON f."SRK_SOC" = s."SRK_SOC"
    JOIN dw.dim_inf i ON f."SRK_INF" = i."SRK_INF"
    GROUP BY l."CTY_FUL"
)
SELECT
    cidade,
    ROUND((infra / preco) * (renda / deslocamento)::numeric,6) AS indice_eficiencia
FROM base
ORDER BY indice_eficiencia DESC
LIMIT 10;


/* =========================================================
   CONSULTA 10 - Pressão do mercado imobiliário por cidade
   ========================================================= */
WITH base AS (
    SELECT
        l."CTY_FUL" AS cidade,
        AVG(f."HOM_SOL") AS vendas,
        AVG(f."SOL_ABV_LST") AS acima,
        AVG(f."NEW_LST") AS novos,
        AVG(f."INV") AS estoque,
        AVG(s."PER_INC") AS renda,
        AVG(i."BNK"+i."BUS"+i."HSP"+i."MAL"+i."PRK"+i."SCH"+i."SUP") AS infra
    FROM dw.fat_hou f
    JOIN dw.dim_tmp t ON f."SRK_TMP" = t."SRK_TMP"
    JOIN dw.dim_loc l ON f."SRK_LOC" = l."SRK_LOC"
    JOIN dw.dim_soc s ON f."SRK_SOC" = s."SRK_SOC"
    JOIN dw.dim_inf i ON f."SRK_INF" = i."SRK_INF"
    GROUP BY l."CTY_FUL"
)
SELECT
    cidade,
    ROUND(
        100 * (
            (vendas - MIN(vendas) OVER()) / NULLIF(MAX(vendas) OVER()-MIN(vendas) OVER(),0) +
            (acima  - MIN(acima)  OVER()) / NULLIF(MAX(acima)  OVER()-MIN(acima)  OVER(),0) +
            (MAX(novos) OVER()-novos) / NULLIF(MAX(novos) OVER()-MIN(novos) OVER(),0) +
            (MAX(estoque) OVER()-estoque) / NULLIF(MAX(estoque) OVER()-MIN(estoque) OVER(),0) +
            (infra - MIN(infra) OVER()) / NULLIF(MAX(infra) OVER()-MIN(infra) OVER(),0) +
            (renda - MIN(renda) OVER()) / NULLIF(MAX(renda) OVER()-MIN(renda) OVER(),0)
        ) / 6
    ::numeric,2) AS indice_pressao
FROM base
ORDER BY indice_pressao DESC
LIMIT 10;
