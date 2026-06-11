-- Proc Inclusão atuarização 
USE RickBankPower;

GO

DROP PROCEDURE  IF EXISTS [dbo].[Sp_InsInclusao];
	
GO

CREATE PROCEDURE [dbo].[Sp_InsInclusao]
	@IdFatura		INT,
	@Valor			DECIMAL(10,2),
	@DataHora		DATETIME,
	@Loja			VARCHAR(255)

	AS
	/*	Documentação
		Arquivo Fonte: ProcedureInclusao.sql
		Objetivo: Incluir valores na conta
		Autor: Anna Hevellyn 
		Data Criação: 09/06/2026
		Exemplo: BEGIN TRANSACTION 
				 DECLARE @RET INT 
						 @DAT_INI DATETIME = GETDATE()
				 EXEC @RET = [dbo].[Sp_Inclusao]	@Id				= 1,
													@IdFatura		= 1,
													@Valor			= 250,
													@DataHora		= @DAT_INI,
													@Loja			= 'Loja da florentina',
													@Autorizador	= 1
				SELECT @RET AS Retorno,
					   DATEDIFF (MILLISECOND, @DAT_INI, GETDATE() AS 'Tempo(ms)'
				SELECT TOP 1 * FROM [dbo].[Autorizacao] WITH(NOLOCK)
					WHERE Id = 1
					ORDER DataHora ASC
				ROLLBACK TRANSATION 
		Retorno: 1 
	*/ 

	-- Inserido dados na procedure

	BEGIN
		DECLARE @ERRO	INT,
				@Id		INT

		INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, DataHora, Loja, Autorizado)
			VALUES (@IdFatura, @Valor, @DataHora, @Loja, 0);
	
		SELECT	@ERRO = @@ERROR,
				@Id	  = SCOPE_IDENTITY();

		IF @ERRO <> 0 
			BEGIN 
				RETURN -1
			END 
		RETURN @Id
	END 
GO 
BEGIN TRANSACTION 
	DECLARE @RET INT,
			@DAT_INI DATETIME = GETDATE()

	EXEC	@RET = [dbo].[Sp_InsInclusao]
				@IdFatura		= 1,
				@Valor			= 10.50,
				@DataHora		= @DAT_INI,
				@Loja			= 'TESTE'

	SELECT @RET AS Retorno
ROLLBACK TRANSACTION
