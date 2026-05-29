IF EXISTS(SELECT 1 FROM [dbo].[sysobjects] WHERE Id = OBJECT_ID(N'[dbo].[TRG_AtualizarSaldo]') AND TYPE = 'TR')
	BEGIN
		DROP TRIGGER [dbo].[TRG_AtualizarSaldo]
	END

GO

CREATE TRIGGER [dbo].[TRG_AtualizarSaldo]
    ON [dbo].[Lancamento]
    FOR INSERT, DELETE, UPDATE
    AS 
        /* 
            Documentação
            Arquivo Fonte:	"C:\Caminho\Arquivo.sql"
            Objetivo:		Atualizar saldo conforme atualizações de lançamento
            Autor:			
            Data Criação:	26/05/2026
            Exemplo:
        */
    BEGIN
        IF EXISTS (SELECT 1 FROM deleted) -- Checando tabela DELETED
            BEGIN
                UPDATE Saldo	
                    SET Credito = (	CASE WHEN deleted.DebCre = 'C' THEN Credito - deleted.Valor ELSE Credito END),
                        Debito	= ( CASE WHEN deleted.DebCre = 'D' THEN Debito	- deleted.Valor ELSE Debito END)

                    FROM [dbo].[Saldo] AS Sd
                        INNER JOIN deleted
                            ON Sd.Id = deleted.IdSaldo
            END
        IF EXISTS (SELECT 1 FROM inserted) -- Checando tabela INSERTED
            BEGIN
                UPDATE Saldo
                    SET Credito = (	CASE WHEN inserted.DebCre = 'C' THEN Credito + inserted.Valor ELSE Credito END),
                        Debito	= ( CASE WHEN inserted.DebCre = 'D' THEN Debito  + inserted.Valor ELSE Debito END)

                    FROM [dbo].[Saldo] AS Sd
                        INNER JOIN inserted
                            ON Sd.Id = inserted.IdSaldo
            END
    END

 INSERT INTO [dbo].[Lancamento] (IdSaldo, DataLancamento, Historico, DebCre, Valor)
    VALUES (8, GETDATE(), 'Transferência recebida - TED', 'C', 100.00);
    