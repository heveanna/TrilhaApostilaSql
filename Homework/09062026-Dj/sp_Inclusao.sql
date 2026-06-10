USE RicBank2;

DROP PROCEDURE IF EXISTS [dbo].[sp_InsInclusao];
GO

CREATE PROC [dbo].[sp_InsInclusao]
	@IdFatura INT,
	@Valor DECIMAL(10, 2),
	@DataHora DATETIME,
	@Loja VARCHAR(255)
	AS
	/*	Documentação

		Arquivo fonte: sp_Inclusao.sql
		Objetivo: Criar uma instância na tabela [dbo].[Autorizacao].
		Autor: Djefferson dos Santos Lima
		Data: 09/06/2026

		Exemplo:	BEGIN TRAN

						DECLARE	@Retorno INT,
								@DataInicial DATETIME = GETDATE();

						EXEC @Retorno = [dbo].[sp_Inclusao] @IdFatura	= 1, 
															@Valor		=  10, 
															@DataHora	= @DataInicial, 
															@Loja		= 'Lojinha Legal';

						SELECT	@Retorno AS Retorno,
								DATEDIFF(MILLISECOND, @DataInicial, GETDATE()) AS 'Tempo (ts)';

						SELECT TOP 1 * FROM [dbo].[Autorizacao] WITH(NOLOCK)
							ORDER BY Id DESC;

					ROLLBACK TRAN

		Retorno:	-1 = Falha na execução
					Retorno positivo se refere ao ID do lançamento

	*/
	BEGIN

		DECLARE @Erro	INT,
				@Id		INT;

		INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, Loja, DataHora, Autorizado)
			VALUES (@IdFatura, @Valor, @Loja, @DataHora, 0);

		SELECT	@Erro	= @@ERROR,
				@Id		= SCOPE_IDENTITY();

		IF @Erro <> 0 
			BEGIN
				RETURN -1
			END

		RETURN @Id

	END
GO

-- Testando a procedure

BEGIN TRAN

	INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite) -- Pop
		VALUES ('1234567890123456', GETDATE(), 0, 100.00)

	INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
		VALUES (SCOPE_IDENTITY(), 1, 0, GETDATE(), 0)

	DECLARE	@Retorno INT,
			@DataInicial DATETIME = GETDATE(),
			@IdFatura INT = SCOPE_IDENTITY();

	EXEC @Retorno = [dbo].[sp_InsInclusao] @IdFatura	= @IdFatura, 
										@Valor		= 10, 
										@DataHora	= @DataInicial, 
										@Loja		= 'Lojinha Legal';

	SELECT	@Retorno AS Retorno,
			DATEDIFF(MILLISECOND, @DataInicial, GETDATE()) AS 'Tempo (ts)';

	SELECT TOP 1 * FROM [dbo].[Autorizacao] WITH(NOLOCK)
		ORDER BY Id DESC;

ROLLBACK TRAN
