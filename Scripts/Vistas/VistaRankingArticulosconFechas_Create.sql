USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaRankingArticulosconFechas]    Script Date: 6/6/2022 18:16:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRankingArticulosconFechas]
AS
SELECT        TOP (100) PERCENT Aux.IdServicio, A.DescCorta, SUM(Aux.Cantidad) AS Unidades, Um.Descripcion AS UMedida, CONVERT(Decimal(11, 2), SUM(Aux.TotalFact)) AS TotalFact, Aux.IdEmpresa, Aux.Fecha
FROM            (SELECT        FVD.IdServicio, FVD.Cantidad, ROUND(FVD.Cantidad * FVD.PrecioUnitario, 2) AS TotalFact, FV.IdEmpresa, FV.FechaEmision AS Fecha
                          FROM            dbo.FacturasVenta AS FV INNER JOIN
                                                    dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                          WHERE        (FVD.IdServicio IS NOT NULL) AND (FV.IdTipoDocumento = 1) AND (FV.FechaAnulacion IS NULL)
                          UNION
                          SELECT        RD.IdArticulo, RD.Cantidad, 0 AS TotalFact, R.IdEmpresa, R.FechaRemito AS Fecha
                          FROM            dbo.Remitos AS R INNER JOIN
                                                   dbo.RemitosDetalle AS RD ON RD.IdRemito = R.IdRemito
                          WHERE        (RD.IdArticulo IS NOT NULL) AND (R.IdFactura IS NULL)
                          UNION
                          SELECT        FVD.IdServicio, - FVD.Cantidad AS Expr1, - ROUND(FVD.Cantidad * FVD.PrecioUnitario, 2) AS TotalFact, FV.IdEmpresa, FV.FechaEmision AS Fecha
                          FROM            dbo.FacturasVenta AS FV INNER JOIN
                                                   dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                          WHERE        (FVD.IdServicio IS NOT NULL) AND (FV.IdTipoDocumento = 2) AND (FV.FechaAnulacion IS NULL)) AS Aux INNER JOIN
                         dbo.Articulos AS A ON A.IdArticulo = Aux.IdServicio INNER JOIN
                         dbo.UnidadesMedida AS Um ON Um.IdUnidadMedida = A.IdUnidadMedida
GROUP BY Aux.IdServicio, A.DescCorta, Um.Descripcion, Aux.IdEmpresa, Aux.Fecha
ORDER BY Unidades DESC, TotalFact DESC
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -480
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 486
               Left = 290
               Bottom = 605
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Um"
            Begin Extent = 
               Top = 486
               Left = 542
               Bottom = 575
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 616
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingArticulosconFechas'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingArticulosconFechas'
GO


