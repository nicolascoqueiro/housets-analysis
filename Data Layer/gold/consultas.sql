/* =========================================================
   CONSULTA 1 - As 5 cidades MAIS BARATAS para comprar imóvel
   ========================================================= */


SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."MED_HOM_VAL") AS preco_medio_imovel
FROM dw.fat_houses f
JOIN dw.dim_local l
    ON f."SRK_LOCAL" = l."SRK_LOCAL"
GROUP BY l."CTY_FUL"
ORDER BY preco_medio_imovel ASC
LIMIT 5;


/* =========================================================
   CONSULTA 2 - As 5 cidades MAIS CARAS para comprar imóvel
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."MED_HOM_VAL") AS preco_medio_imovel
FROM dw.fat_houses f
JOIN dw.dim_local l
    ON f."SRK_LOCAL" = l."SRK_LOCAL"
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

        AVG(
            i."BNK" +
            i."BUS" +
            i."HSP" +
            i."MAL" +
            i."PRK" +
            i."RST" +
            i."SCH" +
            i."STN" +
            i."SUP"
        ) AS score_infraestrutura,

        AVG(f."MED_HOM_VAL") AS preco_medio_imovel
    FROM dw.fat_houses f
    JOIN dw.dim_local l
        ON f."SRK_LOCAL" = l."SRK_LOCAL"
    JOIN dw.dim_infra i
        ON f."SRK_INFRA" = i."SRK_INFRA"
    GROUP BY l."CTY_FUL"
),
indice AS (
    SELECT
        cidade,
        score_infraestrutura,
        preco_medio_imovel,
        (score_infraestrutura / preco_medio_imovel) AS indice_bruto
    FROM infra_preco
),
normalizado AS (
    SELECT
        cidade,
        score_infraestrutura,
        preco_medio_imovel,
        indice_bruto,
        100 * (indice_bruto - MIN(indice_bruto) OVER ())
        / NULLIF(
            MAX(indice_bruto) OVER () - MIN(indice_bruto) OVER (),
            0
        ) AS indice_custo_beneficio
    FROM indice
)
SELECT
    cidade,
    ROUND(score_infraestrutura::numeric, 2) AS score_infraestrutura,
    ROUND(preco_medio_imovel::numeric, 2) AS preco_medio_imovel,
    ROUND(indice_custo_beneficio::numeric, 2) AS indice_custo_beneficio
FROM normalizado
ORDER BY indice_custo_beneficio DESC
LIMIT 5;

/* =========================================================
   CONSULTA 4 - Taxa de imóveis vendidos acima do preço
   por cidade
   ========================================================= */
SELECT
    l."CTY_FUL" AS cidade,
    AVG(f."SOL_ABV_LST") * 100 AS percentual_acima_lista
FROM dw.fat_houses f
JOIN dw.dim_local l
    ON f."SRK_LOCAL" = l."SRK_LOCAL"
GROUP BY l."CTY_FUL"
ORDER BY percentual_acima_lista DESC;

/* =========================================================
   CONSULTA 5 - As 5 cidades com mais jovens e alto desemprego
   ========================================================= */

WITH jovens_desemprego AS (
    SELECT
        l."CTY_FUL" AS cidade,
        AVG(s."TOT_SCH_AGE") AS populacao_jovem,
        AVG(s."UNE_POP")     AS populacao_desempregada
    FROM dw.fat_houses f
    JOIN dw.dim_local l
        ON f."SRK_LOCAL" = l."SRK_LOCAL"
    JOIN dw.dim_socio s
        ON f."SRK_SOCIO" = s."SRK_SOCIO"
    GROUP BY l."CTY_FUL"
)
SELECT
    cidade,
    ROUND(populacao_jovem::numeric, 0) AS populacao_jovem,
    ROUND(populacao_desempregada::numeric, 0) AS populacao_desempregada
FROM jovens_desemprego
ORDER BY
    populacao_jovem DESC,
    populacao_desempregada DESC
LIMIT 5;

/* =========================================================
   CONSULTA 6 - As 5 cidades com maior volume
   de vendas de imóveis
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    SUM(f."HOM_SOL") AS total_vendas
FROM dw.fat_houses f
JOIN dw.dim_local l
    ON f."SRK_LOCAL" = l."SRK_LOCAL"
GROUP BY l."CTY_FUL"
ORDER BY total_vendas DESC
LIMIT 5;

/* =========================================================
   CONSULTA 7 - As 5 cidades com maior renda média
   ========================================================= */

SELECT
    l."CTY_FUL" AS cidade,
    AVG(s."PER_INC") AS renda_media
FROM dw.fat_houses f
JOIN dw.dim_local l
    ON f."SRK_LOCAL" = l."SRK_LOCAL"
JOIN dw.dim_socio s
    ON f."SRK_SOCIO" = s."SRK_SOCIO"
GROUP BY l."CTY_FUL"
ORDER BY renda_media DESC
LIMIT 5;

/* =========================================================
   CONSULTA 8 - Evolução do preço dos imóveis vs 
   infraestrutura ao longo do tempo
   ========================================================= */

   WITH base_temporal AS (
    SELECT
        t."YEA" AS ano,
        l."CTY_FUL" AS cidade,

        AVG(f."MED_HOM_VAL") AS preco_medio_imovel,

        AVG(
            i."BNK" +
            i."BUS" +
            i."HSP" +
            i."SCH" +
            i."SUP"
        ) AS score_infraestrutura
    FROM dw.fat_houses f
    JOIN dw.dim_tempo t
        ON f."SRK_TEMPO" = t."SRK_TEMPO"
    JOIN dw.dim_local l
        ON f."SRK_LOCAL" = l."SRK_LOCAL"
    JOIN dw.dim_socio s
        ON f."SRK_SOCIO" = s."SRK_SOCIO"
    JOIN dw.dim_infra i
        ON f."SRK_INFRA" = i."SRK_INFRA"
    GROUP BY
        t."YEA",
        l."CTY_FUL"
)
SELECT
    ano,
    cidade,
    ROUND(preco_medio_imovel::numeric, 2) AS preco_medio_imovel,
    ROUND(score_infraestrutura::numeric, 2) AS score_infraestrutura
FROM base_temporal
ORDER BY ano, preco_medio_imovel DESC;

/* =========================================================
   CONSULTA 9 - Eficiência urbana: cidades com boa 
   infraestrutura, renda média e baixo tempo de deslocamento
   ========================================================= */

WITH indicadores_base AS (
    SELECT
        l."CTY_FUL" AS cidade,

        AVG(f."MED_HOM_VAL") AS preco_medio_imovel,
        AVG(s."PER_INC") AS renda_media,
        AVG(s."MED_COM_TIM") AS tempo_deslocamento,

        AVG(
            i."BNK" +
            i."BUS" +
            i."HSP" +
            i."PRK" +
            i."SCH" +
            i."SUP"
        ) AS score_infraestrutura
    FROM dw.fat_houses f
    JOIN dw.dim_tempo t
        ON f."SRK_TEMPO" = t."SRK_TEMPO"
    JOIN dw.dim_local l
        ON f."SRK_LOCAL" = l."SRK_LOCAL"
    JOIN dw.dim_socio s
        ON f."SRK_SOCIO" = s."SRK_SOCIO"
    JOIN dw.dim_infra i
        ON f."SRK_INFRA" = i."SRK_INFRA"
    GROUP BY l."CTY_FUL"
),
normalizacao AS (
    SELECT
        cidade,
        preco_medio_imovel,
        renda_media,
        tempo_deslocamento,
        score_infraestrutura,

        /* quanto menor o preço e o deslocamento, melhor */
        (score_infraestrutura / NULLIF(preco_medio_imovel, 0)) *
        (renda_media / NULLIF(tempo_deslocamento, 0)) AS indice_eficiencia
    FROM indicadores_base
)
SELECT
    cidade,
    ROUND(preco_medio_imovel::numeric, 2) AS preco_medio_imovel,
    ROUND(renda_media::numeric, 2) AS renda_media,
    ROUND(tempo_deslocamento::numeric, 2) AS tempo_deslocamento,
    ROUND(score_infraestrutura::numeric, 2) AS score_infraestrutura,
    ROUND(indice_eficiencia::numeric, 6) AS indice_eficiencia_urbana
FROM normalizacao
ORDER BY indice_eficiencia_urbana DESC
LIMIT 10;

/* =========================================================
   CONSULTA 10 - Pressão do mercado imobiliário por cidade
   ========================================================= */

WITH base AS (
    SELECT
        l."CTY_FUL" AS cidade,
        AVG(f."HOM_SOL")     AS vendas,
        AVG(f."SOL_ABV_LST") AS acima_lista,
        AVG(f."NEW_LST")     AS novos,
        AVG(f."INV")         AS estoque,
        AVG(s."PER_INC")     AS renda,
        AVG(i."BNK"+i."BUS"+i."HSP"+i."MAL"+i."PRK"+i."SCH"+i."SUP") AS infra
    FROM dw.fat_houses f
    JOIN dw.dim_tempo t ON f."SRK_TEMPO" = t."SRK_TEMPO"
    JOIN dw.dim_local l ON f."SRK_LOCAL" = l."SRK_LOCAL"
    JOIN dw.dim_socio s ON f."SRK_SOCIO" = s."SRK_SOCIO"
    JOIN dw.dim_infra i ON f."SRK_INFRA" = i."SRK_INFRA"
    GROUP BY l."CTY_FUL"
)
SELECT
    cidade,
    ROUND((
        100 * (
            (vendas - MIN(vendas) OVER ()) / NULLIF(MAX(vendas) OVER () - MIN(vendas) OVER (), 0) +
            (acima_lista - MIN(acima_lista) OVER ()) / NULLIF(MAX(acima_lista) OVER () - MIN(acima_lista) OVER (), 0) +
            (MAX(novos) OVER () - novos) / NULLIF(MAX(novos) OVER () - MIN(novos) OVER (), 0) +
            (MAX(estoque) OVER () - estoque) / NULLIF(MAX(estoque) OVER () - MIN(estoque) OVER (), 0) +
            (infra - MIN(infra) OVER ()) / NULLIF(MAX(infra) OVER () - MIN(infra) OVER (), 0) +
            (renda - MIN(renda) OVER ()) / NULLIF(MAX(renda) OVER () - MIN(renda) OVER (), 0)
        ) / 6
    )::numeric, 2) AS indice_pressao
FROM base
ORDER BY indice_pressao DESC
LIMIT 10;
