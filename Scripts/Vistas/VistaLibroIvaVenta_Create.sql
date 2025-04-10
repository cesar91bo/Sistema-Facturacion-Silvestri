USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaLibroIvaVenta]    Script Date: 6/6/2022 18:00:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaLibroIvaVenta]
AS
SELECT        TOP (100) PERCENT CASE FV.IdTipoDocumento WHEN 1 THEN 'TF' ELSE 'NC' END AS TipoDoc, CASE FV.IdTipoFactura WHEN 1 THEN 'A' WHEN 2 THEN 'B' WHEN 3 THEN 'C' END AS LetraFact, FV.IdFacturaVenta, 
                         FV.BVFact + '-' + FV.NCompFact AS NroFactura, CONVERT(nvarchar, FV.FechaEmision, 103) AS FechaEmision, C.ApellidoyNombre, 
                         CASE RI.Descripcion WHEN 'Responsable Inscripto' THEN 'RI' WHEN 'Responsable No Inscripto' THEN 'RNI' WHEN 'Responsable Exento' THEN 'Exento' WHEN 'Consumidor Final' THEN 'CF' WHEN 'Monotributista' THEN 'Mono'
                          WHEN 'No Categorizado' THEN 'NC' END AS Descripcion, ISNULL(C.TipoDocumento, 'CUIT') AS TipoDocumento, ISNULL(CONVERT(nvarchar(15), C.NroDocumento), C.Cuit0 + '-' + C.Cuit1 + '-' + C.Cuit2) AS NroDocumento, 
                         CASE WHEN FV.IdTipoFactura = 1 THEN (CASE WHEN fv.IdTipoDocumento = 2 THEN - (Fv.TotalDescuento21 + FV.TotalDescuento105) ELSE FV.TotalDescuento21 + FV.TotalDescuento105 END) 
                         ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN - vtd.TotalGravado ELSE vtd.TotalGravado END) END AS NetoGravado, 
                         CASE WHEN FV.IdTipoFactura = 1 THEN (CASE WHEN fv.IdTipoDocumento = 2 THEN - (FV.SubTotal - FV.TotalDescuento - (Fv.TotalDescuento21 + FV.TotalDescuento105)) 
                         ELSE (FV.SubTotal - FV.TotalDescuento - (FV.TotalDescuento21 + FV.TotalDescuento105)) END) ELSE (CASE WHEN fv.IdTipoDocumento = 1 THEN vtd.TotalNoGravado ELSE - vtd.TotalNoGravado END) END AS NoGravado, 
                         CASE WHEN FV.IdTipoFactura = 1 THEN (CASE FV.IdTipoDocumento WHEN 2 THEN - FV.totaliva105 ELSE FV.totaliva105 END) ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN - vtd.Iva105 ELSE vtd.Iva105 END) 
                         END AS Iva105, CASE WHEN FV.IdTipoFactura = 1 THEN (CASE FV.IdTipoDocumento WHEN 2 THEN - FV.totaliva21 ELSE FV.totaliva21 END) ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN - vtd.iva21 ELSE vtd.IVA21 END) 
                         END AS Iva21, CASE FV.IdTipoDocumento WHEN 2 THEN - FV.Total ELSE FV.Total END AS MontoTotal, FV.IdEmpresa, RI.IdRegimenImpositivo, FV.Impresa, FV.Observaciones
FROM            dbo.FacturasVenta AS FV INNER JOIN
                         dbo.ClientesCajasDistribucionesServicios AS CCDS ON FV.ClienteCajaDistribucionServicioId = CCDS.ClienteCajaDistribucionServicioId INNER JOIN
                         dbo.Clientes AS C ON C.NroCliente = CCDS.ClienteId LEFT OUTER JOIN
                         dbo.VistaTotalesDiscriminadosFactB AS vtd ON vtd.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN
                         dbo.RegimenesImpositivos AS RI ON C.IdRegimenImpositivo = RI.IdRegimenImpositivo
WHERE        (FV.FechaAnulacion IS NULL)
GROUP BY FV.IdFacturaVenta, FV.BVFact, FV.NCompFact, FV.FechaEmision, C.ApellidoyNombre, C.TipoDocumento, C.NroDocumento, FV.SubTotal, FV.Total, FV.TotalIva105, FV.TotalIva21, FV.IdTipoDocumento, FV.IdEmpresa, FV.Total, 
                         C.Cuit0, C.Cuit1, C.Cuit2, FV.Subtotal105, FV.Subtotal21, FV.IdTipoFactura, vtd.TotalGravado, vtd.TotalNOGravado, vtd.IVA105, vtd.IVA21, RI.Descripcion, FV.TotalDescuento105, FV.TotalDescuento21, FV.TotalDescuento, 
                         FV.Impresa, RI.IdRegimenImpositivo, FV.Observaciones
ORDER BY FechaEmision
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
         Begin Table = "FV"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 24
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vtd"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 256
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RI"
            Begin Extent = 
               Top = 258
               Left = 38
               Bottom = 354
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CCDS"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 136
               Right = 790
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
      Begin ColumnWidths = 15
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
      End
   En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLibroIvaVenta'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLibroIvaVenta'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLibroIvaVenta'
GO


