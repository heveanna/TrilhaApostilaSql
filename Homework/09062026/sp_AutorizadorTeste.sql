USE RickBankPower;

GO
DROP PROCEDURE IF EXISTS [dbo].[Sp_InsAutorizadorTeste];

GO 
CREATE PROCEDURE [dbo].[Sp_InsAutorizadorTeste]
	@IdAutorizacao		INT

	AS
	/*	Documentação
		Arquivo Fonte: ProcedureInclusaoTeste.sql
		Objetivo: Testar nova procedure de inclusão
		Autor: Anna Hevellyn 
		Data Criação: 09/06/2026
		Exemplo: BEGIN TRANSACTION
				 DECLARE @RET INT
						 @DAT_INI DATETIME = GETDATE()
				 EXAC @RET = [dbo].[Sp_InclusaoTeste]	 @Id				= 1,
														 @IdFatura			= 1,
														 @Valor				= 100.00,
														 @DataHora			= @DAT_INI,
														 @Loja				= 'TESTE',
														 @Autorizador		= 1
				SELECT @RET AS Retorno,
					   DATEDIFF (MILLISECOND, @DAT_INI, GETDATE() AS 'Tempo(ms)'
				SELECT TOP 1 * FROM [dbo].[Autorizacao] WITH(NOLOCK)
					WHERE Id = 1
				ROLLBACK TRANSACTION
		Retorno -1 retorna os dados inserindos na inclusão
	*/

	BEGIN 
		DECLARE @Limite DECIMAL(10,2) = (
											SELECT	c.Limite  -- limite do cartão 
											FROM [dbo].[Fatura] as f
												JOIN [dbo].[Cartao] as c
													ON c.Id = f.IdCartao
												JOIN [dbo].[Autorizacao] as a
													ON a.IdFatura = f.Id
											WHERE @IdAutorizacao = a.Id)
		DECLARE @Saldo	DECIMAL(10,2) = (
											SELECT	fa.Saldo  -- valor da fatura 
											FROM [dbo].[Fatura] as fa 
												JOIN [dbo].[Autorizacao] as au
													ON au.Id = fa.Id
											WHERE @IdAutorizacao = au.Id)
		DECLARE @ERRO INT 

		IF @Limite < @Saldo + (SELECT au.Valor FROM Autorizacao as au)  -- autorizacao valor compra 
			BEGIN	
				SET @ERRO = -1  -- define um valor 
				RETURN @ERRO
			END
		UPDATE [dbo].[Autorizacao] 
			SET Autorizado = 1
			WHERE @IdAutorizacao = Id
		SELECT @ERRO = @@ERROR
		IF @ERRO <> 0
			BEGIN 
				SET @ERRO = -1
				RETURN @ERRO
			END
	END 
