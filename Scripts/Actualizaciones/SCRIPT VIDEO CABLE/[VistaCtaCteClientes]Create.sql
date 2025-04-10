CREATE VIEW [dbo].[VistaCtaCteClientes]
AS
SELECT     aux.NroCliente, aux.Cliente, SUM(aux.Debe) AS Debe, SUM(aux.Haber) AS Haber, SUM(aux.Debe - aux.Haber) AS Saldo, aux.IdEmpresa, C.FechaBaja
FROM         (SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(FV.Total), 0) AS Debe, 0 AS Haber, FV.IdEmpresa, 1 as tipodoc
                       FROM          dbo.Clientes AS C 
					   
					   inner join ClientesCajasDistribucionesServicios CCDS ON c.NroCliente = CCDS.ClienteId

					   LEFT OUTER JOIN
                                              dbo.FacturasVenta AS FV ON CCDS.ClienteId = C.NroCliente
                       WHERE      (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento IN (1, 3, 8)) AND (FV.FechaAnulacion IS NULL) AND IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
					   UNION
					   SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(FV.Total), 0) AS Debe, 0 AS Haber, FV.IdEmpresa, 1 as tipodoc
                       FROM          dbo.Clientes AS C 
					   inner join ClientesCajasDistribucionesServicios CCDS ON c.NroCliente = CCDS.ClienteId
					   LEFT OUTER JOIN
                                              dbo.FacturasVenta AS FV ON  CCDS.ClienteId = C.NroCliente
                       WHERE      (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 9) AND (FV.FechaAnulacion IS NULL)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
					   UNION
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, SUM(ISNULL(FV.Total, 0)) AS Haber, FV.IdEmpresa, 2 as tipodoc
                       FROM         dbo.Clientes AS C 
					   
					   inner join ClientesCajasDistribucionesServicios CCDS ON c.NroCliente = CCDS.ClienteId
					   LEFT OUTER JOIN
                                             dbo.FacturasVenta AS FV ON CCDS.ClienteId = C.NroCliente
                       WHERE     (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 2) AND (FV.FechaAnulacion IS NULL)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
                       UNION 
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, SUM(ISNULL(R.MontoTotal, 0)) AS Haber, R.IdEmpresa, 5 as tipodoc
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN
                                             dbo.Recibos AS R ON C.NroCliente = R.NroCliente AND R.FechaBaja IS NULL
                       GROUP BY C.NroCliente, C.ApellidoyNombre, R.IdEmpresa
                       UNION
                       SELECT     C.NroCliente, C.ApellidoyNombre, ISNULL(SUM(GI.TotalInteres), 0) AS Debe, 0 AS Haber, fv.IdEmpresa, 1 as tipodoc
                       FROM         dbo.Clientes AS C 
					   
					   inner join ClientesCajasDistribucionesServicios CCDS ON c.NroCliente = CCDS.ClienteId
					   
                  LEFT OUTER JOIN                dbo.FacturasVenta AS fv ON CCDS.ClienteId = C.NroCliente AND fv.FechaAnulacion IS NULL AND fv.IdFormaPago = 2 LEFT OUTER JOIN
                                                 (SELECT     MAX(IdDiaGeneracion) AS IdDia, IdFacturaVenta
                                                   FROM          dbo.GeneracionInteres
                                                   GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta INNER JOIN
                                             dbo.GeneracionInteres AS GI ON GI.IdDiaGeneracion = AuxInt.IdDia AND AuxInt.IdFacturaVenta = GI.IdFacturaVenta
                       GROUP BY C.NroCliente, C.ApellidoyNombre, fv.IdEmpresa) AS aux INNER JOIN
                      dbo.Clientes AS C ON C.NroCliente = aux.NroCliente 
WHERE     (aux.IdEmpresa IS NOT NULL)
GROUP BY aux.NroCliente, aux.Cliente, aux.IdEmpresa, C.FechaBaja