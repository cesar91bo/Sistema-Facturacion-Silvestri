USE [SgPymeBase]
GO
SET IDENTITY_INSERT [dbo].[Empresa] ON 

INSERT [dbo].[Empresa] ([IdEmpresa], [RazonSocial], [NFantasia], [InicioActividades], [CUIT], [Logo], [Direccion], [Telefono], [Correo], [IIBB], [CondicionIva], [CodigoPostal], [SubCodigoPostal], [RutaCertificado], [SerialCertificado]) VALUES (1, N'SILVESTRI FABIAN ALBERTO', N'VIDEO CABLE PAMPA DEL INDIO', CAST(N'2005-09-09T00:00:00' AS SmallDateTime), N'20202233954', NULL, N'C.P. (3531) PAMPA DEL INDIO - CHACO', NULL, NULL, N'20202233954', N'IVA RESPONSABLE INSCRIPTO', NULL, NULL, N'C:\Certificados\Fabian.p12', N'6b626f1531deedfa')
SET IDENTITY_INSERT [dbo].[Empresa] OFF
GO
