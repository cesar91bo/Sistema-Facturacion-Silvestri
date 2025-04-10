CREATE VIEW [dbo].[VistaArtSinVentas]
AS
SELECT     TOP (100) PERCENT A.IdArticulo, A.DescCorta, R.Descripcion AS Rubro, S.Descripcion AS SubRubro, (CASE A.LlevarStock WHEN 1 THEN 'SI' ELSE 'NO' END) 
                      AS LlevarStock, A.StockActual, UM.Descripcion AS UMedida, A.FechaAcceso AS FechaCarga, ISNULL(CONVERT(Nvarchar, DATEDIFF(DAY, aux.MaxFecha, GETDATE())), 
                      'SIN MOVIMIENTOS') AS Dias, ISNULL(DATEDIFF(DAY, aux.MaxFecha, GETDATE()), 0) AS DiasInt, aux.IdEmpresa
FROM         dbo.Articulos AS A LEFT OUTER JOIN
                          (SELECT     FVD.IdServicio, MAX(FV.FechaEmision) AS MaxFecha, FV.IdEmpresa
                            FROM          dbo.FacturasVenta AS FV INNER JOIN
                                                   dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                            WHERE      (FV.FechaAnulacion IS NULL) AND (FVD.IdServicio IS NOT NULL)
                            GROUP BY FVD.IdServicio, FV.IdEmpresa) AS aux ON aux.IdServicio = A.IdArticulo INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro INNER JOIN
                      dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida
ORDER BY DiasInt DESC
