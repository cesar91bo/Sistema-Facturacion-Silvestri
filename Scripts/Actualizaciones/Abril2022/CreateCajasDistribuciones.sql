USE [SgPymeBase]
GO
/****** Object:  Table [dbo].[CajasDistribuciones]    Script Date: 4/12/2022 8:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajasDistribuciones](
	[CajaDistribucionId] [int] IDENTITY(1,1) NOT NULL,
	[Descipcion] [varchar](100) NOT NULL,
	[Longitud] [varchar](50) NULL,
	[Latitud] [varchar](50) NULL,
	[FechaUltimaModificacion] [date] NOT NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_CajasDistribuciones] PRIMARY KEY CLUSTERED 
(
	[CajaDistribucionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
