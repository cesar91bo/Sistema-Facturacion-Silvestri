USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaCabFactVenta]    Script Date: 6/6/2022 18:55:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCabFactVenta]
AS
SELECT        dbo.TiposDocFact.Descripcion AS TipoDoc, dbo.FacturasVenta.IdFacturaVenta, dbo.TiposFactura.Descripcion AS TipoFact, dbo.FacturasVenta.NCompFact AS NroFact, dbo.FacturasVenta.FechaEmision, 
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
         Begin Table = "FacturasVenta"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "TiposDocFact"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 101
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposFactura"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CondicionesPago"
            Begin Extent = 
               Top = 102
               Left = 532
               Bottom = 197
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FormasPago"
            Begin Extent = 
               Top = 102
               Left = 779
               Bottom = 197
               Right = 988
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 1026
               Bottom = 125
               Right = 1224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ClientesCajasDistribucionesServicios"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactVenta'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 302
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 102
               Left = 285
               Bottom = 231
               Right = 494
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
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactVenta'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactVenta'
GO


