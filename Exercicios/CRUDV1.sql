CREATE PROCEDURE sp_CRUDFeriados
@ACAO VARCHAR(10),
@ID INT = NULL,
@NOME VARCHAR (100) = NULL,
@DATA DATE = NULL

AS 
BEGIN TRANSACTION 

  IF @ACAO NOT IN('select', 'insert', 'update', 'delete')
  BEGIN 
		ROLLBACK;
		PRINT 'Ação inválida. Use select, insert, update ou delete.'
		GOTO FIM_ERRO
  END

  IF(@ACAO = 'select')
  BEGIN 
	IF @ID IS NULL
	BEGIN
		SELECT *
		FROM Feriados
	END 
	ELSE
	BEGIN
		SELECT COD_FERIADO, NOME_FERIADO, DATA_FERIADO
		FROM Feriados
		WHERE @ID = COD_FERIADO
		GOTO FIM_CERTO 
	END
  END

  IF (@ACAO = 'insert')
  BEGIN
	IF @NOME IS NULL AND @DATA IS NULL 
	BEGIN
		ROLLBACK;
		PRINT 'Nome e Data são obrigatórios para inserção.'
		GOTO FIM_ERRO
	END
	ELSE
		INSERT INTO Feriados(NOME_FERIADO, DATA_FERIADO)
		VALUES (@NOME, @DATA)
  END 

  IF(@ACAO = 'update')
  BEGIN 
	IF @ID IS NULL 
	BEGIN
		ROLLBACK;
		PRINT'registro não encontrado para atualização.'
		GOTO FIM_ERRO
	END
	ELSE
		UPDATE Feriados
		SET NOME_FERIADO =ISNULL(@NOME, NOME_FERIADO), DATA_FERIADO = ISNULL(@DATA,DATA_FERIADO)
		WHERE COD_FERIADO = @ID
		GOTO FIM_CERTO
	END

  IF (@ACAO = 'delete')
  BEGIN
	IF @ID IS NULL
	BEGIN
		ROLLBACK;
		PRINT 'Id é obrigatório para exclusão.'
		GOTO FIM_ERRO
	END
	ELSE
		DELETE FROM Feriados
		WHERE COD_FERIADO = @ID
		GOTO FIM_CERTO
  END

FIM_CERTO:
COMMIT; 
PRINT 'DADOS SELECIONADOS,INSERIDOS OU ATUALIZADO COM SUCESSO'; 
GOTO FIM
 
FIM_ERRO:
PRINT 'ALGO DEU ERRADO!!!'; 

FIM:
PRINT 'FINALIZADO!!!'; 

DROP PROCEDURE sp_CRUDFeriados

 
--SELECT
EXEC sp_CRUDFeriados @Acao = 'select'
EXEC sp_CRUDFeriados @Acao = 'kosdaoskdoksad'
EXEC sp_CRUDFeriados @Acao = 'select', @Id = 1

--INSERT
SELECT * FROM Feriados
EXEC sp_CRUDFeriados @Acao = 'insert', @Nome = NULL, @Data = NULL
EXEC sp_CRUDFeriados @Acao = 'insert', @Nome = 'TESTE2', @Data = '2025-03-01'
EXEC sp_CRUDFeriados @Acao = 'select', @Id = 11
SELECT * FROM Feriados

--UPDATE
EXEC sp_CRUDFeriados @Acao = 'update', @Id = 26, @Nome = 'TESTEeeee'
SELECT * FROM Feriados

--DELETE
EXEC sp_CRUDFeriados @Acao = 'delete', @Id = 26
SELECT * FROM Feriados







