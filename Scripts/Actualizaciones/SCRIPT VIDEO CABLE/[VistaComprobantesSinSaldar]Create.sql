CREATE VIEW [dbo].[VistaComprobantesSinSaldar]
AS
  
SELECT *
FROM (SELECT VFSS.IdFacturaVenta,
			 VFSS.NroFactura,
			 VFSS.Total,
			 VFSS.TotalSaldado,
			 VFSS.FechaEmision,
			 VFSS.NroCliente,
			 VFSS.ApellidoyNombre,
			 VFSS.Direccion,
			 VFSS.IdTipoFactura,
			 NULL AS IdNotaCredito,
			 CP.Localidad
	  FROM VistaFacturasSinSaldar VFSS JOIN Clientes C ON VFSS.NroCliente = C.NroCliente
									   JOIN CPostales CP ON C.CodigoPostal = CP.CodigoPostal AND
															C.SubCodigoPostal = CP.SubCodigoPostal
	  
	  UNION

	  SELECT VNCSS.IdFacturaVenta,
			 VNCSS.NroFactura,
			 VNCSS.Total,
			 VNCSS.TotalSaldado,
			 VNCSS.FechaEmision,
			 VNCSS.NroCliente,
			 VNCSS.ApellidoyNombre,
			 VNCSS.Direccion,
			 VNCSS.IdTipoFactura,
			 VNCSS.IdFacturaVenta AS IdNotaCredito,
			 CP.Localidad
	  from VistaNCsinSaldar VNCSS JOIN Clientes C ON VNCSS.NroCliente = C.NroCliente
								  JOIN CPostales CP ON C.CodigoPostal = CP.CodigoPostal AND
													   C.SubCodigoPostal = CP.SubCodigoPostal) AS Aux
