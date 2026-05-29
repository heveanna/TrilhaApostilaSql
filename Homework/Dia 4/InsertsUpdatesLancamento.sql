-- HOMEWORK: Criar scripts que incluam lançamento e atualizem saldo (30 lançamentos de diversas contas)

-- 1

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (1, GETDATE(), 'Recebimento via Pix', 'C', 1500.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 1500.00
    WHERE Id = 1;

-- 2

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (1, GETDATE(), 'Débito Automático - Conta de Luz', 'D', 200.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 200.00
    WHERE Id = 1;

-- 3

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (2, GETDATE(), 'Transferência recebida - TED', 'C', 3000.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 3000.00
    WHERE Id = 2;
 
 -- 4

 INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (2, GETDATE(), 'Pagamento Fatura Cartão de Crédito', 'D', 450.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 450.00
    WHERE Id = 2;

-- 5

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (3, GETDATE(), 'Depósito via Internet Banking', 'C', 800.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 800.00
    WHERE Id = 3;

-- 6

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (3, GETDATE(), 'Pix enviado - Pagamento Aluguel', 'D', 150.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 150.00
    WHERE Id = 3;


-- 7

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (4, GETDATE(), 'Depósito em espécie na Agência', 'C', 2200.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 2200.00
    WHERE Id = 4;

-- 8

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (4, GETDATE(), 'Transferência enviada - DOC', 'D', 300.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 300.00
    WHERE Id = 4;

-- 9

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (5, GETDATE(), 'Pix recebido - Salário', 'C', 1800.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 1800.00
    WHERE Id = 5;

-- 10

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (5, GETDATE(), 'Débito Automático - Internet/Telefone', 'D', 600.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 600.00
    WHERE Id = 5;
 
-- 11

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (6, GETDATE(), 'Crédito via Internet Banking', 'C', 900.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 900.00
    WHERE Id = 6;

-- 12 

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (6, GETDATE(), 'Pagamento Fatura Cartão de Crédito', 'D', 120.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 120.00
    WHERE Id = 6;

-- 13

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (7, GETDATE(), 'Depósito identificado na Agência', 'C', 5000.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 5000.00
    WHERE Id = 7;
 
 -- 14

 INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (7, GETDATE(), 'Transferência enviada - TED', 'D', 1200.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 1200.00
    WHERE Id = 7;
 
-- 15

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (8, GETDATE(), 'Pix recebido - Reembolso', 'C', 750.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 750.00
    WHERE Id = 8;

-- 16

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (8, GETDATE(), 'Débito Automático - Streaming', 'D', 80.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 80.00
    WHERE Id = 8;

-- 17

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (1, GETDATE(), 'Crédito via Internet Banking', 'C', 400.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 400.00
    WHERE Id = 1;

-- 18

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (2, GETDATE(), 'Pix enviado - Compra Mercado', 'D', 220.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 220.00
    WHERE Id = 2;
 
 -- 19

 INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (3, GETDATE(), 'Transferência recebida - DOC', 'C', 1100.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 1100.00
    WHERE Id = 3;
 
 -- 20

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
	VALUES (4, GETDATE(), 'Pagamento Cartão de Crédito - Parcela', 'D', 500.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 500.00
    WHERE Id = 4;

-- 21 

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (5, GETDATE(), 'Crédito de cheque depositado na Agência', 'C', 350.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 350.00
    WHERE Id = 5;

-- 22

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (6, GETDATE(), 'Pix enviado - Pagamento Serviço', 'D', 90.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 90.00
    WHERE Id = 6;

-- 23

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (7, GETDATE(), 'Depósito via Internet Banking', 'C', 2500.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 2500.00
    WHERE Id = 7;

-- 24

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (8, GETDATE(), 'Transferência enviada - Pagamento Fornecedor', 'D', 430.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 430.00
    WHERE Id = 8;

-- 25

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (1, GETDATE(), 'Pagamento Fatura Cartão de Crédito', 'D', 175.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 175.00
    WHERE Id = 1;

-- 26 

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (3, GETDATE(), 'Saque em espécie na Agência', 'D', 320.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 320.00
    WHERE Id = 3;

-- 27

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (5, GETDATE(), 'Pix enviado - Pagamento Escola', 'D', 980.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 980.00
    WHERE Id = 5;
 
-- 28

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (7, GETDATE(), 'Débito Automático - Seguro de Vida', 'D', 650.00);
 
UPDATE [dbo].[Saldo]
    SET Debito = Debito + 650.00
    WHERE Id = 7;

-- 29

INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (2, GETDATE(), 'Depósito em cheque na Agência', 'C', 1300.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 1300.00
    WHERE Id = 2;
 
 -- 30 

 INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (6, GETDATE(), 'Transferência recebida - TED', 'C', 670.00);
 
UPDATE [dbo].[Saldo]
    SET Credito = Credito + 670.00
    WHERE Id = 6;
