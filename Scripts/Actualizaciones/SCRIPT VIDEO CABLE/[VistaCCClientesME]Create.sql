CREATE VIEW [dbo].[VistaCCClientesME]
AS
SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(f.Total), 0) + ISNULL(Aux3.Intereses, 0) AS Debe, ISNULL(aux.HaberNC + Aux2.HaberRecibo, 0) AS Haber, 
                      ISNULL(ISNULL(SUM(f.Total), 0) + ISNULL(Aux3.Intereses, 0) - ISNULL(aux.HaberNC + Aux2.HaberRecibo, 0), 0) AS Saldo, C.FechaBaja
FROM         dbo.Clientes AS C LEFT OUTER JOIN


                      dbo.FacturasVenta AS f ON  f.IdFormaPago = 2 AND f.IdTipoDocumento IN (1, 8) AND f.FechaAnulacion IS NULL INNER JOIN
                          (SELECT     C.NroCliente, SUM(ISNULL(nc.Total, 0)) AS HaberNC
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.FacturasVenta AS nc ON  nc.IdTipoDocumento = 2 AND nc.FechaAnulacion IS NULL AND nc.IdFormaPago = 2
                            GROUP BY C.NroCliente) AS aux ON aux.NroCliente = C.NroCliente INNER JOIN
                          (SELECT     C.NroCliente, SUM(ISNULL(R.MontoTotal, 0)) AS HaberRecibo
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.Recibos AS R ON C.NroCliente = R.NroCliente AND R.FechaBaja IS NULL
                            GROUP BY C.NroCliente) AS Aux2 ON Aux2.NroCliente = C.NroCliente INNER JOIN
                          (SELECT     C.NroCliente, SUM(AuxInt.Intereses) AS Intereses
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.FacturasVenta AS fv ON  fv.FechaAnulacion IS NULL AND fv.IdFormaPago = 2 LEFT OUTER JOIN
                                                       (SELECT     MAX(TotalInteres) AS Intereses, IdFacturaVenta
                                                         FROM          dbo.GeneracionInteres
                                                         GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta
                            GROUP BY C.NroCliente) AS Aux3 ON Aux3.NroCliente = C.NroCliente
GROUP BY C.NroCliente, C.ApellidoyNombre, aux.HaberNC, Aux2.HaberRecibo, Aux3.Intereses, C.FechaBaja