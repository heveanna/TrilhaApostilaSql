/*
Documentacao:
Arquivo Fonte: InsertsUpdatesLancamento.sql
Objetivo: Criar scripts que incluam lancamentos e atualizem saldo
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	Executar apos Modelagem.sql e Inserts.sql.
*/

USE RicBank2;
GO

-- HOMEWORK: Criar scripts que incluam lancamento e atualizem saldo (30 lancamentos de diversas contas)

/* ============================================================
   CLIENTES - 30 USUARIOS
   ============================================================ */

INSERT INTO [dbo].[Cliente](Nome, Email, CPF, DataNascimento, DataCadastro)
	VALUES
	('Cliente 01', 'cliente01@email.com', 10000000001, '1995-01-10', GETDATE()),
	('Cliente 02', 'cliente02@email.com', 10000000002, '1996-02-11', GETDATE()),
	('Cliente 03', 'cliente03@email.com', 10000000003, '1997-03-12', GETDATE()),
	('Cliente 04', 'cliente04@email.com', 10000000004, '1998-04-13', GETDATE()),
	('Cliente 05', 'cliente05@email.com', 10000000005, '1999-05-14', GETDATE()),
	('Cliente 06', 'cliente06@email.com', 10000000006, '2000-06-15', GETDATE()),
	('Cliente 07', 'cliente07@email.com', 10000000007, '1994-07-16', GETDATE()),
	('Cliente 08', 'cliente08@email.com', 10000000008, '1993-08-17', GETDATE()),
	('Cliente 09', 'cliente09@email.com', 10000000009, '1992-09-18', GETDATE()),
	('Cliente 10', 'cliente10@email.com', 10000000010, '1991-10-19', GETDATE()),
	('Cliente 11', 'cliente11@email.com', 10000000011, '1990-11-20', GETDATE()),
	('Cliente 12', 'cliente12@email.com', 10000000012, '1989-12-21', GETDATE()),
	('Cliente 13', 'cliente13@email.com', 10000000013, '1988-01-22', GETDATE()),
	('Cliente 14', 'cliente14@email.com', 10000000014, '1987-02-23', GETDATE()),
	('Cliente 15', 'cliente15@email.com', 10000000015, '1986-03-24', GETDATE()),
	('Cliente 16', 'cliente16@email.com', 10000000016, '1985-04-25', GETDATE()),
	('Cliente 17', 'cliente17@email.com', 10000000017, '1984-05-26', GETDATE()),
	('Cliente 18', 'cliente18@email.com', 10000000018, '1983-06-27', GETDATE()),
	('Cliente 19', 'cliente19@email.com', 10000000019, '1982-07-28', GETDATE()),
	('Cliente 20', 'cliente20@email.com', 10000000020, '1981-08-29', GETDATE()),
	('Cliente 21', 'cliente21@email.com', 10000000021, '1980-09-30', GETDATE()),
	('Cliente 22', 'cliente22@email.com', 10000000022, '1995-10-01', GETDATE()),
	('Cliente 23', 'cliente23@email.com', 10000000023, '1996-11-02', GETDATE()),
	('Cliente 24', 'cliente24@email.com', 10000000024, '1997-12-03', GETDATE()),
	('Cliente 25', 'cliente25@email.com', 10000000025, '1998-01-04', GETDATE()),
	('Cliente 26', 'cliente26@email.com', 10000000026, '1999-02-05', GETDATE()),
	('Cliente 27', 'cliente27@email.com', 10000000027, '2000-03-06', GETDATE()),
	('Cliente 28', 'cliente28@email.com', 10000000028, '2001-04-07', GETDATE()),
	('Cliente 29', 'cliente29@email.com', 10000000029, '2002-05-08', GETDATE()),
	('Cliente 30', 'cliente30@email.com', 10000000030, '2003-06-09', GETDATE());
GO

/* ============================================================
   CONTAS
   IdCliente PAR = conta nas duas agencias
   IdCliente IMPAR = conta em uma agencia
   ============================================================ */

INSERT INTO [dbo].[Conta](IdCliente, IdAgencia, Numero, DataCadastro)
	SELECT 
		C.Id,
		1,
		20000 + C.Id,
		GETDATE()
		FROM [dbo].[Cliente] C
		WHERE C.CPF BETWEEN 10000000001 AND 10000000030;
GO

INSERT INTO [dbo].[Conta](IdCliente, IdAgencia, Numero, DataCadastro)
	SELECT 
		C.Id,
		2,
		30000 + C.Id,
		GETDATE()
		FROM [dbo].[Cliente] C
		WHERE C.CPF BETWEEN 10000000001 AND 10000000030
			AND C.Id % 2 = 0;
GO

/* ============================================================
   SALDO INICIAL PARA CADA CONTA
   ============================================================ */

INSERT INTO [dbo].[Saldo](IdConta, DataSaldo, SaldoInicial, Credito, Debito)
	SELECT 
		C.Id,
		GETDATE(),
		0.00,
		0.00,
		0.00
		FROM [dbo].[Conta] C
		WHERE NOT EXISTS (
			SELECT 1 
			FROM [dbo].[Saldo] S 
			WHERE S.IdConta = C.Id
);
GO

/* ============================================================
   LANCAMENTOS - 30 REGISTROS
   D = Debito
   C = Credito
   ============================================================ */

INSERT INTO [dbo].[Lancamento](IdSaldo, DataLancamento, Historico, DebCre, Valor)
	VALUES
		(1,  GETDATE(), 'Deposito inicial via Pix',              'C', 500.00),
		(2,  GETDATE(), 'Pagamento de boleto',                   'D', 120.00),
		(3,  GETDATE(), 'Transferencia recebida',                'C', 300.00),
		(4,  GETDATE(), 'Compra no cartao de debito',            'D', 80.00),
		(5,  GETDATE(), 'Deposito em agencia',                   'C', 1000.00),
		(6,  GETDATE(), 'Saque em caixa eletronico',             'D', 200.00),
		(7,  GETDATE(), 'Pix recebido',                          'C', 250.00),
		(8,  GETDATE(), 'Pagamento de conta de energia',         'D', 180.00),
		(9,  GETDATE(), 'TED recebida',                          'C', 700.00),
		(10, GETDATE(), 'Pagamento de internet',                 'D', 99.90),
		(11, GETDATE(), 'Credito de salario',                    'C', 2500.00),
		(12, GETDATE(), 'Compra supermercado',                   'D', 350.75),
		(13, GETDATE(), 'Transferencia entre contas',            'C', 450.00),
		(14, GETDATE(), 'Pagamento cartao de credito',           'D', 600.00),
		(15, GETDATE(), 'Deposito via envelope',                 'C', 900.00),
		(16, GETDATE(), 'Saque em agencia',                      'D', 300.00),
		(17, GETDATE(), 'Pix recebido de terceiro',              'C', 150.00),
		(18, GETDATE(), 'Pagamento assinatura streaming',        'D', 39.90),
		(19, GETDATE(), 'Transferencia recebida via internet',   'C', 800.00),
		(20, GETDATE(), 'Pagamento de aluguel',                  'D', 1200.00),
		(21, GETDATE(), 'Deposito em dinheiro',                  'C', 650.00),
		(22, GETDATE(), 'Compra farmacia',                       'D', 75.50),
		(23, GETDATE(), 'Pix recebido',                          'C', 320.00),
		(24, GETDATE(), 'Pagamento academia',                    'D', 100.00),
		(25, GETDATE(), 'Credito transferencia bancaria',        'C', 1100.00),
		(26, GETDATE(), 'Pagamento financiamento',               'D', 850.00),
		(27, GETDATE(), 'Reembolso recebido',                    'C', 220.00),
		(28, GETDATE(), 'Compra loja online',                    'D', 430.00),
		(29, GETDATE(), 'Deposito via internet banking',         'C', 770.00),
		(30, GETDATE(), 'Pagamento boleto faculdade',            'D', 500.00);
GO

/* ============================================================
   ATUALIZACAO DO SALDO
   ============================================================ */

UPDATE S
SET 
    S.Credito = ISNULL(L.TotalCredito, 0),
    S.Debito = ISNULL(L.TotalDebito, 0)
FROM [dbo].[Saldo] S
LEFT JOIN (
    SELECT 
        IdSaldo,
        SUM(CASE WHEN UPPER(DebCre) = 'C' THEN Valor ELSE 0 END) AS TotalCredito,
        SUM(CASE WHEN UPPER(DebCre) = 'D' THEN Valor ELSE 0 END) AS TotalDebito
    FROM [dbo].[Lancamento]
    GROUP BY IdSaldo
) L ON L.IdSaldo = S.Id;
GO

SELECT 
    C.Id AS IdCliente,
    C.Nome AS Cliente,
    A.Nome AS Agencia,
    CT.Numero AS NumeroConta,
    S.SaldoInicial,
    S.Credito,
    S.Debito,
    S.SaldoInicial + S.Credito - S.Debito AS SaldoFinal
	FROM [dbo].[Cliente] C
		INNER JOIN [dbo].[Conta] CT
	ON CT.IdCliente = C.Id
		INNER JOIN [dbo].[Agencia] A
	ON A.Id = CT.IdAgencia
		INNER JOIN [dbo].[Saldo] S
	ON S.IdConta = CT.Id
	ORDER BY C.Id, A.Id;
GO
