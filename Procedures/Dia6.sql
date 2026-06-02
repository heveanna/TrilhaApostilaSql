/*
Documentacao:
Arquivo Fonte: Dia6.sql
Objetivo: Criar procedures para inserir, atualizar e excluir lancamentos
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	EXEC [dbo].[SP_InsLancamento] @IdSaldo = 1, @Historico = 'Teste', @DebCre = 'C', @Valor = 500;
*/

USE RicBank2;
GO

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[SP_InsLancamento]') -- " N' " Transforma o nome do objeto em N-string
					AND OBJECTPROPERTY(ID, N'IsProcedure') = 1
	   		)
		BEGIN
			DROP PROCEDURE [dbo].[SP_InsLancamento]
		END
GO

CREATE PROCEDURE [dbo].[SP_InsLancamento]
	   @IdSaldo INT,
	   @DataLancamento DATETIME = NULL,
	   @Historico VARCHAR(200),
	   @DebCre CHAR(1),
	   @Valor DECIMAL(10, 2)
	   AS
		/*
		DOCUMENTACAO

		Arquivo Fonte: Dia6.sql
		Objetivo: Procedimento para inserir lancamentos e atualizar saldo automaticamente via trigger
		Autor: Yure
		Data Criacao: 28/05/2026

		Exemplo: 
			BEGIN TRANSACTION
				DECLARE @Ret INT, @Dat_INI DATETIME = GETDATE()
				EXEC @Ret = [dbo].[SP_InsLancamento]	@IdSaldo = 1,
														@DataLancamento = @Dat_INI,
														@Historico = 'Teste',
														@DebCre = 'C',
														@Valor = 500
			
				SELECT @Ret AS Retorno,
					DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) AS Tempo

				SELECT TOP 1 * FROM [dbo].[Lancamento] WITH(NOLOCK)
					ORDER BY Id DESC

			ROLLBACK TRANSACTION

			Retornos: -1 - Falha na Execucao
					  Retorno Positivo se refere ao Id do Lancamento
		*/
		BEGIN
			DECLARE @ERRO INT,
					@ID INT

			-- Inclusao Registro
			INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
				VALUES (@IdSaldo, ISNULL(@DataLancamento, GETDATE()), @Historico, @DebCre, @Valor)

			SELECT @Erro = @@ERROR, -- Retorna o erro anterior a ele, 0 - Se OK, se nao erro
				   @ID   = Scope_Identity()

			IF @ERRO <> 0
				BEGIN 
					RETURN -1
				END

			RETURN @ID
		END
GO

BEGIN TRANSACTION

	SELECT * FROM [dbo].[Saldo] WHERE Id = 1;

	DECLARE @RET int, 
			@Dat_INI DATETIME = GETDATE();

	EXEC    @RET = [dbo].[SP_InsLancamento] @IdSaldo = 1, 
											@DataLancamento = @Dat_INI,
											@Historico = 'Descricao do lancamento', 
											@DebCre = 'D',
											@Valor = 10.50;

	SELECT @RET as Retorno,
		DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) as Tempo;

	SELECT Top 1 * FROM [dbo].[Lancamento] WITH(NOLOCK)
		ORDER BY Id DESC;

	SELECT * FROM [dbo].[Saldo] WHERE Id = 1;

ROLLBACK TRANSACTION
GO

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[SP_UpdLancamento]') -- " N' " Transforma o nome do objeto em N-string
					AND OBJECTPROPERTY(ID, N'IsProcedure') = 1
	   		)
		BEGIN
			DROP PROCEDURE [dbo].[SP_UpdLancamento]
		END
GO

CREATE PROCEDURE [dbo].[SP_UpdLancamento]
	   @Id INT,
	   @IdSaldo INT,
	   @DataLancamento DATETIME = NULL,
	   @Historico VARCHAR(200),
	   @DebCre CHAR(1),
	   @Valor DECIMAL(10, 2)
	   AS
		/*
		DOCUMENTACAO

		Arquivo Fonte: Dia6.sql
		Objetivo: Procedimento para atualizar lancamentos e atualizar saldo automaticamente via trigger
		Autor: Yure
		Data Criacao: 02/06/2026

		Exemplo: 
			BEGIN TRANSACTION
				DECLARE @Ret INT, @Dat_INI DATETIME = GETDATE()
				EXEC @Ret = [dbo].[SP_UpdLancamento]	@Id = 1,
														@IdSaldo = 1,
														@DataLancamento = @Dat_INI,
														@Historico = 'Lancamento atualizado',
														@DebCre = 'C',
														@Valor = 750
			
				SELECT @Ret AS Retorno,
					DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) AS Tempo

				SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK)
					WHERE Id = 1

			ROLLBACK TRANSACTION

			Retornos: -1 - Falha na Execucao
					   0 - Lancamento nao encontrado
					  Retorno Positivo se refere ao Id do Lancamento
		*/
		BEGIN
			DECLARE @ERRO INT,
					@QTD INT

			-- Atualizacao Registro
			UPDATE [dbo].[Lancamento]
				SET IdSaldo = @IdSaldo,
					DataLancamento = ISNULL(@DataLancamento, GETDATE()),
					Historico = @Historico,
					DebCre = @DebCre,
					Valor = @Valor
				WHERE Id = @Id

			SELECT @Erro = @@ERROR, -- Retorna o erro anterior a ele, 0 - Se OK, se nao erro
				   @QTD  = @@ROWCOUNT

			IF @ERRO <> 0
				BEGIN 
					RETURN -1
				END

			IF @QTD = 0
				BEGIN
					RETURN 0
				END

			RETURN @Id
		END
GO

BEGIN TRANSACTION

	SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK) WHERE Id = 1;
	SELECT * FROM [dbo].[Saldo] WITH(NOLOCK) WHERE Id = 1;

	DECLARE @RET_UPD int, 
			@Dat_INI_UPD DATETIME = GETDATE();

	EXEC    @RET_UPD = [dbo].[SP_UpdLancamento] @Id = 1,
												@IdSaldo = 1, 
												@DataLancamento = @Dat_INI_UPD,
												@Historico = 'Descricao do lancamento atualizada', 
												@DebCre = 'C',
												@Valor = 750.00;

	SELECT @RET_UPD as Retorno,
		DATEDIFF (MILLISECOND, @Dat_INI_UPD, GETDATE()) as Tempo;

	SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK) WHERE Id = 1;
	SELECT * FROM [dbo].[Saldo] WITH(NOLOCK) WHERE Id = 1;

ROLLBACK TRANSACTION
GO

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[SP_DelLancamento]') -- " N' " Transforma o nome do objeto em N-string
					AND OBJECTPROPERTY(ID, N'IsProcedure') = 1
	   		)
		BEGIN
			DROP PROCEDURE [dbo].[SP_DelLancamento]
		END
GO

CREATE PROCEDURE [dbo].[SP_DelLancamento]
	   @Id INT
	   AS
		/*
		DOCUMENTACAO

		Arquivo Fonte: Dia6.sql
		Objetivo: Procedimento para excluir lancamentos e atualizar saldo automaticamente via trigger
		Autor: Yure
		Data Criacao: 02/06/2026

		Exemplo: 
			BEGIN TRANSACTION
				DECLARE @Ret INT, @Dat_INI DATETIME = GETDATE()
				EXEC @Ret = [dbo].[SP_DelLancamento] @Id = 1
			
				SELECT @Ret AS Retorno,
					DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) AS Tempo

				SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK)
					WHERE Id = 1

			ROLLBACK TRANSACTION

			Retornos: -1 - Falha na Execucao
					   0 - Lancamento nao encontrado
					  Retorno Positivo se refere ao Id do Lancamento
		*/
		BEGIN
			DECLARE @ERRO INT,
					@QTD INT

			-- Exclusao Registro
			DELETE FROM [dbo].[Lancamento]
				WHERE Id = @Id

			SELECT @Erro = @@ERROR, -- Retorna o erro anterior a ele, 0 - Se OK, se nao erro
				   @QTD  = @@ROWCOUNT

			IF @ERRO <> 0
				BEGIN 
					RETURN -1
				END

			IF @QTD = 0
				BEGIN
					RETURN 0
				END

			RETURN @Id
		END
GO

BEGIN TRANSACTION

	SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK) WHERE Id = 1;
	SELECT * FROM [dbo].[Saldo] WITH(NOLOCK) WHERE Id = 1;

	DECLARE @RET_DEL int, 
			@Dat_INI_DEL DATETIME = GETDATE();

	EXEC    @RET_DEL = [dbo].[SP_DelLancamento] @Id = 1;

	SELECT @RET_DEL as Retorno,
		DATEDIFF (MILLISECOND, @Dat_INI_DEL, GETDATE()) as Tempo;

	SELECT * FROM [dbo].[Lancamento] WITH(NOLOCK) WHERE Id = 1;
	SELECT * FROM [dbo].[Saldo] WITH(NOLOCK) WHERE Id = 1;

ROLLBACK TRANSACTION
GO
