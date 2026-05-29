USE RicBank2;

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects] WHERE Id = OBJECT_ID(N'[dbo].[SP_InsLancamento]') AND OBJECTPROPERTY(Id, N'IsProcedure') = 1)
	BEGIN
		DROP PROCEDURE [dbo].[SP_InsLancamento]
	END
GO
CREATE PROCEDURE [dbo].[SP_InsLancamento]
	@IdSaldo			INT,
	@DataLancamento		DATETIME		= GETDATE,
	@Historico			VARCHAR(200),
	@DebCre				CHAR(1),
	@Valor				DECIMAL(10,2)

AS
	/*
		Arquivo Fonte:	C:\Caminho\Arquivo.sql
		Objetivo:		Inserir lançamento
		Autor:			
		Data Criação:	28/05/2026
		Exemplo:		BEGIN TRANSACTION
						DECLARE @RET INT, 
								@DAT_INI DATETIME = GETDATE()
						EXEC @RET = [dbo].[SP_InsLancamento]	@IdSaldo = 1,
																@DataLancamento = @DAT_INI,
																@Historico = 'Teste',
																@DebCre = 'c',
																@Valor = 500
						SELECT	@RET AS Retorno,
								DATEDIFF(MILLISECOND, @DAT_INI, GETDATE()) AS 'Tempo (ms)'
						SELECT TOP 1 * FROM [dbo].[Lancamento] WITH (NOLOCK)
							ORDER BY ID DESC
					ROLLBACK TRANSACTION

		Retornos:	-1 - Falha na Execução
					Retorno positivo se refere ao ID do Lançamento
	*/
BEGIN
	DECLARE @Erro	INT,
			@Id		INT
	-- Inclusão Registro
	INSERT INTO [dbo].[Lancamento](IdSaldo, DataLancamento, Historico, DebCre, Valor)
		VALUES (@IdSaldo, @DataLancamento, @Historico, @DebCre, @Valor);
	SELECT	@Erro	= @@ERROR,
			@Id		= SCOPE_IDENTITY()
	IF @Erro <> 0
		BEGIN
			RETURN -1
		END

	RETURN @Id

END

BEGIN TRANSACTION
						DECLARE @RET INT, 
								@DAT_INI DATETIME = GETDATE()
						EXEC @RET = [dbo].[SP_InsLancamento]	@IdSaldo = 1,
																@DataLancamento = @DAT_INI,
																@Historico = 'Teste',
																@DebCre = 'c',
																@Valor = 500
						SELECT	@RET AS Retorno,
								DATEDIFF(MILLISECOND, @DAT_INI, GETDATE()) AS 'Tempo (ms)'
						SELECT TOP 1 * FROM [dbo].[Lancamento] WITH (NOLOCK)
							ORDER BY ID DESC
ROLLBACK TRANSACTION
