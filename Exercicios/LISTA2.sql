
-- Exercicio 1 Qual a diferença entre union e union all?

-- Os 2 operadores são utilizados para combinar resultados de uma ou mais instruções SELECT. 
-- A principal diferença entre eles é que o UNION não retorna valores duplicados, ja o UNION ALL retorna.


-- Exercicio 2 O que são subquerys correlatas?

-- É uma consulta aninhada em uma instrução  SELECT, INSET UPDATE e DELETE, ou em subconsulta. Uma subconsulta pode ser usada em qualquer lugar em que é permitida uma expressão. 
-- São uma técnica muito útil, mas também podem ser bastante complicadas.
-- Podem ser muito lentas, especialmente se a consulta externa retornar um grande número de linhas
-- Podem afetar o desempenho da consulta, especialmente se elas forem mal otimizadas ou usadas desnecessariamente


-- Exercicio 3 Transcreva a consulta abaixo para uma versão que use join em vez de subquery

--USE AdventureWorks2016;

--SELECT [Name]
--FROM Production.Product
--WHERE ListPrice =
    --(SELECT ListPrice
     --FROM Production.Product
     --WHERE [Name] = 'Chainring Bolts' )

USE AdventureWorks2016;

SELECT p.Name
FROM production.Product p WITH(NOLOCK)
JOIN Production.Product p2 ON p.ListPrice = p2.ListPrice
WHERE p2.Name = 'Chainring Bolts'


-- Exercicio 4 Transcreva a consulta abaixo para uma versão que use left join em vez de subquery

-- USE AdventureWorks2016;

-- SELECT [Name]
-- FROM Sales.Store
-- WHERE BusinessEntityID NOT IN
    -- (SELECT CustomerID
	 -- FROM Sales.Customer
	 -- WHERE TerritoryID = 5);

USE AdventureWorks2016_EXT

SELECT s.Name
FROM Sales.Store s
LEFT JOIN Sales.Customer c ON s.BusinessEntityID = c.CustomerID AND c.TerritoryID = 5
WHERE c.CustomerID IS NULL;


-- Exercicio 5 Baseado na tabela da Lista 1 Exercicio 5

SELECT * FROM Mercadorias WITH (NOLOCK)

-- e) Pesquise o valor total das NF e ordene o resultado do maior valor para o menor. 
-- As colunas presentes no resultado da consulta são: ID_NF, VALOR_TOTAL. 
-- OBS: O VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. Agrupe o resultado da consulta por ID_NF.

SELECT ID_NF, SUM(QUANTIDADE * VALOR_UNIT ) AS VALOR_TOTAL
FROM  Mercadorias WITH(NOLOCK)
GROUP BY id_nf
ORDER BY valor_total DESC

-- f) Pesquise o valor vendido das NF e ordene o resultado do maior valor para o menor. 
-- As colunas presentes no resultado da consulta são: ID_NF, VALOR_VENDIDO. 
--OBS: O VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. O VALOR_VENDIDO é igual a ∑  VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100)). 
--Agrupe o resultado da consulta por ID_NF. 

SELECT
ID_NF,
ROUND(SUM(VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100))),2) as VALOR_TOTAL
FROM Mercadorias WITH(NOLOCK)
GROUP BY id_nf
ORDER BY valor_TOTAL DESC

-- g) Consulte o produto que mais vendeu no geral. As colunas presentes no resultado da consulta são: COD_PROD, QUANTIDADE. Agrupe o resultado da consulta por COD_PROD. 

SELECT
COD_PROD, SUM(QUANTIDADE) AS qtd
FROM Mercadorias WITH(NOLOCK)
GROUP BY COD_PROD
ORDER BY qtd DESC

-- h) Consulte as NF que foram vendidas mais de 10 unidades de pelo menos um produto. 
-- As colunas presentes no resultado da consulta são: ID_NF, COD_PROD, QUANTIDADE. 
-- Agrupe o resultado da consulta por ID_NF, COD_PROD. 

SELECT DISTINCT 
ID_NF,
COD_PROD,
SUM(QUANTIDADE) AS QUANTIDADE
FROM Mercadorias WITH(NOLOCK)
WHERE QUANTIDADE >10
GROUP BY ID_NF, COD_PROD;

-- i) Pesquise o valor total das NF, onde esse valor seja maior que 500, e ordene o resultado do maior valor para o menor. 
-- As colunas presentes no resultado da consulta são: ID_NF, VALOR_TOT. 
-- OBS: O VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. Agrupe o resultado da consulta por ID_NF.

SELECT id_nf ,
SUM(QUANTIDADE * VALOR_UNIT) AS qtd
FROM Mercadorias
GROUP BY ID_NF
HAVING SUM(QUANTIDADE * VALOR_UNIT)  > 500
order by qtd desc

-- j) Qual o valor médio dos descontos dados por produto. 
-- As colunas presentes no resultado da consulta são: COD_PROD, MEDIA. Agrupe o resultado da consulta por COD_PROD.

SELECT
COD_PROD, AVG(DESCONTO) AS MEDIA
FROM Mercadorias
GROUP by COD_PROD

-- k) Qual o menor, maior e o valor médio dos descontos dados por produto. 
-- As colunas presentes no resultado da consulta são: COD_PROD, MENOR, MAIOR, MEDIA. Agrupe o resultado da consulta por COD_PROD.

SELECT
COD_PROD,
MAX(DESCONTO) AS MAIOR,
MIN(DESCONTO) AS MENOR,
AVG(DESCONTO) AS MEDIA
FROM Mercadorias
GROUP by COD_PROD

-- l) Quais as NF que possuem mais de 3 itens vendidos. 
-- As colunas presentes no resultado da consulta são: ID_NF, QTD_ITENS. 
-- OBS:: NÃO ESTÁ RELACIONADO A QUANTIDADE VENDIDA DO ITEM E SIM A QUANTIDADE DE ITENS POR NOTA FISCAL. 
-- Agrupe o resultado da consulta por ID_NF

SELECT
ID_NF,
COUNT(QUANTIDADE) AS quantidade
FROM Mercadorias
GROUP BY ID_NF
HAVING COUNT(QUANTIDADE)>3
