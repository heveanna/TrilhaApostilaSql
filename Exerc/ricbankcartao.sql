/*
DOCUMENTAÇÃO

Arquivo Fonte: ricbankcartao.sql
Objetivo: Criar modelagem, trigger e procedures para Cartao, Fatura e Autorizacao
Autor: Yure
Data Criação: 09/06/2026

Exemplo:
	Executar após Modelagem.sql.
*/

USE RicBank2;
GO

CREATE TABLE [dbo].[Cartao](
						Id			INT				IDENTITY(1,1),
						Numero		CHAR(16)		NOT NULL,
						Validade	DATE			NOT NULL,
						Bloqueado	BIT				NOT NULL	CONSTRAINT DF_Bloqueado_Cartao DEFAULT 0,
						Limite		DECIMAL(10,2)	NOT NULL,

						CONSTRAINT	PK_IdCartao			PRIMARY KEY	(Id),
						CONSTRAINT	UQ_Numero_Cartao	UNIQUE	(Numero)
);
GO

CREATE TABLE [dbo].[Fatura](
						Id				INT				IDENTITY(1,1),
						IdCartao		INT				NOT NULL,
						Numero			INT				NOT NULL,
						Saldo			DECIMAL(10,2)	NOT NULL,
						DataFechamento	DATETIME		NOT NULL,
						Pago			BIT				CONSTRAINT DF_Pago_Fatura DEFAULT 0,

						CONSTRAINT	PK_IdFatura			PRIMARY KEY (Id),
						CONSTRAINT	FK_IdCartao_Fatura	FOREIGN KEY (IdCartao) REFERENCES [dbo].[Cartao] (Id),
						CONSTRAINT	UQ_Numero_Fatura	UNIQUE		(Numero)
);
GO

CREATE TABLE [dbo].[Autorizacao](
							Id			INT				IDENTITY(1,1),
							IdFatura	INT				NOT NULL,
							Valor		DECIMAL(10,2)	NOT NULL,
							DataHora	DATETIME		NOT NULL,
							Loja		VARCHAR(255)	NOT NULL,
							Autorizado 	BIT				NOT NULL,

							CONSTRAINT	PK_IdAutorizacao		PRIMARY KEY (Id),
							CONSTRAINT	FK_IdFatura_Autorizacao	FOREIGN KEY	(IdFatura)	REFERENCES [dbo].[Fatura] (Id)
);
GO

/* ======================================
   TRIGGER PARA ATUALIZAR SALDO DA FATURA
   ====================================== */

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[TRG_AtualizarSaldoFatura]')
					AND TYPE = 'TR'
	   		)
		BEGIN
			DROP TRIGGER [dbo].[TRG_AtualizarSaldoFatura]
		END
GO

		CREATE TRIGGER [dbo].[TRG_AtualizarSaldoFatura]
			ON [dbo].[Autorizacao]
			FOR INSERT, DELETE, UPDATE

			/*
			DOCUMENTAÇÃO

			Arquivo Fonte: ricbankcartao.sql
			Objetivo: Atualizar saldo da fatura conforme autorizacoes aprovadas
			Autor: Yure
			Data Criacao: 09/06/2026

			Exemplo:
				INSERT INTO [dbo].[Autorizacao](IdFatura, Valor, DataHora, Loja, Autorizado)
					VALUES (1, 100.00, GETDATE(), 'Mercado Teste', 1);
			*/

			AS
			BEGIN
				SET NOCOUNT ON

				UPDATE FT
					SET FT.Saldo = FT.Saldo - DE.Valor
					FROM [dbo].[Fatura] FT
						INNER JOIN (
							SELECT
								IdFatura,
								SUM(Valor) AS Valor
								FROM deleted
								WHERE Autorizado = 1
								GROUP BY IdFatura
						) DE
							ON FT.Id = DE.IdFatura

				UPDATE FT
					SET FT.Saldo = FT.Saldo + INS.Valor
					FROM [dbo].[Fatura] FT
						INNER JOIN (
							SELECT
								IdFatura,
								SUM(Valor) AS Valor
								FROM inserted
								WHERE Autorizado = 1
								GROUP BY IdFatura
						) INS
							ON FT.Id = INS.IdFatura
			END
GO

/* ======================================
   PROCEDURE PARA INCLUIR CARTÃO E FATURA
   ====================================== */

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[SP_InsCartao]')
					AND OBJECTPROPERTY(ID, N'IsProcedure') = 1
	   		)
		BEGIN
			DROP PROCEDURE [dbo].[SP_InsCartao]
		END
GO

CREATE PROCEDURE [dbo].[SP_InsCartao]
	   @Numero CHAR(16),
	   @Validade DATE,
	   @Limite DECIMAL(10, 2),
	   @Bloqueado BIT = 0,
	   @NumeroFatura INT = NULL,
	   @DataFechamento DATETIME = NULL
	   AS
		/*
		DOCUMENTAÇÃO

		Arquivo Fonte: ricbankcartao.sql
		Objetivo: Procedimento para incluir cartao e criar sua primeira fatura em aberto
		Autor: Yure
		Data Criacao: 09/06/2026

		Exemplo:
			BEGIN TRANSACTION
				DECLARE @Ret INT, @Dat_INI DATETIME = GETDATE()
				EXEC @Ret = [dbo].[SP_InsCartao]	@Numero = '1234567890123456',
													@Validade = '2030-12-31',
													@Limite = 3000.00,
													@Bloqueado = 0,
													@NumeroFatura = 1001,
													@DataFechamento = '2026-07-10'

				SELECT @Ret AS Retorno,
					DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) AS Tempo

				SELECT *
					FROM [dbo].[Cartao] WITH(NOLOCK)
					WHERE Id = @Ret

				SELECT *
					FROM [dbo].[Fatura] WITH(NOLOCK)
					WHERE IdCartao = @Ret

			ROLLBACK TRANSACTION

			Retornos: -1 - Falha na Execucao
					  -2 - Numero de cartao ja cadastrado
					  Retorno Positivo se refere ao Id do Cartao
		*/
		BEGIN
			DECLARE @ERRO INT,
					@ID INT,
					@QTD INT

			SELECT @QTD = COUNT(1)
				FROM [dbo].[Cartao] WITH(NOLOCK)
				WHERE Numero = @Numero

			IF @QTD > 0
				BEGIN
					RETURN -2
				END

			-- Inclusão Cartão
			INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
				VALUES (@Numero, @Validade, @Bloqueado, @Limite)

			SELECT @Erro = @@ERROR,
				   @ID   = Scope_Identity()

			IF @ERRO <> 0
				BEGIN
					RETURN -1
				END

			-- Inclusão Fatura Inicial
			INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
				VALUES (@ID, ISNULL(@NumeroFatura, @ID), 0.00, ISNULL(@DataFechamento, DATEADD(DAY, 30, GETDATE())), 0)

			SELECT @Erro = @@ERROR

			IF @ERRO <> 0
				BEGIN
					RETURN -1
				END

			RETURN @ID
		END
GO

/* ======================
   PROCEDURE AUTORIZADORA
   ====================== */

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[SP_AutorizadorCartao]')
					AND OBJECTPROPERTY(ID, N'IsProcedure') = 1
	   		)
		BEGIN
			DROP PROCEDURE [dbo].[SP_AutorizadorCartao]
		END
GO

CREATE PROCEDURE [dbo].[SP_AutorizadorCartao]
	   @NumeroCartao CHAR(16),
	   @Valor DECIMAL(10, 2),
	   @Loja VARCHAR(255),
	   @DataHora DATETIME = NULL
	   AS
		/*
		DOCUMENTAÇÃO

		Arquivo Fonte: ricbankcartao.sql
		Objetivo: Procedimento para autorizar compras conforme status, validade e limite disponivel do cartao
		Autor: Yure
		Data Criacao: 09/06/2026

		Exemplo:
			BEGIN TRANSACTION
				DECLARE @Ret INT, @Dat_INI DATETIME = GETDATE()
				EXEC @Ret = [dbo].[SP_AutorizadorCartao]	@NumeroCartao = '1234567890123456',
															@Valor = 150.00,
															@Loja = 'Mercado Teste',
															@DataHora = @Dat_INI

				SELECT @Ret AS Retorno,
					DATEDIFF (MILLISECOND, @Dat_INI, GETDATE()) AS Tempo

				SELECT TOP 1 *
					FROM [dbo].[Autorizacao] WITH(NOLOCK)
					ORDER BY Id DESC

				SELECT FT.*
					FROM [dbo].[Fatura] FT WITH(NOLOCK)
						INNER JOIN [dbo].[Cartao] CT WITH(NOLOCK)
							ON CT.Id = FT.IdCartao
					WHERE CT.Numero = '1234567890123456'

			ROLLBACK TRANSACTION

			Retornos: -1 - Falha na Execução
					  -2 - Cartao não encontrado
					  -3 - Cartao bloqueado
					  -4 - Cartao vencido
					  -5 - Fatura em aberto não encontrada
					  -6 - Valor inválido
					  -7 - Limite insuficiente
					  Retorno Positivo se refere ao Id da Autorizacao
		*/
		BEGIN
			DECLARE @ERRO INT,
					@ID INT,
					@IdCartao INT,
					@IdFatura INT,
					@Validade DATE,
					@Bloqueado BIT,
					@Limite DECIMAL(10, 2),
					@Saldo DECIMAL(10, 2),
					@Autorizado BIT

			SELECT @IdCartao = Id,
				   @Validade = Validade,
				   @Bloqueado = Bloqueado,
				   @Limite = Limite
				FROM [dbo].[Cartao] WITH(NOLOCK)
				WHERE Numero = @NumeroCartao

			IF @IdCartao IS NULL
				BEGIN
					RETURN -2
				END

			IF @Bloqueado = 1
				BEGIN
					RETURN -3
				END

			IF @Validade < CONVERT(DATE, ISNULL(@DataHora, GETDATE()))
				BEGIN
					RETURN -4
				END

			SELECT TOP 1
				   @IdFatura = Id,
				   @Saldo = Saldo
				FROM [dbo].[Fatura] WITH(NOLOCK)
				WHERE IdCartao = @IdCartao
					AND Pago = 0
				ORDER BY DataFechamento DESC

			IF @IdFatura IS NULL
				BEGIN
					RETURN -5
				END

			IF @Valor <= 0
				BEGIN
					RETURN -6
				END

			IF @Saldo + @Valor > @Limite
				BEGIN
					SET @Autorizado = 0
				END
			ELSE
				BEGIN
					SET @Autorizado = 1
				END

			-- Inclusão Autorização
			INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, DataHora, Loja, Autorizado)
				VALUES (@IdFatura, @Valor, ISNULL(@DataHora, GETDATE()), @Loja, @Autorizado)

			SELECT @Erro = @@ERROR,
				   @ID   = Scope_Identity()

			IF @ERRO <> 0
				BEGIN
					RETURN -1
				END

			IF @Autorizado = 0
				BEGIN
					RETURN -7
				END

			RETURN @ID
		END
GO

/* ======================
   DADOS BÁSICOS DE TESTE
   ====================== */

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Cartao] WITH(NOLOCK)
		WHERE Numero = '1111222233334444'
)
BEGIN
	INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
		VALUES ('1111222233334444', CONVERT(DATE, '20311231', 112), 0, 3000.00)
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Cartao] WITH(NOLOCK)
		WHERE Numero = '5555666677778888'
)
BEGIN
	INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
		VALUES ('5555666677778888', CONVERT(DATE, '20300630', 112), 1, 1500.00)
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Cartao] WITH(NOLOCK)
		WHERE Numero = '9999000011112222'
)
BEGIN
	INSERT INTO [dbo].[Cartao] (Numero, Validade, Bloqueado, Limite)
		VALUES ('9999000011112222', CONVERT(DATE, '20250131', 112), 0, 2000.00)
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Fatura] WITH(NOLOCK)
		WHERE Numero = 9001
)
BEGIN
	INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
		SELECT Id, 9001, 0.00, CONVERT(DATETIME, '20260710', 112), 0
			FROM [dbo].[Cartao]
			WHERE Numero = '1111222233334444'
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Fatura] WITH(NOLOCK)
		WHERE Numero = 9002
)
BEGIN
	INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
		SELECT Id, 9002, 0.00, CONVERT(DATETIME, '20260715', 112), 0
			FROM [dbo].[Cartao]
			WHERE Numero = '5555666677778888'
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Fatura] WITH(NOLOCK)
		WHERE Numero = 9003
)
BEGIN
	INSERT INTO [dbo].[Fatura] (IdCartao, Numero, Saldo, DataFechamento, Pago)
		SELECT Id, 9003, 0.00, CONVERT(DATETIME, '20250210', 112), 0
			FROM [dbo].[Cartao]
			WHERE Numero = '9999000011112222'
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Autorizacao] WITH(NOLOCK)
		WHERE Loja = 'Mercado Central'
			AND DataHora = CONVERT(DATETIME, '2026-06-10T10:00:00', 126)
)
BEGIN
	INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, DataHora, Loja, Autorizado)
		SELECT Id, 120.50, CONVERT(DATETIME, '2026-06-10T10:00:00', 126), 'Mercado Central', 1
			FROM [dbo].[Fatura]
			WHERE Numero = 9001
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Autorizacao] WITH(NOLOCK)
		WHERE Loja = 'Farmacia Vida'
			AND DataHora = CONVERT(DATETIME, '2026-06-10T11:30:00', 126)
)
BEGIN
	INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, DataHora, Loja, Autorizado)
		SELECT Id, 89.90, CONVERT(DATETIME, '2026-06-10T11:30:00', 126), 'Farmacia Vida', 1
			FROM [dbo].[Fatura]
			WHERE Numero = 9001
END
GO

IF NOT EXISTS (
	SELECT 1
		FROM [dbo].[Autorizacao] WITH(NOLOCK)
		WHERE Loja = 'Loja Premium'
			AND DataHora = CONVERT(DATETIME, '2026-06-10T12:15:00', 126)
)
BEGIN
	INSERT INTO [dbo].[Autorizacao] (IdFatura, Valor, DataHora, Loja, Autorizado)
		SELECT Id, 5000.00, CONVERT(DATETIME, '2026-06-10T12:15:00', 126), 'Loja Premium', 0
			FROM [dbo].[Fatura]
			WHERE Numero = 9001
END
GO


/* Consultas uteis para validação: */

SELECT *
	FROM [dbo].[Cartao]

SELECT *
	FROM [dbo].[Fatura]

SELECT *
	FROM [dbo].[Autorizacao]

SELECT CT.Numero,
	   CT.Bloqueado,
	   CT.Validade,
	   CT.Limite,
	   FT.Numero AS NumeroFatura,
	   FT.Saldo,
	   FT.DataFechamento,
	   AU.Valor,
	   AU.Loja,
	   AU.Autorizado
	FROM [dbo].[Cartao] CT
		INNER JOIN [dbo].[Fatura] FT
			ON FT.IdCartao = CT.Id
		LEFT JOIN [dbo].[Autorizacao] AU
			ON AU.IdFatura = FT.Id
	ORDER BY CT.Id, FT.Id, AU.Id

