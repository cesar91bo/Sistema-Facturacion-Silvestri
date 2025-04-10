CREATE VIEW [dbo].[VistaCheques] as
SELECT     dbo.Cheques.NroCheque, dbo.Cheques.MontoCheque, dbo.Clientes.ApellidoyNombre, 'Recibo' as TipoMovimiento, dbo.Recibos.IdRecibo AS IdMovimiento, CONVERT(NVARCHAR, 
                      dbo.Cheques.FechaEmision, 103) AS FechaEmision, CONVERT(Nvarchar, dbo.Cheques.FechaCobro, 103) AS FechaCobro, 
                      (CASE WHEN dbo.Cheques.Cruzado = 0 THEN 'NO' ELSE 'SI' END) AS Cruzado, dbo.Bancos.Descripcion AS Banco, ISNULL(CONVERT(Nvarchar, 
                      dbo.Cheques.FechaBaja, 103), '') AS FechaBaja, dbo.Cheques.IdCheque, dbo.Cheques.Propio
FROM         dbo.Cheques INNER JOIN
                      dbo.RecibosDetalle ON dbo.Cheques.IdCheque = dbo.RecibosDetalle.IdCheque INNER JOIN
                      dbo.Recibos ON dbo.RecibosDetalle.IdRecibo = dbo.Recibos.IdRecibo INNER JOIN
                      dbo.Clientes ON dbo.Recibos.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.Bancos ON dbo.Cheques.IdBanco = dbo.Bancos.IdBanco

UNION


SELECT     dbo.Cheques.NroCheque, dbo.Cheques.MontoCheque, dbo.Clientes.ApellidoyNombre, 'Mov.Caja' as TipoMovimiento, dbo.CajasMovimientosDetalle.IdMovimientoCajaDetalle AS IdMovimiento, CONVERT(NVARCHAR, 
                      dbo.Cheques.FechaEmision, 103) AS FechaEmision, CONVERT(Nvarchar, dbo.Cheques.FechaCobro, 103) AS FechaCobro, 
                      (CASE WHEN dbo.Cheques.Cruzado = 0 THEN 'NO' ELSE 'SI' END) AS Cruzado, dbo.Bancos.Descripcion AS Banco, ISNULL(CONVERT(Nvarchar, 
                      dbo.Cheques.FechaBaja, 103), '') AS FechaBaja, dbo.Cheques.IdCheque, dbo.Cheques.Propio
FROM         dbo.Cheques INNER JOIN
                      dbo.CajasMovimientosDetalle ON dbo.Cheques.IdCheque = dbo.CajasMovimientosDetalle.IdCheque INNER JOIN
                      dbo.CajasMovimientos ON dbo.CajasMovimientos.IdMovimientoCaja = dbo.CajasMovimientosDetalle.IdMovimientoCaja INNER JOIN
					  dbo.FacturasVenta ON dbo.FacturasVenta.IdFacturaVenta = dbo.CajasMovimientos.IdFacturaVenta INNER JOIN
					  dbo.ClientesCajasDistribucionesServicios ON dbo.FacturasVenta.ClienteCajaDistribucionServicioId = dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId INNER JOIN
                      dbo.Clientes ON dbo.FacturasVenta.ClienteCajaDistribucionServicioId = dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId INNER JOIN
                      dbo.Bancos ON dbo.Cheques.IdBanco = dbo.Bancos.IdBanco