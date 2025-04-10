USE [SgPymeBase]
GO

UPDATE [dbo].[Clientes]
   SET [TipoDocumento] = <TipoDocumento, nvarchar(5),>
      ,[NroDocumento] = <NroDocumento, int,>
      ,[ApellidoyNombre] = <ApellidoyNombre, nvarchar(200),>
      ,[Direccion] = <Direccion, nvarchar(80),>
      ,[CodigoPostal] = <CodigoPostal, smallint,>
      ,[SubCodigoPostal] = <SubCodigoPostal, tinyint,>
      ,[FechaNacimiento] = <FechaNacimiento, smalldatetime,>
      ,[IdRegimenImpositivo] = <IdRegimenImpositivo, smallint,>
      ,[Telefono] = <Telefono, nvarchar(70),>
      ,[Email1] = <Email1, nvarchar(50),>
      ,[Email2] = <Email2, nvarchar(50),>
      ,[Cuit0] = <Cuit0, nvarchar(2),>
      ,[Cuit1] = <Cuit1, nvarchar(8),>
      ,[Cuit2] = <Cuit2, nvarchar(1),>
      ,[UsrBaja] = <UsrBaja, nvarchar(10),>
      ,[FechaBaja] = <FechaBaja, datetime2(7),>
      ,[FechaAcceso] = <FechaAcceso, datetime2(7),>
      ,[UsrAcceso] = <UsrAcceso, nvarchar(20),>
      ,[IdObservación] = <IdObservación, tinyint,>
      ,[MensajeCuenta] = <MensajeCuenta, nvarchar(300),>
      ,[SaldoExcedido] = <SaldoExcedido, decimal(12,2),>
      ,[CuentaCerrada] = <CuentaCerrada, nvarchar(300),>
      ,[Comentario] = <Comentario, nvarchar(300),>
      ,[ServicioId] = <ServicioId, int,>
 WHERE <Search Conditions,,>
GO


