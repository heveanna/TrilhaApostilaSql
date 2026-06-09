-- Proc Inclusão atuarização 
USE RickBankPower;

GO 
IF EXISTS (SELECT 1 FROM [dbo].[sysobjects] WHERE Id = OBJECT_ID (N'[dbo].[Sp_InsInclusaoAutorizador]')
		AND OBJECTPROPERTY (Id, N'IsProcesure') = 1)
		
	BEGIN 
		DROP PROCEDURE [dbo].[SP_InsInclusao]
	END
GO 

	CREATE PROCEDURE [dbo].[Sp_InsInclusao]
		@Id				INT,
		@IdFatura		INT,
		@Valor			DECIMAL(10,2),
		@DataHora		DATETIME,
		@Loja			VARCHAR(255),
		@Autorizador	BIT

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
												@Loja			= 'Loja da florentina'
												@Autorizador	= 1
			SELECT @RET AS Incluindo,
				   DATEDIFF (MILLISECOND, @DAT_INI, GETDATE() AS ''
			SELECT TOP 1 * FROM [dbo].[Autorizacao] WITH(NOLOCK)
				WHERE Id = 1
				ORDER DataHora ASC
			ROLLBACK TRANSATION 
	Retorno: 1 
*/ 
	BEGIN
		DECLARE @ERRO INT,
				@Id INT

		INSERT INTO [dbo].[Autorizador] (IdFatura, Valor, DataHora, Loja, Autorizador)
		VALUES (@IdFatura, @Valor, @DataHora, @Loja, @Autorizador);
	
		SELECT	@ERRO = @ERROR,
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

		EXEC	@RET = [dbo].[SP_InsAutorizador]
					@IdFatura		= 1,
					@Valor			= 10.50,
					@DataHora		= 


BEGIN TRANSACTION 
					DECLARE @Id	  = re