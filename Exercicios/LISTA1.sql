-- Exercicio 1 Explique o que é ACID

-- ACID é basicamente as propriedades das transações sendo
 
-- A → Atomicidade: Indica que uma transação é uma unidade atômica de processamento, ou seja ela é executada em sua totalidade, ou então nada é executado.
-- C→ Consistência: Significa que a execução de uma transação deve manter a consistência do banco de dados.
-- I→ Isolamento: Uma transação não deve se tornar visível para outras transações feitas em um banco de dados até que ela seja encerrada com sucesso.
-- D→ Durabilidade: Uma vez executadas com sucesso, as alterações são feitas.


-- Exercicio 2 Explique o que é CRUD

-- CRUD são as quatro operações básicas de um banco de dados

-- C→ CREAT 
-- R→ READ
-- U→ UPDATE
-- D→ DELETE


-- Exercicio 3 Qual tipo de dados você usaria em cada dado abaixo?

-- José Ricardo de Oliveira Silva varchar | (n) nomes variam em tamanho
-- 13/10/1754 | date -> data sem horário
-- true | bit -> true e false pode ser armazenado como 0 ou 1
-- 12:54:37 | time -> representa apenas a hora
-- R$ 45,12 | decimal, money ->  é mais preciso e evita erros de arredondamento
-- (CEP) 29651520 | varchar (n) -> CEP pode conter traços e varia entre países
-- 495.635.125-08 | varchar(n) -> pois pode conter pontuação
-- (arquivo) | varbinary, varchar (n) -> varbinary para arquivos binários e varchar se for caminho de arquivo.
-- 15 | int -> é um número inteiro.
-- {”orders”:[{”id”:  01, “name”: “House”},{”id”: 62, “name”: “Computer”}]} | varchar(n), json -> 
-- 100/3 | float -> gera um número decimal
-- 2022-01-01 00:00:01 | datetime2 -> armazena data e hora com precisão maior.


-- Exercicio 4 Conecte no SQL Server instalado na sua máquina ( Seção 2.3 ) e crie um banco de dados chamado Treinamento


-- Exercicio 5
-- Crie uma tabela para armazenar o nome do feriado e data dele. 
-- Em seguida pesquise quais são os feriados nacionais (brasileiros) e insira nessa tabela. 
-- A tabela devera ter código do feriado (auto-incremento), nome do feriado e a data em que ele é comemorado.

CREATE TABLE Feriados(
	COD_FERIADO INT IDENTITY(1,1) PRIMARY KEY,
	NOME_FERIADO VARCHAR(50) NOT NULL,
	DATA_FERIADO DATE NOT NULL
);

INSERT INTO Feriados(NOME_FERIADO, DATA_FERIADO)
VALUES
('Confraternização Universal', '2025-01-01'),
('Sexta Feira Santa', '2025-04-18'),
('Tiradentes', '2025-04-21'),
('Dia do Trabalhador', '2025-05-01'),
('Independência do Brasil', '2025-08-07'),
('Nossa Senhora Aparecida', '2025-10-12'),
('Finados', '2025-11-02'),
('Proclamação da República', '2025-11-15'),
('Consciência Negra', '2025-11-20'),
('Natal', '2025-12-25');

SELECT * FROM Feriados


-- Exercicio 6 Crie, no seu banco de dados, a tabela abaixo, insira os valores apresentados e emseguida escreva as consultas solicitadas abaixo.

-- DROP TABLE Mercadorias

CREATE TABLE Mercadorias(
ID_NF INTEGER,
ID_ITEM INTEGER, 
COD_PROD INTEGER, 
VALOR_UNIT DECIMAL(10,2), 
QUANTIDADE INTEGER, 
DESCONTO REAL
);

INSERT INTO Mercadorias VALUES(1, 1, 1, 25.00, 10, 5);
INSERT INTO Mercadorias VALUES(1, 2, 2, 13.50, 3, null); 
INSERT INTO Mercadorias VALUES(1, 3, 3, 15.00, 2, null);
INSERT INTO Mercadorias VALUES(1, 4, 4, 10.00, 1, null);
INSERT INTO Mercadorias VALUES(1, 5, 5, 30.00, 1, null); 
INSERT INTO Mercadorias VALUES(2, 1, 3, 15.00, 4, null); 
INSERT INTO Mercadorias VALUES(2, 2, 4, 10.00, 5, null); 
INSERT INTO Mercadorias VALUES(2, 3, 5, 30.00, 7, null); 
INSERT INTO Mercadorias VALUES(3, 1, 1, 25.00, 5, null); 
INSERT INTO Mercadorias VALUES(3, 2, 4, 10.00, 4, null); 
INSERT INTO Mercadorias VALUES(3, 3, 5, 30.00, 5, null);
INSERT INTO Mercadorias VALUES(3, 4, 2, 13.50, 7, null);
INSERT INTO Mercadorias VALUES(4, 1, 5, 30.00, 10, 15);
INSERT INTO Mercadorias VALUES(4, 2, 4, 10.00, 12, 5); 
INSERT INTO Mercadorias VALUES(4, 3, 1, 25.00, 13, 5); 
INSERT INTO Mercadorias VALUES(4, 4, 2, 13.50, 15, 5);
INSERT INTO Mercadorias VALUES(5, 1, 3, 15.00, 3, null);
INSERT INTO Mercadorias VALUES(5, 2, 5, 30.00, 6, null);
INSERT INTO Mercadorias VALUES(6, 1, 1, 25.00, 22, 15);
INSERT INTO Mercadorias VALUES(6, 2, 3, 15.00, 25, 20);
INSERT INTO Mercadorias VALUES(7, 1, 1, 25.00, 10, 3);
INSERT INTO Mercadorias VALUES(7, 2, 2, 13.50, 10, 4);
INSERT INTO Mercadorias VALUES(7, 3, 3, 15.00, 10, 4);
INSERT INTO Mercadorias VALUES(7, 4, 5, 30.00, 10, 1);

SELECT * FROM Mercadorias WITH(NOLOCK)

-- a) Pesquise os itens que foram vendidos sem desconto. As colunas presentes no resultado da  consulta são: ID_NF, ID_ITEM, COD_PROD E VALOR_UNIT.

SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT FROM Mercadorias WHERE DESCONTO IS
NULL;

-- b) Pesquise os itens que foram vendidos com desconto. 
-- As colunas presentes no resultado da consulta são: ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT E O VALOR VENDIDO.
-- OBS: O valor vendido é igual ao VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100)).

SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, DESCONTO, VALOR_UNIT-
(VALOR_UNIT*(DESCONTO/100)) AS VALOR_VENDIDO 
FROM Mercadorias
WHERE DESCONTO IS NOT NULL;

-- c) Altere o valor do desconto (para zero) de todos os registros onde este campo é nulo.

UPDATE Mercadorias SET DESCONTO = 0 WHERE DESCONTO IS NULL;
SELECT * FROM Mercadorias

-- d) Pesquise os itens que foram vendidos. 
-- As colunas presentes no resultado da consulta são: ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, VALOR_TOTAL, DESCONTO, VALOR_VENDIDO. 
-- OBS: O VALOR_TOTAL é obtido pela fórmula: QUANTIDADE * VALOR_UNIT. O VALOR_VENDIDO é igual a VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100)).

SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, (QUANTIDADE * VALOR_UNIT) AS
VALOR_TOTAL, DESCONTO, (VALOR_UNIT-(VALOR_UNIT*(DESCONTO/100))) AS
VALOR_VENDIDO FROM Mercadorias


-- Exercicio 6 Restaure na sua máquina o banco de dados, fornecido pela microsoft, AdvantureWorks 2016