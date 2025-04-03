USE Treinamento

CREATE TABLE Negociacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    DadosJSON NVARCHAR(MAX) 
);

--DROP TABLE Negociacoes

INSERT INTO Negociacoes (DadosJSON)
VALUES (N'{
    "NegociacaoDto": [
        {
            "IdClienteCarteira": 1,
            "NomeFinanciado": "FULANO DA SILVA",
            "NrContrato": "979192",
            "VlDivida": 693.3,
            "VlDividaAtualizada": 560.47,
            "DtContrato": "2021-08-18T00:00:00",
            "Parcelas": [
                {
                    "IdParcela": 6730853,
                    "NrParcela": "6",
                    "DtVencimento": "2022-02-05T00:00:00",
                    "VlSaldo": 231.1
                },
                {
                    "IdParcela": 6727116,
                    "NrParcela": "7",
                    "DtVencimento": "2022-03-05T00:00:00",
                    "VlSaldo": 231.1
                },
                {
                    "IdParcela": 6716596,
                    "NrParcela": "8",
                    "DtVencimento": "2022-04-05T00:00:00",
                    "VlSaldo": 231.1
                }
            ]
        }
    ],
    "Success": true
}');



-- Exercício 1 Por meio dos recursos do SQL Server, retorne os dados da tabela de feriados do Exercicio 4 da Lista 1 em estrutura JSON

SELECT * FROM Feriados WITH(NOLOCK) FOR JSON AUTO
SELECT * FROM Feriados WITH(NOLOCK) FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER -- Retorna o json sem []


-- Exercício 2  Usando como base o json abaixo e o SQL Server, faça o select parar NomeFinanciado e VlDivida

SELECT JSON_VALUE(DadosJSON, '$.NegociacaoDto[0].NomeFinanciado') AS NomeFinanciado,
       JSON_VALUE(DadosJSON, '$.NegociacaoDto[0].VlDivida') AS VlDivida,
       JSON_VALUE(DadosJSON, '$.Success') AS Success
FROM Negociacoes WITH(NOLOCK);


-- Exercício 3  Usando as ferramentas do SQL Server e o JSON do exercício anterior,
-- escreva um script que inclua uma propriedade chamada ParcelasRestantes no mesmo nivel em que fica o NrContrato,
--  e seu valor será a contagem de parcelas que o contrato possui no array Parcelas 

UPDATE Negociacoes
SET DadosJSON = (
    SELECT 
        ( 
            SELECT 
                IdClienteCarteira,
                NomeFinanciado,
                NrContrato,
                VlDivida,
                VlDividaAtualizada,
                DtContrato,
                ParcelasRestantes = (
                    SELECT COUNT(*) 
                    FROM OPENJSON(JSON_QUERY(DadosJSON, '$.NegociacaoDto[0].Parcelas'))
                ),
                Parcelas = JSON_QUERY(DadosJSON, '$.NegociacaoDto[0].Parcelas')
            FROM OPENJSON(DadosJSON, '$.NegociacaoDto') 
            WITH (
                IdClienteCarteira INT '$.IdClienteCarteira',
                NomeFinanciado NVARCHAR(200) '$.NomeFinanciado',
                NrContrato NVARCHAR(50) '$.NrContrato',
                VlDivida DECIMAL(10,2) '$.VlDivida',
                VlDividaAtualizada DECIMAL(10,2) '$.VlDividaAtualizada',
                DtContrato DATETIME '$.DtContrato'
            ) 
            FOR JSON PATH
        ) AS NegociacaoDto,
        Success
    FROM OPENJSON(DadosJSON) 
    WITH (Success BIT '$.Success')
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
);


SELECT DadosJSON 
FROM Negociacoes WITH(NOLOCK);


-- Exercício 4  Transforme o JSON do Exercício 2 em uma resultado em formato de tabela (abaixo), usando o SQL Server
-- NomeFinanciado	NrContrato	VlDivida	DtContrato	NrParcela	DtVencimento	VlSaldo

SELECT 
    Negociacao.NomeFinanciado,
    Negociacao.NrContrato,
    Negociacao.VlDivida,
    Negociacao.DtContrato,
    Parcela.NrParcela,
    Parcela.DtVencimento,
    Parcela.VlSaldo
FROM Negociacoes N WITH(NOLOCK)
CROSS APPLY OPENJSON(N.DadosJSON, '$.NegociacaoDto') 
WITH (
    NomeFinanciado NVARCHAR(100),
    NrContrato NVARCHAR(50),
    VlDivida DECIMAL(10,2),
    DtContrato DATETIME,
    Parcelas NVARCHAR(MAX) AS JSON  
) AS Negociacao
CROSS APPLY OPENJSON(Negociacao.Parcelas) 
WITH (
    NrParcela NVARCHAR(10),
    DtVencimento DATETIME,
    VlSaldo DECIMAL(10,2)
) AS Parcela;


-- Exercício 5  Dado o modelo de dados definido abaixo:

--DROP TABLE Colaborador
--DROP TABLE Dependente

create table Colaborador (
    Id smallint identity(1,1), 
    Nome varchar(100) not null, 
    DataAdimissao date not null, 
    Celular varchar(11) not null,
    Email varchar(100) null,
    Salário numeric(15,2) not null,
    UltimoAcesso nvarchar(max)
);

alter table Colaborador add constraint PK_Colaborador primary key (Id);

create table Dependente (
    Id int identity(1,1) not null,
    ColaboradorId smallint not null, 
    Nome varchar(100) not null
);

alter table Dependente add constraint PK_Dependente primary key (Id);
alter table Dependente add constraint FK_Dependente_Colaborador foreign key (ColaboradorId) references Colaborador(Id);

insert into Colaborador (Nome,DataAdimissao,Celular,Email,Salário,UltimoAcesso) values 
('José Ferreira da Silva', '20190315','27995826142','jose.silva@email.com.br',3500.00,
	'{"dataHora": "2021-09-09T18:56:34.686Z","tema": "dark","token": "eyhdl8gd0w23.bdfdvw!0dfg"}'),
('Flávia Oliveira', '20190823','27984516320','floliveiraa@email.com',5150.43,
	'{"dataHora": "2021-10-01T13:27:15.569Z","token": "eyhdl8bdfdvw.!0df$gd0w23"}')

insert into Dependente values 
(1,'Ricardo Garcia da Silva'),
(1,'Júlia Garcia da Silva')

SELECT * FROM Colaborador
select * from Dependente


SELECT (
	SELECT 
			a.ID AS 'id',
			a.Nome AS 'nome',
			FORMAT(a.DataAdimissao, 'dd/MM/yyyy') AS 'dataAdmissao',
			a.Celular AS 'celular',
			a.Salário AS 'salario',
			JSON_QUERY(a.UltimoAcesso) AS 'ultimoAcesso',
			(
				SELECT b.ID AS 'id',
					   b.Nome AS 'nome'
			    FROM Dependente b
				WHERE
				b.ColaboradorId = a.Id
				FOR JSON PATH
			) AS 'dependente'
	FROM 
	Colaborador a
	FOR JSON PATH
)
