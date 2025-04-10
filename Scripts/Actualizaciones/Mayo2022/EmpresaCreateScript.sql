USE [SgPymeBase]
GO

/****** Object:  Table [dbo].[Empresa]    Script Date: 5/27/2022 9:41:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Empresa](
	[IdEmpresa] [smallint] IDENTITY(1,1) NOT NULL,
	[RazonSocial] [nvarchar](200) NULL,
	[NFantasia] [nvarchar](200) NULL,
	[InicioActividades] [smalldatetime] NULL,
	[CUIT] [nvarchar](15) NULL,
	[Logo] [varbinary](max) NULL,
	[Direccion] [nvarchar](100) NULL,
	[Telefono] [nvarchar](100) NULL,
	[Correo] [nvarchar](100) NULL,
	[IIBB] [nvarchar](50) NULL,
	[CondicionIva] [nvarchar](50) NULL,
	[CodigoPostal] [smallint] NULL,
	[SubCodigoPostal] [tinyint] NULL,
	[RutaCertificado] [nvarchar](500) NULL,
	[SerialCertificado] [nvarchar](50) NULL,
 CONSTRAINT [PK_Empresa] PRIMARY KEY CLUSTERED 
(
	[IdEmpresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Empresa_Empresa] FOREIGN KEY([CodigoPostal], [SubCodigoPostal])
REFERENCES [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal])
GO

ALTER TABLE [dbo].[Empresa] CHECK CONSTRAINT [FK_Empresa_Empresa]
GO


