USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaCajaDistribuciones]    Script Date: 5/29/2022 12:14:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCajaDistribuciones]
AS
SELECT     cd.CajaDistribucionId, cd.Descipcion, cd.Longitud as 'Direccion', cd.FechaUltimaModificacion
FROM         CajasDistribuciones cd 

GO