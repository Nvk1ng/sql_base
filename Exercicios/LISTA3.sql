
-- Exercício 1 Crie uma view para a consulta da lista 1 - Exercicio 5.d 

CREATE VIEW  v_valor_vendido
AS 
	SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, (QUANTIDADE * VALOR_UNIT) AS VALOR_TOTAL, DESCONTO, VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100)) AS VALOR_VENDIDO
	FROM Mercadorias WITH(NOLOCK)

SELECT * FROM v_valor_vendido

DROP VIEW  v_valor_vendido


-- Exercicio 2 Crie uma função escalar que recebe uma data por parâmetro e retorne quantos dias faltam para esse dia

CREATE FUNCTION fn_teste(@data DATE)
RETURNS INT
AS
BEGIN
	DECLARE @dataAno DATETIME;
	SET @dataAno = @data
	RETURN DATEDIFF(DAY, GETDATE(), @dataAno);
END

SELECT dbo.fn_teste('2024-12-25') diff;

DROP FUNCTION dbo.fn_teste


-- Exercicio 3 Baseado no Exercicio 5.j da Lista 2 crie uma função que recebe o COD_PROD e retorne MENOR, MAIOR e MEDIA

CREATE FUNCTION fn_teste2(@cod_prod INT)
RETURNS TABLE
AS
RETURN(
    SELECT 
        @cod_prod AS COD_PROD,
        round(min(VALOR_UNIT * VALOR_UNIT * (1 - DESCONTO/100.0)), 2) AS MENOR,
        round(max(QUANTIDADE * VALOR_UNIT * (1 - DESCONTO/100.0)), 2) AS MAIOR,
        round(avg(QUANTIDADE * VALOR_UNIT * (1 - DESCONTO/100.0)), 2) AS MEDIA
    FROM Mercadorias WITH(NOLOCK)
    WHERE COD_PROD = @cod_prod
);
SELECT * FROM dbo.fn_teste2(1)
DROP FUNCTION dbo.fn_teste2


-- Exercicio 4 Crie uma função que replica caracteres de uma string. 
--A função receberá como parâmetro a string e a quantidade de repetição
--Ex:
--Entrada: string - ‘abc’; quantidade - 3**
--Saída: ‘aaabbbccc’


CREATE FUNCTION fn_replica(@valores VARCHAR(20), @replicas INT)
RETURNS VARCHAR(20) 
BEGIN
	DECLARE @res VARCHAR(20);
	SET @res= REPLICATE(@valores,@replicas)
	RETURN (@res)
END

SELECT dbo.fn_replica('abc',3)

DROP FUNCTION dbo.fn_replica

SELECT * FROM Mercadorias WITH(NOLOCK)



