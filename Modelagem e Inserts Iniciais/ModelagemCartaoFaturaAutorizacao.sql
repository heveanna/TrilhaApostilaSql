USE RickBankPower;

CREATE TABLE Cartao(
						Id			INT				IDENTITY(1,1),
						Numero		CHAR(16)		NOT NULL,
						Validade	DATE			NOT NULL,
						Bloqueado	BIT				NOT NULL	CONSTRAINT DF_Bloqueado_Cartao DEFAULT 0,
						Limite		DECIMAL(10,2)	NOT NULL

						CONSTRAINT	PK_IdCartao			PRIMARY KEY	(Id),
						CONSTRAINT	UQ_Numero_Cartao	UNIQUE	(Numero)
);

CREATE TABLE Fatura(
						Id				INT				IDENTITY(1,1),
						IdCartao		INT				NOT NULL,
						Numero			INT				NOT NULL,
						Saldo			DECIMAL(10,2)	NOT NULL,
						DataFechamento	DATETIME		NOT NULL,
						Pago			BIT				CONSTRAINT DF_Pago_Fatura DEFAULT 0,

						CONSTRAINT	PK_IdFatura			PRIMARY KEY (Id),
						CONSTRAINT	FK_IdCartao_Fatura	FOREIGN KEY (IdCartao) REFERENCES Cartao (Id),
						CONSTRAINT	UQ_Numero_Fatura	UNIQUE		(Numero)
);

CREATE TABLE Autorizacao(
							Id			INT				IDENTITY(1,1),
							IdFatura	INT				NOT NULL,
							Valor		DECIMAL(10,2)	NOT NULL,
							DataHora	DATETIME		NOT NULL,
							Loja		VARCHAR(255)	NOT NULL,
							Autorizado 	BIT				NOT NULL

							CONSTRAINT	PK_IdAutorizacao		PRIMARY KEY (Id),
							CONSTRAINT	FK_IdFatura_Autorizacao	FOREIGN KEY	(IdFatura)	REFERENCES Fatura (Id)
);
