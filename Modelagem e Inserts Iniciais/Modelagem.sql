/*
Documentacao:
Arquivo Fonte: Modelagem.sql
Objetivo: Criar o banco RicBank2 e as tabelas principais do projeto
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	Executar este script antes dos inserts iniciais.
*/

CREATE DATABASE RicBank2;
GO

USE RicBank2;
GO

CREATE TABLE [dbo].[Cliente](
							Id				INT				IDENTITY(1,1),
							Nome			VARCHAR(100)	NOT NULL,
							Email			VARCHAR(255)	NOT NULL,
							CPF				BIGINT			NOT NULL,
							DataNascimento	DATE			NOT NULL,
							DataCadastro	DATETIME		NOT NULL,

							CONSTRAINT PK_IdCliente		PRIMARY KEY(Id),
							CONSTRAINT UQ_CPF_Cliente	UNIQUE (CPF)
							);
GO

CREATE TABLE [dbo].[Agencia](
							Id				INT				IDENTITY(1,1),
							Numero			INT				NOT NULL,
							Nome			VARCHAR(100)	NOT NULL,
							DataCadastro	DATETIME		NOT NULL,

							CONSTRAINT PK_IdAgencia			PRIMARY KEY	(Id),
							CONSTRAINT UQ_Numero_Agencia	UNIQUE		(Numero)
							);
GO

CREATE TABLE [dbo].[Tipo](
						 Id		TINYINT			NOT NULL,
						 Nome	VARCHAR(100)	NOT NULL,

						 CONSTRAINT	PK_IdTipo		PRIMARY KEY (Id),
						 CONSTRAINT	UQ_Nome_Tipo	UNIQUE (Nome)
						 );
GO

INSERT INTO [dbo].[Tipo](Id, Nome)
	VALUES	(1, 'Debito Automatico'),
			(2, 'Cartao Credito'),
			(3, 'Transferencia'),
			(4, 'Agencia'),
			(5, 'Internet'),
			(6, 'Pix');
GO

CREATE TABLE [dbo].[Conta](
							Id				INT			IDENTITY(1,1),
							IdCliente		INT			NOT NULL,
							IdAgencia		INT			NOT NULL,
							Numero			INT			NOT NULL,
							DataCadastro	DATETIME	NOT NULL,

							CONSTRAINT PK_IdConta			PRIMARY KEY (Id),
							CONSTRAINT FK_IdCliente_Conta	FOREIGN KEY (IdCliente) REFERENCES [dbo].[Cliente](Id),
							CONSTRAINT FK_IdAgencia_Conta	FOREIGN KEY (IdAgencia) REFERENCES [dbo].[Agencia](Id)
							);
GO

CREATE TABLE [dbo].[Saldo](
							Id				INT				IDENTITY(1,1),
							IdConta			INT				NOT NULL,
							DataSaldo		DATETIME		NOT NULL,
							SaldoInicial	DECIMAL(10,2)	NOT NULL,
							Credito			DECIMAL(10,2)	NOT NULL,
							Debito			DECIMAL(10,2)	NOT NULL,

							CONSTRAINT PK_IdSaldo		PRIMARY KEY (Id),
							CONSTRAINT FK_IdConta_Saldo FOREIGN KEY (IdConta) REFERENCES [dbo].[Conta](Id)
							);
GO

CREATE TABLE [dbo].[Lancamento](
								Id				INT				IDENTITY(1,1),
								IdSaldo			INT				NOT NULL,
								DataLancamento	DATETIME		NOT NULL,
								Historico		VARCHAR(200)	NOT NULL,
								DebCre			CHAR(1)			NOT NULL,
								Valor			DECIMAL(10,2)	NOT NULL,

								CONSTRAINT PK_IdLancamento			PRIMARY KEY (Id),
								CONSTRAINT FK_IdSaldo_Lancamento	FOREIGN KEY (IdSaldo) REFERENCES [dbo].[Saldo](Id)
								);
GO
