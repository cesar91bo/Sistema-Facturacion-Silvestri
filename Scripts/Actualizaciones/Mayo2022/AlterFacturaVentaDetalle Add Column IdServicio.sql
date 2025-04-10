use SgPymeBase

ALTER TABLE [dbo].[FacturasVentaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVentaDetalle_Servicios] FOREIGN KEY([IdServicio])
REFERENCES [dbo].[Servicios] ([ServicioId])
GO


