SELECT        dbo.TiposDocFact.Descripcion AS TipoDoc, dbo.FacturasVenta.IdFacturaVenta, dbo.TiposFactura.Descripcion AS TipoFact, dbo.FacturasVenta.NCompFact AS NroFact, dbo.FacturasVenta.FechaEmision, Pagado = (CASE WHEN dbo.FacturasVenta.Pagado = 1 THEN 'SI' ELSE 'NO' END),
                         (CASE WHEN dbo.FacturasVenta.Impresa = 1 THEN 'SI' ELSE 'NO' END) AS Impresa, dbo.FacturasVenta.Observaciones, dbo.FacturasVenta.SubTotal, dbo.FacturasVenta.Descuento, dbo.FacturasVenta.TotalDescuento, 
                         dbo.Clientes.ApellidoyNombre AS Cliente, ISNULL((CASE WHEN FacturasVenta.IdTipoDocumento = 2 THEN - dbo.FacturasVenta.Total ELSE dbo.FacturasVenta.Total END), 0) AS Total, ISNULL(dbo.CondicionesPago.Descripcion, 
                         '') AS CondPago, dbo.FormasPago.Descripcion AS FPago, dbo.FacturasVenta.FechaVencimiento, ISNULL(CONVERT(nvarchar, dbo.FacturasVenta.FechaAnulacion, 103), '') AS FechaAnulacion, dbo.Clientes.NroCliente, 
                         dbo.FacturasVenta.BVFact, dbo.FacturasVenta.TotalIva105, dbo.FacturasVenta.TotalIva21, dbo.FacturasVenta.IdEmpresa, dbo.Empresa.RazonSocial, dbo.FacturasVenta.TotalSaldado, dbo.FacturasVenta.TotalInteres, 
                         dbo.FacturasVenta.TotalSaldadoInteres, dbo.FacturasVenta.BVReferencia + '-' + dbo.FacturasVenta.NroCompFactReferencia AS NroFactReferencia, dbo.FacturasVenta.IdConceptoFactura, dbo.FacturasVenta.FechaAlta, 
                         dbo.FacturasVenta.Cobrador
FROM            dbo.FacturasVenta INNER JOIN
                         dbo.TiposDocFact ON dbo.FacturasVenta.IdTipoDocumento = dbo.TiposDocFact.IdTipoDocumento INNER JOIN
                         dbo.TiposFactura ON dbo.FacturasVenta.IdTipoFactura = dbo.TiposFactura.IdTipoFactura LEFT OUTER JOIN
                         dbo.CondicionesPago ON dbo.FacturasVenta.IdCondicionPago = dbo.CondicionesPago.IdCondicionPago INNER JOIN
                         dbo.FormasPago ON dbo.FacturasVenta.IdFormaPago = dbo.FormasPago.IdFormaPago INNER JOIN
                         dbo.Empresa ON dbo.FacturasVenta.IdEmpresa = dbo.Empresa.IdEmpresa INNER JOIN
                         dbo.ClientesCajasDistribucionesServicios ON dbo.FacturasVenta.ClienteCajaDistribucionServicioId = dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId INNER JOIN
                         dbo.Clientes ON dbo.ClientesCajasDistribucionesServicios.ClienteId = dbo.Clientes.NroCliente
WHERE        (dbo.FacturasVenta.IdFacturaVenta NOT IN
                             (SELECT        IdFacturaVenta
                               FROM            dbo.RemitosXfacturados))