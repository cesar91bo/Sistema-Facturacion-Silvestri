USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaLiquidaciones]    Script Date: 6/6/2022 18:02:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaLiquidaciones]
AS
SELECT        L.Fecha, L.IdLiquidacion, L.NroVendedor, ISNULL(LF.MontoBase, 0) AS TotalFactura, V.ApellidoyNombre AS Vendedor, LF.MontoComision, LF.IdFacturaVenta, FV.BVFact + '-' + FV.NCompFact AS NroFactura, 
                         R.FechaEmision AS FechaRecibo, C.ApellidoyNombre AS Cliente
FROM            dbo.Liquidaciones AS L LEFT OUTER JOIN
                         dbo.LiquidacionesFacturas AS LF ON L.IdLiquidacion = LF.IdLiquidacion INNER JOIN
                         dbo.Vendedores AS V ON V.NroVendedor = L.NroVendedor INNER JOIN
                         dbo.FacturasVenta AS FV ON LF.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN
                         dbo.ClientesCajasDistribucionesServicios AS CCDS ON FV.ClienteCajaDistribucionServicioId = CCDS.ClienteCajaDistribucionServicioId INNER JOIN
                         dbo.Recibos AS R ON R.IdRecibo = LF.IdRecibo INNER JOIN
                         dbo.Clientes AS C ON C.NroCliente = CCDS.ClienteId
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "L"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LF"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "V"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FV"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 302
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 138
               Left = 265
               Bottom = 268
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CCDS"
            Begin Extent = 
               Top = 6
               Left = 489
               Bottom = 136
               Right = 753
            End
            DisplayFlags = 280
            TopColumn = 0
         End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLiquidaciones'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLiquidaciones'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLiquidaciones'
GO


