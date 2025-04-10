CREATE view [dbo].[VistaCabFactVentaConCaja] as

SELECT     dbo.TiposDocFact.Descripcion AS TipoDoc, dbo.FacturasVenta.IdFacturaVenta, dbo.TiposFactura.Descripcion AS TipoFact, 
                      dbo.FacturasVenta.BVFact + ' - ' + dbo.FacturasVenta.NCompFact AS NroFact, CONVERT(NVarchar, dbo.FacturasVenta.FechaEmision, 103) AS FechaEmision, 
                      dbo.FacturasVenta.FechaEmision AS Fecha, (CASE WHEN dbo.FacturasVenta.Impresa = 1 THEN 'SI' ELSE 'NO' END) AS Impresa, dbo.FacturasVenta.Observaciones, 
                      dbo.FacturasVenta.SubTotal, dbo.FacturasVenta.Descuento, dbo.FacturasVenta.TotalDescuento, dbo.Clientes.ApellidoyNombre AS Cliente, 
                      ISNULL((CASE WHEN FacturasVenta.IdTipoDocumento = 2 THEN - dbo.FacturasVenta.Total ELSE dbo.FacturasVenta.Total END), 0) AS Total, 
                      ISNULL(dbo.CondicionesPago.Descripcion, '') AS CondPago, dbo.FormasPago.Descripcion AS FPago, dbo.FacturasVenta.FechaVencimiento, 
                      ISNULL(CONVERT(nvarchar, dbo.FacturasVenta.FechaAnulacion, 103), '') AS FechaAnulacion, dbo.Clientes.NroCliente, dbo.FacturasVenta.BVFact, 
                      dbo.FacturasVenta.TotalIva105, dbo.FacturasVenta.TotalIva21, dbo.FacturasVenta.IdEmpresa, dbo.Empresa.RazonSocial, dbo.FacturasVenta.TotalSaldado, 
                      dbo.FacturasVenta.TotalInteres, dbo.FacturasVenta.TotalSaldadoInteres, 
                      dbo.FacturasVenta.BVReferencia + '-' + dbo.FacturasVenta.NroCompFactReferencia AS NroFactReferencia, c.Descripcion, dbo.FacturasVenta.FechaAlta
FROM         dbo.FacturasVenta INNER JOIN
                      dbo.TiposDocFact ON dbo.FacturasVenta.IdTipoDocumento = dbo.TiposDocFact.IdTipoDocumento INNER JOIN
                      dbo.TiposFactura ON dbo.FacturasVenta.IdTipoFactura = dbo.TiposFactura.IdTipoFactura INNER JOIN
					  dbo.ClientesCajasDistribucionesServicios ON dbo.FacturasVenta.ClienteCajaDistribucionServicioId = dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId INNER JOIN
                      dbo.Clientes ON dbo.ClientesCajasDistribucionesServicios.ClienteId = dbo.Clientes.NroCliente LEFT OUTER JOIN
                      dbo.CondicionesPago ON dbo.FacturasVenta.IdCondicionPago = dbo.CondicionesPago.IdCondicionPago INNER JOIN
                      dbo.FormasPago ON dbo.FacturasVenta.IdFormaPago = dbo.FormasPago.IdFormaPago INNER JOIN
                      dbo.Empresa ON dbo.FacturasVenta.IdEmpresa = dbo.Empresa.IdEmpresa left join
					  cajasmovimientos cm on cm.IdFacturaVenta = FacturasVenta.IdFacturaVenta left join
					  CajasAperturas ca on ca.IdAperturaCaja = cm.IdAperturaCaja left join
					  Cajas c on c.IdCaja = ca.IdCaja