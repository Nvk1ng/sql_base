CREATE PROCEDURE sp_ManipularFeriados
    @Acao VARCHAR(10),
    @Id INT = NULL,
    @Nome VARCHAR(100) = NULL,
    @Data DATE = NULL
AS
BEGIN
    
    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    
    BEGIN TRY
        
        BEGIN TRANSACTION

        IF @Acao NOT IN ('select', 'insert', 'update', 'delete')
        BEGIN
            RAISERROR('Ação inválida. Use select, insert, update ou delete.', 16, 1)
            RETURN
        END

        IF @Acao = 'select'
        BEGIN
            IF @Id IS NULL
            BEGIN
                SELECT COD_FERIADO, NOME_FERIADO, DATA_FERIADO 
                FROM Feriados
            END
            
            ELSE
            BEGIN
                SELECT COD_FERIADO, NOME_FERIADO, DATA_FERIADO  
                FROM Feriados 
                WHERE COD_FERIADO = @Id
            END
        END

        ELSE IF @Acao = 'insert'
        BEGIN
            
            IF @Nome IS NULL OR @Data IS NULL
            BEGIN
                RAISERROR('Nome e Data são obrigatórios para inserção.', 16, 1)
                RETURN
            END

            INSERT INTO Feriados (NOME_FERIADO, DATA_FERIADO)
            VALUES (@Nome, @Data)

            
            SELECT SCOPE_IDENTITY() AS NovoId
        END

        ELSE IF @Acao = 'update'
        BEGIN
            
            IF @Id IS NULL
            BEGIN
                RAISERROR('Id é obrigatório para atualização.', 16, 1)
                RETURN
            END

            
            IF NOT EXISTS (SELECT 1 FROM Feriados WHERE COD_FERIADO = @Id)
            BEGIN
                RAISERROR('Registro não encontrado para atualização.', 16, 1)
                RETURN
            END

            UPDATE Feriados
            SET NOME_FERIADO = COALESCE(@Nome, NOME_FERIADO),
                DATA_FERIADO = COALESCE(@Data, DATA_FERIADO)
            WHERE COD_FERIADO = @Id

            
            SELECT COD_FERIADO, NOME_FERIADO, DATA_FERIADO  
            FROM Feriados 
            WHERE COD_FERIADO = @Id
        END

        ELSE IF @Acao = 'delete'
        BEGIN
            
            IF @Id IS NULL
            BEGIN
                RAISERROR('Id é obrigatório para exclusão.', 16, 1)
                RETURN
            END

            
            IF NOT EXISTS (SELECT 1 FROM Feriados WHERE COD_FERIADO = @Id)
            BEGIN
                RAISERROR('Registro não encontrado para exclusão.', 16, 1)
                RETURN
            END

            DELETE FROM Feriados
            WHERE COD_FERIADO = @Id
        END

        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()

        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END

DROP PROCEDURE sp_ManipularFeriados


SELECT * FROM Feriados

--SELECT
EXEC sp_ManipularFeriados @Acao = 'select'
EXEC sp_ManipularFeriados @Acao = 'select', @Id = 10

--INSERT
EXEC sp_ManipularFeriados @Acao = 'insert', @Nome = 'Teste', @Data = '2001-01-01'
EXEC sp_ManipularFeriados @Acao = 'select', @Id = 11
SELECT * FROM Feriados

--UPDATE
EXEC sp_ManipularFeriados @Acao = 'update', @Id = 13, @Nome = 'TESTE ID 13'
SELECT * FROM Feriados

--DELETE
EXEC sp_ManipularFeriados @Acao = 'delete', @Id = 17
SELECT * FROM Feriados




