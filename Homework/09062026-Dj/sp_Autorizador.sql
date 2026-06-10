USE RicBank2;

DROP PROCEDURE IF EXISTS [dbo].[sp_Autorizador];
GO

CREATE PROC [dbo].[sp_Autorizador]
	@IdAutorizacao INT
	AS
	/*	Documentacao
		
		Arquivo fonte: sp_Autorizador.sql
		Objetivo:	Verificar se uma instância da tabela [dbo].[Autorizacao] 
					pode ser autorizada para aplicar o valor à fatura.
		Autor: Djefferson dos Santos Lima
		Data criação: 09/06/2026
		
		Exemplo:	BEGIN TRAN
	
						DECLARE	@Retorno INT,
								@DataInicial DATETIME = GETDATE(),
								@IdAutorizacaoTeste INT,
								@IdFaturaTeste INT;

						INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
							VALUES ('1234567890123456', GETDATE(), 0, 100.00)
	
						INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
							VALUES (SCOPE_IDENTITY(), 1, 0, GETDATE(), 0)

						SET @IdFaturaTeste = SCOPE_IDENTITY();

						EXEC @IdAutorizacaoTeste = [dbo].[sp_InsInclusao]	@IdFatura	= @IdFaturaTeste,
																			@Valor		= 10,
																			@DataHora	= @DataInicial,
																			@Loja		= 'Lojinha legal'

						EXEC @Retorno = [dbo].[sp_Autorizador]	@IdAutorizacao = @IdAutorizacaoTeste;

						SELECT	@Retorno as Retorno,
								DATEDIFF (MILLISECOND, @DataInicial, GETDATE()) AS 'Tempo (ts)';

						SELECT	*	FROM [dbo].[Autorizacao] WHERE Id = @IdAutorizacaoTeste

					ROLLBACK TRAN

		Retorno:	-1	= Algum erro impediu a conclusão da procedure.
					-2	= A autorizacao foi rejeitada pois o valor excederia o limite de crédito.
					Quando retornar o Id da autorizacao, ocorreu tudo bem e ela foi aprovada.

	*/
	BEGIN
		DECLARE	@Erro INT = @@ERROR;

		DECLARE	@Limite DECIMAL(10, 2) =	(
												SELECT ca.Limite
													FROM [dbo].[Autorizacao] as au
														INNER JOIN [dbo].[Fatura] as fa
															ON fa.Id = au.IdFatura
														INNER JOIN [dbo].[Cartao] as ca
															ON ca.Id = fa.IdCartao
													WHERE au.Id = @IdAutorizacao
											);

		DECLARE @SaldoFatura DECIMAL(10, 2) =	(
													SELECT	fa.Saldo
														FROM [dbo].[Autorizacao] as au
															INNER JOIN [dbo].[Fatura] as fa
																ON fa.Id = au.IdFatura
														WHERE au.Id = @IdAutorizacao
												);

		DECLARE @ValorAutorizacao DECIMAL(10, 2) =	( SELECT Valor FROM [dbo].[Autorizacao] WHERE Id = @IdAutorizacao );

		IF @Erro <> 0
			BEGIN
				RETURN -1
			END

		IF @Limite < ( @SaldoFatura + @ValorAutorizacao )
			BEGIN

				UPDATE [dbo].[Autorizacao]
					SET Autorizado = 0
					WHERE Id = @IdAutorizacao;
				RETURN -2

			END

		UPDATE [dbo].[Autorizacao]
			SET Autorizado = 1
			WHERE Id = @IdAutorizacao;

		RETURN @IdAutorizacao;

	END
GO


-- Testando proc

BEGIN TRAN
	
	DECLARE	@Retorno INT,
			@DataInicial DATETIME = GETDATE(),
			@IdAutorizacaoTeste INT,
			@IdFaturaTeste INT;

	INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
		VALUES ('1234567890123456', GETDATE(), 0, 100.00)
	
	INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
		VALUES (SCOPE_IDENTITY(), 1, 0, GETDATE(), 0)

	SET @IdFaturaTeste = SCOPE_IDENTITY();

	EXEC @IdAutorizacaoTeste = [dbo].[sp_InsInclusao]	@IdFatura	= @IdFaturaTeste,
														@Valor		= 10,
														@DataHora	= @DataInicial,
														@Loja		= 'Lojinha legal'

	EXEC @Retorno = [dbo].[sp_Autorizador]	@IdAutorizacao = @IdAutorizacaoTeste;

	SELECT	@Retorno as Retorno,
			DATEDIFF (MILLISECOND, @DataInicial, GETDATE()) AS 'Tempo (ts)';

	SELECT	*	FROM [dbo].[Autorizacao] WHERE Id = @IdAutorizacaoTeste

ROLLBACK TRAN