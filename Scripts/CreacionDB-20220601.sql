USE [master]
GO
/****** Object:  Database [SgPymeBase]    Script Date: 1/6/2022 12:12:56 ******/
CREATE DATABASE [SgPymeBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SgPymeBase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\SgPymeBase.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SgPymeBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\SgPymeBase_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SgPymeBase] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SgPymeBase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SgPymeBase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SgPymeBase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SgPymeBase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SgPymeBase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SgPymeBase] SET ARITHABORT OFF 
GO
ALTER DATABASE [SgPymeBase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SgPymeBase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SgPymeBase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SgPymeBase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SgPymeBase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SgPymeBase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SgPymeBase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SgPymeBase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SgPymeBase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SgPymeBase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SgPymeBase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SgPymeBase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SgPymeBase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SgPymeBase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SgPymeBase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SgPymeBase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SgPymeBase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SgPymeBase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SgPymeBase] SET  MULTI_USER 
GO
ALTER DATABASE [SgPymeBase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SgPymeBase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SgPymeBase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SgPymeBase] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SgPymeBase]
GO
/****** Object:  User [usrsp]    Script Date: 1/6/2022 12:12:56 ******/
CREATE USER [usrsp] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [usrsg]    Script Date: 1/6/2022 12:12:56 ******/
CREATE USER [usrsg] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_datareader] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [usrsp]
GO
ALTER ROLE [db_owner] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_datareader] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [usrsg]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [usrsg]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetElement]    Script Date: 1/6/2022 12:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetElement]
(
@ord AS INT,
@str AS VARCHAR(8000),
@delim AS VARCHAR(1) )
RETURNS INT
AS
BEGIN
  -- If input is invalid, return null.
  IF  @str IS NULL
      OR LEN(@str) = 0
      OR @ord IS NULL
      OR @ord < 1
      -- @ord > [is the] expression that calculates the number of elements.
      OR @ord > LEN(@str) - LEN(REPLACE(@str, @delim, '')) + 1
    RETURN NULL
  DECLARE @pos AS INT, @curord AS INT
  SELECT @pos = 1, @curord = 1
  -- Find next element's start position and increment index.
  WHILE @curord < @ord
    SELECT
      @pos    = CHARINDEX(@delim, @str, @pos) + 1,
      @curord = @curord + 1
  RETURN    CAST(SUBSTRING(@str, @pos, CHARINDEX(@delim, @str + @delim, @pos) - @pos) AS INT)
END








GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetProfileElement]    Script Date: 1/6/2022 12:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[fn_GetProfileElement] 
( 
@fieldName AS NVARCHAR(100), 
@fields AS NVARCHAR(4000), 
@values AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000) 
AS 
BEGIN 

-- If input is invalid, return null. 
IF @fieldName IS NULL 
OR LEN(@fieldName) = 0 
OR @fields IS NULL 
OR LEN(@fields) = 0 
OR @values IS NULL 
OR LEN(@values) = 0 
RETURN NULL 

-- locate FieldName in Fields 
DECLARE @fieldNameToken AS NVARCHAR(20) 
DECLARE @fieldNameStart AS INTEGER, @valueStart AS INTEGER, @valueLength AS INTEGER 

-- Only handle string type fields (:S 
SET @fieldNameStart = CHARINDEX(@fieldName + ':S',@Fields,0) 

-- If field is not found, return null 
IF @fieldNameStart = 0 RETURN NULL 
SET @fieldNameStart = @fieldNameStart + LEN(@fieldName) + 3 

-- Get the field token which I've defined as the start of the field offset to the end of the length 
SET @fieldNameToken = SUBSTRING(@Fields,@fieldNameStart,LEN(@Fields)-@fieldNameStart) 

-- Get the values for the offset and length 
SET @valueStart = dbo.fn_getelement(1,@fieldNameToken,':') 
SET @valueLength = dbo.fn_getelement(2,@fieldNameToken,':') 

-- Check for sane values, 0 length means the profile item was stored, just no data 
IF @valueLength = 0 RETURN '' 

-- Return the string 
RETURN SUBSTRING(@values, @valueStart+1, @valueLength) 
END








GO
/****** Object:  Table [dbo].[AjustesStock]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AjustesStock](
	[IdAjuste] [int] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [bigint] NOT NULL,
	[FechaAjuste] [datetime2](7) NOT NULL,
	[Cantidad] [decimal](10, 2) NOT NULL,
	[Motivo] [nvarchar](250) NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AjustesStock] PRIMARY KEY CLUSTERED 
(
	[IdAjuste] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArchivosGenerados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArchivosGenerados](
	[IdArchivo] [smallint] IDENTITY(1,1) NOT NULL,
	[FechaArchivo] [datetime2](7) NOT NULL,
	[NombreArchivo] [nvarchar](50) NOT NULL,
	[UsrArchivo] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_ArchivosGenerados] PRIMARY KEY CLUSTERED 
(
	[IdArchivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articulos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulos](
	[IdArticulo] [bigint] IDENTITY(1,1) NOT NULL,
	[CodigoBarra] [nvarchar](30) NULL,
	[DescCorta] [nvarchar](100) NOT NULL,
	[DescLarga] [nvarchar](1000) NOT NULL,
	[IdRubro] [int] NOT NULL,
	[IdSubRubro] [int] NOT NULL,
	[LlevarStock] [bit] NOT NULL,
	[StockActual] [float] NOT NULL,
	[UltimaActStock] [datetime2](7) NOT NULL,
	[CantidadMinima] [float] NOT NULL,
	[IdUnidadMedida] [smallint] NOT NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsrBaja] [nvarchar](10) NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[CodigoProducto] [nvarchar](50) NULL,
	[Embalaje] [tinyint] NULL,
 CONSTRAINT [PK_Articulos] PRIMARY KEY CLUSTERED 
(
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ARTS]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARTS](
	[cod] [float] NULL,
	[Articulo] [nvarchar](255) NULL,
	[RUBRO] [nvarchar](255) NULL,
	[SUBRUBRO] [nvarchar](255) NULL,
	[UNIDAD DE MEDIDA] [nvarchar](255) NULL,
	[ PRECIO DE VENTA ] [numeric](38, 2) NULL,
	[PrecioBase] [numeric](38, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AsientosContables]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AsientosContables](
	[IdAsientoContable] [bigint] NOT NULL,
	[IdCuentaContable] [int] NOT NULL,
	[Tipo] [nchar](1) NOT NULL,
	[Valor] [decimal](12, 2) NOT NULL,
	[Periodo] [int] NOT NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AsientosContables_1] PRIMARY KEY CLUSTERED 
(
	[IdAsientoContable] ASC,
	[IdCuentaContable] ASC,
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AutenticacionesWSAA]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutenticacionesWSAA](
	[IdAutenticacion] [int] IDENTITY(1,1) NOT NULL,
	[Token] [nvarchar](1000) NOT NULL,
	[Sign] [nvarchar](500) NOT NULL,
	[FechaAutorizacion] [datetime2](7) NOT NULL,
	[FechaExpiracion] [datetime2](7) NOT NULL,
	[IdEmpresa] [tinyint] NOT NULL,
 CONSTRAINT [PK_AutorizacionesWSAA] PRIMARY KEY CLUSTERED 
(
	[IdAutenticacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bancos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bancos](
	[IdBanco] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Bancos] PRIMARY KEY CLUSTERED 
(
	[IdBanco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cajas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cajas](
	[IdCaja] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[FechaCreacion] [datetime2](7) NOT NULL,
	[IdEstadoCaja] [smallint] NOT NULL,
 CONSTRAINT [PK_Cajas] PRIMARY KEY CLUSTERED 
(
	[IdCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasAperturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajasAperturas](
	[IdAperturaCaja] [int] IDENTITY(1,1) NOT NULL,
	[FechaApertura] [datetime2](7) NOT NULL,
	[UsrApertura] [nvarchar](50) NOT NULL,
	[IdCaja] [smallint] NOT NULL,
	[SaldoInicial] [decimal](10, 2) NOT NULL,
	[SaldoFinal] [decimal](11, 2) NULL,
	[FechaCierre] [datetime2](7) NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CajasAperturas] PRIMARY KEY CLUSTERED 
(
	[IdAperturaCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasAperturasDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajasAperturasDetalle](
	[IdAperturaDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdApertura] [int] NOT NULL,
	[SencilloInicio5ctvos] [smallint] NOT NULL,
	[SencilloInicio10ctvos] [smallint] NOT NULL,
	[SencilloInicio25ctvos] [smallint] NOT NULL,
	[SencilloInicio50ctvos] [smallint] NOT NULL,
	[SencilloInicio1peso] [smallint] NOT NULL,
	[SencilloInicio2pesos] [smallint] NOT NULL,
	[SencilloInicio5pesos] [smallint] NOT NULL,
	[SencilloInicio10pesos] [smallint] NOT NULL,
	[SencilloInicio20pesos] [smallint] NOT NULL,
	[SencilloInicio50pesos] [smallint] NOT NULL,
	[SencilloInicio100pesos] [smallint] NOT NULL,
	[SencilloCierre5ctvos] [smallint] NOT NULL,
	[SencilloCierre10ctvos] [smallint] NOT NULL,
	[SencilloCierre25ctvos] [smallint] NOT NULL,
	[SencilloCierre50ctvos] [smallint] NOT NULL,
	[SencilloCierre1peso] [smallint] NOT NULL,
	[SencilloCierre2pesos] [smallint] NOT NULL,
	[SencilloCierre5pesos] [smallint] NOT NULL,
	[SencilloCierre10pesos] [smallint] NOT NULL,
	[SencilloCierre20pesos] [smallint] NOT NULL,
	[SencilloCierre50pesos] [smallint] NOT NULL,
	[SencilloCierre100pesos] [smallint] NOT NULL,
 CONSTRAINT [PK_CajasAperturasDetalle] PRIMARY KEY CLUSTERED 
(
	[IdAperturaDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasDistribuciones]    Script Date: 1/6/2022 12:12:57 ******/
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
	[UsuarioUltimaModificacion] [smallint] NOT NULL,
 CONSTRAINT [PK_CajasDistribuciones] PRIMARY KEY CLUSTERED 
(
	[CajaDistribucionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasMovimientos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajasMovimientos](
	[IdMovimientoCaja] [bigint] IDENTITY(1,1) NOT NULL,
	[IdAperturaCaja] [int] NOT NULL,
	[IdTipoMovCaja] [smallint] NOT NULL,
	[Monto] [decimal](11, 2) NOT NULL,
	[VueltoEntregado] [decimal](7, 2) NULL,
	[IdFacturaVenta] [int] NULL,
	[DescripcionMov] [nvarchar](150) NOT NULL,
	[FechaMov] [datetime2](7) NOT NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CajasMovimientos] PRIMARY KEY CLUSTERED 
(
	[IdMovimientoCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasMovimientosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajasMovimientosDetalle](
	[IdMovimientoCajaDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdMovimientoCaja] [bigint] NOT NULL,
	[IdTipoPago] [smallint] NOT NULL,
	[Monto] [decimal](9, 2) NOT NULL,
	[IdCheque] [int] NULL,
	[IdEmpTarjeta] [smallint] NULL,
	[NroTarjeta] [nvarchar](25) NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CajasMovimientosDetalle] PRIMARY KEY CLUSTERED 
(
	[IdMovimientoCajaDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CancelacionFacturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CancelacionFacturas](
	[IdCancelacion] [int] IDENTITY(1,1) NOT NULL,
	[IdRecibo] [int] NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[MontoCancelacion] [decimal](12, 2) NOT NULL,
	[FechaAnulacion] [datetime2](7) NULL,
	[IdNotaCredito] [int] NULL,
	[NroCliente] [int] NULL,
 CONSTRAINT [PK_CancelacionFacturas] PRIMARY KEY CLUSTERED 
(
	[IdCancelacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CancelacionFacturasCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CancelacionFacturasCompra](
	[IdCancelacion] [int] IDENTITY(1,1) NOT NULL,
	[IdPago] [int] NOT NULL,
	[IdFacturaCompra] [int] NOT NULL,
	[MontoCancelacion] [decimal](12, 2) NOT NULL,
	[FechaAnulacion] [datetime2](7) NULL,
	[IdNotaCredito] [int] NULL,
	[IdMovBanco] [bigint] NULL,
 CONSTRAINT [PK_CancelacionFacturasCompra] PRIMARY KEY CLUSTERED 
(
	[IdCancelacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cheques]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cheques](
	[IdCheque] [int] IDENTITY(1,1) NOT NULL,
	[NroCheque] [bigint] NOT NULL,
	[MontoCheque] [decimal](8, 2) NOT NULL,
	[FechaEmision] [smalldatetime] NOT NULL,
	[IdBanco] [int] NOT NULL,
	[FechaCobro] [smalldatetime] NOT NULL,
	[Cruzado] [bit] NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[Propio] [bit] NOT NULL,
	[IdEmpresa] [smallint] NOT NULL,
 CONSTRAINT [PK_Cheques] PRIMARY KEY CLUSTERED 
(
	[IdCheque] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CierresIvaCompras]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CierresIvaCompras](
	[IdCierre] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime2](7) NOT NULL,
	[FechaCierre] [datetime2](7) NOT NULL,
	[MesCorrespondiente] [int] NOT NULL,
	[AñoCorrespondiente] [int] NOT NULL,
 CONSTRAINT [PK_CierresIvaCompras] PRIMARY KEY CLUSTERED 
(
	[IdCierre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[NroCliente] [int] IDENTITY(1,1) NOT NULL,
	[TipoDocumento] [nvarchar](5) NULL,
	[NroDocumento] [int] NULL,
	[ApellidoyNombre] [nvarchar](200) NOT NULL,
	[Direccion] [nvarchar](80) NOT NULL,
	[CodigoPostal] [smallint] NOT NULL,
	[SubCodigoPostal] [tinyint] NOT NULL,
	[FechaNacimiento] [smalldatetime] NULL,
	[IdRegimenImpositivo] [smallint] NOT NULL,
	[Telefono] [nvarchar](70) NULL,
	[Email1] [nvarchar](50) NULL,
	[Email2] [nvarchar](50) NULL,
	[Cuit0] [nvarchar](2) NULL,
	[Cuit1] [nvarchar](8) NULL,
	[Cuit2] [nvarchar](1) NULL,
	[UsrBaja] [nvarchar](10) NULL,
	[FechaBaja] [datetime2](7) NULL,
	[FechaAcceso] [datetime2](7) NULL,
	[UsrAcceso] [nvarchar](20) NULL,
	[IdObservación] [tinyint] NULL,
	[MensajeCuenta] [nvarchar](300) NULL,
	[SaldoExcedido] [decimal](12, 2) NULL,
	[CuentaCerrada] [nvarchar](300) NULL,
	[Comentario] [nvarchar](300) NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[NroCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientesCajasDistribucionesServicios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientesCajasDistribucionesServicios](
	[ClienteCajaDistribucionServicioId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NOT NULL,
	[CajaDistribucionId] [int] NOT NULL,
	[ServicioId] [int] NOT NULL,
	[UltimoEstadoId] [int] NULL,
	[FechaUltimaModificacion] [datetime] NOT NULL,
	[UsuarioUltimaModificacion] [smallint] NOT NULL,
 CONSTRAINT [PK_ClientesCajasDistribucionesServicios] PRIMARY KEY CLUSTERED 
(
	[ClienteCajaDistribucionServicioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientesCajasDistribucionesServiciosEstados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados](
	[ClienteCajaDistribucionServicioEstadoId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteCajaDistribucionServicioId] [int] NOT NULL,
	[EstadoId] [int] NOT NULL,
	[FechaUltimaModificacion] [datetime] NOT NULL,
	[UsuarioUltimaModificacion] [smallint] NOT NULL,
	[Observaciones] [varchar](200) NULL,
 CONSTRAINT [PK_ClientesCajasDistribucionesServiciosEstados] PRIMARY KEY CLUSTERED 
(
	[ClienteCajaDistribucionServicioEstadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clis]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clis](
	[F1] [float] NULL,
	[Razon Social] [nvarchar](255) NULL,
	[Direccion] [nvarchar](255) NULL,
	[Localidad*] [nvarchar](255) NULL,
	[Condicion IVA] [nvarchar](255) NULL,
	[CUIT] [nvarchar](255) NULL,
	[Telefono*] [nvarchar](255) NULL,
	[Email*] [nvarchar](255) NULL,
	[Saldo] [money] NULL,
	[F10] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CondicionesPago]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CondicionesPago](
	[IdCondicionPago] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
	[FechaBaja] [datetime2](7) NULL,
 CONSTRAINT [PK_CondicionesPago] PRIMARY KEY CLUSTERED 
(
	[IdCondicionPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControladoresFiscales]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControladoresFiscales](
	[IdCF] [smallint] IDENTITY(1,1) NOT NULL,
	[IdTipoCF] [smallint] NOT NULL,
	[BocadeVenta] [nvarchar](4) NOT NULL,
	[Observaciones] [nvarchar](300) NULL,
	[FechaBaja] [datetime2](7) NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[Puerto] [smallint] NOT NULL,
	[MachineName] [varchar](100) NULL,
 CONSTRAINT [PK_ControladoresFiscales] PRIMARY KEY CLUSTERED 
(
	[IdCF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CPostales]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CPostales](
	[CodigoPostal] [smallint] NOT NULL,
	[SubCodigoPostal] [tinyint] NOT NULL,
	[Localidad] [nvarchar](70) NOT NULL,
	[IdProvincia] [tinyint] NOT NULL,
 CONSTRAINT [PK_CPostales] PRIMARY KEY CLUSTERED 
(
	[CodigoPostal] ASC,
	[SubCodigoPostal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentasBancarias]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentasBancarias](
	[IdCuentaBancaria] [int] IDENTITY(1,1) NOT NULL,
	[IdBanco] [int] NOT NULL,
	[TitularCuenta] [nvarchar](50) NOT NULL,
	[CBU] [nvarchar](30) NOT NULL,
	[NroCuenta] [bigint] NOT NULL,
	[IdEmpresa] [tinyint] NOT NULL,
 CONSTRAINT [PK_CuentasBancarias] PRIMARY KEY CLUSTERED 
(
	[IdCuentaBancaria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentasContables]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentasContables](
	[IdCuentaContable] [int] IDENTITY(1,1) NOT NULL,
	[Nivel1] [tinyint] NOT NULL,
	[Nivel2] [tinyint] NOT NULL,
	[Nivel3] [smallint] NOT NULL,
	[Nivel4] [smallint] NOT NULL,
	[Descripcion] [nvarchar](400) NOT NULL,
	[ImputaValor] [bit] NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[FechaBaja] [datetime] NULL,
	[IdCuentaSuperior] [int] NULL,
 CONSTRAINT [PK_CuentasContables] PRIMARY KEY CLUSTERED 
(
	[IdCuentaContable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosImpositivos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosImpositivos](
	[IdDatosImpositivos] [int] IDENTITY(1,1) NOT NULL,
	[NroCliente] [int] NOT NULL,
	[IdTipoImpuesto] [smallint] NOT NULL,
	[FechaInicioExc] [datetime2](7) NULL,
	[IdProvincia] [tinyint] NULL,
	[NroInscripcion] [int] NOT NULL,
	[Tipo] [nvarchar](100) NULL,
	[FechaInscripcion] [datetime2](7) NOT NULL,
	[NroCertificadoExc] [nvarchar](20) NULL,
	[FechaFinExc] [datetime2](7) NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_DatosImpositivos_1] PRIMARY KEY CLUSTERED 
(
	[IdDatosImpositivos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Depositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Depositos](
	[IdDeposito] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[Ubicacion] [nvarchar](100) NOT NULL,
	[FechaBaja] [datetime] NULL,
 CONSTRAINT [PK_Depositos] PRIMARY KEY CLUSTERED 
(
	[IdDeposito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiaGeneracionInteres]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiaGeneracionInteres](
	[IdDiaGeneracion] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_GeneracionIntereses] PRIMARY KEY CLUSTERED 
(
	[IdDiaGeneracion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empresa]    Script Date: 1/6/2022 12:12:57 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpTarjetas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpTarjetas](
	[IdEmpTarjeta] [smallint] IDENTITY(1,1) NOT NULL,
	[Empresa] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_EmpTarjetas] PRIMARY KEY CLUSTERED 
(
	[IdEmpTarjeta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Errores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Errores](
	[IdError] [bigint] IDENTITY(1,1) NOT NULL,
	[TextoError] [nvarchar](2000) NOT NULL,
	[UsrError] [nvarchar](50) NOT NULL,
	[SeccionError] [nvarchar](500) NOT NULL,
	[ObjetoError] [nvarchar](200) NOT NULL,
	[TraceError] [nvarchar](4000) NOT NULL,
	[FechaError] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Errores] PRIMARY KEY CLUSTERED 
(
	[IdError] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estados](
	[EstadoId] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Estados] PRIMARY KEY CLUSTERED 
(
	[EstadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosCaja]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosCaja](
	[IdEstadoCaja] [smallint] NOT NULL,
	[Estado] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EstadosCaja] PRIMARY KEY CLUSTERED 
(
	[IdEstadoCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasCompra](
	[IdFacturaCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDocumento] [smallint] NOT NULL,
	[IdTipoFactura] [smallint] NOT NULL,
	[BVFactCompra] [nvarchar](4) NOT NULL,
	[NCompFactCompra] [nvarchar](8) NOT NULL,
	[FechaEmision] [smalldatetime] NOT NULL,
	[IdFormaPago] [smallint] NOT NULL,
	[IdCondicionPago] [smallint] NULL,
	[NroProveedor] [int] NOT NULL,
	[Observaciones] [nvarchar](500) NOT NULL,
	[Subtotal105] [decimal](12, 2) NOT NULL,
	[Subtotal21] [decimal](12, 2) NOT NULL,
	[Subtotal] [decimal](13, 2) NOT NULL,
	[Bonificacion1] [decimal](6, 2) NOT NULL,
	[TotalBonificacion1] [decimal](10, 2) NOT NULL,
	[Total] [decimal](14, 2) NOT NULL,
	[FechaVencimiento] [smalldatetime] NOT NULL,
	[FechaAnulacion] [datetime2](7) NULL,
	[Bonificacion2] [decimal](6, 2) NOT NULL,
	[Bonificacion3] [decimal](6, 2) NOT NULL,
	[Bonificacion4] [decimal](6, 2) NOT NULL,
	[PorcentajePerIVA] [decimal](6, 2) NOT NULL,
	[PorcentajePerIIBB] [decimal](6, 2) NOT NULL,
	[TotalBonificacion2] [decimal](10, 2) NOT NULL,
	[TotalBonificacion3] [decimal](10, 2) NOT NULL,
	[TotalBonificacion4] [decimal](10, 2) NOT NULL,
	[TotalDescuento105] [decimal](12, 2) NOT NULL,
	[TotalDescuento21] [decimal](12, 2) NOT NULL,
	[TotalPerIVA] [decimal](10, 2) NOT NULL,
	[TotalPerIIBB] [decimal](10, 2) NOT NULL,
	[TotalIVA105] [decimal](8, 2) NOT NULL,
	[TotalIVA21] [decimal](8, 2) NOT NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[AñoCorrespondiente] [int] NOT NULL,
	[MesCorrespondiente] [int] NOT NULL,
	[ConceptosNoGravados] [decimal](10, 2) NOT NULL,
	[FechaAlta] [datetime2](7) NOT NULL,
	[BVFactReferencia] [nvarchar](4) NULL,
	[NCompFactReferencia] [nvarchar](8) NULL,
	[Bonificacion5] [decimal](6, 2) NOT NULL,
	[Bonificacion6] [decimal](6, 2) NOT NULL,
	[TotalBonificacion5] [decimal](10, 2) NOT NULL,
	[TotalBonificacion6] [decimal](10, 2) NOT NULL,
	[SubTotal27] [decimal](12, 2) NOT NULL,
	[TotalDescuento27] [decimal](12, 2) NOT NULL,
	[TotalIVA27] [decimal](12, 2) NOT NULL,
 CONSTRAINT [PK_FacturasCompra] PRIMARY KEY CLUSTERED 
(
	[IdFacturaCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasCompraDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasCompraDetalle](
	[IdFacturaCompraDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdFacturaCompra] [int] NOT NULL,
	[IdArticulo] [bigint] NULL,
	[Articulo] [nvarchar](200) NULL,
	[UMedida] [nvarchar](100) NULL,
	[Cantidad] [decimal](9, 2) NOT NULL,
	[PrecioUnitario] [decimal](14, 4) NOT NULL,
	[PorcentajeBonif] [decimal](6, 2) NOT NULL,
	[TotalArt] [decimal](14, 2) NOT NULL,
	[DesdeRemito] [bit] NOT NULL,
	[IdTipoIva] [tinyint] NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[MueveStock] [bit] NULL,
	[PorcentajeBonif2] [decimal](6, 2) NOT NULL,
	[PorcentajeBonif3] [decimal](6, 2) NOT NULL,
	[PorcentajeBonif4] [decimal](6, 2) NOT NULL,
	[PorcentajeBonif5] [decimal](6, 2) NOT NULL,
 CONSTRAINT [PK_FacturasCompraDetalle] PRIMARY KEY CLUSTERED 
(
	[IdFacturaCompraDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasElectronicas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasElectronicas](
	[IdFacturaElectronica] [int] IDENTITY(1,1) NOT NULL,
	[IdFacturaVenta] [int] NULL,
	[CAE] [nvarchar](50) NOT NULL,
	[FechaVtoCAE] [datetime2](7) NOT NULL,
	[NCompFact] [nvarchar](8) NOT NULL,
	[Fecha] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_FacturasElectronicas] PRIMARY KEY CLUSTERED 
(
	[IdFacturaElectronica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasVenta](
	[IdFacturaVenta] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDocumento] [smallint] NOT NULL,
	[IdTipoFactura] [smallint] NOT NULL,
	[BVFact] [nvarchar](4) NULL,
	[NCompFact] [nvarchar](8) NULL,
	[FechaEmision] [smalldatetime] NOT NULL,
	[IdFormaPago] [smallint] NOT NULL,
	[IdCondicionPago] [smallint] NULL,
	[ClienteCajaDistribucionServicioId] [int] NOT NULL,
	[Impresa] [bit] NOT NULL,
	[Observaciones] [nvarchar](500) NULL,
	[Subtotal105] [decimal](12, 2) NOT NULL,
	[Subtotal21] [decimal](12, 2) NOT NULL,
	[SubTotal] [decimal](13, 2) NOT NULL,
	[Descuento] [decimal](4, 2) NOT NULL,
	[TotalDescuento105] [decimal](10, 2) NOT NULL,
	[TotalDescuento21] [decimal](10, 2) NOT NULL,
	[TotalDescuento] [decimal](13, 2) NOT NULL,
	[TotalIva105] [decimal](8, 2) NOT NULL,
	[TotalIva21] [decimal](8, 2) NOT NULL,
	[Total] [decimal](14, 2) NOT NULL,
	[FechaVencimiento] [datetime2](7) NOT NULL,
	[FechaAnulacion] [datetime2](7) NULL,
	[TotalSaldado] [decimal](10, 2) NOT NULL,
	[TotalInteres] [decimal](8, 2) NOT NULL,
	[TotalSaldadoInteres] [decimal](8, 2) NOT NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[BVReferencia] [nvarchar](4) NULL,
	[NroCompFactReferencia] [nvarchar](8) NULL,
	[IdConceptoFactura] [int] NOT NULL,
	[FechaAlta] [datetime2](7) NOT NULL,
	[Cobrador] [bit] NOT NULL,
	[MoverStock] [bit] NOT NULL,
	[NombreMaquina] [varchar](50) NULL,
	[Pagado] [bit] NULL,
 CONSTRAINT [PK_FacturasVenta] PRIMARY KEY CLUSTERED 
(
	[IdFacturaVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasVentaDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasVentaDetalle](
	[IdFacturaVentaDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[IdServicio] [int] NULL,
	[Servicio] [nvarchar](200) NULL,
	[UMedida] [nvarchar](100) NULL,
	[Cantidad] [decimal](9, 2) NULL,
	[PrecioUnitario] [decimal](14, 4) NOT NULL,
	[IdTipoIva] [tinyint] NOT NULL,
	[TotalArt] [decimal](14, 2) NOT NULL,
	[DesdeRemito] [bit] NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[MueveStock] [bit] NULL,
	[PrecioManual] [bit] NULL,
 CONSTRAINT [PK_FacturasDetalle] PRIMARY KEY CLUSTERED 
(
	[IdFacturaVentaDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormasPago]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormasPago](
	[IdFormaPago] [smallint] NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_FormasPago] PRIMARY KEY CLUSTERED 
(
	[IdFormaPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneracionInteres]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneracionInteres](
	[IdGeneracionInteres] [bigint] IDENTITY(1,1) NOT NULL,
	[IdDiaGeneracion] [int] NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[NroGeneracion] [smallint] NOT NULL,
	[TotalInteres] [decimal](8, 2) NOT NULL,
 CONSTRAINT [PK_GeneracionInteres] PRIMARY KEY CLUSTERED 
(
	[IdGeneracionInteres] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Liquidaciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Liquidaciones](
	[IdLiquidacion] [int] IDENTITY(1,1) NOT NULL,
	[NroVendedor] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[TotalComision] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_Liquidaciones] PRIMARY KEY CLUSTERED 
(
	[IdLiquidacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LiquidacionesFacturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LiquidacionesFacturas](
	[IdLiquidacionFacturas] [int] IDENTITY(1,1) NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[IdLiquidacion] [int] NOT NULL,
	[MontoBase] [numeric](18, 2) NOT NULL,
	[MontoComision] [numeric](18, 2) NOT NULL,
	[IdRecibo] [int] NULL,
	[IdMovCaja] [bigint] NULL,
 CONSTRAINT [PK_LiquidacionesFacturas] PRIMARY KEY CLUSTERED 
(
	[IdLiquidacionFacturas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Modulos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modulos](
	[IdModulo] [smallint] NOT NULL,
	[Modulo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Modulos] PRIMARY KEY CLUSTERED 
(
	[IdModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModulosTiposUsuarios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModulosTiposUsuarios](
	[IdModulo] [smallint] NOT NULL,
	[IdTipoUsuario] [smallint] NOT NULL,
 CONSTRAINT [PK_ModulosTiposUsuarios] PRIMARY KEY CLUSTERED 
(
	[IdModulo] ASC,
	[IdTipoUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientosBancos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientosBancos](
	[IdMovBanco] [bigint] IDENTITY(1,1) NOT NULL,
	[IdTipoMovBanco] [smallint] NOT NULL,
	[IdTipoPersona] [smallint] NOT NULL,
	[IdPersona] [int] NOT NULL,
	[FechaEmision] [date] NOT NULL,
	[FechaEfectivizacion] [date] NOT NULL,
	[NroComprobante] [nvarchar](50) NULL,
	[Descripcion] [nvarchar](200) NULL,
	[IdCheque] [int] NULL,
 CONSTRAINT [PK_MovimientosBancos] PRIMARY KEY CLUSTERED 
(
	[IdMovBanco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientosDepositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientosDepositos](
	[IdMovimientoDeposito] [bigint] IDENTITY(1,1) NOT NULL,
	[IdDeposito] [int] NOT NULL,
	[IdArticulo] [bigint] NOT NULL,
	[Cantidad] [numeric](18, 2) NOT NULL,
	[IdTipoMovDeposito] [int] NOT NULL,
	[IdDepositoSecundario] [int] NULL,
	[FechaMovimiento] [datetime] NOT NULL,
 CONSTRAINT [PK_MovimientosDepositos] PRIMARY KEY CLUSTERED 
(
	[IdMovimientoDeposito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObservacionesCliente]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObservacionesCliente](
	[IdObservacion] [tinyint] IDENTITY(1,1) NOT NULL,
	[Descripción] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_ObservacionesCliente] PRIMARY KEY CLUSTERED 
(
	[IdObservacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesPedidoFacturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesPedidoFacturas](
	[IdOrdenFactura] [bigint] IDENTITY(1,1) NOT NULL,
	[IdOrdenDetalle] [bigint] NOT NULL,
	[IdFacturaCompraDetalle] [bigint] NOT NULL,
	[Cantidad] [numeric](18, 2) NOT NULL,
	[IdArticulo] [bigint] NOT NULL,
 CONSTRAINT [PK_OrdenesPedidoFacturas] PRIMARY KEY CLUSTERED 
(
	[IdOrdenFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesPedidos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesPedidos](
	[IdOrdenPedido] [int] IDENTITY(1,1) NOT NULL,
	[NroOrden] [nvarchar](13) NOT NULL,
	[FechaOrden] [datetime] NOT NULL,
	[NroProveedor] [int] NOT NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[FechaBaja] [datetime] NULL,
	[Total] [decimal](12, 2) NOT NULL,
 CONSTRAINT [PK_OrdenesPedidos] PRIMARY KEY CLUSTERED 
(
	[IdOrdenPedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenesPedidosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenesPedidosDetalle](
	[IdOrdenDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdOrdenPedido] [int] NOT NULL,
	[IdArticulo] [bigint] NULL,
	[Cantidad] [numeric](11, 2) NOT NULL,
	[FechaLinea] [datetime] NOT NULL,
	[Precio] [decimal](18, 2) NOT NULL,
	[Artículo] [nvarchar](200) NULL,
	[UMedida] [nvarchar](100) NULL,
	[IdTipoIva] [tinyint] NOT NULL,
	[CodigoProducto] [nvarchar](20) NULL,
 CONSTRAINT [PK_OrdenesDetalle] PRIMARY KEY CLUSTERED 
(
	[IdOrdenDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pagos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pagos](
	[IdPago] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDocumento] [smallint] NOT NULL,
	[FechaEmision] [datetime2](7) NOT NULL,
	[NroProveedor] [int] NOT NULL,
	[MontoTotal] [decimal](12, 2) NOT NULL,
	[Concepto] [nvarchar](500) NULL,
	[FechaBaja] [datetime2](7) NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Pagos] PRIMARY KEY CLUSTERED 
(
	[IdPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PagosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PagosDetalle](
	[IdPagoDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdPago] [int] NOT NULL,
	[IdTipoPago] [smallint] NOT NULL,
	[Monto] [decimal](8, 2) NOT NULL,
	[IdCheque] [int] NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[IdEmpTarjeta] [smallint] NULL,
	[NroTarjeta] [nvarchar](20) NULL,
 CONSTRAINT [PK_PagosDetalle] PRIMARY KEY CLUSTERED 
(
	[IdPagoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeriodosContables]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodosContables](
	[Periodo] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [datetime2](7) NOT NULL,
	[FechaCierre] [datetime2](7) NULL,
 CONSTRAINT [PK_PeriodosContables] PRIMARY KEY CLUSTERED 
(
	[Periodo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreciosVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreciosVenta](
	[IdArticulo] [bigint] NOT NULL,
	[FechaPrecios] [datetime2](7) NOT NULL,
	[PrecioContado] [numeric](18, 4) NOT NULL,
	[PrecioFiado] [numeric](18, 4) NOT NULL,
	[PrecioEspecial] [numeric](18, 4) NULL,
	[PrecioContadoIva] [numeric](18, 4) NOT NULL,
	[PrecioFiadoIva] [numeric](18, 4) NOT NULL,
	[PrecioEspecialIva] [numeric](18, 4) NULL,
	[PrecioBase] [numeric](18, 4) NOT NULL,
	[Bonificacion1] [numeric](6, 2) NULL,
	[Bonificacion2] [numeric](6, 2) NULL,
	[Bonificacion3] [numeric](6, 2) NULL,
	[Bonificacion4] [numeric](6, 2) NULL,
	[IdTipoIva] [tinyint] NOT NULL,
	[CostoBruto] [numeric](18, 4) NULL,
	[PorcentajeFlete] [numeric](6, 2) NULL,
	[CostoFlete] [numeric](18, 4) NULL,
	[PorcentajeDescarga] [numeric](6, 2) NULL,
	[CostoDescarga] [numeric](9, 4) NULL,
	[CostoTotal] [numeric](18, 4) NULL,
	[PorcentajeGcia] [numeric](6, 2) NOT NULL,
	[PorcentajeFiado] [numeric](6, 2) NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[Impuesto] [decimal](5, 2) NULL,
 CONSTRAINT [PK_PreciosVenta] PRIMARY KEY CLUSTERED 
(
	[IdArticulo] ASC,
	[FechaPrecios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Presupuestos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuestos](
	[IdPresupuesto] [int] IDENTITY(1,1) NOT NULL,
	[NombrePres] [nvarchar](150) NULL,
	[NroCliente] [int] NULL,
	[Nombre] [nvarchar](100) NULL,
	[Direccion] [nvarchar](100) NULL,
	[Telefono] [nvarchar](50) NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[FechaPresupuesto] [smalldatetime] NOT NULL,
	[Subtotal] [numeric](9, 2) NOT NULL,
	[Descuento] [numeric](5, 2) NOT NULL,
	[Total] [numeric](10, 2) NOT NULL,
	[PlazoEntrega] [nvarchar](200) NULL,
	[ValidezOferta] [nvarchar](200) NULL,
	[FormaPago] [nvarchar](200) NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[IdFacturaVenta] [int] NULL,
	[IdTipoPres] [smallint] NOT NULL,
 CONSTRAINT [PK_Presupuestos] PRIMARY KEY CLUSTERED 
(
	[IdPresupuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PresupuestosDetalles]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PresupuestosDetalles](
	[IdPresupuestoDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdPresupuesto] [int] NOT NULL,
	[IdArticulo] [bigint] NULL,
	[Cantidad] [numeric](11, 2) NOT NULL,
	[PrecioUnitario] [numeric](14, 4) NOT NULL,
	[FechaAcceso] [datetime2](7) NULL,
	[UsrAcceso] [nvarchar](20) NULL,
	[Articulo] [nvarchar](200) NULL,
	[UMedida] [nvarchar](100) NULL,
	[IVAArt] [decimal](6, 2) NULL,
 CONSTRAINT [PK_PresupuestosDetalles] PRIMARY KEY CLUSTERED 
(
	[IdPresupuestoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedores](
	[NroProveedor] [int] IDENTITY(1,1) NOT NULL,
	[TipoDocumento] [nvarchar](5) NOT NULL,
	[NroDocumento] [bigint] NOT NULL,
	[ApellidoyNombre] [nvarchar](200) NOT NULL,
	[Direccion] [nvarchar](80) NOT NULL,
	[CodigoPostal] [smallint] NOT NULL,
	[SubCodigoPostal] [tinyint] NOT NULL,
	[Telefono] [nvarchar](70) NULL,
	[Email1] [nvarchar](50) NULL,
	[Email2] [nvarchar](50) NULL,
	[PaginaWeb] [nvarchar](200) NULL,
	[FechaAcceso] [datetime2](7) NULL,
	[UsrAcceso] [nvarchar](20) NULL,
	[IdRegimenImpositivo] [smallint] NOT NULL,
	[FechaBaja] [datetime] NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[NroProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provincias]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provincias](
	[IdProvincia] [tinyint] NOT NULL,
	[Provincia] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Provincias] PRIMARY KEY CLUSTERED 
(
	[IdProvincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recibos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recibos](
	[IdRecibo] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDocumento] [smallint] NOT NULL,
	[FechaEmision] [datetime2](7) NOT NULL,
	[NroCliente] [int] NOT NULL,
	[MontoTotal] [decimal](10, 2) NOT NULL,
	[Concepto] [nvarchar](500) NULL,
	[FechaBaja] [datetime2](7) NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Recibos] PRIMARY KEY CLUSTERED 
(
	[IdRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecibosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecibosDetalle](
	[IdReciboDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdTipoPago] [smallint] NOT NULL,
	[IdCheque] [int] NULL,
	[IdRecibo] [int] NOT NULL,
	[Monto] [decimal](8, 2) NOT NULL,
	[IdEmpTarjeta] [smallint] NULL,
	[NroTarjeta] [nvarchar](20) NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_RecibosDetalle] PRIMARY KEY CLUSTERED 
(
	[IdReciboDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReferentesProveedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReferentesProveedores](
	[IdReferente] [int] IDENTITY(1,1) NOT NULL,
	[NroProveedor] [int] NOT NULL,
	[Referente] [nvarchar](200) NOT NULL,
	[Cargo] [nvarchar](200) NULL,
	[FechaBaja] [datetime2](7) NULL,
 CONSTRAINT [PK_ReferentesProveedores] PRIMARY KEY CLUSTERED 
(
	[IdReferente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegimenesImpositivos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegimenesImpositivos](
	[IdRegimenImpositivo] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_RegimenesImpositivos] PRIMARY KEY CLUSTERED 
(
	[IdRegimenImpositivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Remitos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Remitos](
	[IdRemito] [int] IDENTITY(1,1) NOT NULL,
	[NroRemito] [nvarchar](13) NOT NULL,
	[FechaRemito] [datetime2](7) NOT NULL,
	[NroCliente] [int] NOT NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[IdFactura] [int] NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[FechaAnulacion] [datetime2](7) NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[Total] [numeric](18, 2) NULL,
	[TotalDescuento] [numeric](18, 2) NULL,
	[PorcDescuento] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Remitos] PRIMARY KEY CLUSTERED 
(
	[IdRemito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RemitosCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RemitosCompra](
	[IdRemitoCompra] [int] IDENTITY(1,1) NOT NULL,
	[BVRemCompra] [nvarchar](4) NOT NULL,
	[NroCompRemCompra] [nvarchar](8) NOT NULL,
	[NroProveedor] [int] NOT NULL,
	[FechaRemitoCompra] [datetime2](7) NOT NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[IdFacturaCompra] [int] NULL,
	[IdEmpresa] [smallint] NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_RemitosCompra] PRIMARY KEY CLUSTERED 
(
	[IdRemitoCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RemitosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RemitosDetalle](
	[IdRemitoDetalle] [bigint] IDENTITY(1,1) NOT NULL,
	[IdRemito] [int] NOT NULL,
	[IdArticulo] [bigint] NULL,
	[Cantidad] [numeric](11, 2) NOT NULL,
	[FechaLinea] [datetime2](7) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[Articulo] [nvarchar](200) NULL,
	[UMedida] [nvarchar](100) NULL,
	[IVA] [decimal](5, 2) NULL,
	[PrecioTotal] [decimal](18, 2) NULL,
	[MueveStock] [bit] NULL,
 CONSTRAINT [PK_RemitosDetalle] PRIMARY KEY CLUSTERED 
(
	[IdRemitoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RemitosDetalleCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RemitosDetalleCompra](
	[IdRemitoDetalleCompra] [bigint] IDENTITY(1,1) NOT NULL,
	[IdRemitoCompra] [int] NOT NULL,
	[IdArticulo] [bigint] NOT NULL,
	[Cantidad] [numeric](11, 2) NOT NULL,
	[FechaLinea] [datetime2](7) NOT NULL,
	[FechaAcceso] [datetime2](7) NOT NULL,
	[UsrAcceso] [nvarchar](20) NOT NULL,
	[MueveStock] [bit] NULL,
 CONSTRAINT [PK_RemitosDetalleCompra] PRIMARY KEY CLUSTERED 
(
	[IdRemitoDetalleCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RemitosXfacturados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RemitosXfacturados](
	[IdFacturacion] [int] IDENTITY(1,1) NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[IdFacturaFinal] [int] NOT NULL,
 CONSTRAINT [PK_RemitosXfacturados] PRIMARY KEY CLUSTERED 
(
	[IdFacturacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RetencionesGcia]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RetencionesGcia](
	[IdRetencionGcia] [int] IDENTITY(1,1) NOT NULL,
	[FechaCalculo] [datetime2](7) NOT NULL,
	[MontoRetencion] [numeric](10, 2) NOT NULL,
	[IdPago] [int] NOT NULL,
	[NroProveedor] [int] NOT NULL,
	[BaseCalculo] [numeric](14, 2) NOT NULL,
 CONSTRAINT [PK_RetencionesGcia] PRIMARY KEY CLUSTERED 
(
	[IdRetencionGcia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rubros]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rubros](
	[IdRubro] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Rubros] PRIMARY KEY CLUSTERED 
(
	[IdRubro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RubSub]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RubSub](
	[RUBRO] [nvarchar](255) NULL,
	[SUBRUBRO] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Servicios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servicios](
	[ServicioId] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
	[FechaUltimaModificacion] [datetime] NOT NULL,
	[UsuarioUltimaModificacion] [smallint] NOT NULL,
	[Costo] [decimal](18, 0) NOT NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_Servicios] PRIMARY KEY CLUSTERED 
(
	[ServicioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Seteos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seteos](
	[IdSeteo] [tinyint] NOT NULL,
	[UsarCF] [bit] NOT NULL,
	[DiasVtoFact] [tinyint] NOT NULL,
	[PathBackUp] [nvarchar](500) NOT NULL,
	[PorcentajeGcia] [decimal](4, 2) NULL,
	[PorcentajeFiado] [decimal](4, 2) NULL,
	[UsarCaja] [bit] NOT NULL,
	[UsarPrecioIVAPres] [bit] NOT NULL,
	[UsarCajaRegistradora] [bit] NOT NULL,
	[DuplicadoRecibo] [bit] NOT NULL,
	[UsarMultiEmpresa] [bit] NOT NULL,
	[MostrarArtBajas] [bit] NOT NULL,
	[MostrarCliBajas] [bit] NOT NULL,
	[MostarArtLoad] [bit] NOT NULL,
	[MostarArtPreciosLoad] [bit] NOT NULL,
	[FacturacionRapida] [bit] NOT NULL,
	[Usar4DigitosPrecios] [bit] NOT NULL,
	[UsarIntereses] [bit] NOT NULL,
	[PorcentajeInteres] [decimal](4, 2) NULL,
	[PreciosSoloAdmin] [bit] NOT NULL,
	[UsarRemitoX] [bit] NOT NULL,
	[ImprimirRecCtdoCajas] [bit] NOT NULL,
	[UsarDetalleCajas] [bit] NOT NULL,
	[UsarUpdater] [bit] NOT NULL,
	[UsarCB] [bit] NOT NULL,
	[UsarDolar] [bit] NOT NULL,
	[CotizacionDolar] [decimal](4, 2) NULL,
	[UsarLogo] [bit] NOT NULL,
	[DuplicadoRemitoX] [bit] NOT NULL,
	[Hollistor] [bit] NOT NULL,
	[Flete] [bit] NOT NULL,
	[Descarga] [bit] NOT NULL,
	[PorcentajeFlete] [decimal](4, 2) NULL,
	[PorcentajeDescarga] [decimal](4, 2) NULL,
	[Impuesto] [bit] NOT NULL,
	[HabilitarUserPorIntentos] [bit] NULL,
	[MaxIntentosFallidos] [int] NULL,
	[LapsoTiempoBloqueo] [int] NULL,
	[PermitirFacturar] [bit] NOT NULL,
	[UltimaHoraZ] [datetime] NULL,
 CONSTRAINT [PK_Seteos] PRIMARY KEY CLUSTERED 
(
	[IdSeteo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubRubros]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubRubros](
	[IdSubRubro] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
	[IdRubro] [int] NULL,
 CONSTRAINT [PK_SubRubros] PRIMARY KEY CLUSTERED 
(
	[IdSubRubro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposCF]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposCF](
	[IdTipoCF] [smallint] NOT NULL,
	[TipoCF] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposCF] PRIMARY KEY CLUSTERED 
(
	[IdTipoCF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposCheques]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposCheques](
	[IdTipoCheque] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](70) NOT NULL,
 CONSTRAINT [PK_TiposCheques] PRIMARY KEY CLUSTERED 
(
	[IdTipoCheque] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposConceptoFactura]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposConceptoFactura](
	[IdConceptoFactura] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposConceptoFactura] PRIMARY KEY CLUSTERED 
(
	[IdConceptoFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposDocFact]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposDocFact](
	[IdTipoDocumento] [smallint] NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposDocFact] PRIMARY KEY CLUSTERED 
(
	[IdTipoDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposDocumento]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposDocumento](
	[TipoDocumento] [nvarchar](5) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TiposDocumento_1] PRIMARY KEY CLUSTERED 
(
	[TipoDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposFactura]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposFactura](
	[IdTipoFactura] [smallint] NOT NULL,
	[Descripcion] [nvarchar](1) NOT NULL,
 CONSTRAINT [PK_TiposFactura] PRIMARY KEY CLUSTERED 
(
	[IdTipoFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposImpuestos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposImpuestos](
	[IdTipoImpuesto] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposImpuestos] PRIMARY KEY CLUSTERED 
(
	[IdTipoImpuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposIva]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposIva](
	[IdTipoIva] [tinyint] IDENTITY(1,1) NOT NULL,
	[PorcentajeIVA] [real] NOT NULL,
 CONSTRAINT [PK_TiposIva] PRIMARY KEY CLUSTERED 
(
	[IdTipoIva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposMovimientosBanco]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposMovimientosBanco](
	[IdTipoMovBanco] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[DescripAbreviada] [nvarchar](30) NOT NULL,
	[IdTipoCancelacion] [int] NOT NULL,
 CONSTRAINT [PK_TiposMovimientosBanco] PRIMARY KEY CLUSTERED 
(
	[IdTipoMovBanco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposMovimientosCaja]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposMovimientosCaja](
	[IdTipoMovCaja] [smallint] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TiposMovimientosCaja] PRIMARY KEY CLUSTERED 
(
	[IdTipoMovCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposMovimientosDepositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposMovimientosDepositos](
	[IdTipoMovDeposito] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TiposMovDeposito] PRIMARY KEY CLUSTERED 
(
	[IdTipoMovDeposito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposPagos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposPagos](
	[IdTipoPago] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposPagos] PRIMARY KEY CLUSTERED 
(
	[IdTipoPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposPersona]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposPersona](
	[IdTipoPersona] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposPersona] PRIMARY KEY CLUSTERED 
(
	[IdTipoPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposRetenciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposRetenciones](
	[IdTipoRetencion] [int] IDENTITY(1,1) NOT NULL,
	[MontoMinimo] [numeric](18, 2) NOT NULL,
	[Alicuota] [numeric](8, 4) NOT NULL,
 CONSTRAINT [PK_TiposRetenciones] PRIMARY KEY CLUSTERED 
(
	[IdTipoRetencion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposUsuarios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposUsuarios](
	[IdTipoUser] [smallint] IDENTITY(1,1) NOT NULL,
	[Tipo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposUsuarios] PRIMARY KEY CLUSTERED 
(
	[IdTipoUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposVendedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposVendedores](
	[IdTipoVendedor] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposVendedores] PRIMARY KEY CLUSTERED 
(
	[IdTipoVendedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposVendedoresExternos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposVendedoresExternos](
	[IdTipoVendedorExt] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposVendedoresExternos] PRIMARY KEY CLUSTERED 
(
	[IdTipoVendedorExt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadesMedida]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadesMedida](
	[IdUnidadMedida] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_UnidadesMedida] PRIMARY KEY CLUSTERED 
(
	[IdUnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[IdUser] [smallint] IDENTITY(1,1) NOT NULL,
	[NombreUser] [nvarchar](10) NOT NULL,
	[IdTipoUser] [smallint] NOT NULL,
	[FechaBaja] [datetime2](7) NULL,
	[PassUser] [binary](20) NULL,
	[FechaDeBloqueo] [datetime] NULL,
	[NumeroDeIntentos] [int] NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendedores](
	[NroVendedor] [int] IDENTITY(1,1) NOT NULL,
	[TipoDocumento] [nvarchar](5) NOT NULL,
	[NroDocumento] [bigint] NULL,
	[ApellidoyNombre] [nvarchar](200) NOT NULL,
	[Direccion] [nvarchar](80) NOT NULL,
	[CodigoPostal] [smallint] NOT NULL,
	[SubCodigoPostal] [tinyint] NOT NULL,
	[Telefono] [nvarchar](70) NULL,
	[Email1] [nvarchar](50) NULL,
	[Email2] [nvarchar](50) NULL,
	[PaginaWeb] [nvarchar](200) NULL,
	[PorcComision] [numeric](15, 2) NOT NULL,
	[IdTipoVendedor] [int] NOT NULL,
	[IdTipoVendedorExt] [int] NULL,
	[FechaBaja] [datetime] NULL,
 CONSTRAINT [PK_Vendedores] PRIMARY KEY CLUSTERED 
(
	[NroVendedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendedoresFacturasVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendedoresFacturasVenta](
	[NroVendedor] [int] NOT NULL,
	[IdFacturaVenta] [int] NOT NULL,
	[MontoComision] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_VendedoresFacturasVenta] PRIMARY KEY CLUSTERED 
(
	[NroVendedor] ASC,
	[IdFacturaVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendedoresRemitos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendedoresRemitos](
	[NroVendedor] [int] NOT NULL,
	[IdRemito] [int] NOT NULL,
 CONSTRAINT [PK_VendedoresRemitos] PRIMARY KEY CLUSTERED 
(
	[NroVendedor] ASC,
	[IdRemito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VistaOrdenesPedidoDetallePendienteFacturacion]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaOrdenesPedidoDetallePendienteFacturacion] as
select O.IdOrdenPedido, OD.IdOrdenDetalle, A.IdArticulo, A.DescCorta, o.NroOrden, O.NroProveedor, P.ApellidoyNombre, ISNULL(SUM(OPF.Cantidad),0) AS TotalFacturado, OD.Cantidad as Cantidad, 
OD.Cantidad - ISNULL(SUM(OPF.Cantidad),0) as PendienteFacturacion
from OrdenesPedidosDetalle OD inner join 
OrdenesPedidos O on O.IdOrdenPedido = OD.IdOrdenPedido LEFT JOIN
OrdenesPedidoFacturas OPF on OD.IdOrdenDetalle = OPF.IdOrdenDetalle left JOIN 
Articulos A on A.IdArticulo = OD.IdArticulo INNER JOIN
Proveedores P on P.NroProveedor = O.NroProveedor
WHERE O.FechaBaja is null
group by OD.IdOrdenDetalle, A.IdArticulo, A.DescCorta, O.NroOrden, O.NroProveedor, OD.Cantidad, O.IdOrdenPedido, O.FechaBaja, P.ApellidoyNombre
HAVING OD.Cantidad - ISNULL(SUM(OPF.Cantidad),0) > 0

GO
/****** Object:  View [dbo].[VistaOrdenesPedidos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[VistaOrdenesPedidos] as 
(select distinct op.IdOrdenPedido as IdOrdenPedido, op.NroOrden, op.FechaOrden, op.Observaciones, op.NroProveedor, 
p.ApellidoyNombre, op.FechaBaja, op.Total, CASE WHEN v.IdOrdenPedido is null then 1 else 0 end as Facturado
 from OrdenesPedidos op 
 inner join Proveedores p 
	on op.NroProveedor = p.NroProveedor 
 left join VistaOrdenesPedidoDetallePendienteFacturacion v
	on op.IdOrdenPedido = v.IdOrdenPedido)

GO
/****** Object:  View [dbo].[VistaNCsinSaldar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VistaNCsinSaldar]
AS
SELECT     fv.IdFacturaVenta, fv.NroCliente, fv.BVFact + '-' + fv.NCompFact AS NroFactura, fv.IdEmpresa, fv.Total, 
				SUM(ISNULL(cf.MontoCancelacion, 0)) AS TotalSaldado, (fv.Total - SUM(ISNULL(cf.MontoCancelacion, 0))) as Pendiente,
                      fv.FechaEmision, fv.FechaAnulacion, cf.IdNotaCredito, c.ApellidoyNombre, C.Direccion, FV.IdTipoFactura, fv.Cobrador					  
FROM         FacturasVenta AS fv LEFT OUTER JOIN
                      CancelacionFacturas AS cf ON cf.IdNotaCredito = fv.IdFacturaVenta AND cf.FechaAnulacion IS NULL INNER JOIN
                      Clientes C on fv.NroCliente = c.NroCliente
WHERE     (fv.IdFormaPago = 2) AND (fv.FechaAnulacion is null) AND (fv.IdTipoDocumento = 2) AND C.FechaBaja is null
GROUP BY fv.IdFacturaVenta, fv.NroCliente, fv.BVFact + '-' + fv.NCompFact, fv.IdEmpresa, fv.Total, fv.FechaEmision, 
fv.FechaAnulacion, cf.IdNotaCredito, c.ApellidoyNombre, C.Direccion, FV.IdTipoFactura, fv.Cobrador
HAVING (fv.Total > SUM(ISNULL(cf.MontoCancelacion, 0)))

GO
/****** Object:  View [dbo].[VistaTotalNCsinSaldar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaTotalNCsinSaldar] as
(select v.nroCliente, c.ApellidoyNombre, SUM(Pendiente) as TotalNC
from VistaNCsinSaldar v join Clientes c 
on v.NroCliente = c.NroCliente
group by v.NroCliente, c.ApellidoyNombre)

GO
/****** Object:  View [dbo].[VistaFacturasSinSaldar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VistaFacturasSinSaldar]
AS
select fv.IdFacturaVenta, fv.NroCliente, fv.BVFact + '-' + fv.NCompFact AS NroFactura, fv.Total, fv.IdTipoDocumento, fv.IdTipoFactura,
	SUM(ISNULL(cf.MontoCancelacion, 0)) as TotalSaldado, fv.Total  - SUM(ISNULL(cf.MontoCancelacion, 0)) as PendienteCobro, 
	fv.FechaEmision, c.ApellidoyNombre, c.Direccion, NroDocumento, cuit0 + '-' + cuit1 + '-' + cuit2 as CUIT, IdEmpresa	
from FacturasVenta fv left join CancelacionFacturas cf
on fv.IdFacturaVenta = cf.IdFacturaVenta and cf.FechaAnulacion is null
inner join Clientes c on fv.NroCliente = c.NroCliente and c.FechaBaja is null
where (fv.IdFormaPago = 2) AND (fv.FechaAnulacion is null) and (fv.IdTipoDocumento in (1,8)) 
and fv.IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
group by fv.IdFacturaVenta, fv.NroCliente, fv.BVFact + '-' + fv.NCompFact, fv.Total, fv.IdTipoDocumento, 
			fv.IdTipoFactura, fv.FechaEmision, c.ApellidoyNombre, c.Direccion, NroDocumento, cuit0 + '-' + cuit1 + '-' + cuit2, IdEmpresa
having fv.Total > SUM(ISNULL(cf.MontoCancelacion, 0))



GO
/****** Object:  View [dbo].[VistaComprobantesSinSaldar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
/****** Object:  View [dbo].[VistaVendedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VistaVendedores] as
select V.NroVendedor, V.TipoDocumento, V.NroDocumento, V.ApellidoyNombre, V.Direccion, V.CodigoPostal, V.SubCodigoPostal,
V.Telefono, V.Email1, V.Email2, V.PaginaWeb, V.PorcComision, V.IdTipoVendedor, 
CP.Localidad, TV.Descripcion as TipoVendedor, TVE.IdTipoVendedorExt, TVE.Descripcion as TipoVendedorExterno, v.FechaBaja
From Vendedores V INNER JOIN 
CPostales CP on V.CodigoPostal = CP.CodigoPostal and V.SubCodigoPostal = CP.SubCodigoPostal INNER JOIN
TiposVendedores TV on TV.IdTipoVendedor = V.IdTipoVendedor LEFT JOIN
TiposVendedoresExternos TVE on TVE.IdTipoVendedorExt = V.IdTipoVendedorExt








GO
/****** Object:  View [dbo].[VistaVendedoresFactVta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VistaVendedoresFactVta] as
select vfv.*, ApellidoyNombre, TipoVendedor
from VendedoresFacturasVenta vfv join VistaVendedores vend 
on vfv.NroVendedor = vend.NroVendedor

GO
/****** Object:  View [dbo].[VistaTotalesComisionesFacturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VistaTotalesComisionesFacturas] as
select SUM(Lf.MontoComision) as TotalComisionado, lf.IdFacturaVenta, vfv.NroVendedor
from LiquidacionesFacturas LF inner join 
Liquidaciones L on LF.IdLiquidacion = L.IdLiquidacion INNER JOIN
VendedoresFacturasVenta VFV on VFV.IdFacturaVenta = LF.IdFacturaVenta and l.NroVendedor = VFV.NroVendedor
group by lf.IdFacturaVenta, vfv.NroVendedor






GO
/****** Object:  View [dbo].[VistaDetalleFacturasSinComisionar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE view [dbo].[VistaDetalleFacturasSinComisionar] as
select FV.BVFact + '-' + FV.NCompFact as NroFactura, FV.IdFacturaVenta, FVD.IdFacturaVentaDetalle, A.IdArticulo,
A.DescCorta as Articulo, V.PorcComision, VFV.MontoComision, FV.Total, FV.FechaEmision, VFV.NroVendedor
from FacturasVentaDetalle FVD inner join 
FacturasVenta FV on FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
VendedoresFacturasVenta VFV on VFV.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN
Articulos A on FVD.IdArticulo = A.IdArticulo INNER JOIN 
Vendedores V on V.NroVendedor = VFV.NroVendedor LEFT JOIN
VistaTotalesComisionesFacturas VTC on VTC.IdFacturaVenta = FV.IdFacturaVenta and VFV.NroVendedor = VTC.NroVendedor

where FV.FechaAnulacion is null and VFV.MontoComision > 0 and VFV.MontoComision > ISNULL(VTC.TotalComisionado, 0)







GO
/****** Object:  View [dbo].[VistaTotalesDiscriminadosFactB]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[VistaTotalesDiscriminadosFactB] as
SELECT     fv.IdFacturaVenta, SUM(aux2.TotalGravado) AS TotalGravado, SUM(aux2.TotalNOGravado) AS TotalNOGravado, SUM(aux2.IVA21) AS IVA21, SUM(aux2.IVA105) 
                      AS IVA105, fv.Total
FROM         (SELECT     aux.IdFacturaVenta, ROUND(SUM(aux.totalgravado / (1 + ti.PorcentajeIVA / 100)), 2) AS TotalGravado, SUM(aux.totalnogravado) AS TotalNOGravado, 
                                              (CASE WHEN ti.IdtipoIVa = 1 THEN round(SUM(totalgravado - totalgravado / (1 + (ti.PorcentajeIVA / 100))), 2) ELSE 0 END) AS IVA21, 
                                              (CASE WHEN ti.IdtipoIVa = 2 THEN round(SUM(totalgravado - totalgravado / (1 + (ti.PorcentajeIVA / 100))), 2) ELSE 0 END) AS IVA105, ti.IdTipoIva
                       FROM          (SELECT    FVD.IdFacturaVentaDetalle, FV.IdFacturaVenta, fvd.IdTipoIva, (CASE WHEN fvd.IdTipoIva = 3 THEN (SUM(fvd.TotalArt) - (fvd.totalart * (fv.descuento / 100))) ELSE SUM(0) END) AS totalnogravado, 
                                                                      (CASE WHEN fvd.IdTipoIva <> 3 THEN (SUM(fvd.TotalArt) - (fvd.totalart * (fv.descuento / 100))) ELSE SUM(0) END) AS totalgravado
                                               FROM          dbo.FacturasVenta AS FV INNER JOIN
                                                                      dbo.FacturasVentaDetalle AS fvd ON fvd.IdFacturaVenta = FV.IdFacturaVenta
                                               WHERE      (FV.IdTipoFactura = 2)
                                               GROUP BY FVD.IdFacturaVentaDetalle, FV.IdFacturaVenta, fvd.IdTipoIva, fv.Descuento, fvd.totalart) AS aux INNER JOIN
                                              dbo.TiposIva AS ti ON ti.IdTipoIva = aux.IdTipoIva
                       GROUP BY aux.IdFacturaVenta, ti.IdTipoIva, ti.PorcentajeIVA) AS aux2 INNER JOIN
                      dbo.FacturasVenta AS fv ON fv.IdFacturaVenta = aux2.IdFacturaVenta
GROUP BY fv.IdFacturaVenta, fv.Total








GO
/****** Object:  View [dbo].[VistaUnificacionLiquidacionesSinComisionar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE View [dbo].[VistaUnificacionLiquidacionesSinComisionar] as


Select vfv.IdFacturaVenta, V.ApellidoyNombre as Vendedor, VDF.NroFactura, C.ApellidoyNombre as Cliente, VDF.FechaEmision as FechaFactura, 
Round(SUM((vFV.MontoComision) * (ISNULL(CF.MontoCancelacion, FV.Total) / FV.Total)), 2) as TotalComision, vfv.NroVendedor as NroVendedor, FV.IdTipoFactura, 
ISNULL(R.FechaEmision, FV.FechaEmision) as Fecha, CF.IdRecibo, null as IdMovCaja 
from VistaDetalleFacturasSinComisionar VDF INNER JOIN
VendedoresFacturasVenta VFV on VFV.IdFacturaVenta = VDF.IdFacturaVenta and  vdf.NroVendedor = vfv.NroVendedor inner join
Vendedores V on V.NroVendedor = VDF.NroVendedor LEFT JOIN 
CancelacionFacturas CF on CF.IdFacturaVenta = VDF.IdFacturaVenta LEFT JOIN
FacturasVenta FV on FV.IdFacturaVenta = VDF.IdFacturaVenta INNER JOIN
Clientes C on C.NroCliente = FV.NroCliente LEFT JOIN
VistaTotalesDiscriminadosFactB VTDB on FV.IdFacturaVenta = VTDB.IdFacturaVenta INNER JOIN
Recibos R on R.IdRecibo = CF.IdRecibo left join
VistaTotalesComisionesFacturas vtcf on vtcf.IdFacturaVenta = FV.IdFacturaVenta
group by vfv.IdFacturaVenta, VFV.NroVendedor, VDF.NroFactura,  V.ApellidoyNombre, VDF.FechaEmision, C.ApellidoyNombre, 
FV.IdTipoFactura,VTDB.TotalGravado, CF.IdRecibo, CF.MontoCancelacion, R.FechaEmision, vtcf.TotalComisionado, FV.FechaEmision
having Round(SUM((vFV.MontoComision) * (ISNULL(CF.MontoCancelacion, FV.Total) / FV.Total)), 2) > 0 and CF.IdRecibo is not null and
cf.IdRecibo not in (select lf.IdRecibo
from LiquidacionesFacturas lf
where lf.IdRecibo is not null)

union

Select vfv.IdFacturaVenta, V.ApellidoyNombre as Vendedor, VDF.NroFactura, C.ApellidoyNombre as Cliente, VDF.FechaEmision as FechaFactura, 
Round(SUM((vFV.MontoComision) * (ISNULL(CM.Monto, FV.Total) / FV.Total)), 2) as TotalComision, vfv.NroVendedor as NroVendedor, FV.IdTipoFactura, 
CM.FechaMov as Fecha, null as IdRecibo, CM.IdMovimientoCaja as IdMovCaja 
from VistaDetalleFacturasSinComisionar VDF INNER JOIN
CajasMovimientos CM on CM.IdFacturaVenta = VDF.IdFacturaVenta inner join
VendedoresFacturasVenta VFV on VFV.IdFacturaVenta = VDF.IdFacturaVenta and  vdf.NroVendedor = vfv.NroVendedor inner join
Vendedores V on V.NroVendedor = VDF.NroVendedor LEFT JOIN
FacturasVenta FV on FV.IdFacturaVenta = VDF.IdFacturaVenta INNER JOIN
Clientes C on C.NroCliente = FV.NroCliente LEFT JOIN
VistaTotalesDiscriminadosFactB VTDB on FV.IdFacturaVenta = VTDB.IdFacturaVenta LEFT JOIN
VistaTotalesComisionesFacturas vtcf on vtcf.IdFacturaVenta = FV.IdFacturaVenta
group by vfv.IdFacturaVenta, VFV.NroVendedor, VDF.NroFactura,  V.ApellidoyNombre, VDF.FechaEmision, C.ApellidoyNombre, 
FV.IdTipoFactura,VTDB.TotalGravado, CM.IdMovimientoCaja, CM.Monto, CM.FechaMov, vtcf.TotalComisionado, FV.FechaEmision
having Round(SUM((vFV.MontoComision) * (ISNULL(CM.Monto, FV.Total) / FV.Total)), 2) > 0 and CM.IdMovimientoCaja is not null and
CM.IdMovimientoCaja not in (select lf.IdMovCaja
from LiquidacionesFacturas lf
where lf.IdMovCaja is not null)





GO
/****** Object:  View [dbo].[VistaLibroIvaVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaLibroIvaVenta] as
SELECT     TOP (100) PERCENT CASE FV.IdTipoDocumento WHEN 1 THEN 'TF' ELSE 'NC' END AS TipoDoc, 
                      CASE FV.IdTipoFactura WHEN 1 THEN 'A' WHEN 2 THEN 'B' WHEN 3 THEN 'C' END AS LetraFact, FV.IdFacturaVenta, FV.BVFact + '-' + FV.NCompFact AS NroFactura, Convert(nvarchar, FV.FechaEmision, 103) as FechaEmision, 
                      C.ApellidoyNombre, 
                      CASE RI.Descripcion WHEN 'Responsable Inscripto' THEN 'RI' WHEN 'Responsable No Inscripto' THEN 'RNI' WHEN 'Responsable Exento' THEN 'Exento' WHEN 'Consumidor Final'
                       THEN 'CF' WHEN 'Monotributista' THEN 'Mono' WHEN 'No Categorizado' THEN 'NC' END AS Descripcion, ISNULL(C.TipoDocumento, 'CUIT') AS TipoDocumento, 
                      ISNULL(CONVERT(nvarchar(15), C.NroDocumento), C.Cuit0 + '-' + C.Cuit1 + '-' + C.Cuit2) AS NroDocumento, 
                      CASE WHEN FV.IdTipoFactura = 1 THEN (CASE WHEN fv.IdTipoDocumento = 2 THEN - (Fv.TotalDescuento21 + FV.TotalDescuento105) ELSE FV.TotalDescuento21 + FV.TotalDescuento105 END) 
                      ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN - vtd.TotalGravado else vtd.TotalGravado END) END AS NetoGravado, 
                      CASE WHEN FV.IdTipoFactura = 1 THEN (CASE WHEN fv.IdTipoDocumento = 2 THEN  -(FV.SubTotal - FV.TotalDescuento - (Fv.TotalDescuento21 + FV.TotalDescuento105)) 
                      ELSE (FV.SubTotal - FV.TotalDescuento - (FV.TotalDescuento21 + FV.TotalDescuento105)) END) ELSE 
                      (CASE WHEN fv.IdTipoDocumento = 1 THEN vtd.TotalNoGravado ELSE - vtd.TotalNoGravado END) END AS NoGravado, 
                      CASE WHEN FV.IdTipoFactura = 1 THEN (CASE FV.IdTipoDocumento WHEN 2 THEN - FV.totaliva105 ELSE FV.totaliva105 END) ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN -vtd.Iva105 ELSE vtd.Iva105 END) END AS Iva105, 
                      CASE WHEN FV.IdTipoFactura = 1 THEN (CASE FV.IdTipoDocumento WHEN 2 THEN - FV.totaliva21 ELSE FV.totaliva21 END) ELSE (CASE WHEN FV.IdTipoDocumento = 2 THEN -vtd.iva21 ELSE vtd.IVA21 END) END AS Iva21, 
                      CASE FV.IdTipoDocumento WHEN 2 THEN - FV.Total ELSE FV.Total END AS MontoTotal, FV.IdEmpresa, ri.IdRegimenImpositivo, fv.Impresa, fv.Observaciones
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.Clientes AS C ON C.NroCliente = FV.NroCliente LEFT OUTER JOIN
                      dbo.VistaTotalesDiscriminadosFactB AS vtd ON vtd.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN
                      dbo.RegimenesImpositivos AS RI ON C.IdRegimenImpositivo = RI.IdRegimenImpositivo
WHERE     (FV.FechaAnulacion IS NULL) 
GROUP BY FV.IdFacturaVenta, FV.BVFact, FV.NCompFact, FV.FechaEmision, C.ApellidoyNombre, C.TipoDocumento, C.NroDocumento, FV.SubTotal, FV.Total, FV.TotalIva105, 
                      FV.TotalIva21, FV.IdTipoDocumento, FV.IdEmpresa, FV.Total, C.Cuit0, C.Cuit1, C.Cuit2, FV.Subtotal105, FV.Subtotal21, FV.IdTipoFactura, vtd.TotalGravado, 
                      vtd.TotalNOGravado, vtd.IVA105, vtd.IVA21, RI.Descripcion, FV.TotalDescuento105, FV.TotalDescuento21, FV.TotalDescuento, FV.Impresa, RI.IdRegimenImpositivo, fv.Observaciones
ORDER BY FV.FechaEmision







GO
/****** Object:  View [dbo].[VistaTotalFPagosCaja]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaTotalFPagosCaja]
AS
SELECT     (CASE WHEN cm.IdTipoMovCaja = 1 THEN cmd.Monto ELSE - (cmd.Monto) END) AS Total, dbo.TiposPagos.Descripcion AS FPago, cm.IdAperturaCaja, 
                      cm.DescripcionMov, ISNULL(dbo.FacturasVenta.BVFact + '-' + dbo.FacturasVenta.NCompFact, '') AS NroFact, cm.IdTipoMovCaja, cm.FechaBaja
FROM         dbo.CajasMovimientosDetalle AS cmd INNER JOIN
                      dbo.CajasMovimientos AS cm ON cmd.IdMovimientoCaja = cm.IdMovimientoCaja INNER JOIN
                      dbo.TiposPagos ON cmd.IdTipoPago = dbo.TiposPagos.IdTipoPago LEFT OUTER JOIN
                      dbo.FacturasVenta ON cm.IdFacturaVenta = dbo.FacturasVenta.IdFacturaVenta








GO
/****** Object:  View [dbo].[VistaDetalleMovimientosCajaySencillo]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaDetalleMovimientosCajaySencillo]
AS
SELECT     C.IdCaja, CA.IdAperturaCaja, C.Descripcion AS Caja, CA.FechaApertura, ISNULL(dinero.TotalDinero, 0) AS Dinero, ISNULL(cheque.TotalCheque, 0) AS Cheque, 
                      ISNULL(TC.TotalTC, 0) AS TarjetaCredito, ISNULL(TD.TotalTD, 0) AS TarjetaDebito, ISNULL(TB.TotalTB, 0) AS TransferenciaBancaria, ISNULL(TDC.TotalDC, 0) 
                      AS DescuentoCtaCte, ISNULL(aux.MontoGastos, 0) AS Gastos, ISNULL(aux2.MontoIngresos, 0) AS Ingresos, CAD.SencilloCierre100pesos, CAD.SencilloCierre10ctvos, 
                      CAD.SencilloCierre10pesos, CAD.SencilloCierre1peso, CAD.SencilloCierre20pesos, CAD.SencilloCierre25ctvos, CAD.SencilloCierre2pesos, CAD.SencilloCierre50ctvos, 
                      CAD.SencilloCierre50pesos, CAD.SencilloCierre5ctvos, CAD.SencilloCierre5pesos, CAD.SencilloInicio100pesos, CAD.SencilloInicio10ctvos, 
                      CAD.SencilloInicio10pesos, CAD.SencilloInicio1peso, CAD.SencilloInicio20pesos, CAD.SencilloInicio25ctvos, CAD.SencilloInicio2pesos, CAD.SencilloInicio50ctvos, 
                      CAD.SencilloInicio50pesos, CAD.SencilloInicio5ctvos, CAD.SencilloInicio5pesos
FROM         dbo.Cajas AS C INNER JOIN
                      dbo.CajasAperturas AS CA ON CA.IdCaja = C.IdCaja INNER JOIN
                      dbo.CajasAperturasDetalle AS CAD ON CAD.IdApertura = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalDinero, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Dinero')
                            GROUP BY IdAperturaCaja) AS dinero ON dinero.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalCheque, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Cheque')
                            GROUP BY IdAperturaCaja) AS cheque ON cheque.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalTC, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Tarjeta de Crédito')
                            GROUP BY IdAperturaCaja) AS TC ON TC.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalTD, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Tarjeta de Débito')
                            GROUP BY IdAperturaCaja) AS TD ON TD.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalTB, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Transferencia Bancaria')
                            GROUP BY IdAperturaCaja) AS TB ON TB.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Total) AS TotalDC, IdAperturaCaja
                            FROM          dbo.VistaTotalFPagosCaja AS FP
                            WHERE      (FPago = 'Descuento de Cta.Cte')
                            GROUP BY IdAperturaCaja) AS TDC ON TDC.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Monto) AS MontoGastos, IdAperturaCaja
                            FROM          dbo.CajasMovimientos AS CAE
                            WHERE      (IdTipoMovCaja = 2)
                            GROUP BY IdAperturaCaja) AS aux ON aux.IdAperturaCaja = CA.IdAperturaCaja LEFT OUTER JOIN
                          (SELECT     SUM(Monto) AS MontoIngresos, IdAperturaCaja
                            FROM          dbo.CajasMovimientos AS CAI
                            WHERE      (IdTipoMovCaja = 1)
                            GROUP BY IdAperturaCaja) AS aux2 ON aux2.IdAperturaCaja = CA.IdAperturaCaja








GO
/****** Object:  View [dbo].[VistaMovStock]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VistaMovStock]
AS
SELECT     TOP (100) PERCENT Movimiento, CONVERT(Nvarchar, Fecha, 103) AS Fecha, Ingreso, Egreso, IdArticulo, ID, Fecha as FechaConMinutos
FROM         (SELECT     fv.IdFacturaVenta AS ID, fvd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fv.NCompFact, '') 
                                              = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) ELSE 'Nro.Comprobante ' + fv.BVFact + '-' + fv.NCompFact END) AS Movimiento, 
                                              fv.FechaEmision AS Fecha, 0 AS Ingreso, fvd.Cantidad AS Egreso
                       FROM          dbo.FacturasVenta AS fv INNER JOIN
                                              dbo.FacturasVentaDetalle AS fvd ON fv.IdFacturaVenta = fvd.IdFacturaVenta AND fvd.DesdeRemito = 0 AND fvd.IdArticulo IS NOT NULL INNER JOIN
                                              dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fv.IdTipoDocumento INNER JOIN
                                              dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fv.IdTipoFactura
                       WHERE      (fv.IdTipoDocumento = 1 OR fv.IdTipoDocumento = 8) AND (fv.FechaAnulacion IS NULL) AND fvd.MueveStock = 1 AND fv.IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       UNION
                       SELECT     R.IdRemito AS ID, RD.IdArticulo, 'Remito vta. Nro. ' + R.NroRemito AS Movimiento, R.FechaRemito AS Fecha, 0 AS Ingreso, RD.Cantidad AS Egreso
                       FROM         dbo.Remitos AS R INNER JOIN
                                             dbo.RemitosDetalle AS RD ON RD.IdRemito = R.IdRemito
						WHERE	RD.MueveStock = 1 and R.FechaAnulacion is null
                       UNION
                       SELECT     fv.IdFacturaVenta AS ID, fvd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fv.NCompFact, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) ELSE 'Nro.Comprobante ' + fv.BVFact + '-' + fv.NCompFact END) AS Movimiento, 
                                             fv.FechaEmision AS Fecha, fvd.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.FacturasVenta AS fv INNER JOIN
                                             dbo.FacturasVentaDetalle AS fvd ON fv.IdFacturaVenta = fvd.IdFacturaVenta AND fvd.IdArticulo IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fv.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fv.IdTipoFactura
                       WHERE     (fv.IdTipoDocumento = 2) AND (fv.FechaAnulacion IS NULL) AND fvd.MueveStock = 1
                       UNION
                       SELECT     RC.IdRemitoCompra AS ID, RDC.IdArticulo, 'Remito cpra. Nro. ' + RC.BVRemCompra + '-' + RC.NroCompRemCompra AS Movimiento, 
                                             RC.FechaRemitoCompra AS Fecha, RDC.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.RemitosCompra AS RC INNER JOIN
                                             dbo.RemitosDetalleCompra AS RDC ON RDC.IdRemitoCompra = RC.IdRemitoCompra
                       WHERE		RDC.MueveStock = 1
					   UNION
                       SELECT     fC.IdFacturaCompra AS ID, fcd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(fC.NCompFactCompra, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fc.IdFacturaCompra) ELSE 'Nro.Comprobante ' + fc.BVFactCompra + '-' + fc.NCompFactCompra END) 
                                             AS Movimiento, fC.FechaEmision AS Fecha, fcd.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.FacturasCompra AS fC INNER JOIN
                                             dbo.FacturasCompraDetalle AS fcd ON fC.IdFacturaCompra = fcd.IdFacturaCompra AND fcd.DesdeRemito = 0 AND fcd.IdArticulo IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fC.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fC.IdTipoFactura
                       WHERE     (fC.IdTipoDocumento = 4) AND (fC.FechaAnulacion IS NULL) AND fcd.MueveStock = 1
                       UNION
                       SELECT     fc.IdFacturaCompra AS ID, fcd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fc.NCompFactCompra, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fc.IdFacturaCompra) ELSE 'Nro.Comprobante ' + fc.BVFactCompra + '-' + fc.NCompFactCompra END) 
                                             AS Movimiento, fc.FechaEmision AS Fecha, 0 AS Ingreso, fcd.Cantidad AS Egreso
                       FROM         dbo.FacturasCompra AS fc INNER JOIN
                                             dbo.FacturasCompraDetalle AS fcd ON fc.IdFacturaCompra = fcd.IdFacturaCompra AND fcd.IdArticulo IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fc.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fc.IdTipoFactura
                       WHERE     (fc.IdTipoDocumento = 7) AND (fc.FechaAnulacion IS NULL) AND fcd.MueveStock = 1
					   

                       UNION
                       SELECT     IdAjuste AS ID, IdArticulo, 'Ajuste de Stock, motivo: ' + ISNULL(Motivo, 'No se cargó motivo.') AS Movimiento, FechaAjuste AS Fecha, 
                                             (CASE WHEN Aj.Cantidad > 0 THEN Aj.Cantidad ELSE 0 END) AS Ingreso, (CASE WHEN Aj.Cantidad < 0 THEN - Aj.Cantidad ELSE 0 END) AS Egreso
                       FROM         dbo.AjustesStock AS Aj) AS Aux
ORDER BY FechaConMinutos

GO
/****** Object:  View [dbo].[CalculoStockInicial]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CalculoStockInicial]
AS
SELECT     A.IdArticulo, A.StockActual, ISNULL(SUM(Aux.Ingreso), 0) AS Restar, ISNULL(SUM(Aux.Egreso), 0) AS sumar, ISNULL(A.StockActual + SUM(Aux.Egreso) 
                      - SUM(Aux.Ingreso), A.StockActual) AS StockInicial, CONVERT(Nvarchar, A.FechaAcceso, 103) AS Fecha
FROM         dbo.Articulos AS A LEFT OUTER JOIN
                      dbo.VistaMovStock AS Aux ON Aux.IdArticulo = A.IdArticulo
GROUP BY A.IdArticulo, A.StockActual, A.FechaAcceso








GO
/****** Object:  View [dbo].[VistaTotalesDiscriminadosFactBCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VistaTotalesDiscriminadosFactBCompra]
AS
SELECT     fv.IdFacturaCompra, case IdTipoDocumento when 2 then - SUM(aux2.TotalGravado) else SUM(aux2.TotalGravado) end AS TotalGravado, case IdTipoDocumento when 2 then - SUM(aux2.TotalNOGravado) else SUM(aux2.TotalNOGravado) end AS TotalNOGravado, 
			case idtipodocumento when 2 then - SUM(aux2.IVA21) else SUM(aux2.IVA21) end AS IVA21, 
			case idtipodocumento when 2 then - SUM(aux2.IVA27) else SUM(aux2.IVA27) end AS IVA27 ,
			case IdTipoDocumento when 2 then - SUM(aux2.IVA105) else SUM(aux2.IVA105) end AS IVA105,
			 fv.TotalPerIIBB, fv.TotalPerIVA ,fv.Total
FROM         (SELECT     aux.IdFacturaCompra, ROUND(SUM(aux.totalgravado / (1 + ti.PorcentajeIVA / 100)), 2) AS TotalGravado, SUM(aux.totalnogravado) AS TotalNOGravado, 
                                              (CASE WHEN ti.IdtipoIVa = 1 THEN  round(SUM(totalgravado - totalgravado / (1 + (ti.PorcentajeIVA / 100))), 2) ELSE 0 END) AS IVA21, 
                                              (CASE WHEN ti.IdtipoIVa = 2 THEN  round(SUM(totalgravado - totalgravado / (1 + (ti.PorcentajeIVA / 100))), 2) ELSE 0 END) AS IVA105, 
											  (CASE WHEN ti.IdtipoIVa = 4 THEN  round(SUM(totalgravado - totalgravado / (1 + (ti.PorcentajeIVA / 100))), 2) ELSE 0 END) AS IVA27,
											  ti.IdTipoIva
                       FROM          (SELECT     FV.IdFacturaCompra, fvd.IdTipoIva, (CASE WHEN fvd.IdTipoIva = 3 THEN (SUM(fvd.TotalArt)) ELSE SUM(0) END) AS totalnogravado, 
                                                                      (CASE WHEN fvd.IdTipoIva <> 3 THEN (SUM(fvd.TotalArt)) ELSE SUM(0) END) + fv.conceptosnogravados AS totalgravado
                                               FROM          dbo.FacturasCompra AS FV INNER JOIN
                                                                      dbo.FacturasCompraDetalle AS fvd ON fvd.IdFacturaCompra = FV.IdFacturaCompra
                                               WHERE      (FV.IdTipoFactura <> 1)
                                               GROUP BY FV.IdFacturaCompra, fvd.IdTipoIva, fv.conceptosnogravados) AS aux INNER JOIN
                                              dbo.TiposIva AS ti ON ti.IdTipoIva = aux.IdTipoIva
                       GROUP BY aux.IdFacturaCompra, ti.IdTipoIva, ti.PorcentajeIVA) AS aux2 INNER JOIN
                      dbo.FacturasCompra AS fv ON fv.IdFacturaCompra = aux2.IdFacturaCompra
GROUP BY fv.IdFacturaCompra, fv.Total, fv.IdTipoDocumento, fv.TotalPerIIBB, fv.TotalPerIVA
















GO
/****** Object:  View [dbo].[VistaLibroIvaCompras]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaLibroIvaCompras]
AS

SELECT TOP (100) PERCENT
	   CASE FC.IdTipoDocumento WHEN 4 THEN 'FACT'
							   ELSE 'NC'
	   END AS TipoDoc,
	   CASE FC.IdTipoFactura WHEN 1 THEN 'A' WHEN 2 THEN 'B'
							 WHEN 3 THEN 'C'
	   END AS LetraFact,
	   FC.IdFacturaCompra,
	   FC.BVFactCompra + '-' + FC.NCompFactCompra AS NroFactura,
	   FC.FechaEmision,
	   P.ApellidoyNombre,
	   ISNULL(P.TipoDocumento, 'CUIT') AS TipoDocumento,
	   ISNULL(CONVERT(NVARCHAR(15), P.NroDocumento), P.NroDocumento) AS NroDocumento,
       CASE WHEN FC.IdTipoFactura = 1 THEN (CASE WHEN FC.IdTipoDocumento = 7 THEN - (FC.Subtotal105 + FC.Subtotal21)
												 ELSE FC.Subtotal105 + FC.Subtotal21
										    END)
			ELSE (CASE WHEN FC.IdTipoDocumento = 7  THEN -VTD.TotalGravado
					   ELSE VTD.TotalGravado
				  END)
	   END AS NetoGravado,
	   CASE WHEN FC.IdTipoFactura = 1 THEN (CASE WHEN FC.IdTipoDocumento = 7 THEN - (FC.SubTotal - FC.ConceptosNoGravados - (FC.Subtotal105 + FC.Subtotal21))
												 ELSE (FC.SubTotal +  FC.ConceptosNoGravados - (FC.Subtotal105 + FC.Subtotal21))
										    END)
			ELSE (CASE WHEN FC.IdTipoDocumento = 7 THEN - VTD.TotalNoGravado
					   ELSE VTD.TotalNOGravado
				  END)
	   END AS NoGravado,
	   CASE WHEN FC.IdTipoFactura = 3 THEN FC.Total   
			ELSE 0   
	   END AS Exento, 
	   CASE WHEN FC.IdTipoFactura = 1 THEN (CASE FC.IdTipoDocumento WHEN 7 THEN - FC.totaliva105
																	ELSE FC.totaliva105
											END)
		    ELSE (CASE WHEN FC.IdTipoDocumento = 7 THEN -VTD.Iva105
					   ELSE VTD.IVA105
				  END)
	   END AS Iva105,
	   CASE WHEN FC.IdTipoFactura = 1 THEN (CASE FC.IdTipoDocumento WHEN 7 THEN - FC.totaliva21
																	ELSE FC.totaliva21
											END)
			ELSE (CASE WHEN FC.IdTipoDocumento = 7 THEN -VTD.iva21
					   ELSE VTD.IVA21
				  END)
	   END AS Iva21,
	   CASE WHEN FC.IdTipoFactura = 1 THEN (CASE FC.IdTipoDocumento WHEN 7 THEN - FC.totaliva27
																	ELSE FC.totaliva27
											END)
			ELSE (CASE WHEN FC.IdTipoDocumento = 7 THEN -VTD.iva27
					   ELSE VTD.IVA27
				  END)
	   END AS Iva27,
       CASE WHEN FC.IdTipoDocumento = 7 THEN - FC.TotalPerIIBB 
			ELSE FC.TotalPerIIBB
	   END AS TotalPerIIBB,
       CASE WHEN FC.IdTipoDocumento = 7 THEN - FC.TotalPerIVA
			ELSE FC.TotalPerIVA
	   END AS TotalPerIVA,
	   CASE FC.IdTipoDocumento WHEN 7 THEN - FC.Total
							   ELSE FC.Total
	   END AS MontoTotal,
	   FC.IdEmpresa,
	   FC.AñoCorrespondiente,
	   FC.MesCorrespondiente,
	   FC.NroProveedor
FROM FacturasCompra AS FC INNER JOIN Proveedores AS P ON P.NroProveedor = FC.NroProveedor
						  LEFT OUTER JOIN VistaTotalesDiscriminadosFactBCompra AS VTD ON VTD.IdFacturaCompra = FC.IdFacturaCompra
WHERE FC.FechaAnulacion IS NULL
GROUP BY FC.IdFacturaCompra,
		 FC.BVFactCompra,
		 FC.NCompFactCompra,
		 FC.FechaEmision,
		 P.ApellidoyNombre,
		 P.TipoDocumento,
		 P.NroDocumento,
		 FC.SubTotal,
		 FC.Total,
		 FC.TotalIva105,
		 FC.TotalIva21,
		 FC.IdTipoDocumento,
		 FC.IdEmpresa,
		 FC.Total,
		 P.NroDocumento,
		 FC.Subtotal105,
		 FC.Subtotal21,
		 FC.IdTipoFactura,
		 VTD.TotalGravado,
		 VTD.TotalNOGravado,
		 VTD.IVA105,
		 VTD.IVA21,
		 FC.TotalPerIIBB,
		 FC.TotalPerIVA,
		 FC.ConceptosNoGravados,
		 FC.AñoCorrespondiente,
		 FC.MesCorrespondiente,
		 FC.totaliva27,
		 VTD.IVA27,
		 FC.NroProveedor
ORDER BY FC.IdTipoFactura,
		 FC.FechaEmision

GO
/****** Object:  View [dbo].[VistaRegimenesImpositivosCompras]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaRegimenesImpositivosCompras] as
Select R.IdRegimenImpositivo, R.Descripcion as RegimenImpositivo, Right('0' + Convert(nvarchar(2),MONTH(L.FechaEmision)), 2)  + '/' + Convert(nvarchar(4),YEAR(L.FechaEmision)) as Fecha, SUM(L.NoGravado) as NoGravado, SUM(L.NetoGravado) as NetoGravado,
SUM(L.Iva105) as Iva105, SUM(L.Iva21) as Iva21, SUM(L.MontoTotal) as Total
From VistaLibroIvaCompras L INNER JOIN 
FacturasCompra FC on L.IdFacturaCompra = FC.IdFacturaCompra INNER JOIN
Proveedores P on P.NroProveedor = FC.NroProveedor INNER JOIN
RegimenesImpositivos R on R.IdRegimenImpositivo = P.IdRegimenImpositivo
Group by R.IdRegimenImpositivo, R.Descripcion, MONTH(L.FechaEmision), YEAR(L.FechaEmision)













GO
/****** Object:  View [dbo].[VistaRegimenesImpositivos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VistaRegimenesImpositivos] as
Select R.IdRegimenImpositivo, R.Descripcion as RegimenImpositivo, Right('0' + Convert(nvarchar(2),MONTH(fc.FechaEmision)), 2)  + '/' + Convert(nvarchar(4),YEAR(fc.FechaEmision)) as Fecha, 
SUM(L.NoGravado) as NoGravado, SUM(L.NetoGravado) as NetoGravado, SUM(L.Iva105) as Iva105, SUM(L.Iva21) as Iva21, SUM(L.MontoTotal) as Total
From VistaLibroIvaVenta L INNER JOIN 
FacturasVenta FC on L.IdFacturaVenta = FC.IdFacturaVenta INNER JOIN
Clientes C on C.NroCliente = FC.NroCliente INNER JOIN
RegimenesImpositivos R on R.IdRegimenImpositivo = C.IdRegimenImpositivo
where l.Impresa = 1
Group by R.IdRegimenImpositivo, R.Descripcion, MONTH(fc.FechaEmision), YEAR(fc.FechaEmision)

















GO
/****** Object:  View [dbo].[VistaMovimientosDepositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaMovimientosDepositos] as
select MD.IdArticulo, D.IdDeposito, MD.Cantidad, TMD.Descripcion as TipoMovimiento, A.DescCorta, TMD.IdTipoMovDeposito, 
D.Descripcion as Deposito, DS.Descripcion as DepositoSecundario, MD.FechaMovimiento, MD.IdDepositoSecundario
from Depositos D INNER JOIN
MovimientosDepositos MD on D.IdDeposito = MD.IdDeposito LEFT JOIN 
Depositos DS on DS.IdDeposito = MD.IdDepositoSecundario inner join
TiposMovimientosDepositos TMD on TMD.IdTipoMovDeposito = MD.IdTipoMovDeposito INNER JOIN
Articulos A on MD.IdArticulo = A.IdArticulo






GO
/****** Object:  View [dbo].[VistaDetalleMovimientosDepositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VistaDetalleMovimientosDepositos] as

select top 100 percent aux.FechaMovimiento, aux.Deposito, aux.IdDeposito, aux.TipoMovimiento, aux.IdTipoMovDeposito, aux.Ingreso,
aux.Egreso, aux.DepositoSecundario, aux.IdDepositoSecundario, aux.IdArticulo, aux.DescCorta
from (
select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, VMD.Cantidad as Ingreso, 0 as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario, 
isnull(VMD.IdDepositoSecundario,0) as IdDepositoSecundario,VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join
Articulos A on A.IdArticulo = VMD.IdArticulo
where VMD.IdTipoMovDeposito = 1 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, 0 as Ingreso, VMD.Cantidad as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario,
isnull(VMD.IdDepositoSecundario,0) as IdDepositoSecundario, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join
Articulos A on A.IdArticulo = VMD.IdArticulo 
where VMD.IdTipoMovDeposito = 2 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, 0 as Ingreso, VMD.Cantidad as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario, 
VMD.IdDepositoSecundario, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join 
Articulos A on A.IdArticulo = vmd.IdArticulo
where VMD.IdTipoMovDeposito = 3 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.DepositoSecundario, VMD.IdDepositoSecundario, 'Traslado de Deposito: ' + vmd.Deposito as TipoMov, VMD.IdTipoMovDeposito, VMD.Cantidad as Ingreso, 0 as Egreso, 
'-' as DepositoSecundario, VMD.IdDeposito, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join 
Articulos A on A.IdArticulo = VMD.IdArticulo
where VMD.IdTipoMovDeposito = 3 and A.LlevarStock = 1

union 

Select VMS.FechaConMinutos, D.Descripcion as Deposito, 1, VMS.Movimiento,
Case when  vms.Ingreso > 0 THEN 1 when VMS.Egreso > 0 then 2 end as IdTipoMovimiento,
VMS.Ingreso as Ingreso, VMS.Egreso as Egreso, null as DepositoSecundario, null as IdDepositoSecundario, VMS.IdArticulo, A.DescCorta
from VistaMovStock VMS inner join
Depositos D on D.IdDeposito = 1 INNER JOIN 
Articulos A on A.IdArticulo = VMS.IdArticulo
where A.LlevarStock = 1) as aux
order by aux.FechaMovimiento 






GO
/****** Object:  View [dbo].[VistaArticulos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VistaArticulos]
AS
SELECT     dbo.Articulos.IdArticulo, dbo.Articulos.DescCorta, dbo.Articulos.DescLarga, (CASE dbo.Articulos.LlevarStock WHEN 1 THEN 'SI' ELSE 'NO' END) AS LlevarStock, 
                      CONVERT(Nvarchar, dbo.Articulos.StockActual) + ' - ' + (CASE dbo.Articulos.LlevarStock WHEN 1 THEN 'S' ELSE 'N' END) AS Stock, dbo.Articulos.UltimaActStock, 
                      dbo.Articulos.CantidadMinima, ISNULL(CONVERT(Nvarchar, dbo.Articulos.FechaBaja, 103), '') AS FechaBaja, dbo.Rubros.Descripcion AS Rubro, 
                      dbo.SubRubros.Descripcion AS SubRubro, dbo.UnidadesMedida.Descripcion AS UnidadMedida, dbo.Articulos.UsrBaja, dbo.Articulos.StockActual, 
                      dbo.Articulos.CodigoBarra, aux.Maxfecha, dbo.Articulos.FechaAcceso AS FechaCarga, Articulos.IdRubro, Articulos.IdSubRubro, Articulos.CodigoProducto
FROM         dbo.Articulos INNER JOIN
                      dbo.Rubros ON dbo.Articulos.IdRubro = dbo.Rubros.IdRubro INNER JOIN
                      dbo.SubRubros ON dbo.Articulos.IdSubRubro = dbo.SubRubros.IdSubRubro INNER JOIN
                      dbo.UnidadesMedida ON dbo.Articulos.IdUnidadMedida = dbo.UnidadesMedida.IdUnidadMedida LEFT OUTER JOIN
                          (SELECT     IdArticulo, MAX(FechaPrecios) AS Maxfecha
                            FROM          dbo.PreciosVenta AS PrV
                            GROUP BY IdArticulo) AS aux ON dbo.Articulos.IdArticulo = aux.IdArticulo











GO
/****** Object:  View [dbo].[VistaTotalesStockArticulosDepositos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaTotalesStockArticulosDepositos] as
select va.IdArticulo, VDM.DescCorta, VDM.IdDeposito, VDM.Deposito, SUM(VDM.Ingreso) as TotalIngreso, SUM(VDM.Egreso) as TotalEgreso,
SUM(VDM.Ingreso) - SUM(VDM.Egreso) as Stock, va.Rubro, va.SubRubro, va.IdRubro, va.IdSubRubro
from VistaDetalleMovimientosDepositos VDM join VistaArticulos va 
on vdm.IdArticulo = va.IdArticulo
group by VDM.IdDeposito, VDM.Deposito, va.IdArticulo, VDM.DescCorta, va.Rubro, va.SubRubro, va.IdRubro, va.IdSubRubro

GO
/****** Object:  View [dbo].[VistaCabFactVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VistaCabFactVenta]
AS
SELECT					dbo.TiposDocFact.Descripcion AS TipoDoc, dbo.FacturasVenta.IdFacturaVenta, dbo.TiposFactura.Descripcion AS TipoFact, 
                      dbo.FacturasVenta.BVFact + ' - ' + dbo.FacturasVenta.NCompFact AS NroFact, dbo.FacturasVenta.FechaEmision, (CASE WHEN dbo.FacturasVenta.Impresa = 1 THEN 'SI' ELSE 'NO' END) AS Impresa, dbo.FacturasVenta.Observaciones, 
                      dbo.FacturasVenta.SubTotal, dbo.FacturasVenta.Descuento, dbo.FacturasVenta.TotalDescuento, dbo.Clientes.ApellidoyNombre AS Cliente, 
                      ISNULL((CASE WHEN FacturasVenta.IdTipoDocumento = 2 THEN - dbo.FacturasVenta.Total ELSE dbo.FacturasVenta.Total END), 0) AS Total, 
                      ISNULL(dbo.CondicionesPago.Descripcion, '') AS CondPago, dbo.FormasPago.Descripcion AS FPago, dbo.FacturasVenta.FechaVencimiento, 
                      ISNULL(CONVERT(nvarchar, dbo.FacturasVenta.FechaAnulacion, 103), '') AS FechaAnulacion, dbo.Clientes.NroCliente, dbo.FacturasVenta.BVFact, 
                      dbo.FacturasVenta.TotalIva105, dbo.FacturasVenta.TotalIva21, dbo.FacturasVenta.IdEmpresa, dbo.Empresa.RazonSocial, dbo.FacturasVenta.TotalSaldado, 
                      dbo.FacturasVenta.TotalInteres, dbo.FacturasVenta.TotalSaldadoInteres, 
                      dbo.FacturasVenta.BVReferencia + '-' + dbo.FacturasVenta.NroCompFactReferencia AS NroFactReferencia, dbo.FacturasVenta.IdConceptoFactura,dbo.FacturasVenta.FechaAlta,
					  dbo.FacturasVenta.Cobrador
FROM         dbo.FacturasVenta INNER JOIN
                      dbo.TiposDocFact ON dbo.FacturasVenta.IdTipoDocumento = dbo.TiposDocFact.IdTipoDocumento INNER JOIN
                      dbo.TiposFactura ON dbo.FacturasVenta.IdTipoFactura = dbo.TiposFactura.IdTipoFactura INNER JOIN
                      dbo.Clientes ON dbo.FacturasVenta.NroCliente = dbo.Clientes.NroCliente LEFT OUTER JOIN
                      dbo.CondicionesPago ON dbo.FacturasVenta.IdCondicionPago = dbo.CondicionesPago.IdCondicionPago INNER JOIN
                      dbo.FormasPago ON dbo.FacturasVenta.IdFormaPago = dbo.FormasPago.IdFormaPago INNER JOIN
                      dbo.Empresa ON dbo.FacturasVenta.IdEmpresa = dbo.Empresa.IdEmpresa
Where IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)

GO
/****** Object:  View [dbo].[VistaDetalleFactVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaDetalleFactVenta]
AS
SELECT     dbo.FacturasVentaDetalle.IdFacturaVentaDetalle, ISNULL(dbo.Articulos.DescCorta, dbo.FacturasVentaDetalle.Articulo) AS DescCorta, 
                      dbo.FacturasVentaDetalle.Cantidad, ISNULL(dbo.UnidadesMedida.Descripcion, dbo.FacturasVentaDetalle.UMedida) AS UMedida, 
                      dbo.FacturasVentaDetalle.PrecioUnitario, dbo.FacturasVentaDetalle.TotalArt, dbo.FacturasVentaDetalle.IdFacturaVenta, dbo.FacturasVentaDetalle.DesdeRemito, 
                      ISNULL(CONVERT(NVarchar, dbo.FacturasVentaDetalle.IdArticulo), '') AS IdArticulo, dbo.TiposIva.PorcentajeIVA
FROM         dbo.FacturasVentaDetalle INNER JOIN
                      dbo.TiposIva ON dbo.FacturasVentaDetalle.IdTipoIva = dbo.TiposIva.IdTipoIva LEFT OUTER JOIN
                      dbo.Articulos ON dbo.FacturasVentaDetalle.IdArticulo = dbo.Articulos.IdArticulo LEFT OUTER JOIN
                      dbo.UnidadesMedida ON dbo.Articulos.IdUnidadMedida = dbo.UnidadesMedida.IdUnidadMedida









GO
/****** Object:  View [dbo].[VistaConsultaDetalleFacturacion]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[VistaConsultaDetalleFacturacion] as
select top 100 percent aux.*
from(
select FV.IdFacturaVenta, FVD.IdFacturaVentaDetalle, FV.NroFact as NroFactura, FV.FechaEmision, 
FVD.DescCorta, 
CASE WHEN FV.TipoDoc = 'Factura de Venta' THEN (CASE WHEN FV.TipoFact = 'A' THEN FVD.PrecioUnitario else (FVD.PrecioUnitario / (1+(FVD.PorcentajeIVA / 100))) END) 
else (CASE WHEN FV.TipoFact = 'A' THEN -FVD.PrecioUnitario else -(FVD.PrecioUnitario / 1+(FVD.PorcentajeIVA / 100)) END) end as PrecioUnitario,
 FVD.Cantidad, FVD.PorcentajeIVA, 
 CASE WHEN FV.TipoDoc = 'Factura de Venta' THEN (CASE WHEN FV.TipoFact = 'A' THEN FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100)) ELSE FVD.TotalArt END) ELSE 
 (CASE WHEN FV.TipoFact = 'A' THEN -(FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100))) ELSE - FVD.TotalArt END) END AS TotalArt, 
 FV.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
from VistaDetalleFactVenta FVD inner join 
VistaCabFactVenta FV on fvd.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN 
Clientes C on C.NroCliente = FV.NroCliente) as aux
order by aux.FechaEmision








GO
/****** Object:  View [dbo].[VistaCabFactCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCabFactCompra]
AS

SELECT FC.IdFacturaCompra,
	   TF.Descripcion AS TipoFact,
	   FC.BVFactCompra + ' - ' + FC.NCompFactCompra AS NroFact,
	   CONVERT(NVARCHAR, FC.FechaEmision, 103) AS FechaEmision,
	   FC.FechaEmision AS Fecha,
	   FC.Observaciones,
	   FC.Subtotal,
	   P.ApellidoyNombre AS Proveedor,
	   FC.Total,
	   TDF.Descripcion AS TipoDoc,
	   ISNULL(CP.Descripcion, '') AS CondPago,
	   FP.Descripcion AS FPago,
	   FC.FechaVencimiento,
	   ISNULL(CONVERT(NVARCHAR, FC.FechaAnulacion,103), '') AS FechaAnulacion,
	   FC.NroProveedor,
	   FC.Bonificacion1,
	   FC.TotalBonificacion1,
	   FC.Bonificacion2,
	   FC.Bonificacion3,
	   FC.Bonificacion4,
	   FC.PorcentajePerIVA,
	   FC.PorcentajePerIIBB,
	   FC.TotalBonificacion2,
	   FC.TotalBonificacion3,
	   FC.TotalBonificacion4,
	   FC.TotalPerIVA,
	   FC.TotalPerIIBB,
	   FC.TotalIVA105,
	   FC.TotalIVA21,
	   FC.Subtotal105,
	   FC.Subtotal21,
	   FC.TotalDescuento105,
	   FC.TotalDescuento21,
	   FC.BVFactReferencia + '-' + FC.NCompFactReferencia AS NroFactReferencia,
	   FC.IdEmpresa,
	   E.RazonSocial,
	   FC.IdTipoDocumento,
	   FC.BVFactCompra,
	   FC.NCompFactCompra,
	   FC.UsrAcceso,
	   FC.AñoCorrespondiente,
	   FC.MesCorrespondiente,
	   FC.ConceptosNoGravados,
	   FC.SubTotal27,
	   FC.TotalDescuento27,
	   FC.TotalIVA27			
FROM FacturasCompra FC INNER JOIN TiposDocFact TDF ON FC.IdTipoDocumento = TDF.IdTipoDocumento
					   INNER JOIN TiposFactura TF ON FC.IdTipoFactura = TF.IdTipoFactura
					   LEFT OUTER JOIN CondicionesPago CP ON FC.IdCondicionPago = CP.IdCondicionPago
					   INNER JOIN FormasPago FP ON FC.IdFormaPago = FP.IdFormaPago
					   INNER JOIN Proveedores P ON FC.NroProveedor = P.NroProveedor
					   INNER JOIN Empresa E ON FC.IdEmpresa = E.IdEmpresa

GO
/****** Object:  View [dbo].[VistaDetalleFactCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaDetalleFactCompra]
AS

SELECT FCD.IdFacturaCompraDetalle,
	   FCD.IdFacturaCompra,
	   ISNULL(A.DescCorta, FCD.Articulo) AS DescCorta,
	   ISNULL(UM.Descripcion, FCD.UMedida) AS UMedida,
	   FCD.Cantidad,
	   FCD.PrecioUnitario,
	   FCD.TotalArt,
	   FCD.DesdeRemito,
	   A.IdArticulo,
	   TI.PorcentajeIVA,
	   FC.NroProveedor,
	   FC.FechaEmision,
	   FC.FechaAnulacion
FROM FacturasCompraDetalle FCD INNER JOIN TiposIva TI ON FCD.IdTipoIva = TI.IdTipoIva
						   LEFT OUTER JOIN Articulos A ON FCD.IdArticulo = A.IdArticulo
						   LEFT OUTER JOIN UnidadesMedida UM ON A.IdUnidadMedida = UM.IdUnidadMedida
						   INNER JOIN FacturasCompra FC ON FC.IdFacturaCompra = FCD.IdFacturaCompra

GO
/****** Object:  View [dbo].[VistaConsultaDetalleFacturacionCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[VistaConsultaDetalleFacturacionCompra] as 

Select top 100 percent aux.*
from
(select FV.IdFacturaCompra, FVD.IdFacturaCompraDetalle, FV.NroFact as NroFactura, FV.FechaEmision, FVD.DescCorta, 
CASE WHEN FV.TipoDoc = 'Factura de Compra' then (CASE WHEN FV.TipoFact = 'A' THEN FVD.PrecioUnitario ELSE (FVD.PrecioUnitario / (1+(FVD.PorcentajeIVA / 100))) END) 
ELSE (CASE WHEN FV.TipoFact = 'A' THEN -FVD.PrecioUnitario else -(FVD.PrecioUnitario / 1+(FVD.PorcentajeIVA / 100)) END) END AS PrecioUnitario, 
FVD.Cantidad, FVD.PorcentajeIVA, 
 CASE WHEN FV.TipoDoc = 'Factura de Compra' THEN (CASE WHEN FV.TipoFact = 'A' THEN FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100)) ELSE FVD.TotalArt END) ELSE 
 (CASE WHEN FV.TipoFact = 'A' THEN -(FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100))) ELSE - FVD.TotalArt END) END AS TotalArt, 
P.NroProveedor, P.ApellidoyNombre, FV.Fecha,
FV.IdEmpresa
from VistaDetalleFactCompra FVD inner join 
VistaCabFactCompra FV on fvd.IdFacturaCompra = FV.IdFacturaCompra INNER JOIN 
Proveedores P on FV.NroProveedor = P.NroProveedor) as aux
order by aux.Fecha









GO
/****** Object:  View [dbo].[VistaTotalesNotaCreditoCompra]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[VistaTotalesNotaCreditoCompra] as
Select FV.IdTipoFactura, FV.BVFactReferencia + '-' + FV.NCompFactReferencia as NroFactura, SUM(FV.Total) as TotalNC
From FacturasCompra FV
Where FV.IdTipoDocumento = 7
Group By FV.BVFactReferencia + '-' + FV.NCompFactReferencia, FV.IdTipoFactura






GO
/****** Object:  View [dbo].[VistaFacturasSinSaldarCompras]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VistaFacturasSinSaldarCompras]
AS
SELECT     fv.IdFacturaCompra, fv.NroProveedor, fv.BVFactCompra + '-' + fv.NCompFactCompra AS NroFactura, fv.IdEmpresa, 
		(fv.Total - SUM(ISNULL(VTNC.TotalNC, 0))) as Total, SUM(ISNULL(cf.MontoCancelacion, 0))AS TotalSaldado, 
		(fv.Total - SUM(ISNULL(VTNC.TotalNC, 0))) - SUM(ISNULL(cf.MontoCancelacion, 0)) as PendienteCobro,
                      fv.FechaEmision, fv.FechaAnulacion, cf.IdNotaCredito, P.ApellidoyNombre, P.Direccion, FV.IdTipoFactura					  
FROM         dbo.FacturasCompra AS fv LEFT OUTER JOIN
                      dbo.CancelacionFacturasCompra AS cf ON cf.IdFacturaCompra = fv.IdFacturaCompra AND cf.FechaAnulacion IS NULL INNER JOIN
                      Proveedores P on fv.NroProveedor = P.NroProveedor LEFT JOIN
					  VistaTotalesNotaCreditoCompra VTNC on VTNC.NroFactura = fv.BVFactCompra + '-' + fv.NCompFactCompra and fv.IdTipoFactura = VTNC.IdTipoFactura
WHERE     (fv.IdFormaPago = 2) AND (fv.FechaAnulacion IS NULL) AND (fv.IdTipoDocumento in (4)) 
		
GROUP BY fv.IdFacturaCompra, fv.NroProveedor, fv.BVFactCompra + '-' + fv.NCompFactCompra, fv.IdEmpresa, fv.Total, fv.FechaEmision, 
fv.FechaAnulacion, cf.IdNotaCredito, P.ApellidoyNombre, P.Direccion, FV.IdTipoFactura
HAVING (fv.Total - - SUM(ISNULL(VTNC.TotalNC, 0))) > SUM(ISNULL(cf.MontoCancelacion, 0))











GO
/****** Object:  UserDefinedFunction [dbo].[FnBuscarEstadosPorClienteId]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ojeda, JOse
-- Create date: 2022-04-28
-- Description:	Devuelve un listado de los estados de un cliente, filtrando por ClienteCajaDistribucionServicioId
-- =============================================
CREATE FUNCTION [dbo].[FnBuscarEstadosPorClienteId] 
(	
	@ClienteCajaDistribucionServicioId int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		ccdse.ClienteCajaDistribucionServicioEstadoId,
		es.Descripcion,
		ccdse.FechaUltimaModificacion,
		ccdse.Observaciones,
		Fila = ROW_NUMBER() OVER (ORDER BY ccdse.FechaUltimaModificacion DESC)  --< ORDER BY
	
	FROM Clientes cli
		INNER JOIN ClientesCajasDistribucionesServicios ccds on cli.NroCliente = ccds.ClienteId
		INNER JOIN ClientesCajasDistribucionesServiciosEstados ccdse on ccds.ClienteCajaDistribucionServicioId = ccdse.ClienteCajaDistribucionServicioId
		INNER JOIN Estados es on ccdse.EstadoId = es.EstadoId

	WHERE  ccds.ClienteCajaDistribucionServicioId = @ClienteCajaDistribucionServicioId
)
GO
/****** Object:  View [dbo].[CabeceraArchivoFact]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CabeceraArchivoFact]
AS
SELECT     FV.IdTipoDocumento, TF.Descripcion AS TipoF, FV.Subtotal - FV.TotalDescuento AS Dto, FV.Observaciones, FP.Descripcion AS FPago, 
                      C.ApellidoyNombre AS RazonSocial, ISNULL(C.TipoDocumento, 'CUIT') AS TipoDoc, ISNULL(C.NroDocumento, C.Cuit0 + C.Cuit1 + C.Cuit2) AS NroDoc, 
                      RI.Descripcion AS RegImp, C.Direccion, FV.IdFacturaVenta
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.Clientes AS C ON C.NroCliente = FV.NroCliente INNER JOIN
                      dbo.FormasPago AS FP ON FP.IdFormaPago = FV.IdFormaPago INNER JOIN
                      dbo.RegimenesImpositivos AS RI ON RI.IdRegimenImpositivo = C.IdRegimenImpositivo INNER JOIN
                      dbo.TiposFactura AS TF ON TF.IdTipoFactura = FV.IdTipoFactura








GO
/****** Object:  View [dbo].[DetalleArchivoFact]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DetalleArchivoFact]
AS
SELECT        ISNULL(A.DescCorta, FVD.Articulo) AS Articulo, ISNULL(UM.Descripcion, FVD.UMedida) AS UMedida, FVD.Cantidad, FVD.PrecioUnitario, ISNULL(TI.PorcentajeIVA, 21) 
                         AS IVA, FVD.IdFacturaVenta
FROM            dbo.FacturasVentaDetalle AS FVD LEFT OUTER JOIN
                         dbo.Articulos AS A ON A.IdArticulo = FVD.IdArticulo LEFT OUTER JOIN
                         dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida LEFT OUTER JOIN
                             (SELECT        IdTipoIva, IdArticulo, MAX(FechaPrecios) AS Fecha
                               FROM            dbo.PreciosVenta
                               GROUP BY IdTipoIva, IdArticulo) AS aux ON aux.IdArticulo = A.IdArticulo LEFT OUTER JOIN
                         dbo.TiposIva AS TI ON TI.IdTipoIva = aux.IdTipoIva








GO
/****** Object:  View [dbo].[FechaServidor]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FechaServidor]
AS
SELECT     GETDATE() AS Fecha








GO
/****** Object:  View [dbo].[VistaAperturasCajas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaAperturasCajas]
AS
SELECT     TOP (100) PERCENT ca.IdAperturaCaja, CONVERT(Nvarchar, ca.FechaApertura, 103) AS FechaApertura, ca.UsrApertura, CONVERT(Nvarchar, c.IdCaja) 
                      + ' - ' + c.Descripcion AS Caja, ca.SaldoInicial, ISNULL(CONVERT(Nvarchar, ca.SaldoFinal), '') AS SaldoFinal, ISNULL(CONVERT(Nvarchar, ca.FechaCierre, 103), '') 
                      AS FechaCierre, (CASE WHEN ca.FechaCierre IS NULL THEN 'Abierta' ELSE 'Cerrada' END) AS Estado
FROM         dbo.CajasAperturas AS ca INNER JOIN
                      dbo.Cajas AS c ON c.IdCaja = ca.IdCaja
ORDER BY ca.IdAperturaCaja DESC








GO
/****** Object:  View [dbo].[VistaArticulosPV]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaArticulosPV]
AS

SELECT TOP (100) PERCENT a.IdArticulo, a.DescCorta as Articulo, CONVERT(Nvarchar, FechaPrecio, 103) as FechaPrecio, 
ISNULL(PrecioContado, '0') as PrecioContado, ISNULL(PrecioContadoIva, '0') as PrecioContadoIva, 
ISNULL(PrecioFiado, '0') as PrecioFiado, ISNULL(PrecioFiadoIva, '0') as PrecioFiadoIva, 
ISNULL(PrecioEspecial, '0') as PrecioEspecial, ISNULL(PrecioEspecialIva, '0') as PrecioEspecialIva, 
ISNULL(PrecioBase, '0') as PrecioBase, r.Descripcion as Rubro, sr.Descripcion as SubRubro, r.IdRubro, sr.IdSubRubro, CodigoBarra, 
CONVERT(Nvarchar, FechaBaja, 103) as FechaBaja, um.Descripcion as UMedida, StockActual, Embalaje
FROM PreciosVenta pv join 					
(select IdArticulo, MAX(FechaPrecios) FechaPrecio
from PreciosVenta
group by IdArticulo) Aux 
on pv.IdArticulo = aux.IdArticulo AND pv.FechaPrecios = aux.FechaPrecio right join Articulos a 
on pv.IdArticulo = a.IdArticulo join Rubros r 
on a.IdRubro = r.IdRubro join SubRubros sr
on a.IdSubRubro = sr.IdSubRubro join UnidadesMedida um 
on a.IdUnidadMedida = um.IdUnidadMedida
order by pv.IdArticulo


GO
/****** Object:  View [dbo].[VistaArtSinVentas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaArtSinVentas]
AS
SELECT     TOP (100) PERCENT A.IdArticulo, A.DescCorta, R.Descripcion AS Rubro, S.Descripcion AS SubRubro, (CASE A.LlevarStock WHEN 1 THEN 'SI' ELSE 'NO' END) 
                      AS LlevarStock, A.StockActual, UM.Descripcion AS UMedida, A.FechaAcceso AS FechaCarga, ISNULL(CONVERT(Nvarchar, DATEDIFF(DAY, aux.MaxFecha, GETDATE())), 
                      'SIN MOVIMIENTOS') AS Dias, ISNULL(DATEDIFF(DAY, aux.MaxFecha, GETDATE()), 0) AS DiasInt, aux.IdEmpresa
FROM         dbo.Articulos AS A LEFT OUTER JOIN
                          (SELECT     FVD.IdArticulo, MAX(FV.FechaEmision) AS MaxFecha, FV.IdEmpresa
                            FROM          dbo.FacturasVenta AS FV INNER JOIN
                                                   dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                            WHERE      (FV.FechaAnulacion IS NULL) AND (FVD.IdArticulo IS NOT NULL)
                            GROUP BY FVD.IdArticulo, FV.IdEmpresa) AS aux ON aux.IdArticulo = A.IdArticulo INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro INNER JOIN
                      dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida
ORDER BY DiasInt DESC








GO
/****** Object:  View [dbo].[VistaAsientosContables]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaAsientosContables] as
Select aux.IdAsientoContable,  aux.Periodo, SUM(aux.TotalDebe) as Debe, SUM(aux.TotalHaber) as Haber
from(
Select AC.IdAsientoContable, AC.Periodo, AC.Fecha, case when AC.Tipo = 'd' THEN SUM(AC.Valor) else 0 end as TotalDebe, 
case when AC.Tipo = 'h' THEN SUM(AC.Valor) else 0 end as TotalHaber
from AsientosContables AC
Group By AC.IdAsientoContable, AC.Fecha, AC.Periodo, AC.Tipo) as aux
group by aux.IdAsientoContable,  aux.Periodo







GO
/****** Object:  View [dbo].[VistaCabeceraRemImp]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCabeceraRemImp]
AS
SELECT     dbo.Remitos.NroRemito, dbo.Remitos.FechaRemito, dbo.Clientes.ApellidoyNombre, dbo.Clientes.Direccion, dbo.CPostales.Localidad, 
                      dbo.RegimenesImpositivos.Descripcion AS TipoIVA, dbo.Remitos.Observaciones, dbo.Remitos.IdRemito, dbo.Remitos.IdEmpresa
FROM         dbo.Remitos INNER JOIN
                      dbo.Clientes ON dbo.Remitos.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.CPostales ON dbo.Clientes.CodigoPostal = dbo.CPostales.CodigoPostal AND dbo.Clientes.SubCodigoPostal = dbo.CPostales.SubCodigoPostal INNER JOIN
                      dbo.RegimenesImpositivos ON dbo.Clientes.IdRegimenImpositivo = dbo.RegimenesImpositivos.IdRegimenImpositivo








GO
/****** Object:  View [dbo].[VistaCabFactVentaConCaja]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaCabFactVentaConCaja] as

SELECT     dbo.TiposDocFact.Descripcion AS TipoDoc, dbo.FacturasVenta.IdFacturaVenta, dbo.TiposFactura.Descripcion AS TipoFact, 
                      dbo.FacturasVenta.BVFact + ' - ' + dbo.FacturasVenta.NCompFact AS NroFact, CONVERT(NVarchar, dbo.FacturasVenta.FechaEmision, 103) AS FechaEmision, 
                      dbo.FacturasVenta.FechaEmision AS Fecha, (CASE WHEN dbo.FacturasVenta.Impresa = 1 THEN 'SI' ELSE 'NO' END) AS Impresa, dbo.FacturasVenta.Observaciones, 
                      dbo.FacturasVenta.SubTotal, dbo.FacturasVenta.Descuento, dbo.FacturasVenta.TotalDescuento, dbo.Clientes.ApellidoyNombre AS Cliente, 
                      ISNULL((CASE WHEN FacturasVenta.IdTipoDocumento = 2 THEN - dbo.FacturasVenta.Total ELSE dbo.FacturasVenta.Total END), 0) AS Total, 
                      ISNULL(dbo.CondicionesPago.Descripcion, '') AS CondPago, dbo.FormasPago.Descripcion AS FPago, dbo.FacturasVenta.FechaVencimiento, 
                      ISNULL(CONVERT(nvarchar, dbo.FacturasVenta.FechaAnulacion, 103), '') AS FechaAnulacion, dbo.Clientes.NroCliente, dbo.FacturasVenta.BVFact, 
                      dbo.FacturasVenta.TotalIva105, dbo.FacturasVenta.TotalIva21, dbo.FacturasVenta.IdEmpresa, dbo.Empresa.RazonSocial, dbo.FacturasVenta.TotalSaldado, 
                      dbo.FacturasVenta.TotalInteres, dbo.FacturasVenta.TotalSaldadoInteres, 
                      dbo.FacturasVenta.BVReferencia + '-' + dbo.FacturasVenta.NroCompFactReferencia AS NroFactReferencia, c.Descripcion, dbo.FacturasVenta.FechaAlta
FROM         dbo.FacturasVenta INNER JOIN
                      dbo.TiposDocFact ON dbo.FacturasVenta.IdTipoDocumento = dbo.TiposDocFact.IdTipoDocumento INNER JOIN
                      dbo.TiposFactura ON dbo.FacturasVenta.IdTipoFactura = dbo.TiposFactura.IdTipoFactura INNER JOIN
                      dbo.Clientes ON dbo.FacturasVenta.NroCliente = dbo.Clientes.NroCliente LEFT OUTER JOIN
                      dbo.CondicionesPago ON dbo.FacturasVenta.IdCondicionPago = dbo.CondicionesPago.IdCondicionPago INNER JOIN
                      dbo.FormasPago ON dbo.FacturasVenta.IdFormaPago = dbo.FormasPago.IdFormaPago INNER JOIN
                      dbo.Empresa ON dbo.FacturasVenta.IdEmpresa = dbo.Empresa.IdEmpresa left join
					  cajasmovimientos cm on cm.IdFacturaVenta = FacturasVenta.IdFacturaVenta left join
					  CajasAperturas ca on ca.IdAperturaCaja = cm.IdAperturaCaja left join
					  Cajas c on c.IdCaja = ca.IdCaja








GO
/****** Object:  View [dbo].[VistaCajaDistribuciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCajaDistribuciones]
AS
SELECT     cd.CajaDistribucionId, cd.Descipcion, cd.Longitud as 'Direccion', cd.FechaUltimaModificacion
FROM         CajasDistribuciones cd 

GO
/****** Object:  View [dbo].[VistaCajas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCajas]
AS
SELECT     dbo.Cajas.IdCaja AS NroCaja, dbo.Cajas.Descripcion AS Caja, CONVERT(NVarchar, dbo.Cajas.FechaCreacion, 103) AS FechaCreacion, dbo.EstadosCaja.Estado
FROM         dbo.Cajas INNER JOIN
                      dbo.EstadosCaja ON dbo.Cajas.IdEstadoCaja = dbo.EstadosCaja.IdEstadoCaja








GO
/****** Object:  View [dbo].[VistaCancelacionFacturas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCancelacionFacturas]
AS
SELECT IdFacturaVenta, SUM(MontoCancelacion) as TotalSaldado
FROM CancelacionFacturas
GROUP BY IdFacturaVenta

GO
/****** Object:  View [dbo].[VistaCancelacionFacturasRetenciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaCancelacionFacturasRetenciones] as

select c.*, FC.NroProveedor, P.ApellidoyNombre, FC.FechaEmision, FC.IdEmpresa, FC.Subtotal
from CancelacionFacturasCompra C inner join FacturasCompra FC on fc.IdFacturaCompra = C.IdFacturaCompra inner join
	Proveedores P on p.NroProveedor = FC.NroProveedor









GO
/****** Object:  View [dbo].[VistaCancelacionNC]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaCancelacionNC] as 
select IdNotaCredito, cf.IdRecibo, SUM(MontoCancelacion) as MontoNC, fv.BVFact, fv.NCompFact, CONVERT(NVarchar, fv.FechaEmision, 103) AS FechaEmision
from CancelacionFacturas cf left join FacturasVenta fv
on cf.IdNotaCredito = fv.IdFacturaVenta left join Recibos r
on cf.IdRecibo = r.IdRecibo
where cf.IdNotaCredito is not null
group by IdNotaCredito, cf.IdRecibo, fv.BVFact, fv.NCompFact, fv.FechaEmision

GO
/****** Object:  View [dbo].[VistaCancelacionNCPagos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaCancelacionNCPagos] as 
select IdNotaCredito, cfc.IdPago, SUM(MontoCancelacion) as MontoNC, fc.BVFactCompra, fc.NCompFactCompra, CONVERT(NVarchar, fc.FechaEmision, 103) AS FechaEmision
from CancelacionFacturasCompra cfc left join FacturasCompra fc
on cfc.IdNotaCredito = fc.IdFacturaCompra left join Pagos p
on cfc.IdPago = p.IdPago
where cfc.IdNotaCredito is not null
group by IdNotaCredito, cfc.IdPago, fc.BVFactCompra, fc.NCompFactCompra, fc.FechaEmision

GO
/****** Object:  View [dbo].[VistaCantFactporRubro]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCantFactporRubro]
AS
SELECT     TOP (100) PERCENT R.Descripcion AS Rubro, CONVERT(Decimal(10, 2), SUM(FVD.Cantidad * FVD.PrecioUnitario)) AS TotalFacturado, R.IdRubro, FV.IdEmpresa
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.FacturasVentaDetalle AS FVD ON FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
                      dbo.Articulos AS A ON A.IdArticulo = FVD.IdArticulo INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY R.Descripcion, R.IdRubro, FV.IdEmpresa
ORDER BY TotalFacturado DESC








GO
/****** Object:  View [dbo].[VistaCantFactporRubroSubRubro]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCantFactporRubroSubRubro]
AS
SELECT     TOP (100) PERCENT R.Descripcion AS Rubro, S.Descripcion AS Subrubro, CONVERT(Decimal(10, 2), SUM(FVD.Cantidad * FVD.PrecioUnitario)) AS TotalFacturado, 
                      R.IdRubro, S.IdSubRubro, FV.IdEmpresa
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.FacturasVentaDetalle AS FVD ON FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
                      dbo.Articulos AS A ON A.IdArticulo = FVD.IdArticulo INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY R.Descripcion, S.Descripcion, R.IdRubro, S.IdSubRubro, FV.IdEmpresa
ORDER BY TotalFacturado DESC








GO
/****** Object:  View [dbo].[VistaCantFactporSubRubro]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCantFactporSubRubro]
AS
SELECT     TOP (100) PERCENT S.Descripcion AS SubRubro, CONVERT(Decimal(10, 2), SUM(FVD.Cantidad * FVD.PrecioUnitario)) AS TotalFacturado, S.IdSubRubro, 
                      FV.IdEmpresa
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.FacturasVentaDetalle AS FVD ON FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
                      dbo.Articulos AS A ON A.IdArticulo = FVD.IdArticulo INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY S.Descripcion, S.IdSubRubro, FV.IdEmpresa
ORDER BY TotalFacturado DESC








GO
/****** Object:  View [dbo].[VistaCCClientesME]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCCClientesME]
AS
SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(f.Total), 0) + ISNULL(Aux3.Intereses, 0) AS Debe, ISNULL(aux.HaberNC + Aux2.HaberRecibo, 0) AS Haber, 
                      ISNULL(ISNULL(SUM(f.Total), 0) + ISNULL(Aux3.Intereses, 0) - ISNULL(aux.HaberNC + Aux2.HaberRecibo, 0), 0) AS Saldo, C.FechaBaja
FROM         dbo.Clientes AS C LEFT OUTER JOIN
                      dbo.FacturasVenta AS f ON C.NroCliente = f.NroCliente AND f.IdFormaPago = 2 AND f.IdTipoDocumento IN (1, 8) AND f.FechaAnulacion IS NULL INNER JOIN
                          (SELECT     C.NroCliente, SUM(ISNULL(nc.Total, 0)) AS HaberNC
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.FacturasVenta AS nc ON nc.NroCliente = C.NroCliente AND nc.IdTipoDocumento = 2 AND nc.FechaAnulacion IS NULL AND nc.IdFormaPago = 2
                            GROUP BY C.NroCliente) AS aux ON aux.NroCliente = C.NroCliente INNER JOIN
                          (SELECT     C.NroCliente, SUM(ISNULL(R.MontoTotal, 0)) AS HaberRecibo
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.Recibos AS R ON C.NroCliente = R.NroCliente AND R.FechaBaja IS NULL
                            GROUP BY C.NroCliente) AS Aux2 ON Aux2.NroCliente = C.NroCliente INNER JOIN
                          (SELECT     C.NroCliente, SUM(AuxInt.Intereses) AS Intereses
                            FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                                   dbo.FacturasVenta AS fv ON fv.NroCliente = C.NroCliente AND fv.FechaAnulacion IS NULL AND fv.IdFormaPago = 2 LEFT OUTER JOIN
                                                       (SELECT     MAX(TotalInteres) AS Intereses, IdFacturaVenta
                                                         FROM          dbo.GeneracionInteres
                                                         GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta
                            GROUP BY C.NroCliente) AS Aux3 ON Aux3.NroCliente = C.NroCliente
GROUP BY C.NroCliente, C.ApellidoyNombre, aux.HaberNC, Aux2.HaberRecibo, Aux3.Intereses, C.FechaBaja








GO
/****** Object:  View [dbo].[VistaCCProveedoresME]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCCProveedoresME]
AS
SELECT     P.NroProveedor, P.ApellidoyNombre AS Proveedor, ISNULL(SUM(f.Total), 0) AS Debe, ISNULL(Aux2.HaberRecibo + aux.HaberNC, 0) AS Haber, 
                      ISNULL(ISNULL(Aux2.HaberRecibo + aux.HaberNC, 0) - ISNULL(SUM(f.Total), 0), 0) AS Saldo
FROM         dbo.Proveedores AS P LEFT OUTER JOIN
                      dbo.FacturasCompra AS f ON P.NroProveedor = f.NroProveedor AND f.IdFormaPago = 2 AND f.IdTipoDocumento = 4 AND f.FechaAnulacion IS NULL INNER JOIN
                          (SELECT     P.NroProveedor, SUM(ISNULL(nc.Total, 0)) AS HaberNC
                            FROM          dbo.Proveedores AS P LEFT OUTER JOIN
                                                   dbo.FacturasCompra AS nc ON nc.NroProveedor = P.NroProveedor AND nc.IdTipoDocumento = 7 AND nc.FechaAnulacion IS NULL
                            GROUP BY P.NroProveedor) AS aux ON aux.NroProveedor = P.NroProveedor INNER JOIN
                          (SELECT     P.NroProveedor, SUM(ISNULL(Pag.MontoTotal, 0)) AS HaberRecibo
                            FROM          dbo.Proveedores AS P LEFT OUTER JOIN
                                                   dbo.Pagos AS Pag ON P.NroProveedor = Pag.NroProveedor AND Pag.FechaBaja IS NULL
                            GROUP BY P.NroProveedor) AS Aux2 ON Aux2.NroProveedor = P.NroProveedor
GROUP BY P.NroProveedor, P.ApellidoyNombre, aux.HaberNC, Aux2.HaberRecibo








GO
/****** Object:  View [dbo].[VistaCFs]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VistaCFs]
AS
SELECT     cf.IdCF, cf.BocadeVenta, cf.Observaciones, tcf.TipoCF, tcf.TipoCF + ' (' + cf.Observaciones + ')' AS DescCF, cf.FechaBaja, 
				cf.IdEmpresa, cf.Puerto, cf.MachineName, tcf.IdTipoCF
FROM         ControladoresFiscales cf INNER JOIN
                      TiposCF tcf ON cf.IdTipoCF = tcf.IdTipoCF

GO
/****** Object:  View [dbo].[VistaCheques]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCheques] as
SELECT     dbo.Cheques.NroCheque, dbo.Cheques.MontoCheque, dbo.Clientes.ApellidoyNombre, 'Recibo' as TipoMovimiento, dbo.Recibos.IdRecibo AS IdMovimiento, CONVERT(NVARCHAR, 
                      dbo.Cheques.FechaEmision, 103) AS FechaEmision, CONVERT(Nvarchar, dbo.Cheques.FechaCobro, 103) AS FechaCobro, 
                      (CASE WHEN dbo.Cheques.Cruzado = 0 THEN 'NO' ELSE 'SI' END) AS Cruzado, dbo.Bancos.Descripcion AS Banco, ISNULL(CONVERT(Nvarchar, 
                      dbo.Cheques.FechaBaja, 103), '') AS FechaBaja, dbo.Cheques.IdCheque, dbo.Cheques.Propio
FROM         dbo.Cheques INNER JOIN
                      dbo.RecibosDetalle ON dbo.Cheques.IdCheque = dbo.RecibosDetalle.IdCheque INNER JOIN
                      dbo.Recibos ON dbo.RecibosDetalle.IdRecibo = dbo.Recibos.IdRecibo INNER JOIN
                      dbo.Clientes ON dbo.Recibos.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.Bancos ON dbo.Cheques.IdBanco = dbo.Bancos.IdBanco

UNION


SELECT     dbo.Cheques.NroCheque, dbo.Cheques.MontoCheque, dbo.Clientes.ApellidoyNombre, 'Mov.Caja' as TipoMovimiento, dbo.CajasMovimientosDetalle.IdMovimientoCajaDetalle AS IdMovimiento, CONVERT(NVARCHAR, 
                      dbo.Cheques.FechaEmision, 103) AS FechaEmision, CONVERT(Nvarchar, dbo.Cheques.FechaCobro, 103) AS FechaCobro, 
                      (CASE WHEN dbo.Cheques.Cruzado = 0 THEN 'NO' ELSE 'SI' END) AS Cruzado, dbo.Bancos.Descripcion AS Banco, ISNULL(CONVERT(Nvarchar, 
                      dbo.Cheques.FechaBaja, 103), '') AS FechaBaja, dbo.Cheques.IdCheque, dbo.Cheques.Propio
FROM         dbo.Cheques INNER JOIN
                      dbo.CajasMovimientosDetalle ON dbo.Cheques.IdCheque = dbo.CajasMovimientosDetalle.IdCheque INNER JOIN
                      dbo.CajasMovimientos ON dbo.CajasMovimientos.IdMovimientoCaja = dbo.CajasMovimientosDetalle.IdMovimientoCaja INNER JOIN
					  dbo.FacturasVenta ON dbo.FacturasVenta.IdFacturaVenta = dbo.CajasMovimientos.IdFacturaVenta INNER JOIN
                      dbo.Clientes ON dbo.FacturasVenta.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.Bancos ON dbo.Cheques.IdBanco = dbo.Bancos.IdBanco







GO
/****** Object:  View [dbo].[VistaChequesPropios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaChequesPropios]
AS
SELECT     dbo.Cheques.NroCheque, dbo.Cheques.MontoCheque, dbo.Proveedores.ApellidoyNombre, dbo.Pagos.IdPago AS NroPago, CONVERT(NVARCHAR, 
                      dbo.Cheques.FechaEmision, 103) AS FechaEmision, CONVERT(Nvarchar, dbo.Cheques.FechaCobro, 103) AS FechaCobro, 
                      (CASE WHEN dbo.Cheques.Cruzado = 0 THEN 'NO' ELSE 'SI' END) AS Cruzado, dbo.Bancos.Descripcion AS Banco, ISNULL(CONVERT(Nvarchar, 
                      dbo.Cheques.FechaBaja, 103), '') AS FechaBaja, dbo.Cheques.IdCheque, dbo.Cheques.Propio
FROM         dbo.Cheques INNER JOIN
                      dbo.Bancos ON dbo.Cheques.IdBanco = dbo.Bancos.IdBanco INNER JOIN
                      dbo.PagosDetalle ON dbo.Cheques.IdCheque = dbo.PagosDetalle.IdCheque INNER JOIN
                      dbo.Pagos ON dbo.PagosDetalle.IdPago = dbo.Pagos.IdPago INNER JOIN
                      dbo.Proveedores ON dbo.Pagos.NroProveedor = dbo.Proveedores.NroProveedor








GO
/****** Object:  View [dbo].[VistaClientes]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VistaClientes]
AS
SELECT      TOP (100) PERCENT dbo.Clientes.NroCliente, dbo.Clientes.ApellidoyNombre, ISNULL(dbo.Clientes.TipoDocumento, '') AS TipoDocumento, ISNULL(CONVERT(Nvarchar, dbo.Clientes.NroDocumento), '') AS [Nro.Doc], 
                         dbo.Clientes.Direccion, dbo.RegimenesImpositivos.Descripcion, dbo.CPostales.Localidad, dbo.Clientes.FechaNacimiento, dbo.Clientes.Telefono, dbo.Clientes.Email1, dbo.Clientes.Email2, dbo.Provincias.Provincia, 
                         (CASE WHEN dbo.Clientes.Cuit0 IS NULL THEN '' ELSE (dbo.Clientes.Cuit0 + '-' + dbo.Clientes.Cuit1 + '-' + Isnull(dbo.Clientes.Cuit2, '')) END) AS Cuit, ISNULL(CONVERT(Nvarchar, dbo.Clientes.FechaBaja, 103), '') AS FechaBaja, 
                         dbo.Clientes.Comentario, dbo.Clientes.CodigoPostal, dbo.CajasDistribuciones.Descipcion, dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId
FROM         dbo.Clientes INNER JOIN
                         dbo.RegimenesImpositivos ON dbo.Clientes.IdRegimenImpositivo = dbo.RegimenesImpositivos.IdRegimenImpositivo INNER JOIN
                         dbo.CPostales ON dbo.Clientes.CodigoPostal = dbo.CPostales.CodigoPostal AND dbo.Clientes.SubCodigoPostal = dbo.CPostales.SubCodigoPostal INNER JOIN
                         dbo.Provincias ON dbo.CPostales.IdProvincia = dbo.Provincias.IdProvincia INNER JOIN
                         dbo.ClientesCajasDistribucionesServicios ON dbo.Clientes.NroCliente = dbo.ClientesCajasDistribucionesServicios.ClienteId INNER JOIN
                         dbo.CajasDistribuciones ON dbo.ClientesCajasDistribucionesServicios.CajaDistribucionId = dbo.CajasDistribuciones.CajaDistribucionId INNER JOIN
                         dbo.Servicios AS s ON dbo.ClientesCajasDistribucionesServicios.ServicioId = s.ServicioId

ORDER BY dbo.Clientes.NroCliente


GO
/****** Object:  View [dbo].[VistaCobranzaxTP]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCobranzaxTP]
AS
SELECT     dbo.RecibosDetalle.Monto, dbo.Recibos.FechaEmision, dbo.Clientes.ApellidoyNombre, dbo.TiposPagos.Descripcion, dbo.Recibos.IdEmpresa
FROM         dbo.RecibosDetalle INNER JOIN
                      dbo.Recibos ON dbo.RecibosDetalle.IdRecibo = dbo.Recibos.IdRecibo AND dbo.Recibos.FechaBaja IS NULL INNER JOIN
                      dbo.TiposPagos ON dbo.RecibosDetalle.IdTipoPago = dbo.TiposPagos.IdTipoPago INNER JOIN
                      dbo.Clientes ON dbo.Recibos.NroCliente = dbo.Clientes.NroCliente








GO
/****** Object:  View [dbo].[VistaCPostales]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaCPostales]
AS
SELECT        TOP (100) PERCENT CP.CodigoPostal, CP.SubCodigoPostal, CP.Localidad, P.Provincia, CONVERT(Nvarchar, CP.CodigoPostal) + '-' + CONVERT(Nvarchar, 
                         CP.SubCodigoPostal) AS CpSubCp, P.IdProvincia
FROM            dbo.CPostales AS CP INNER JOIN
                         dbo.Provincias AS P ON CP.IdProvincia = P.IdProvincia
ORDER BY CP.CodigoPostal, CP.SubCodigoPostal








GO
/****** Object:  View [dbo].[VistaCtaCteClientes]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[VistaCtaCteClientes]
AS
SELECT     aux.NroCliente, aux.Cliente, SUM(aux.Debe) AS Debe, SUM(aux.Haber) AS Haber, SUM(aux.Debe - aux.Haber) AS Saldo, aux.IdEmpresa, C.FechaBaja
FROM         (SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(FV.Total), 0) AS Debe, 0 AS Haber, FV.IdEmpresa, 1 as tipodoc
                       FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                              dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente
                       WHERE      (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento IN (1, 3, 8)) AND (FV.FechaAnulacion IS NULL) AND IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
					   UNION
					   SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(FV.Total), 0) AS Debe, 0 AS Haber, FV.IdEmpresa, 1 as tipodoc
                       FROM          dbo.Clientes AS C LEFT OUTER JOIN
                                              dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente
                       WHERE      (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 9) AND (FV.FechaAnulacion IS NULL)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
					   UNION
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, SUM(ISNULL(FV.Total, 0)) AS Haber, FV.IdEmpresa, 2 as tipodoc
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN
                                             dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente
                       WHERE     (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 2) AND (FV.FechaAnulacion IS NULL)
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
                       UNION 
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, SUM(ISNULL(R.MontoTotal, 0)) AS Haber, R.IdEmpresa, 5 as tipodoc
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN
                                             dbo.Recibos AS R ON C.NroCliente = R.NroCliente AND R.FechaBaja IS NULL
                       GROUP BY C.NroCliente, C.ApellidoyNombre, R.IdEmpresa
                       UNION
                       SELECT     C.NroCliente, C.ApellidoyNombre, ISNULL(SUM(GI.TotalInteres), 0) AS Debe, 0 AS Haber, fv.IdEmpresa, 1 as tipodoc
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN
                                             dbo.FacturasVenta AS fv ON fv.NroCliente = C.NroCliente AND fv.FechaAnulacion IS NULL AND fv.IdFormaPago = 2 LEFT OUTER JOIN
                                                 (SELECT     MAX(IdDiaGeneracion) AS IdDia, IdFacturaVenta
                                                   FROM          dbo.GeneracionInteres
                                                   GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta INNER JOIN
                                             dbo.GeneracionInteres AS GI ON GI.IdDiaGeneracion = AuxInt.IdDia AND AuxInt.IdFacturaVenta = GI.IdFacturaVenta
                       GROUP BY C.NroCliente, C.ApellidoyNombre, fv.IdEmpresa) AS aux INNER JOIN
                      dbo.Clientes AS C ON C.NroCliente = aux.NroCliente 
WHERE     (aux.IdEmpresa IS NOT NULL)
GROUP BY aux.NroCliente, aux.Cliente, aux.IdEmpresa, C.FechaBaja

GO
/****** Object:  View [dbo].[VistaCtaCteProveedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaCtaCteProveedores]
AS

SELECT NroProveedor,
	   Proveedor,
	   SUM(Debe) AS Debe,
	   SUM(Haber) AS Haber,
	   SUM(Debe - Haber) AS Saldo,
	   IdEmpresa
FROM (SELECT P.NroProveedor,
			 P.ApellidoyNombre AS Proveedor,
			 ISNULL(SUM(FC.Total), 0) AS Debe,
			 0 AS Haber,
			 FC.IdEmpresa
	  FROM Proveedores AS P LEFT OUTER JOIN FacturasCompra AS FC ON FC.NroProveedor = P.NroProveedor
	  WHERE FC.IdFormaPago = 2 AND 
			FC.IdTipoDocumento IN (4,10,11) AND
			FC.FechaAnulacion IS NULL
	  GROUP BY P.NroProveedor,
			   P.ApellidoyNombre,
			   FC.IdEmpresa

	  UNION

	  SELECT P.NroProveedor,
			 P.ApellidoyNombre AS Proveedor,
			 0 AS Debe,
			 ISNULL(SUM(FC.Total), 0) AS Haber,
			 FC.IdEmpresa
	  FROM Proveedores AS P LEFT OUTER JOIN FacturasCompra AS FC ON FC.NroProveedor = P.NroProveedor
	  WHERE FC.IdFormaPago = 2 AND
			FC.IdTipoDocumento = 7 AND
			FC.FechaAnulacion IS NULL
	  GROUP BY P.NroProveedor,
			   P.ApellidoyNombre,
			   FC.IdEmpresa

	  UNION
	
	  SELECT P.NroProveedor,
			 P.ApellidoyNombre AS Proveedor,
			 0 AS Debe,
			 SUM(ISNULL(Pa.MontoTotal, 0)) AS Haber,
			 Pa.IdEmpresa
	  FROM Proveedores AS P LEFT OUTER JOIN Pagos AS Pa ON P.NroProveedor = Pa.NroProveedor AND
											Pa.FechaBaja IS NULL
	  GROUP BY P.NroProveedor,
			   P.ApellidoyNombre,
			   Pa.IdEmpresa) AS aux
WHERE IdEmpresa IS NOT NULL
GROUP BY NroProveedor,
		 Proveedor,
		 IdEmpresa

GO
/****** Object:  View [dbo].[VistaCuentasBancarias]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaCuentasBancarias] as

select CB.*, B.Descripcion
from CuentasBancarias CB INNER JOIN Bancos B on CB.IdBanco = B.IdBanco





GO
/****** Object:  View [dbo].[VistaDatosImpositivos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaDatosImpositivos]
AS
SELECT        dbo.DatosImpositivos.NroCliente, dbo.DatosImpositivos.FechaInicioExc, dbo.TiposImpuestos.Descripcion, ISNULL(dbo.Provincias.Provincia, '') AS Provincia, 
                         dbo.DatosImpositivos.NroInscripcion, dbo.DatosImpositivos.Tipo, dbo.DatosImpositivos.FechaInscripcion, dbo.DatosImpositivos.NroCertificadoExc, 
                         dbo.DatosImpositivos.FechaFinExc, dbo.DatosImpositivos.IdDatosImpositivos
FROM            dbo.DatosImpositivos INNER JOIN
                         dbo.TiposImpuestos ON dbo.DatosImpositivos.IdTipoImpuesto = dbo.TiposImpuestos.IdTipoImpuesto LEFT OUTER JOIN
                         dbo.Provincias ON dbo.DatosImpositivos.IdProvincia = dbo.Provincias.IdProvincia








GO
/****** Object:  View [dbo].[VistaDetalleAsientosContables]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaDetalleAsientosContables] as
Select AC.Fecha, AC.IdAsientoContable, AC.Periodo, AC.Tipo, AC.Valor, Convert(nvarchar,CC.Nivel1) + 
Convert(nvarchar,CC.Nivel2) + Right('0' + Convert(nvarchar,CC.Nivel3), 2) + Right('0' + Convert(nvarchar,CC.Nivel4), 2) as NroCuenta,
CC.Descripcion as CuentaContable, CC.IdCuentaContable
from CuentasContables CC INNER JOIN
AsientosContables AC on AC.IdCuentaContable = CC.IdCuentaContable






GO
/****** Object:  View [dbo].[VistaDetalleCCClientes]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[VistaDetalleCCClientes]
AS
SELECT     TOP (100) PERCENT Aux.TipoDoc AS Documento, Aux.NroComprobante, Aux.Fecha, Aux.Debe, Aux.Haber, Aux.Id, Aux.NroCliente, Aux.FechaAcceso, 
                      Aux.FechaEmision, Aux.IdEmpresa, dbo.Empresa.RazonSocial, Aux.Cobrador
FROM         (SELECT     (CASE WHEN F.IdTipoDocumento = 8 THEN TD.Descripcion ELSE TD.Descripcion + ' ' + TF.Descripcion END) AS TipoDoc, (CASE WHEN isnull(F.NCompFact,
                                               '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, 
                                              CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 0 AS Haber, F.IdFacturaVenta AS Id, F.NroCliente, F.FechaAcceso, F.FechaEmision, 
                                              F.IdEmpresa, F.Cobrador
                       FROM          dbo.FacturasVenta AS F INNER JOIN
                                              dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                              dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento AND F.IdTipoDocumento IN (1, 8) AND IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       WHERE      (F.IdFormaPago = 2) AND (F.FechaAnulacion IS NULL)
                       UNION
					   SELECT     (CASE WHEN F.IdTipoDocumento = 8 THEN TD.Descripcion ELSE TD.Descripcion + ' ' + TF.Descripcion END) AS TipoDoc, (CASE WHEN isnull(F.NCompFact,
                                               '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, 
                                              CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 0 AS Haber, F.IdFacturaVenta AS Id, F.NroCliente, F.FechaAcceso, F.FechaEmision, 
                                              F.IdEmpresa, F.Cobrador
                       FROM          dbo.FacturasVenta AS F INNER JOIN
                                              dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                              dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento AND F.IdTipoDocumento = 9
                       WHERE      (F.IdFormaPago = 2) AND (F.FechaAnulacion IS NULL)
					   UNION
                       SELECT     TD.Descripcion AS TipoDoc, 'Nro. ' + CONVERT(Nvarchar, R.IdRecibo) AS NroComprobante, CONVERT(NVarchar, R.FechaEmision, 103) AS Fecha, 0 AS Debe,
                                              R.MontoTotal AS Haber, R.IdRecibo AS Id, R.NroCliente, R.FechaAcceso, R.FechaEmision, R.IdEmpresa, 0
                       FROM         dbo.Recibos AS R INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = R.IdTipoDocumento
                       WHERE     (R.FechaBaja IS NULL)
                       UNION
                       SELECT     TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc, (CASE WHEN isnull(F.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) 
                                             ELSE  f.BVFact + '-' + f.NCompFact END) AS NroComprobante, CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, 0 AS Debe, 
                                             F.Total AS Haber, F.IdFacturaVenta AS Id, F.NroCliente, F.FechaAcceso, F.FechaEmision, F.IdEmpresa, F.Cobrador
                       FROM         dbo.FacturasVenta AS F INNER JOIN
                                             dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento
                       WHERE     (F.IdTipoDocumento = 2) AND (F.FechaAnulacion IS NULL) AND (F.IdFormaPago = 2)
                       UNION
                       SELECT     'Intereses' AS TipoDoc, (CASE WHEN isnull(Fv.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) 
                                             ELSE fv.BVFact + '-' + fv.NCompFact END) AS NroComprobante, CONVERT(Nvarchar, dgi.Fecha, 103) AS Fecha, ISNULL(GI.TotalInteres,
                                              0) AS Debe, 0 AS Haber, fv.IdFacturaVenta, fv.NroCliente, fv.FechaAcceso, dgi.Fecha AS FechaEmision, fv.IdEmpresa, 0
                       FROM         dbo.FacturasVenta AS fv INNER JOIN
                                                 (SELECT     MAX(IdDiaGeneracion) AS IdDia, IdFacturaVenta
                                                   FROM          dbo.GeneracionInteres
                                                   GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta INNER JOIN
                                             dbo.GeneracionInteres AS GI ON GI.IdDiaGeneracion = AuxInt.IdDia AND GI.IdFacturaVenta = AuxInt.IdFacturaVenta INNER JOIN
                                             dbo.DiaGeneracionInteres AS dgi ON dgi.IdDiaGeneracion = AuxInt.IdDia
                       WHERE     (fv.FechaAnulacion IS NULL) AND (fv.IdFormaPago = 2)
					   UNION
                       SELECT     TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc, (CASE WHEN isnull(F.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) 
                                             ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 
                                             0 AS Haber, F.IdFacturaVenta AS Id, F.NroCliente, F.FechaAcceso, F.FechaEmision, F.IdEmpresa, F.Cobrador
                       FROM         dbo.FacturasVenta AS F INNER JOIN
                                             dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento
                       WHERE     (F.IdTipoDocumento = 3) AND (F.FechaAnulacion IS NULL) AND (F.IdFormaPago = 2)) AS Aux INNER JOIN
                      dbo.Empresa ON Aux.IdEmpresa = dbo.Empresa.IdEmpresa
ORDER BY CONVERT(Datetime, Aux.Fecha)


GO
/****** Object:  View [dbo].[VistaDetalleCCProv]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaDetalleCCProv]
AS

SELECT TOP (100) PERCENT
	   Aux.TipoDoc AS Documento,
	   Aux.NroComprobante,
	   Aux.Fecha,
	   Aux.Debe,
	   Aux.Haber,
	   Aux.Id,
	   Aux.NroProveedor,
	   Aux.FechaEmision,
	   Aux.FechaAcceso,
	   Aux.IdEmpresa,
	   Empresa.RazonSocial
FROM (SELECT TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc,
			 (CASE WHEN ISNULL(F.NCompFactCompra, '') = '' THEN 'Nro. Interno ' + CONVERT(NVARCHAR, f.IdFacturaCompra)
				   ELSE 'Nro.Comprobante ' + f.BVFactCompra + '-' + f.NCompFactCompra
			  END) AS NroComprobante,
			  CONVERT(NVARCHAR, F.FechaEmision, 103) AS Fecha,
			  F.Total AS Debe,
			  0 AS Haber,
			  F.IdFacturaCompra AS Id,
			  F.NroProveedor,
			  F.FechaEmision,
			  F.FechaAcceso,
			  F.IdEmpresa
	  FROM FacturasCompra AS F INNER JOIN TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura
							   INNER JOIN TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento AND
										  F.IdTipoDocumento IN (4, 10, 11)
	  WHERE F.IdFormaPago = 2 AND
		    F.FechaAnulacion IS NULL

	  UNION  

	  SELECT TD.Descripcion AS TipoDoc,
			 'Nro. ' + CONVERT(NVARCHAR, P.IdPago) AS NroComprobante,
			 CONVERT(NVARCHAR, P.FechaEmision, 103) AS Fecha, 0 AS Debe,
			 P.MontoTotal AS Haber,
			 P.IdPago AS Id,
			 P.NroProveedor,
			 P.FechaEmision,
			 P.FechaAcceso,
			 P.IdEmpresa
	  FROM Pagos AS P INNER JOIN TiposDocFact AS TD ON TD.IdTipoDocumento = P.IdTipoDocumento
	  WHERE P.FechaBaja IS NULL

	  UNION

	  SELECT TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc,
			 (CASE WHEN ISNULL(F.NCompFactCompra, '') = '' THEN 'Nro. Interno ' + CONVERT(NVARCHAR, f.IdFacturaCompra)
				   ELSE 'Nro.Comprobante ' + f.BVFactCompra + '-' + f.NCompFactCompra
			  END) AS NroComprobante,
			 CONVERT(NVARCHAR, F.FechaEmision, 103) AS Fecha,
			 0 AS Debe,
			 F.Total AS Haber,
			 F.IdFacturaCompra AS Id,
			 F.NroProveedor,
			 F.FechaEmision,
			 F.FechaAcceso,
			 F.IdEmpresa
	  FROM FacturasCompra AS F INNER JOIN TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura
							   INNER JOIN TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento
	  WHERE F.IdTipoDocumento = 7 AND
			F.FechaAnulacion IS NULL AND
			F.IdFormaPago = 2) AS Aux INNER JOIN Empresa ON Aux.IdEmpresa = dbo.Empresa.IdEmpresa  
ORDER BY Aux.FechaEmision  

GO
/****** Object:  View [dbo].[VistaDetallePagoCancelacion]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VistaDetallePagoCancelacion]
AS
SELECT     aux.IdCancelacion, aux.idpago, aux.IdFacturacompra, aux.NroComp,
	aux.NroProveedor, aux.MontoTotal, aux.Total, aux.TotalSaldado, CF.MontoCancelacion, R.FechaEmision
FROM         
	(SELECT CF.IdCancelacion, CF.idpago, CF.IdFacturacompra, BVFactCompra + '-' + NCompFactCompra as NroComp,
	R.NroProveedor, R.MontoTotal, fv.Total, SUM(ISNULL(CF.MontoCancelacion, 0)) AS TotalSaldado
    FROM dbo.CancelacionFacturasCompra AS CF 
	INNER JOIN dbo.Pagos AS R ON R.IdPago = CF.idpago 
	INNER JOIN dbo.FacturasCompra AS fv ON fv.IdFacturaCompra = CF.IdFacturacompra
	WHERE (fv.IdFormaPago = 2) AND (fv.FechaAnulacion IS NULL)
    GROUP BY CF.IdCancelacion, CF.Idpago, CF.IdFacturacompra, BVFactCompra + '-' + NCompFactCompra, R.NroProveedor, R.MontoTotal, fv.Total, CF.MontoCancelacion) AS aux 
INNER JOIN dbo.CancelacionFacturascompra AS CF ON CF.IdCancelacion = aux.IdCancelacion 
INNER JOIN dbo.pagos AS R ON R.IdPago = aux.idpago










GO
/****** Object:  View [dbo].[VistaDetalleReciboCancelacion]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaDetalleReciboCancelacion]
AS
SELECT     aux.IdCancelacion, aux.IdRecibo, aux.IdFacturaVenta, 
	aux.NroCliente, aux.MontoTotal, aux.Total, aux.TotalSaldado, CF.MontoCancelacion, R.FechaEmision as FechaRecibo, cf.IdNotaCredito, aux.BVFact, aux.NCompFact, aux.FechaEmision as FechaFactura
FROM         
	(SELECT CF.IdCancelacion, CF.IdRecibo, CF.IdFacturaVenta, 
	R.NroCliente, R.MontoTotal, fv.Total, SUM(ISNULL(CF.MontoCancelacion, 0)) AS TotalSaldado, fv.BVFact, fv.NCompFact, fv.FechaEmision
	FROM          dbo.CancelacionFacturas AS CF
	INNER JOIN dbo.Recibos AS R ON R.IdRecibo = CF.IdRecibo 
	INNER JOIN dbo.FacturasVenta AS fv ON fv.IdFacturaVenta = CF.IdFacturaVenta
                       WHERE      (fv.IdFormaPago = 2) AND (fv.FechaAnulacion IS NULL)
	GROUP BY CF.IdCancelacion, CF.IdRecibo, CF.IdFacturaVenta, R.NroCliente, R.MontoTotal, fv.Total, CF.MontoCancelacion, fv.BVFact, fv.NCompFact, fv.FechaEmision) AS aux 
INNER JOIN dbo.CancelacionFacturas AS CF ON CF.IdCancelacion = aux.IdCancelacion 
INNER JOIN dbo.Recibos AS R ON R.IdRecibo = aux.IdRecibo

GO
/****** Object:  View [dbo].[VistaDiaGeneracionIntereses]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaDiaGeneracionIntereses]
AS
SELECT     TOP (100) PERCENT d.IdDiaGeneracion, d.Fecha, SUM(ISNULL(g.TotalInteres, 0)) AS TotalIntereses
FROM         dbo.DiaGeneracionInteres AS d LEFT OUTER JOIN
                      dbo.GeneracionInteres AS g ON d.IdDiaGeneracion = g.IdDiaGeneracion
GROUP BY d.IdDiaGeneracion, d.Fecha
ORDER BY d.Fecha DESC








GO
/****** Object:  View [dbo].[VistaEmpresa]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaEmpresa]
AS
SELECT     dbo.Empresa.RazonSocial, dbo.Empresa.NFantasia, dbo.Empresa.InicioActividades, dbo.Empresa.CUIT, dbo.Empresa.Logo, dbo.Empresa.Direccion, 
                      dbo.Empresa.Telefono, dbo.Empresa.Correo, dbo.Empresa.IIBB, dbo.Empresa.CondicionIva, dbo.CPostales.Localidad, dbo.Empresa.IdEmpresa
FROM         dbo.Empresa LEFT OUTER JOIN
                      dbo.CPostales ON dbo.Empresa.CodigoPostal = dbo.CPostales.CodigoPostal AND dbo.Empresa.SubCodigoPostal = dbo.CPostales.SubCodigoPostal








GO
/****** Object:  View [dbo].[VistaFacturasElectronicas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaFacturasElectronicas] as

select FE.*, FV.BVFact, TF.Descripcion as TipoFactura, tf.IdTipoFactura , FV.Total, fv.SubTotal, fv.TotalIva21, fv.TotalIva105, tdf.Descripcion as TipoDocumento,
tdf.IdTipoDocumento, fv.IdEmpresa, C.NroCliente, C.ApellidoyNombre
from FacturasElectronicas FE inner join Facturasventa FV on FE.idfacturaventa = fv.idfacturaventa INNER JOIN
tiposfactura TF on FV.idtipofactura = TF.idtipofactura INNER JOIN
tiposdocfact TDF on TDF.idtipodocumento = FV.idtipodocumento INNER JOIN 
Clientes C on c.NroCliente = FV.NroCliente








GO
/****** Object:  View [dbo].[VistaInteresesGenerados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaInteresesGenerados]
AS
SELECT     g.IdGeneracionInteres, g.IdFacturaVenta, g.IdDiaGeneracion, g.NroGeneracion, g.TotalInteres, (CASE WHEN isnull(Fv.NCompFact, '') 
                      = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) ELSE 'Nro.Comprobante ' + fv.BVFact + '-' + fv.NCompFact END) AS NroComprobante, 
                      c.ApellidoyNombre AS Cliente, d.Fecha
FROM         dbo.GeneracionInteres AS g INNER JOIN
                      dbo.FacturasVenta AS fv ON fv.IdFacturaVenta = g.IdFacturaVenta INNER JOIN
                      dbo.Clientes AS c ON c.NroCliente = fv.NroCliente INNER JOIN
                      dbo.DiaGeneracionInteres AS d ON d.IdDiaGeneracion = g.IdDiaGeneracion








GO
/****** Object:  View [dbo].[VistaLiquidaciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[VistaLiquidaciones] as 

select L.Fecha, L.IdLiquidacion, L.NroVendedor, ISNULL(LF.MontoBase, 0) as TotalFactura, V.ApellidoYNombre as Vendedor, 
LF.MontoComision, LF.IdFacturaVenta, FV.BVFact + '-' + FV.NCompFact as NroFactura, R.FechaEmision as FechaRecibo, 
C.ApellidoyNombre as Cliente
from Liquidaciones L LEFT JOIN
LiquidacionesFacturas LF on L.IdLiquidacion = LF.IdLiquidacion INNER JOIN
Vendedores V on V.NroVendedor = L.NroVendedor INNER JOIN
FacturasVenta FV on LF.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN 
Recibos R on R.IdRecibo = LF.IdRecibo INNER JOIN 
Clientes C on C.NroCliente = FV.NroCliente








GO
/****** Object:  View [dbo].[VistaMovimientosCaja]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaMovimientosCaja]
AS
SELECT     TMC.Descripcion AS TipoMov, (CASE WHEN CM.IdFacturaVenta <> NULL THEN fv.BVFact + '-' + fv.NCompFact ELSE '' END) AS NroFact, tp.Descripcion AS TipoPago, 
                      CM.DescripcionMov, CM.FechaMov, (CASE WHEN cm.IdTipoMovCaja = 1 THEN cmd.Monto ELSE 0 END) AS Ingreso, 
                      (CASE WHEN cm.IdTipoMovCaja = 2 THEN cmd.Monto ELSE 0 END) AS Egreso, CM.IdAperturaCaja, CM.IdMovimientoCaja, ISNULL(CONVERT(NVarchar, CM.FechaBaja,
                       103), '') AS FechaBaja
FROM         dbo.CajasMovimientos AS CM INNER JOIN
                      dbo.CajasMovimientosDetalle AS cmd ON cmd.IdMovimientoCaja = CM.IdMovimientoCaja INNER JOIN
                      dbo.TiposMovimientosCaja AS TMC ON TMC.IdTipoMovCaja = CM.IdTipoMovCaja INNER JOIN
                      dbo.TiposPagos AS tp ON tp.IdTipoPago = cmd.IdTipoPago LEFT OUTER JOIN
                      dbo.FacturasVenta AS fv ON fv.IdFacturaVenta = CM.IdFacturaVenta








GO
/****** Object:  View [dbo].[VistaNCCompSinSaldar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VistaNCCompSinSaldar]
AS
SELECT     fc.IdFacturaCompra, fc.NroProveedor, fc.BVFactCompra + '-' + fc.NCompFactCompra AS NroFactura, fc.IdEmpresa, fc.Total, 
				SUM(ISNULL(cfc.MontoCancelacion, 0)) AS TotalSaldado, (fc.Total - SUM(ISNULL(cfc.MontoCancelacion, 0))) as Pendiente,
                      fc.FechaEmision, fc.FechaAnulacion, cfc.IdNotaCredito, P.ApellidoyNombre, P.Direccion, fc.IdTipoFactura					  
FROM         FacturasCompra AS fc LEFT OUTER JOIN
                      CancelacionFacturasCompra AS cfc ON cfc.IdNotaCredito = fc.IdFacturaCompra AND cfc.FechaAnulacion IS NULL INNER JOIN
                      Proveedores P on fc.NroProveedor = P.NroProveedor
WHERE     (fc.IdFormaPago = 2) AND (fc.FechaAnulacion is null) AND (fc.IdTipoDocumento = 7) AND P.FechaBaja is null
GROUP BY fc.IdFacturaCompra, fc.NroProveedor, fc.BVFactCompra + '-' + fc.NCompFactCompra, fc.IdEmpresa, fc.Total, fc.FechaEmision, 
fc.FechaAnulacion, cfc.IdNotaCredito, P.ApellidoyNombre, P.Direccion, fc.IdTipoFactura
HAVING (fc.Total > SUM(ISNULL(cfc.MontoCancelacion, 0)))

GO
/****** Object:  View [dbo].[VistaOrdenesPedidosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaOrdenesPedidosDetalle] as 
select opd.IdOrdenPedido, opd.IdOrdenDetalle, opd.IdArticulo, ISNULL(a.DescCorta, opd.Artículo) as DescCorta, opd.Cantidad, opd.Precio, 
CASE when opd.IdArticulo is null then opd.CodigoProducto else a.CodigoProducto end as CodigoProducto, opd.UMedida
from OrdenesPedidosDetalle opd inner join OrdenesPedidos op 
on opd.IdOrdenPedido = op.IdOrdenPedido left join Articulos a 
on opd.IdArticulo = a.IdArticulo

GO
/****** Object:  View [dbo].[VistaPagos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaPagos]
AS
SELECT     TOP (100) PERCENT dbo.Pagos.IdPago, dbo.Pagos.NroProveedor, dbo.Pagos.MontoTotal, dbo.Pagos.FechaBaja, dbo.Proveedores.ApellidoyNombre, 
                      CONVERT(Nvarchar, dbo.Pagos.FechaEmision, 103) AS FechaEmision, ISNULL(dbo.Pagos.Concepto, '') AS Concepto, dbo.Pagos.FechaEmision AS Fecha, 
                      dbo.Pagos.IdEmpresa, dbo.Empresa.RazonSocial
FROM         dbo.Pagos INNER JOIN
                      dbo.Proveedores ON dbo.Pagos.NroProveedor = dbo.Proveedores.NroProveedor INNER JOIN
                      dbo.Empresa ON dbo.Pagos.IdEmpresa = dbo.Empresa.IdEmpresa
ORDER BY dbo.Pagos.IdPago








GO
/****** Object:  View [dbo].[VistaPagosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaPagosDetalle]
AS
SELECT        dbo.PagosDetalle.IdPago, dbo.PagosDetalle.Monto, dbo.TiposPagos.Descripcion AS TipoPago, dbo.PagosDetalle.IdPagoDetalle, ISNULL(CONVERT(Nvarchar, 
                         dbo.Cheques.NroCheque), '') AS NroCheque
FROM            dbo.PagosDetalle INNER JOIN
                         dbo.TiposPagos ON dbo.PagosDetalle.IdTipoPago = dbo.TiposPagos.IdTipoPago LEFT OUTER JOIN
                         dbo.Cheques ON dbo.PagosDetalle.IdCheque = dbo.Cheques.IdCheque








GO
/****** Object:  View [dbo].[VistaPagosxTP]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaPagosxTP]
AS
SELECT PR.ApellidoyNombre,
	   TP.Descripcion,
	   P.FechaEmision,
	   PD.Monto,
	   P.IdEmpresa,
	   P.IdPago,
	   P.FechaBaja
FROM PagosDetalle PD INNER JOIN Pagos P ON PD.IdPago = P.IdPago
					 INNER JOIN TiposPagos TP ON PD.IdTipoPago = TP.IdTipoPago
					 INNER JOIN Proveedores PR ON P.NroProveedor = PR.NroProveedor  

GO
/****** Object:  View [dbo].[VistaPreciosVenta]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VistaPreciosVenta]
AS
SELECT      art.IdArticulo, art.DescCorta, pv.FechaPrecios as FechaPrecio, ti.PorcentajeIVA, pv.PrecioContado, pv.PrecioFiado, 
					   pv.PrecioEspecial,  pv.PrecioContadoIva, pv.PrecioFiadoIva, pv.PrecioEspecialIva, pv.PrecioBase, 
					   pv.Bonificacion1, pv.Bonificacion2, pv.Bonificacion3, pv.Bonificacion4, pv.PorcentajeFlete, 
                       pv.PorcentajeDescarga, pv.PorcentajeGcia, pv.PorcentajeFiado, pv.Impuesto, ti.IdTipoIva
FROM         PreciosVenta pv INNER JOIN
                       Articulos art ON pv.IdArticulo =  art.IdArticulo INNER JOIN
                       TiposIva ti ON  pv.IdTipoIva =  ti.IdTipoIva			   

GO
/****** Object:  View [dbo].[VistaPresupuestos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VistaPresupuestos]
AS
SELECT     P.IdPresupuesto AS NroPresupuesto, CONVERT(Nvarchar, P.FechaPresupuesto, 103) AS Fecha, P.NombrePres, (CASE Isnull(CONVERT(Nvarchar, p.NroCliente), 'SI') 
                      WHEN 'SI' THEN P.Nombre ELSE C.ApellidoyNombre END) AS Cliente, P.Subtotal, P.Descuento, P.Total, P.NroCliente, P.Nombre, CONVERT(Decimal(7, 2), 
                      ROUND(P.Subtotal * (P.Descuento / 100), 2)) AS TotalDto, P.Direccion, P.FormaPago, P.Observaciones, P.PlazoEntrega, P.Telefono, P.ValidezOferta, 
                      P.IdEmpresa, p.IdFacturaVenta
FROM         dbo.Presupuestos AS P LEFT OUTER JOIN
                      dbo.Clientes AS C ON C.NroCliente = P.NroCliente

GO
/****** Object:  View [dbo].[VistaPresupuestosDetalles]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaPresupuestosDetalles]
AS
SELECT     ISNULL(dbo.Articulos.DescCorta, dbo.PresupuestosDetalles.Articulo) AS DescCorta, ISNULL(UM.Descripcion, dbo.PresupuestosDetalles.UMedida) AS UMedida, 
                      dbo.PresupuestosDetalles.Cantidad, dbo.PresupuestosDetalles.PrecioUnitario, dbo.PresupuestosDetalles.IdPresupuesto, dbo.PresupuestosDetalles.IdArticulo, 
                      dbo.PresupuestosDetalles.IdPresupuestoDetalle, dbo.PresupuestosDetalles.Cantidad * dbo.PresupuestosDetalles.PrecioUnitario AS TotalArt
FROM         dbo.PresupuestosDetalles LEFT OUTER JOIN
                      dbo.Articulos ON dbo.PresupuestosDetalles.IdArticulo = dbo.Articulos.IdArticulo LEFT OUTER JOIN
                      dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = dbo.Articulos.IdUnidadMedida








GO
/****** Object:  View [dbo].[VistaProveedores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaProveedores]
AS
SELECT        dbo.Proveedores.NroProveedor, dbo.Proveedores.TipoDocumento, dbo.Proveedores.NroDocumento, dbo.Proveedores.ApellidoyNombre, dbo.Proveedores.Direccion, 
                         dbo.Proveedores.Telefono, dbo.Proveedores.Email1, dbo.Proveedores.Email2, dbo.CPostales.Localidad, dbo.Provincias.Provincia, 
                         dbo.Proveedores.PaginaWeb
FROM            dbo.Proveedores INNER JOIN
                         dbo.CPostales ON dbo.Proveedores.CodigoPostal = dbo.CPostales.CodigoPostal AND 
                         dbo.Proveedores.SubCodigoPostal = dbo.CPostales.SubCodigoPostal INNER JOIN
                         dbo.Provincias ON dbo.CPostales.IdProvincia = dbo.Provincias.IdProvincia
WHERE			dbo.Proveedores.FechaBaja is null


GO
/****** Object:  View [dbo].[VistaProvVSArt]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaProvVSArt]
AS

SELECT Aux.IdArticulo,
 	   Aux.DescCorta,
       SUM(Aux.Cantidad) AS Cantidad,
       Aux.FechaUltPrecio,
       FCD.PrecioUnitario,
       Aux.Descripcion,
       Aux.NroProveedor,
       P.ApellidoyNombre
FROM FacturasCompra FC JOIN (SELECT A.IdArticulo,
									A.DescCorta,
									SUM(CASE FC2.IdTipoDocumento WHEN 7 THEN - FCD2.Cantidad
																 ELSE FCD2.Cantidad
										END) AS Cantidad,
									MAX(FP.FechaEmision) AS FechaUltPrecio,
									UM.Descripcion,
									P.NroProveedor
							 FROM Proveedores AS P INNER JOIN FacturasCompra AS FC2 ON FC2.NroProveedor = P.NroProveedor
												   INNER JOIN FacturasCompraDetalle AS FCD2 ON FCD2.IdFacturaCompra = FC2.IdFacturaCompra  
												   INNER JOIN Articulos AS A ON A.IdArticulo = FCD2.IdArticulo
												   INNER JOIN UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida
												   INNER JOIN (SELECT P2.NroProveedor,
																	  FC3.FechaEmision,
																	  FCD3.PrecioUnitario,
																	  FCD3.IdArticulo
															   FROM Proveedores P2 JOIN FacturasCompra FC3 ON P2.NroProveedor = FC3.NroProveedor
																				   JOIN FacturasCompraDetalle FCD3 ON FCD3.IdFacturaCompra = FC3.IdFacturaCompra
															   WHERE FC3.FechaEmision IN (SELECT MAX(FC4.FechaEmision) FechaEmision
																						  FROM Proveedores P2 JOIN FacturasCompra FC4 ON P2.NroProveedor = FC4.NroProveedor
																											   JOIN FacturasCompraDetalle FCD4 ON FCD4.IdFacturaCompra = FC4.IdFacturaCompra
																						  GROUP BY P2.NroProveedor,
																								   FCD4.IdArticulo) AND
																	 FCD3.IdArticulo IS NOT NULL
															   GROUP BY P2.NroProveedor,
																		FC3.FechaEmision,
																		FCD3.PrecioUnitario,
																		FCD3.IdArticulo) AS FP ON P.NroProveedor = FP.NroProveedor AND
																								  FC2.FechaEmision = FP.FechaEmision AND
																								  FCD2.PrecioUnitario = FP.PrecioUnitario AND
																								  FCD2.IdArticulo = FP.IdArticulo
							 WHERE A.IdArticulo IS NOT NULL AND
								   FC2.FechaAnulacion IS NULL
							 GROUP BY A.IdArticulo,
									  A.DescCorta,
									  UM.Descripcion,
									  P.NroProveedor) AS Aux ON FC.NroProveedor = Aux.NroProveedor AND
																FC.FechaEmision = Aux.FechaUltPrecio
					   JOIN FacturasCompraDetalle FCD ON FCD.IdArticulo = Aux.IdArticulo AND  
													     FC.IdFacturaCompra = FCD.IdFacturaCompra
					   JOIN Proveedores P ON FC.NroProveedor = P.NroProveedor
GROUP BY Aux.IdArticulo,
		 Aux.DescCorta,
		 Aux.FechaUltPrecio,
		 Aux.NroProveedor,
		 FCD.PrecioUnitario,
		 Aux.Descripcion,
		 FC.NroProveedor,
		 FCD.IdArticulo,
		 P.ApellidoyNombre

GO
/****** Object:  View [dbo].[VistaRankingArticulos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRankingArticulos]
AS
SELECT     TOP (100) PERCENT ROW_NUMBER() OVER (ORDER BY Sum(Aux.Cantidad) DESC) AS Posicion, Aux.IdArticulo, A.DescCorta, Sum(Aux.Cantidad) AS Unidades, 
Um.Descripcion AS UMedida, CONVERT(Decimal(11, 2), Sum(Aux.TotalFact)) AS TotalFact, Aux.IdEmpresa
FROM         (SELECT     IdArticulo, Cantidad, ROUND(Cantidad * PrecioUnitario, 2) AS TotalFact, FV.IdEmpresa
                       FROM          FacturasVenta FV JOIN
                                              FacturasVentaDetalle FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                       WHERE      IdArticulo IS NOT NULL AND FV.IdTipoDocumento = 1 AND FV.FechaAnulacion IS NULL
                       UNION
                       SELECT     RD.IdArticulo, RD.Cantidad, 0 AS TotalFact, R.IdEmpresa
                       FROM         Remitos R JOIN
                                             RemitosDetalle RD ON RD.IdRemito = R.IdRemito
                       WHERE     IdArticulo IS NOT NULL AND R.IdFactura IS NULL
                       UNION
                       SELECT     IdArticulo, - Cantidad, - (ROUND(Cantidad * PrecioUnitario, 2)) AS TotalFact, FV.IdEmpresa
                       FROM         FacturasVenta FV JOIN
                                             FacturasVentaDetalle FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                       WHERE     IdArticulo IS NOT NULL AND FV.IdTipoDocumento = 2 AND FV.FechaAnulacion IS NULL) Aux JOIN
                      Articulos A ON A.IdArticulo = Aux.IdArticulo JOIN
                      UnidadesMedida Um ON Um.IdUnidadMedida = A.IdUnidadMedida
GROUP BY Aux.IdArticulo, A.DescCorta, Um.Descripcion, Aux.IdEmpresa
ORDER BY Unidades DESC, TotalFact DESC








GO
/****** Object:  View [dbo].[VistaRankingArticulosconFechas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRankingArticulosconFechas]
AS
SELECT     TOP (100) PERCENT Aux.IdArticulo, A.DescCorta, SUM(Aux.Cantidad) AS Unidades, Um.Descripcion AS UMedida, CONVERT(Decimal(11, 2), SUM(Aux.TotalFact)) 
                      AS TotalFact, Aux.IdEmpresa, Aux.Fecha
FROM         (SELECT     FVD.IdArticulo, FVD.Cantidad, ROUND(FVD.Cantidad * FVD.PrecioUnitario, 2) AS TotalFact, FV.IdEmpresa, FV.FechaEmision AS Fecha
                       FROM          dbo.FacturasVenta AS FV INNER JOIN
                                              dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                       WHERE      (FVD.IdArticulo IS NOT NULL) AND (FV.IdTipoDocumento = 1) AND (FV.FechaAnulacion IS NULL)
                       UNION
                       SELECT     RD.IdArticulo, RD.Cantidad, 0 AS TotalFact, R.IdEmpresa, R.FechaRemito AS Fecha
                       FROM         dbo.Remitos AS R INNER JOIN
                                             dbo.RemitosDetalle AS RD ON RD.IdRemito = R.IdRemito
                       WHERE     (RD.IdArticulo IS NOT NULL) AND (R.IdFactura IS NULL)
                       UNION
                       SELECT     FVD.IdArticulo, - FVD.Cantidad AS Expr1, - ROUND(FVD.Cantidad * FVD.PrecioUnitario, 2) AS TotalFact, FV.IdEmpresa, FV.FechaEmision AS Fecha
                       FROM         dbo.FacturasVenta AS FV INNER JOIN
                                             dbo.FacturasVentaDetalle AS FVD ON FVD.IdFacturaVenta = FV.IdFacturaVenta
                       WHERE     (FVD.IdArticulo IS NOT NULL) AND (FV.IdTipoDocumento = 2) AND (FV.FechaAnulacion IS NULL)) AS Aux INNER JOIN
                      dbo.Articulos AS A ON A.IdArticulo = Aux.IdArticulo INNER JOIN
                      dbo.UnidadesMedida AS Um ON Um.IdUnidadMedida = A.IdUnidadMedida
GROUP BY Aux.IdArticulo, A.DescCorta, Um.Descripcion, Aux.IdEmpresa, Aux.Fecha
ORDER BY Unidades DESC, TotalFact DESC








GO
/****** Object:  View [dbo].[VistaRankingClientes]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRankingClientes]
AS
SELECT     TOP (100) PERCENT ROW_NUMBER() OVER (ORDER BY SUM(CASE WHEN FV.IdTipoDocumento = 1 THEN FV.Total ELSE - FV.Total END) DESC) AS Posicion, 
C.NroCliente, C.ApellidoyNombre, SUM(CASE WHEN FV.IdTipoDocumento = 1 THEN FV.Total ELSE - FV.Total END) AS Total, Fv.IdEmpresa
FROM         dbo.Clientes AS C INNER JOIN
                      dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY C.NroCliente, C.ApellidoyNombre, Fv.IdEmpresa
ORDER BY Total DESC








GO
/****** Object:  View [dbo].[VistaRankingClientesconFechas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRankingClientesconFechas]
AS
SELECT     TOP (100) PERCENT C.NroCliente, C.ApellidoyNombre, SUM(CASE WHEN FV.IdTipoDocumento = 1 THEN FV.Total ELSE - FV.Total END) AS Total, FV.IdEmpresa, 
                      FV.FechaEmision
FROM         dbo.Clientes AS C INNER JOIN
                      dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa, FV.FechaEmision
ORDER BY Total DESC








GO
/****** Object:  View [dbo].[VistaRecibos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRecibos]
AS
SELECT     TOP (100) PERCENT dbo.Recibos.IdRecibo, dbo.Clientes.ApellidoyNombre, dbo.Recibos.NroCliente, CONVERT(Nvarchar, dbo.Recibos.FechaEmision, 103) 
                      AS FechaEmision, dbo.Recibos.MontoTotal, ISNULL(CONVERT(Nvarchar, dbo.Recibos.FechaBaja, 103), '') AS FechaBaja, ISNULL(dbo.Recibos.Concepto, '') 
                      AS Concepto, dbo.Recibos.FechaEmision AS Fecha, dbo.Recibos.IdEmpresa, dbo.Empresa.RazonSocial
FROM         dbo.Recibos INNER JOIN
                      dbo.Clientes ON dbo.Recibos.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.Empresa ON dbo.Recibos.IdEmpresa = dbo.Empresa.IdEmpresa
ORDER BY dbo.Recibos.IdRecibo








GO
/****** Object:  View [dbo].[VistaRecibosDetalle]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaRecibosDetalle]
AS
SELECT     dbo.RecibosDetalle.IdReciboDetalle, dbo.TiposPagos.Descripcion AS TipoPago, dbo.RecibosDetalle.Monto, ISNULL(CONVERT(Nvarchar, dbo.Cheques.NroCheque), '') 
                      AS NroCheque, dbo.RecibosDetalle.IdRecibo, ISNULL(dbo.EmpTarjetas.Empresa, '') AS Empresa, ISNULL(dbo.RecibosDetalle.NroTarjeta, '') AS NroTarjeta
FROM         dbo.RecibosDetalle INNER JOIN
                      dbo.TiposPagos ON dbo.RecibosDetalle.IdTipoPago = dbo.TiposPagos.IdTipoPago LEFT OUTER JOIN
                      dbo.EmpTarjetas ON dbo.RecibosDetalle.IdEmpTarjeta = dbo.EmpTarjetas.IdEmpTarjeta LEFT OUTER JOIN
                      dbo.Cheques ON dbo.RecibosDetalle.IdCheque = dbo.Cheques.IdCheque








GO
/****** Object:  View [dbo].[VistaRemitosCab]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRemitosCab]
AS
SELECT     dbo.Remitos.IdRemito, dbo.Remitos.NroRemito, CONVERT(Nvarchar, dbo.Remitos.FechaRemito, 103) AS FechaRemito, dbo.Clientes.ApellidoyNombre, 
                      dbo.Remitos.Observaciones, ISNULL(CONVERT(nvarchar, dbo.Remitos.IdFactura), '') AS NroFactura, dbo.Remitos.NroCliente, 
                      dbo.Clientes.Direccion AS DireccionCliente, dbo.CPostales.Localidad AS LocalidadCliente, dbo.RegimenesImpositivos.Descripcion AS CondIvaCliente, 
                      dbo.Remitos.IdEmpresa, ISNULL(CONVERT(Nvarchar, dbo.Remitos.FechaAnulacion, 103), '') AS FechaAnulacion
FROM         dbo.Remitos INNER JOIN
                      dbo.Clientes ON dbo.Remitos.NroCliente = dbo.Clientes.NroCliente INNER JOIN
                      dbo.CPostales ON dbo.Clientes.CodigoPostal = dbo.CPostales.CodigoPostal AND dbo.Clientes.SubCodigoPostal = dbo.CPostales.SubCodigoPostal INNER JOIN
                      dbo.RegimenesImpositivos ON dbo.Clientes.IdRegimenImpositivo = dbo.RegimenesImpositivos.IdRegimenImpositivo








GO
/****** Object:  View [dbo].[VistaRemitosCompraCab]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRemitosCompraCab]
AS
SELECT     dbo.RemitosCompra.IdRemitoCompra, dbo.RemitosCompra.BVRemCompra + '-' + dbo.RemitosCompra.NroCompRemCompra AS NroRemito, 
                      dbo.RemitosCompra.NroProveedor, dbo.RemitosCompra.Observaciones, dbo.Proveedores.ApellidoyNombre, CONVERT(Nvarchar, 
                      dbo.RemitosCompra.FechaRemitoCompra, 103) AS FechaRemitoCompra, ISNULL(dbo.FacturasCompra.BVFactCompra + ' - ' + dbo.FacturasCompra.NCompFactCompra, 
                      '') AS NroFactura, dbo.FacturasCompra.IdFacturaCompra, dbo.RemitosCompra.IdEmpresa
FROM         dbo.RemitosCompra INNER JOIN
                      dbo.Proveedores ON dbo.Proveedores.NroProveedor = dbo.RemitosCompra.NroProveedor LEFT OUTER JOIN
                      dbo.FacturasCompra ON dbo.RemitosCompra.IdFacturaCompra = dbo.FacturasCompra.IdFacturaCompra








GO
/****** Object:  View [dbo].[VistaRemitosCompraDet]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaRemitosCompraDet]
AS
SELECT        dbo.RemitosDetalleCompra.IdRemitoCompra, dbo.RemitosDetalleCompra.IdArticulo, dbo.RemitosDetalleCompra.Cantidad, dbo.Articulos.DescCorta, 
                         dbo.UnidadesMedida.Descripcion AS UMedida, 0 AS Total
FROM            dbo.RemitosDetalleCompra INNER JOIN
                         dbo.Articulos ON dbo.RemitosDetalleCompra.IdArticulo = dbo.Articulos.IdArticulo INNER JOIN
                         dbo.UnidadesMedida ON dbo.Articulos.IdUnidadMedida = dbo.UnidadesMedida.IdUnidadMedida








GO
/****** Object:  View [dbo].[VistaRemitosDet]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaRemitosDet]
AS
SELECT        dbo.RemitosDetalle.IdArticulo, dbo.Articulos.DescCorta, dbo.RemitosDetalle.Cantidad, dbo.UnidadesMedida.Descripcion AS UMedida, CONVERT(Nvarchar, 
                         dbo.RemitosDetalle.FechaLinea, 103) AS FechaLinea, dbo.RemitosDetalle.IdRemito
FROM            dbo.RemitosDetalle INNER JOIN
                         dbo.Articulos ON dbo.RemitosDetalle.IdArticulo = dbo.Articulos.IdArticulo INNER JOIN
                         dbo.UnidadesMedida ON dbo.UnidadesMedida.IdUnidadMedida = dbo.Articulos.IdUnidadMedida








GO
/****** Object:  View [dbo].[VistaRemitosnofactdeProv]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VistaRemitosnofactdeProv]
AS
SELECT     r.IdRemitoCompra, r.BVRemCompra + '-' + r.NroCompRemCompra AS NroRemito, CONVERT(Nvarchar, r.FechaRemitoCompra, 103) AS FechaRemitoCompra, 
                      p.NroProveedor, r.IdEmpresa
FROM         dbo.RemitosCompra AS r INNER JOIN
                      dbo.Proveedores AS p ON p.NroProveedor = r.NroProveedor
WHERE     (r.IdFacturaCompra IS NULL)








GO
/****** Object:  View [dbo].[VistaRemitosXFacturados]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VistaRemitosXFacturados] as
Select rxf.IdFacturacion,
fv.IdFacturaVenta as IdRemito,
fv.BVFact + '-' + fv.NCompFact as NroRemito, 
cliRem.ApellidoyNombre as ClienteRemito,
fv.FechaEmision as FechaRemito, 
fv.Total as TotalRemito, 
fv2.IdFacturaVenta as IdFacturaVenta,
ISNULL(fv2.BVFact + '-' + fv2.NCompFact, 'No impresa') as NroFactura,
cliFact.ApellidoyNombre as ClienteFactura,
fv2.FechaEmision as FechaFactura, 
fv2.Total as TotalFactura,
fv.Observaciones as Observaciones

from
FacturasVenta fv join
RemitosXfacturados rxf on fv.IdFacturaVenta = rxf.IdFacturaVenta join 
Clientes cliRem on fv.NroCliente = cliRem.NroCliente join 
FacturasVenta fv2 on rxf.IdFacturaFinal = fv2.IdFacturaVenta join
Clientes cliFact on fv2.NroCliente = cliFact.NroCliente

GO
/****** Object:  View [dbo].[VistaRemitosXSinFacturar]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VistaRemitosXSinFacturar] as
select * from FacturasVenta where IdTipoDocumento = 8 and IdFacturaVenta not in 
(select IdFacturaVenta from RemitosXfacturados)

GO
/****** Object:  View [dbo].[VistaStockArticulos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaStockArticulos]
AS
SELECT     A.IdArticulo AS 'Nro.Art', A.DescCorta AS Artículo, A.StockActual, A.CantidadMinima, UM.Descripcion AS 'U.Medida', CONVERT(NVarchar, A.UltimaActStock, 103) 
                      AS UltAct
FROM         dbo.Articulos AS A INNER JOIN
                      dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida
WHERE     (A.LlevarStock = 1)








GO
/****** Object:  View [dbo].[VistaTotalesCancelacionCobros]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[VistaTotalesCancelacionCobros] as
Select R.NroCliente, R.IdRecibo, R.MontoTotal, R.FechaEmision, ISNULL(SUM(CF.MontoCancelacion), 0) as MontoPagado, R.MontoTotal - ISNULL(SUM(CF.MontoCancelacion), 0) as MontoDisponible
from Recibos R LEFT JOIN
CancelacionFacturas CF on R.IdRecibo = CF.IdRecibo
--where CF.IdPago is not null
group by R.IdRecibo, R.MontoTotal, R.NroCliente, R.FechaEmision








GO
/****** Object:  View [dbo].[VistaTotalesCancelacionPagos]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VistaTotalesCancelacionPagos] as
Select P.NroProveedor, P.IdPago, P.MontoTotal, P.FechaEmision, ISNULL(SUM(CF.MontoCancelacion), 0) as MontoPagado, P.MontoTotal - ISNULL(SUM(CF.MontoCancelacion), 0) as MontoDisponible
from Pagos P LEFT JOIN
CancelacionFacturasCompra CF on P.IdPago = CF.IdPago
--where CF.IdPago is not null
group by P.IdPago, P.MontoTotal, P.NroProveedor, P.FechaEmision






GO
/****** Object:  View [dbo].[VistaTotalesNotaCredito]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[VistaTotalesNotaCredito] as
Select FV.IdTipoFactura, FV.BVReferencia + '-' + FV.NroCompFactReferencia as NroFactura, SUM(FV.Total) as TotalNC
From FacturasVenta FV
Where FV.IdTipoDocumento = 2
Group By FV.BVReferencia + '-' + FV.NroCompFactReferencia, FV.IdTipoFactura








GO
/****** Object:  View [dbo].[VistaTotalesRetenciones]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[VistaTotalesRetenciones] as

Select P.NroProveedor, SUM(MontoRetencion) as MontoTotal, Month(FechaCalculo) as Mes, YEAR(FechaCalculo) as Año, p.ApellidoyNombre
from RetencionesGcia R inner join Proveedores P on p.NroProveedor = r.NroProveedor 
group by P.NroProveedor, Month(FechaCalculo), YEAR(fechacalculo), P.ApellidoyNombre









GO
/****** Object:  View [dbo].[VistaUsuarios]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaUsuarios]
AS
SELECT        U.IdUser, U.NombreUser, U.PassUser, Tu.Tipo, ISNULL(CONVERT(Nvarchar, U.FechaBaja, 103), '') AS FechaBaja, U.IdTipoUser
FROM            dbo.Usuarios AS U INNER JOIN
                         dbo.TiposUsuarios AS Tu ON Tu.IdTipoUser = U.IdTipoUser








GO
SET IDENTITY_INSERT [dbo].[Bancos] ON 

INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (1, N'Macro')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (2, N'Nación')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (3, N'Provincia')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (4, N'Santander Río')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (5, N'HSBC')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (6, N'Francés')
INSERT [dbo].[Bancos] ([IdBanco], [Descripcion]) VALUES (7, N'Santa Cruz')
SET IDENTITY_INSERT [dbo].[Bancos] OFF
GO
SET IDENTITY_INSERT [dbo].[CajasDistribuciones] ON 

INSERT [dbo].[CajasDistribuciones] ([CajaDistribucionId], [Descipcion], [Longitud], [Latitud], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1, N'Caja Av. 25 de Mayo', NULL, NULL, CAST(N'2022-04-26' AS Date), 1)
INSERT [dbo].[CajasDistribuciones] ([CajaDistribucionId], [Descipcion], [Longitud], [Latitud], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (2, N'Caja Calle 123', NULL, NULL, CAST(N'2022-04-25' AS Date), 1)
SET IDENTITY_INSERT [dbo].[CajasDistribuciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Clientes] ON 

INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (1, N'DNI', 12123436, N'Cliente Eventual', N'-', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2022-04-09T10:36:08.1730000' AS DateTime2), N'dbo', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (2, N'DNI', 123123123, N'jose', N'123812askdjbasd', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (3, N'DNI', 123123123, N'jose', N'123123123xadasdasd', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (4, N'DNI', 35624149, N'12312asdasdasd', N'12312asdsd', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (5, N'DNI', 35624149, N'jose', N'12312asdsda', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (6, N'DNI', 67732987, N'jose 2', N'asdklasdkl', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (7, N'DNI', 1288838883, N'javi', N'asdklasndlkn', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (8, N'DNI', 129939993, N'nachjo', N'12312asdasd', 3531, 1, NULL, 4, N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Clientes] ([NroCliente], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [FechaNacimiento], [IdRegimenImpositivo], [Telefono], [Email1], [Email2], [Cuit0], [Cuit1], [Cuit2], [UsrBaja], [FechaBaja], [FechaAcceso], [UsrAcceso], [IdObservación], [MensajeCuenta], [SaldoExcedido], [CuentaCerrada], [Comentario]) VALUES (9, N'DNI', 34234234, N'asdasdasdasd', N'asdasdasdasd', 3531, 1, NULL, 4, N'asdasd', N'asdasdasd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Clientes] OFF
GO
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServicios] ON 

INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1, 1, 1, 1, 1002, CAST(N'2022-04-25T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (2, 1, 2, 1, 1002, CAST(N'2022-04-24T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1002, 5, 1, 1, 1002, CAST(N'2022-05-24T11:47:20.990' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1003, 6, 1, 1, NULL, CAST(N'2022-05-24T11:48:35.307' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1004, 7, 1, 1, 1002, CAST(N'2022-05-24T11:50:37.417' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1005, 8, 1, 1, 1002, CAST(N'2022-05-24T11:52:47.397' AS DateTime), 1)
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1006, 9, 1, 1, 1002, CAST(N'2022-05-30T09:11:20.777' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServicios] OFF
GO
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ON 

INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1, 2, 1, CAST(N'2022-04-20T00:00:00.000' AS DateTime), 1, N'creacion de estado por creacion de cliente')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (2, 2, 2, CAST(N'2022-04-28T00:00:00.000' AS DateTime), 1, N'baja, no quiso el servicio')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1002, 2, 1, CAST(N'2022-05-03T07:30:15.833' AS DateTime), 1, N'quiso el servicio')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1003, 2, 1002, CAST(N'2022-05-03T07:42:07.540' AS DateTime), 1, N'suspendido')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1004, 1, 1, CAST(N'2022-02-02T00:00:00.000' AS DateTime), 1, N'Action')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1005, 1, 1002, CAST(N'2022-05-24T09:16:13.907' AS DateTime), 1, N'Cliente Suspendido por falta de pago. Adeuda 2 facturas.')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1006, 1002, 1, CAST(N'2022-05-24T11:47:28.753' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1007, 1004, 1, CAST(N'2022-05-24T11:50:38.320' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1008, 1004, 1, CAST(N'2022-05-24T11:50:39.313' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1009, 1005, 1, CAST(N'2022-05-24T11:52:47.427' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1010, 1005, 1, CAST(N'2022-05-24T11:52:47.463' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1011, 1006, 1, CAST(N'2022-05-30T09:11:20.810' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1012, 1006, 1, CAST(N'2022-05-30T09:11:33.433' AS DateTime), 1, NULL)
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1013, 1004, 1002, CAST(N'2022-05-31T16:19:30.693' AS DateTime), 1, N'Cliente Suspendido por falta de pago. Adeuda 2 facturas.')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1014, 1005, 1002, CAST(N'2022-05-31T16:19:30.890' AS DateTime), 1, N'Cliente Suspendido por falta de pago. Adeuda 2 facturas.')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1015, 1006, 1002, CAST(N'2022-05-31T16:19:30.900' AS DateTime), 1, N'Cliente Suspendido por falta de pago. Adeuda 2 facturas.')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Observaciones]) VALUES (1016, 1002, 1002, CAST(N'2022-06-01T10:58:15.590' AS DateTime), 1, N'Cliente Suspendido por falta de pago. Adeuda 2 facturas.')
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] OFF
GO
SET IDENTITY_INSERT [dbo].[CondicionesPago] ON 

INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (1, N'15 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (2, N'30 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (3, N'45 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (4, N'60 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (5, N'90 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (6, N'180 días', NULL)
INSERT [dbo].[CondicionesPago] ([IdCondicionPago], [Descripcion], [FechaBaja]) VALUES (7, N'210 días', NULL)
SET IDENTITY_INSERT [dbo].[CondicionesPago] OFF
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5, 3, N'ARENAZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1000, 1, N'CAPITAL FEDERAL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1001, 1, N'BUENOS AIRES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1002, 1, N'MICROCENTRITO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1185, 0, N'CIUDAD AUTONOMA BUENOS AIRES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1301, 1, N'BS AS MICROCENTRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1317, 1, N'BS.AS. MICROCENTRO 1', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1346, 1, N'BS.AS. MICROCENTRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1602, 1, N'FLORIDA / ARISTOBULO DEL VALLE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1603, 1, N'VILLA MARTELLI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1605, 1, N'MUNRO / CARAPACHAY', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1607, 1, N'VILLA ADELINA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1609, 1, N'BOULOGNE SUR MER', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1611, 1, N'DON TORCUATO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1613, 1, N'LOS POLVORINES / VILLA DE MAYO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1615, 1, N'GRAND BOURG', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1617, 1, N'GENERAL PACHECO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1618, 1, N'EL TALAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1619, 1, N'GARIN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1625, 1, N'ESCOBAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1629, 1, N'PILAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1635, 1, N'PRESIDENTE DERQUI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1636, 1, N'OLIVOS / LA LUCILA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1638, 1, N'VICENTE LOPEZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1640, 1, N'MARTINEZ / ACASSUSO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1642, 1, N'SAN ISIDRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1643, 1, N'BECCAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1644, 1, N'VICTORIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1646, 1, N'SAN FERNANDO / VIRREYES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1648, 1, N'RINCON DE MILBERG / TIGRE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1648, 3, N'BARRIOS DEL TALAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1648, 12, N'BARRIOS ALTOS DEL TALAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1650, 1, N'VILLA MAIPU / BS.AS. MICROCENT', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1651, 1, N'SAN ANDRES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1653, 1, N'VILLA BALLESTER', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1655, 1, N'JOSE LEON SUAREZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1657, 1, N'VILLA LOMA HERMOSA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1661, 1, N'BELLA VISTA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1663, 1, N'SAN MIGUEL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1665, 1, N'JOSE C. PAZ / EL CRUCE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1667, 1, N'TORTUGUITAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1669, 1, N'LA LOMA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1672, 1, N'VILLA LYNCH', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1674, 1, N'SAENZ PE¥A', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1676, 1, N'SANTOS LUGARES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1678, 1, N'CASEROS-PDO.3 DE FEBRERO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1682, 1, N'MARTIN CORONADO / VILLA BOSCH', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1684, 1, N'EL PALOMAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1686, 1, N'HURLINGHAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1688, 1, N'VILLA TESEI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1702, 1, N'JOSE INGENIEROS / CIUDADELA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1704, 1, N'RAMOS MEJIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1706, 1, N'HAEDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1708, 1, N'Moron', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1712, 1, N'CASTELAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1714, 1, N'ITUZAINGO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1716, 1, N'LIBERTAD', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1718, 1, N'SAN ANTONIO DE PADUA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1722, 1, N'PARQUE SAN MARTIN / MERLO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1727, 1, N'MARCOS PAZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1737, 1, N'GENERAL LAS HERAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1741, 1, N'GRAL.LAS HERAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1742, 1, N'PASO DEL REY', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1744, 1, N'MORENO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1748, 1, N'GENERAL RODRIGUEZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1752, 1, N'LOMAS DEL MIRADOR / VILLA INSU', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1754, 1, N'SAN JUSTO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1755, 1, N'RAFAEL CASTILLO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1757, 1, N'LA FERRERE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1759, 1, N'GONZALEZ CATAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1765, 1, N'ISIDRO CASANOVA / BARRIO SAN J', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1766, 1, N'LA TABLADA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1768, 1, N'VILLA MADERO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1770, 1, N'TAPIALES / ALDO BONZI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1772, 1, N'VILLA CELINA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1778, 1, N'GENERAL GUEMES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1802, 1, N'AEROPUERTO EZEIZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1804, 1, N'EZEIZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1806, 1, N'TRISTAN SUAREZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1814, 1, N'CA¥UELAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1822, 1, N'VALENTIN ALSINA / VILLA DIAMAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1824, 1, N'VILLA INDUSTRIALES / LANUS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1825, 1, N'MONTE CHINGOLO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1826, 1, N'REMEDIOS DE ESCALADA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1828, 1, N'BANFIELD', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1832, 1, N'LOMAS DE ZAMORA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1834, 1, N'TEMPERLEY / PASCO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1836, 1, N'LLAVALLOL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1838, 1, N'LUIS GUILLON', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1842, 1, N'E.ECHEVERRIA / MONTE GRANDE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1846, 1, N'ALMIRANTE BROWM / ADROGUE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1847, 1, N'VILLA CALZADA / RAFAEL CALZADA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1852, 1, N'BURZACO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1854, 1, N'LONGCHAMPS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1856, 1, N'GLEW', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1862, 1, N'GUERNICA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1864, 1, N'ALEJANDRO KORN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1865, 1, N'SAN VICENTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1870, 1, N'GERLI -PARTIDO AVELLANEDA- / A', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1871, 1, N'DOCK SUD', 2)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1872, 1, N'SARANDI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1874, 1, N'VILLA DOMINICO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1875, 1, N'WILDE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1876, 1, N'BERNAL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1878, 1, N'QUILMES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1879, 1, N'QUILMES OESTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1881, 1, N'SAN FRANCISCO SOLANO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1882, 1, N'EZPELETA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1884, 1, N'VILLA MITRE / BERAZATEGUI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1888, 1, N'FLORENCIO VARELA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1894, 1, N'VILLA ELISA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1896, 1, N'CITY BELL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1897, 1, N'MANUEL GONET', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1900, 1, N'LA PLATA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1901, 1, N'LISANDRO OLMOS / LA GRANJA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1903, 1, N'MELCHOR ROMERO / ABASTO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1911, 1, N'GENERAL MANSILLA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1913, 1, N'MAGDALENA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1917, 1, N'VERONICA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1923, 1, N'BERISSO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1925, 1, N'ENSENADA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1980, 1, N'CORONEL BRANDSEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (1987, 1, N'GENERAL PAZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2000, 1, N'ROSARIO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2101, 1, N'VILLA AMELIA / ALBARELLOS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2103, 1, N'CORONEL BOGADO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2105, 1, N'CORONEL DOMINGUEZ / CA¥ADA RIC', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2106, 1, N'URANGA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2107, 1, N'ALVAREZ / SOLDINI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2108, 3, N'SOLDINI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2109, 0, N'ACEBAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2109, 1, N'PAVON ARRIBA / ACEBAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2111, 1, N'SANTA TERESA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2113, 1, N'PEYRANO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2115, 1, N'MAXIMO PAZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2117, 1, N'ALCORTA-DPTO.CONSTITUCION', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2119, 1, N'PUEBLO MU¥OZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2121, 1, N'PEREZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2123, 1, N'PUJATO / ZAVALLA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2124, 1, N'VILLA GDOR.GALVEZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2126, 1, N'PUEBLO ESTHER / ALVEAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2128, 1, N'ARROYO SECO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2130, 1, N'FUENTES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2132, 1, N'FUNES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2134, 1, N'ROLDAN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2136, 1, N'SAN JERONIMO SUD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2138, 1, N'CARCARA¥A', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2142, 1, N'IBARLUCEA / LA SALADA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2144, 1, N'TOTORAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2146, 1, N'CLASON / SAN GENARO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2147, 1, N'SAN GENARO NORTE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2148, 1, N'CASAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2148, 2, N'CENTENO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2152, 1, N'GRANADERO BAIGORRIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2154, 1, N'CAPITAN BERMUDEZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2156, 1, N'FRAY LUIS BELTRAN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2170, 1, N'CASILDA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2171, 1, N'FUENTES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2173, 1, N'CHABAS / VILLADA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2175, 1, N'VILLA MUGUETA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2177, 1, N'BIGAND', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2179, 1, N'BOMBAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2181, 1, N'LOS MOLINOS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2183, 1, N'AREQUITO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2185, 1, N'SAN JOSE DE LA ESQUINA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2187, 1, N'ARTEAGA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2189, 1, N'CRUZ ALTA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2200, 1, N'SAN LORENZO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2202, 1, N'PUERTO GRAL. SAN MARTIN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2204, 1, N'TIMBUES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2206, 1, N'OLIVEROS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2208, 1, N'MACIEL / PUERTO GABOTO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2212, 1, N'MONJE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2214, 1, N'ANDINO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2216, 1, N'SERODINO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2217, 1, N'ALDAO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2218, 1, N'CARRIZALES / CLARKE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2222, 1, N'DIAZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2240, 1, N'CORONDA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2246, 1, N'BARRANCAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2248, 1, N'BERNARDO DE IRIGOYEN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2248, 5, N'CASALEGNO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2252, 1, N'GALVEZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2253, 1, N'GESSLER', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2255, 1, N'LOPEZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2257, 1, N'COLONIA BELGRANO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2258, 1, N'SANTA CLARA DE BUENA VISTA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2300, 1, N'RAFAELA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2300, 2, N'Bella Italia', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 1, N'VILA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 2, N'RAMONA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 3, N'SUSANA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 4, N'COLONIA FIDELA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 5, N'EGUSQUIZA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 6, N'PUEBLO MARINI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 8, N'SAN ANTONIO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2301, 15, N'SAN ANTONIO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2302, 1, N'RAMONA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2303, 1, N'ANGELICA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2305, 1, N'LEHMANN', 1)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2306, 1, N'VILA / VILA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2307, 1, N'ATALIVA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2307, 2, N'GALISTEO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2309, 1, N'HUMBERTO PRIMO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 1, N'VIRGINIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 2, N'COLONIA MAUA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 3, N'ITUZAINGO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 5, N'CONSTANZA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 25, N'CAPIVAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2311, 26, N'CAPIVARA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2313, 1, N'MOISES VILLE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 1, N'COLONIA ALDAO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 2, N'EUSEBIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 3, N'HUGENTOBLER', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 4, N'COLONIA BICHA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 5, N'CASABLANCA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2317, 6, N'COLONIA BIGAND', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2318, 1, N'SA PEREIRA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2322, 1, N'SUNCHALES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2322, 2, N'RAQUEL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2322, 3, N'El Cisne', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2324, 1, N'TACURAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2324, 2, N'TACURALES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2325, 1, N'PALACIOS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2326, 1, N'LAS PALMERAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2326, 2, N'COLONIA BOSSI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2340, 1, N'CERES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2340, 12, N'NUEVA CERES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2340, 13, N'NUEVA CERES', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2341, 1, N'COL. ALPINA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2341, 23, N'NUEVA CERES', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2342, 0, N'CURUPAITY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2342, 1, N'MONIGOTES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2344, 1, N'ARRUFO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2345, 1, N'VILLA TRINIDAD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2347, 1, N'SAN GUILLERMO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2347, 2, N'COLONIA ROSA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2349, 1, N'SUARDI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2352, 1, N'AMBROSETTI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2352, 2, N'HERSILIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2353, 1, N'CARLOS PELLEGRINI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2354, 1, N'SELVA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2356, 1, N'PINTO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2400, 1, N'SAN FRANCISCO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2405, 1, N'SANTA CLARA DE SAGUIER', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2405, 10, N'COLONIA CELLO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2407, 1, N'CLUCELLAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2409, 1, N'ZENON PEREYRA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2411, 1, N'LUXARDO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2413, 1, N'FREYRE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2415, 1, N'PORTE¥A', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2417, 1, N'LA PAQUITA / ALTOS DE CHIPION', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2417, 2, N'ALTOS DE CHIPION', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2419, 1, N'BRINKMANN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2419, 3, N'SEEBER', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2419, 5, N'COLONIA VIGNAUD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2419, 6, N'COLONIA VIGNAUD', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2421, 1, N'MORTEROS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2423, 1, N'COLONIA PROSPERIDAD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2424, 1, N'COLONIA MARINA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2424, 2, N'DEVOTO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2426, 1, N'LA FRANCIA / LA FRANCIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2432, 1, N'EL TIO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2433, 1, N'VILLA CONCEPCION DEL TIO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2434, 1, N'ARROYITO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2435, 1, N'LA TORDILLA NORTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2436, 1, N'TRANSITO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2438, 1, N'FRONTERA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2440, 1, N'SASTRE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2441, 1, N'LAS PETACAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2445, 1, N'MARIA JUANA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2447, 1, N'SAN VICENTE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2449, 1, N'SAN MARTIN DE LAS ESCOBAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2451, 1, N'LAS PETACAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2451, 2, N'SAN JORGE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2453, 1, N'LAS PETACAS / CARLOS PELLEGRIN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2454, 1, N'CA¥ADA ROSQUIN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2456, 1, N'ESMERALDA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2500, 1, N'CA¥ADA DE GOMEZ', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2501, 1, N'BUSTINZA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2503, 1, N'VILLA ELOISA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2505, 1, N'LAS PAREJAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2506, 1, N'CORREA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2508, 1, N'ARMSTRONG', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2512, 1, N'TORTUGAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2520, 1, N'LAS ROSAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2521, 1, N'MONTES DE OCA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2523, 1, N'BOUQUET', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2525, 1, N'SAIRA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2527, 1, N'MARIA SUSANA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2529, 1, N'PIAMONTE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2531, 1, N'LANDETA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2533, 1, N'LOS CARDOS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2535, 1, N'EL TREBOL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2550, 1, N'BELL VILLE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2553, 1, N'JUSTINIANO POSSE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2555, 1, N'ORDO¥EZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2557, 1, N'IDIAZABAL', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2559, 1, N'SAN ANTONIO DE LITIN / CINTRA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2563, 1, N'NOETINGER', 3)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2566, 1, N'SAN MARCOS SUD', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2568, 1, N'MORRISON', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2572, 1, N'BALLESTEROS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2580, 1, N'MARCOS JUAREZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2581, 1, N'LOS SURGENTES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2583, 1, N'GENERAL BALDISERA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2585, 1, N'CAMILO ALDAO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2587, 1, N'INRIVILLE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2589, 1, N'MONTE BUEY', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2592, 1, N'GENERAL ROCA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2594, 1, N'LEONES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2600, 1, N'VENADO TUERTO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2601, 1, N'MURPHY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2603, 1, N'CHAPUY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2605, 1, N'SANTA ISABEL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2607, 1, N'VILLA CA¥AS-CGO.BCO.JUNIN 112-', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2607, 5, N'VILLA CAÑAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2609, 1, N'MARIA TERESA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2613, 1, N'SAN GREGORIO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2615, 1, N'SAN EDUARDO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2617, 1, N'SANCTI SPIRITU', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2618, 1, N'CARMEN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2622, 1, N'MAGGIOLO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2624, 1, N'ARIAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2625, 1, N'CAVANAGH', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2627, 1, N'GUATIMOZIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2630, 1, N'FIRMAT', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2633, 1, N'CHOVET', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2635, 1, N'CA¥ADA DEL UCLE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2637, 1, N'LOS QUIRQUINCHOS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2639, 1, N'BERABEVU / GODEKEN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2643, 1, N'CHA¥AR LADEADO / CAFERATTA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2645, 1, N'CORRAL DE BUSTOS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2650, 1, N'CANALS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2651, 1, N'PUEBLO ITALIANO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2655, 1, N'WENCESLAO ESCALANTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2657, 1, N'LABORDE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2659, 1, N'MONTE MAIZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2661, 1, N'ISLA VERDE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2662, 1, N'ALEJO LEDESMA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2670, 1, N'LA CARLOTA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2671, 1, N'SANTA EUFEMIA / VIAMONTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2675, 1, N'CHAZON', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2677, 1, N'UCACHA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2679, 1, N'PASCANAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2681, 1, N'ETRURIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2686, 1, N'ALEJANDRO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2700, 1, N'PERGAMINO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2701, 1, N'GENERAL GELLY / RANCAGUA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2703, 1, N'ESTACION CARABELAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2705, 1, N'ROJAS -CGO.BCO.JUNIN 112- / RO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2713, 1, N'MANUEL OCAMPO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2715, 1, N'EL SOCORRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2717, 1, N'GUERRICO / ACEVEDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2718, 1, N'MARIANO ALFONSO / URQUIZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2720, 1, N'COLON', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2722, 1, N'WHEELWRIGHT', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2723, 1, N'JUNCAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2725, 1, N'HUGUES', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2726, 1, N'LABORDEROY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2728, 1, N'MELINCUE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2729, 1, N'CARRERAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2732, 1, N'ELORTONDO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2740, 1, N'ARRECIFES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2741, 1, N'SALTO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2743, 1, N'ARROYO DULCE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2752, 1, N'CAPITAN SARMIENTO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2760, 1, N'SAN ANTONIO DE ARECO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2800, 1, N'ZARATE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2802, 1, N'OTAMENDI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2804, 1, N'CAMPANA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2806, 1, N'LIMA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2812, 1, N'CAPILLA DEL SE¥OR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2814, 1, N'LOS CARDALES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2820, 1, N'GUALEGUAYCHU', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2823, 1, N'VILLA PARANACITO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2826, 1, N'URDINARRAIN / ALDEA SAN ANTONI', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2840, 1, N'GUALEGUAY / SAN JOSE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2843, 1, N'GENERAL GALARZA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2845, 1, N'MANSILLA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2846, 1, N'IBICUY / ESTACION HOLT', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2854, 1, N'LARROQUE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2900, 1, N'SAN NICOLAS / GENERAL SAVIO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2901, 1, N'LA EMILIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2905, 1, N'GENERAL ROJO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2907, 1, N'CONESA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2909, 1, N'JUAN B. MOLINA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2914, 1, N'VILLA RAMAYO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2915, 1, N'RAMALLO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2918, 1, N'PAVON / EMPALME VILLA CONSTITU', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2919, 1, N'VILLA CONSTITUCION', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2921, 1, N'GODOY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2930, 1, N'SAN PEDRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2933, 1, N'PEREZ MILLAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2935, 1, N'SANTA LUCIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2942, 1, N'BARADERO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (2946, 1, N'GOBERNADOR CASTRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3000, 1, N'SANTA FE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3003, 1, N'HELVECIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3005, 1, N'SAN JAVIER', 1)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3009, 1, N'SAN JERONIMO DEL SAUCE / FRANC', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3011, 1, N'SA PEREIRA / SAN JERONIMO NORT', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3012, 1, N'S. A. PEREIRA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3013, 1, N'SAN CARLOS CENTRO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3016, 1, N'SANTO TOME', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3017, 1, N'SAN AGUSTIN', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3018, 1, N'RECREO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3020, 1, N'LAGUNA PAIVA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3023, 1, N'SARMIENTO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3023, 2, N'PROGRESO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3023, 4, N'HIPATIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3023, 236, N'CULULU', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3025, 0, N'COLONIA CLARA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3025, 1, N'SANTO DOMINGO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3025, 3, N'PROVIDENCIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3025, 5, N'SOUTOMAYOR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3025, 6, N'SOLEDAD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3029, 1, N'ELISA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3032, 1, N'NELSON', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3036, 1, N'LLAMBI CAMPBELL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3040, 1, N'SAN JUSTO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3044, 1, N'GOBERNADOR CRESPO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3048, 1, N'VIDELA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3050, 1, N'D.ABREU / CALCHAQUI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3050, 9, N'CALCHAQUI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3052, 1, N'LA CRIOLLA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3056, 1, N'MARGARITA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3060, 1, N'TOSTADO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3061, 1, N'VILLA MINETTI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3062, 1, N'GUARDIA ESCOLTA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3064, 1, N'BANDERA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3066, 1, N'LOGROÑO', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3066, 2, N'LOGROÑO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3070, 1, N'SAN CRISTOBAL', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3071, 1, N'AGUARA GRANDE', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3072, 1, N'ÑANDUCITA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3076, 1, N'HUANQUEROS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3080, 1, N'ESPERANZA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3081, 1, N'HUMBOLTD', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3083, 1, N'GRUTLY', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3085, 1, N'PILAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3087, 1, N'FELICIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3087, 2, N'NUEVO TORINO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3100, 1, N'PARANA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3101, 1, N'ALDEA VALLE MARIA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3103, 1, N'VILLA LIB.GRAL.SAN MARTIN', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3105, 1, N'DIAMANTE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3109, 1, N'VIALE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3111, 1, N'TABOSSI', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3116, 1, N'CRESPO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3117, 1, N'SEGUI', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3118, 1, N'LA PICADA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3122, 1, N'CERRITO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3127, 1, N'VILLA HERNANDARIAS', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3133, 1, N'MARIA GRANDE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3134, 1, N'HASENKAMP', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3138, 1, N'ALCARAZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3142, 1, N'BOVRIL', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3144, 1, N'SAUCE DE LUNA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3150, 1, N'NOGOYA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3153, 1, N'VICTORIA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3156, 1, N'HERNANDEZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3158, 1, N'LUCAS GONZALEZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3162, 1, N'ARANGUREN', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3164, 1, N'RAMIREZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3170, 1, N'BASAVILBASO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3174, 1, N'ROSARIO DEL TALA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3177, 1, N'MACIA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3180, 1, N'FEDERAL', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3183, 1, N'LOS CONQUISTADORES', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3185, 1, N'SAN JAIME DE LA FRONTERA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3187, 1, N'SAN JOSE DE FELICIANO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3188, 1, N'CONSCRIPTO BERNARDI', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3190, 1, N'LA PAZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3192, 1, N'SANTA ELENA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3196, 1, N'ESQUINA -CH.CGO.OTROS BANCOS-', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3200, 1, N'CONCORDIA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3206, 1, N'FEDERACION', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3212, 1, N'LOS CHARRUAS', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3216, 1, N'GENERAL CAMPOS', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3218, 1, N'SAN SALVADOR', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3220, 1, N'MONTE CASEROS', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3226, 1, N'COLONIA MOCORETA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3228, 1, N'CHAJARI', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3229, 1, N'VILLA DEL ROSARIO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3230, 1, N'PASO DE LOS LIBRES', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3240, 1, N'VILLAGUAY', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3246, 1, N'DOMINGUEZ', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3248, 1, N'SANTA ANITA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3252, 1, N'VILLA CLARA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3260, 1, N'CONCEPCION DEL URUGUAY', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3262, 1, N'SAN JUSTO / CASEROS', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3263, 1, N'PRONUNCIAMIENTO', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3265, 1, N'VILLA ELISA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3272, 1, N'VILLA MANTERO / HERRERA', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3280, 1, N'COLON', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3283, 1, N'SAN JOSE', 4)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3300, 1, N'POSADAS', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3302, 1, N'ITUZAINGO CH.CGO.OTROS BANCOS', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3306, 1, N'SAN JOSE', 6)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3313, 1, N'CERRO AZUL', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3315, 1, N'LEANDRO N. ALEM', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3322, 1, N'SAN IGNACIO', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3324, 1, N'GOBERNADOR ROCA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3328, 1, N'JARDIN AMERICA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3332, 1, N'CAINGUAS / CAPIOVY', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3334, 1, N'PUERTO RICO', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3340, 1, N'SANTO TOME-CH.CGO.OTROS BCOS.-', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3342, 1, N'GOBERNADOR VIRASORO', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3344, 1, N'ALVEAR / CONCEPCION-DPTO.GRAL.', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3346, 1, N'LA CRUZ', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3350, 1, N'APOSTOLES', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3355, 1, N'CONCEPCION DE LA SIERRA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3357, 1, N'SAN JAVIER', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3358, 1, N'COLONIA LIEBIG', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3360, 1, N'OBERA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3361, 1, N'CAMPO RAMON', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3362, 1, N'CAMPO VIERA / CAMPO GRANDE', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3363, 1, N'VEINTICINCO DE MAYO / ALBA POS', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3364, 1, N'SAN PEDRO / SAN VICENTE', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3366, 1, N'BERNARDO DE IRIGOYEN', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3370, 1, N'ALMIRANTE BROWN / PUERTO IGUAZ', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3376, 1, N'COLONIA WANDA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3378, 1, N'PUERTO ESPERANZA', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3380, 1, N'ELDORADO', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3384, 1, N'MONTE CARLO', 6)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3400, 1, N'CORRIENTES', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3403, 1, N'SAN LUIS DEL PALMAR', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3407, 1, N'GENERAL PAZ', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3409, 1, N'PASO DE LA PATRIA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3412, 1, N'SAN COSME', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3414, 1, N'ITATI', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3418, 1, N'EMPEDRADO', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3420, 1, N'SALADAS-CH.CGO.OTROS BANCOS- /', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3421, 1, N'CNIA.STA.ROSA-CH.OTROS BCOS.-', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3423, 1, N'CONCEPCION-DPTO.CONCEPCION', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3427, 1, N'MBURUCUYA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3432, 1, N'BELLA VISTA-CH.CGO.OTROS BCOS.', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3445, 1, N'SANTA LUCIA / GOBERNADOR MARTI', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3448, 1, N'SAN ROQUE-DPTO.SAN ROQUE', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3450, 1, N'GOYA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3460, 1, N'CURUZU CUATIA-CH.CGO.OTROS.BCO', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3461, 1, N'PERUGORRIA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3463, 1, N'SAUCE-CH.CGO.OTROS BANCOS- / S', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3466, 1, N'SANTA ROSA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3470, 1, N'MERCEDES', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3474, 1, N'CHAVARRIA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3476, 1, N'MARIANO I. LOZA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3480, 1, N'ITA IBATE', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3481, 1, N'BARON DE ASTRADA', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3485, 1, N'SAN MIGUEL', 5)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3500, 1, N'RESISTENCIA', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3503, 1, N'BARRANQUERAS', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3509, 1, N'GRAL.SAN MARTIN-OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3514, 1, N'MAKALLE', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3515, 1, N'COLONIAS UNIDAS / COLONIA ELIS', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3516, 1, N'FLORENCIA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3518, 1, N'LAS PALMAS-CGO.OTROS BANCOS- /', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3522, 1, N'LA LEONESA-CGO.OTROS BANCOS- /', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3530, 1, N'QUITILIPI-CGO.OTROS BANCOS- /', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3531, 1, N'PAMPA DEL INDIO-OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3534, 1, N'MACHAGAI', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3536, 1, N'PRESIDENCIA DE LA PLAZA', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3540, 1, N'VILLA ANGELA-CGO.OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3541, 1, N'SANTA SYLVINA-CGO.OTROS BANCOS', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3541, 5, N'CORONEL DU GRATY', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3545, 1, N'VILLA BERTHET-CGO.OTROS BANCOS', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3550, 1, N'VERA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3555, 1, N'ROMANG', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3560, 1, N'RECONQUISTA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3561, 1, N'LA VANGUARDIA / AVELLANEDA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3561, 2, N'AVELLANEDA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3567, 1, N'LA LOLA', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3572, 1, N'MALABRIGO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3580, 1, N'VILLA OCAMPO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3586, 1, N'LAS TOSCAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3600, 1, N'FORMOSA', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3601, 1, N'MISION LAISHI', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3603, 1, N'EL COLORADO', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3606, 1, N'PIRANE', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3610, 1, N'CLORINDA', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3611, 1, N'TENIENTE GRAL SANCHEZ', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3613, 1, N'LAGUNA BLANCA', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3615, 1, N'GENERAL BELGRANO', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3620, 1, N'COMANDANTE FONTANA', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3621, 1, N'VILLA GRAL GUEMES', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3624, 1, N'IBARRETA', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3626, 1, N'ESTANISLAO DEL CAMPO', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3630, 1, N'LAS LOMITAS', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3636, 1, N'INGENIERO JUAREZ', 8)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3700, 1, N'PRESIDENCIA R.S.PE¥A', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3701, 1, N'SAN BERNARDO-CGO.OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3703, 1, N'TRES ISLETAS-CGO.OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3705, 1, N'COLONIA J.J.CASTELLI-O.BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3708, 1, N'PAMPA DEL INFIERNO-OTROS BANCO', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3712, 1, N'PAMPA DE LOS GUANACOS', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3714, 1, N'TACO POZO / MONTE QUEMADO-DPTO', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3716, 1, N'CAMPO LARGO -CGO.OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3718, 1, N'CORZUELA -CGO.OTROS BANCOS- /', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3722, 1, N'LAS BRE¥AS-CGO.OTROS BANCOS- /', 7)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3730, 1, N'CHARATA CGO.OTROS BANCOS / CHA', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3732, 1, N'GRAL.PINEDO-CGO.OTROS BANCOS-', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3733, 1, N'HERMOSO CAMPO-OTROS BANCOS- /', 7)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3740, 1, N'QUIMILI -CARGO BANCO NACION- /', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3740, 5, N'QUIMILI', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3740, 10, N'QUIMILI', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3743, 1, N'TINTINA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3753, 1, N'VILILAS', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3760, 1, N'AÑATUYA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (3773, 1, N'LOS JURIES', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4000, 1, N'TUCUMAN', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4103, 1, N'TAFI VIEJO', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4107, 1, N'YERBA BUENA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4109, 1, N'BANDA DEL RIO SALI', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4111, 6, N'BAJO GRANDE', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4113, 1, N'LEALES', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4119, 1, N'LA RAMADA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4124, 1, N'TRANCAS', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4126, 1, N'EL TALA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4128, 1, N'LULES', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4132, 1, N'FAMAILLA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4137, 1, N'TAFI DEL VALLE / AMAICHA DEL V', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4139, 1, N'SANTA MARIA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4142, 1, N'MONTEROS', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4146, 1, N'CONCEPCION', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4152, 1, N'AGUILARES', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4158, 1, N'JUAN BAUTISTA ALBERDI', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4159, 1, N'GRANEROS', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4162, 1, N'LA COCHA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4164, 1, N'EL BAJO', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4168, 1, N'BELLA VISTA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4172, 1, N'SIMOCA', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4178, 1, N'ALDERETES', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4182, 1, N'LOS RALOS', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4186, 1, N'LAS CEJAS', 12)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4190, 1, N'ROSARIO DE LA FRONTERA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4195, 1, N'MONTE QUEMADO-DPTO.PELLEGRINI', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4197, 1, N'NUEVA ESPERANZA-DPTO.PELLEGRIN', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4200, 1, N'SANTIAGO DEL ESTERO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4205, 1, N'BELTRAN LORETO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4208, 1, N'VILLA SAN MARTIN / LORETO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4220, 1, N'TERMAS DE RIO HONDO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4230, 1, N'FRIAS', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4238, 1, N'SAN PEDRO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4300, 1, N'LA BANDA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4308, 1, N'BELTRAN', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4313, 1, N'LA CAÑADA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4313, 2, N'BREA POZO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4313, 3, N'BREA POZO', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4322, 1, N'FERNANDEZ', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4332, 1, N'COLONIA DORA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4334, 1, N'ICAÑO', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4338, 1, N'CLODOMIRA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4350, 1, N'SUNCHO CORRAL', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4400, 1, N'SALTA / VEINTE DE FEBRERO / SA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4400, 21, N'SALTA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4403, 1, N'CERRILLOS', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4405, 1, N'ROSARIO DE LERMA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4407, 1, N'CAMPO QUIJANO', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4417, 1, N'CACHI', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4421, 1, N'EL CARRIL', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4427, 1, N'CAFAYATE', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4430, 1, N'GENERAL GUEMES', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4440, 1, N'METAN', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4444, 1, N'EL GALPON', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4448, 1, N'JOAQUIN V. GONZALEZ', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4449, 1, N'APOLINARIO SARAVIA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4500, 1, N'SAN PEDRO DE JUJUY', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4512, 1, N'LIBERTADOR GRAL.SAN MARTIN', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4530, 1, N'SAN RAMON DE LA NUEVA ORAN', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4531, 1, N'COLONIA SANTA ROSA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4550, 1, N'EMBARCACION', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4560, 1, N'TARTAGAL', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4562, 1, N'GENERAL MOSCONI', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4568, 1, N'POCITOS / SALVADOR MAZA', 10)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4600, 1, N'SAN SALVADOR DE JUJUY', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4603, 1, N'PERICO DEL CARMEN', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4608, 1, N'PERICO CIUDAD / MONTERRICO', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4612, 1, N'PALPALA', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4622, 1, N'SAN PEDRITO', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4630, 1, N'HUMAHUACA', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4634, 1, N'EL AGUILAR', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4640, 1, N'ABRA PAMPA', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4650, 1, N'LA QUIACA', 9)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4700, 1, N'SAN FDO.DEL VALLE DE CATAMARCA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4707, 1, N'TRES PUENTES / VALLE VIEJO', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4723, 1, N'LOS ALTOS', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4728, 1, N'CHUMBICHA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4740, 1, N'ANDALGALA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (4750, 1, N'BELEN', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5000, 1, N'CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5001, 1, N'ALTA CORDOBA / CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5003, 1, N'ALTO ALBERDI / CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5008, 1, N'LOS PARAISOS / CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5009, 1, N'CERRO DE LAS ROSAS / CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5010, 1, N'LOS NARANJOS / CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5101, 1, N'LOZADA / MALAGUE¥O', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5103, 1, N'GUARNICION AEREA CORDOBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5105, 1, N'VILLA ALLENDE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5109, 1, N'UNQUILLO - CARGO OTROS BCOS.-', 3)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5111, 1, N'RIO CEBALLOS CH/OTROS BCOS. /', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5113, 1, N'SALSIPUEDES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5121, 1, N'DESPE¥ADEROS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5123, 1, N'FERREYRA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5125, 1, N'SANTIAGO TEMPLE / MONTE CRISTO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5127, 1, N'RIO PRIMERO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5133, 1, N'SANTA ROSA DE RIO PRIMERO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5138, 1, N'LA PARA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5139, 1, N'MARULL', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5141, 1, N'BALNEARIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5143, 1, N'MIRAMAR', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5147, 1, N'AEROPUERTO PAJAS BLANCAS / ARG', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5151, 1, N'LA CALERA-DPTO.COLON', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5152, 1, N'VILLA CARLOS PAZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5155, 1, N'TANTI', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5164, 1, N'SANTA MARIA DE PUNILLA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5166, 1, N'COSQUIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5172, 1, N'LA FALDA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5176, 1, N'VILLA GIARDINO / THEA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5178, 1, N'LA CUMBRE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5184, 1, N'CAPILLA DEL MONTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5186, 1, N'ALTA GRACIA CH/OTROS BCOS. / A', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5191, 1, N'SAN AGUSTIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5194, 1, N'VILLA GENERAL BELGRANO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5196, 1, N'SANTA ROSA DE CALAMUCHITA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5200, 1, N'DEAN FUNES / SAN VICENTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5201, 1, N'CALCHIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5203, 1, N'TULUMBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5205, 1, N'LA LAGUNA-DPTO.TULUMBA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5209, 1, N'SAN FRANCISCO DEL CHA¥AR', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5218, 1, N'LA CALERA-DPTO.ISCHILIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5220, 1, N'JESUS MARIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5223, 1, N'COLONIA CAROYA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5225, 1, N'OBISPO TREJO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5231, 1, N'SEBASTIAN EL CANO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5236, 1, N'VILLA DEL TOTORAL', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5238, 1, N'LAS PE¥AS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5244, 1, N'SAN JOSE DE LA DORMIDA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5248, 1, N'VILLA DE MARIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5250, 1, N'OJO DE AGUA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5253, 1, N'SUMAMPA', 11)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5260, 1, N'RECREO', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5265, 1, N'ICA¥O', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5274, 1, N'CATUNA / EL MILAGRO', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5276, 1, N'CHA¥AR', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5280, 1, N'CRUZ DEL EJE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5281, 1, N'LA PUERTA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5284, 1, N'VILLA DE SOTO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5291, 1, N'SAN CARLOS MINA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5295, 1, N'SALSACATE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5300, 1, N'LA RIOJA', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5310, 1, N'AIMOGASTA', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5317, 1, N'POMAN', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5327, 1, N'SALICAS', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5340, 1, N'TINOGASTA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5345, 1, N'FIAMBALA', 13)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5350, 1, N'VILLA UNION', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5357, 1, N'VINCHINAS', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5360, 1, N'CHILECITO', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5361, 1, N'ANILLACO', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5365, 1, N'FAMATINA', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5380, 1, N'CHAMICAL', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5383, 1, N'OLTA', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5385, 1, N'TAMA', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5400, 1, N'MERCADO - OTROS BANCOS / SAN J', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5405, 1, N'BARREAL', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5419, 1, N'ALBARDON', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5425, 1, N'RAWSON', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5427, 1, N'VILLA ABERASTAIN / POCITO', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5435, 1, N'V. SARMIENTO - BCO.DE SAN JUAN', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5442, 1, N'CAUCETE', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5460, 1, N'LOS HORNOS / JACHAL', 15)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5470, 1, N'CHEPES', 14)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5500, 1, N'MENDOZA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5501, 1, N'GODOY CRUZ', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5503, 1, N'CARRODILLA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5505, 1, N'CHACRAS DE CORIA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5507, 1, N'LUJAN DE CUYO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5509, 1, N'LAS COLONIAS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5511, 1, N'GENERAL GUTIERREZ', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5515, 1, N'MAIPU', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5519, 1, N'DORREGO / SAN JOSE', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5521, 1, N'VILLA NUEVA-GUAYMALLEN / GUAYM', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5525, 1, N'RODEO DE LA CRUZ', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5527, 1, N'LOS CORRALITOS / LA PRIMAVERA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5529, 1, N'RODEO DEL MEDIO C/BCO.ALMAFUER', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5531, 1, N'FRAY LUIS BELTRAN', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5533, 1, N'LAVALLE / BERMEJO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5535, 1, N'COSTA DE ARAUJO / NUEVA CALIFO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5539, 1, N'LAS HERAS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5541, 1, N'AEROPUERTO EL PLUMERILLO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5544, 1, N'GOBERNADOR BENEGAS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5545, 1, N'USPALLATA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5547, 1, N'VILLA HIPODROMO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5557, 1, N'LAS CUEVAS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5560, 1, N'TUNUYAN', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5561, 1, N'TUPUNGATO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5567, 1, N'LA CONSULTA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5569, 1, N'SAN CARLOS / EUGENIO BUSTOS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5570, 1, N'GENERAL SAN MARTIN', 23)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5573, 1, N'JUNIN', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5577, 1, N'RIVADAVIA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5582, 1, N'INGENIERO GIANONNI', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5584, 1, N'PALMIRA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5585, 1, N'MEDRANO', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5590, 1, N'LA PAZ', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5592, 1, N'LA DORMIDA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5594, 1, N'LAS CATITAS', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5596, 1, N'SANTA ROSA', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5600, 1, N'SAN RAFAEL', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5609, 1, N'MONTE COMAN', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5613, 1, N'MALARGUE', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5620, 1, N'GENERAL ALVEAR', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5622, 1, N'VILLA ATUEL', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5624, 1, N'REAL DEL PADRE', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5634, 1, N'BOWEN', 23)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5700, 1, N'SAN LUIS', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5705, 1, N'SAN FRANCISCO', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5711, 1, N'QUINES', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5713, 1, N'CANDELARIA', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5719, 1, N'SANTA ROSA DEL GIGANTE', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5730, 1, N'VILLA MERCEDES', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5738, 1, N'JUSTO DARAC', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5750, 1, N'LA TOMA', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5755, 1, N'SAN MARTIN', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5759, 1, N'NASCHEL', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5770, 1, N'CONCARAN', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5773, 1, N'TILISARAO', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5777, 1, N'SANTA ROSA', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5800, 1, N'RIO CUARTO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5805, 1, N'CARNERILLO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5807, 1, N'BENGOLEA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5809, 1, N'GENERAL CABRERA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5813, 1, N'ALCIRA / GIGENA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5815, 1, N'ELENA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5817, 1, N'BERROTARAN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5823, 1, N'LOS CONDORES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5825, 1, N'STA.CATALINA DE HOLBERG', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5827, 1, N'LAS VERTIENTES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5829, 1, N'SAMPACHO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5833, 1, N'ACHIRAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5835, 1, N'VILLA DEL CARMEN', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5841, 1, N'SAN BASILIO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5843, 1, N'ADELIA MARIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5845, 1, N'BULNES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5847, 1, N'CORONEL MOLDES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5848, 1, N'LAS ACEQUIAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5850, 1, N'RIO TERCERO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5853, 1, N'CORRALITO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5854, 1, N'ALMAFUERTE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5856, 1, N'EMBALSE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5859, 1, N'LA CRUZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5870, 1, N'VILLA DOLORES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5879, 1, N'LA PAZ-DPTO.SAN JAVIER', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5881, 1, N'MERLO', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5889, 1, N'MINA CLAVERO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5900, 1, N'VILLA MARIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5901, 1, N'LA LAGUNA-DPTO.GRAL.SAN MARTIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5903, 1, N'VILLA NUEVA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5907, 1, N'COLONIA SILVIO PELLICO / ALTO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5911, 1, N'LA PLAYOSA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5913, 1, N'POZO DEL MOLLE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5915, 1, N'CARRILOBO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5917, 1, N'ARROYO CABRAL', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5919, 1, N'DALMACIO VELEZ', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5921, 1, N'LAS PERDICES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5923, 1, N'GENERAL DEHEZA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5925, 1, N'PASCO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5927, 1, N'TICINO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5929, 1, N'HERNANDO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5933, 1, N'TANCACHA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5935, 1, N'VILLA ASCASUBI', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5940, 1, N'LAS VARILLAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5941, 1, N'LAS VARAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5943, 1, N'LASPIUR', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5945, 1, N'SACANTA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5947, 1, N'EL ARA¥ADO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5949, 1, N'ALICIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5951, 1, N'EL FORTIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5960, 1, N'RIO SEGUNDO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5963, 1, N'VILLA DEL ROSARIO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5965, 1, N'LAS JUNTURAS', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5967, 1, N'LUQUE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5969, 1, N'CALCHIN', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5972, 1, N'PILAR', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5974, 1, N'LAGUNA LARGA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5980, 1, N'OLIVA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5981, 1, N'COLAZO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5984, 1, N'JAMES CRAICK', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5986, 1, N'ONCATIVO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (5987, 1, N'COLONIA ALMADA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6000, 1, N'JUNIN -CARGO OTROS BANCOS - /', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6003, 1, N'ASCENSION', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6005, 1, N'GENERAL ARENALES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6007, 1, N'ARRIBEÑOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6009, 1, N'TEODOLINA -CGO.BCO.JUNIN 112-', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6015, 1, N'GENERAL VIAMONTE / LOS TOLDOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6030, 1, N'VEDIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6032, 1, N'L.N.ALEM -CGO.BCO.JUNIN 112- /', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6034, 1, N'J.B.ALBERDI-CGO.BCO.JUNIN 112-', 2)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6036, 1, N'DIEGO DE ALVEAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6042, 1, N'IRIARTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6050, 1, N'GRAL PINTO - C.BCO JUNIN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6053, 1, N'GERMANIA -CARGO BCO.JUNIN 112-', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6062, 1, N'CORONEL GRANADA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6064, 1, N'AMEGHINO -CGO.BCO.JUNIN 112- /', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6065, 1, N'BLAQUIER', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6070, 1, N'LINCOLN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6071, 1, N'BERMUDEZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6073, 1, N'EL TRIUNFO -CGO.BCO.JUNIN 112-', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6075, 1, N'ROBERTS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6075, 5, N'ARENAZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6077, 1, N'PASTEUR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6100, 1, N'RUFINO', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6101, 1, N'VILLA SABOYA / LA CESIRA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6103, 1, N'AMENABAR', 1)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6105, 1, N'SANTA REGINA / CAÑADA SECA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6120, 1, N'LABOULAYE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6121, 1, N'HUANCHILLA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6123, 1, N'MELO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6125, 1, N'SERRANO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6127, 1, N'JOVITA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6132, 1, N'GENERAL LEVALLE', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6140, 1, N'VICUÑA MACKENNA / TORRES', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6200, 1, N'REALICO-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6205, 1, N'INGENIERO LUIGGI-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6207, 1, N'ALTO ITALIA-OTROS.BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6213, 1, N'PARERA-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6214, 1, N'RANCUL-OTROS BANCOS-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6216, 1, N'NUEVA GALIA / UNION', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6220, 1, N'BERNARDO LARROUDE-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6221, 1, N'INTENDENTE ALVEAR-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6223, 1, N'FERNANDO MARTI / CORONEL CHARL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6225, 1, N'BUCHARDO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6227, 1, N'ITALO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6230, 1, N'GENERAL VILLEGAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6231, 1, N'TRES ALGARROBOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6237, 1, N'RIVADAVIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6241, 1, N'PIEDRITAS / EMILIO V. BUNGHE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6244, 1, N'BANDERALO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6270, 1, N'HUINCA RENANCO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6271, 1, N'DEL CAMPILLO / MATTALDI', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6273, 1, N'VILLA VALERIA', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6275, 1, N'VILLA HUIDOBRO', 3)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6277, 1, N'BUENA ESPERANZA', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6300, 1, N'SANTA ROSA', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6301, 1, N'MIGUEL RIGLOS', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6303, 1, N'TOAY-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6305, 1, N'ATRUECO / DOBLAS', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6307, 1, N'MACACHIN-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6309, 1, N'GENERAL MANUEL CAMPOS / ALPACH', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6311, 1, N'GUATRACHE-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6313, 1, N'WINIFREDA-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6315, 1, N'COLONIA BARON-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6319, 1, N'VICTORICA-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6321, 1, N'TELEN -OTROS BANCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6323, 1, N'SANTA ISABEL', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6330, 1, N'CATRILO-OTROS BCOS.- / CATRILO', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6333, 1, N'QUEMU QUEMU-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6335, 1, N'QUENUMA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6339, 1, N'SALLIQUELO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6343, 1, N'VILLA MAZA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6346, 1, N'PELLEGRINI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6352, 1, N'LONQUIMAY-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6360, 1, N'GENERAL PICO', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6369, 1, N'TRENEL-OTROS BCOS.- / TRENEL B', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6380, 1, N'EDUARDO CASTEX-OTROS BCOS.- /', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6381, 1, N'CONHELO', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6385, 1, N'LA MARUJA / ARATA', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6387, 1, N'CALEUFU-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6389, 1, N'ARIZONA', 22)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6400, 1, N'TRENQUE LAUQUEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6405, 1, N'TREINTA DE AGOSTO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6409, 1, N'TRES LOMAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6411, 1, N'GARRE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6417, 1, N'CASBAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6430, 1, N'CARHUE / ADOLFO ALSINA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6431, 1, N'EPECUEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6435, 1, N'GUAMINI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6439, 1, N'LAGUNA ALSINA / BONIFACIO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6441, 1, N'RIVERA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6450, 1, N'PEHUAJO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6455, 1, N'CARLOS TEJEDOR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6465, 1, N'HENDERSON', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6469, 1, N'MONES CAZON', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6471, 1, N'SALAZAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6472, 1, N'FRANCISCO MADERO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6474, 1, N'JUAN JOSE PASO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6500, 1, N'NVE.DE JULIO-CGO.BCO.JUNIN 112', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6505, 1, N'DUDIGNAC', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6509, 1, N'DEL VALLE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6513, 1, N'LA NI¥A', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6530, 1, N'CARLOS CASARES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6533, 1, N'QUIROGA / MARTINEZ DE HOZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6550, 1, N'BOLIVAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6551, 1, N'PIROVANO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6553, 1, N'URDAMPILLETA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6555, 1, N'DAIREAUX / CASEROS-PDO.CASEROS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6561, 1, N'SAN BERNARDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6600, 1, N'MERCEDES', 2)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6605, 1, N'NAVARRO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6612, 1, N'SUIPACHA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6616, 1, N'CASTILLA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6620, 1, N'CHIVILCOY', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6621, 1, N'GOBERNADOR UGARTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6623, 1, N'SAN SEBASTIAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6625, 1, N'MOQUEHUA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6628, 1, N'CORONEL MOM', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6634, 1, N'ALBERTI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6640, 1, N'BRAGADO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6646, 1, N'GENERAL O''BRIEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6660, 1, N'25 DE MAYO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6663, 1, N'NORBERTO DE LA RIESTRA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6665, 1, N'PEDERNALES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6700, 1, N'LUJAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6706, 1, N'JAUREGUI / VILLA FLANDRIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6708, 1, N'SUCRE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6720, 1, N'SAN ANDRES DE GILES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6725, 1, N'CARMEN DE ARECO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6734, 1, N'RAWSON', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6740, 1, N'CHACABUCO-CGO.BCO.JUNIN 112-', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6740, 3, N'CHACABUCO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (6748, 1, N'O''HIGGINS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7000, 1, N'VILLA ITALIA-PDO.TANDIL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7000, 2, N'TANDIL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7003, 1, N'MARIA IGNACIA VELA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7005, 1, N'BARKER', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7007, 1, N'SAN MANUEL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7011, 1, N'JUAN N. FERNANDEZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7020, 1, N'BENITO JUAREZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7100, 1, N'DOLORES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7101, 1, N'TORDILLO / GENERAL CONESA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7103, 1, N'GENERAL LAVALLE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7105, 1, N'SAN CLEMENTE DEL TUYU', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7107, 1, N'SANTA TERESITA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7109, 1, N'MAR DE AJO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7111, 1, N'SAN BERNARDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7114, 1, N'CASTELLI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7116, 1, N'PILA / MANUEL J. COBO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7118, 1, N'GENERAL GUIDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7130, 1, N'CHASCOMUS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7150, 1, N'AYACUCHO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7160, 1, N'MAIPU', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7163, 1, N'GENERAL MADARIAGA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7165, 1, N'VILLA GESSELL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7167, 1, N'PINAMAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7172, 1, N'GENERAL PIRAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7174, 1, N'CORONEL VIDAL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7200, 1, N'LAS FLORES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7203, 1, N'RAUCH', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7214, 1, N'CACHARI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7220, 1, N'MONTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7223, 1, N'SAN MARTIN-PDO.CHASCOMUS / GEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7240, 1, N'LOBOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7245, 1, N'ROQUE PEREZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7260, 1, N'SALADILLO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7263, 1, N'GENERAL ALVEAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7300, 1, N'AZUL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7303, 1, N'TAPALQUE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7311, 1, N'CHILLAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7318, 1, N'HINOJO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7400, 1, N'PUEBLO NUEVO-OLAVARRIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7403, 1, N'SIERRAS BAYAS / LOMA NEGRA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7406, 1, N'GENERAL LAMADRID', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7414, 1, N'LAPRIDA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7500, 1, N'TRES ARROYOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7501, 1, N'INDIO RICO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7503, 1, N'ORENSE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7505, 1, N'CLAROMECO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7509, 1, N'ORIENTE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7511, 1, N'COPETONAS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7513, 1, N'GONZALEZ CHAVEZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7515, 1, N'DELAGARMA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7521, 1, N'SAN CAYETANO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7530, 1, N'CORONEL PRINGLES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7540, 1, N'CORONEL SUAREZ', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7545, 1, N'HUANGUELEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7600, 1, N'EL MONOLITO / MAR DEL PLATA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7601, 1, N'BATAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7603, 1, N'COMANDANTE N. OTAMENDI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7605, 1, N'MECHONGUE / CHAPADMALAL', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7607, 1, N'MIRAMAR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7620, 1, N'BALCARCE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7630, 1, N'VILLA DIAZ VELEZ / NECOCHEA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7631, 1, N'QUEQUEN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7635, 1, N'LOBERIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (7637, 1, N'NICANOR OLIVERA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8000, 1, N'VILLA DOMINGO PRONSATO / BAHIA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8103, 1, N'INGENIERO WHITE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8105, 1, N'GENERAL CERRI', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8109, 1, N'PUNTA ALTA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8111, 1, N'PUERTO BELGRANO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8118, 1, N'CABILDO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8126, 1, N'VILLA IRIS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8129, 1, N'FELIPE SOLA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8132, 1, N'MEDANOS', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8134, 1, N'LA ADELA', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8136, 1, N'JUAN COSTEAU', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8138, 1, N'RIO COLORADO / COLONIA JULIA Y', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8142, 1, N'HILARIO ASCASUBI', 2)
GO
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8146, 1, N'MAYOR BURATOVICH', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8148, 1, N'PEDRO LURO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8150, 1, N'CORONEL DORREGO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8153, 1, N'MONTE HERMOSO', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8156, 1, N'JOSE GUISASOLA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8160, 1, N'TORNQUIST', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8164, 1, N'DUFAUR', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8166, 1, N'SALDUNGARAY', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8168, 1, N'SIERRA DE LA VENTANA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8170, 1, N'PIGUE', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8174, 1, N'SAAVEDRA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8180, 1, N'PUAN', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8183, 1, N'DARRAGUEIRA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8200, 1, N'GENERAL ACHA', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8201, 1, N'VEINTICINCO DE MAYO-O-BCOS.- /', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8204, 1, N'BERNASCONI-OTROS BCOS.-', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8206, 1, N'GRAL.SAN MARTIN-OTROS BCOS.- /', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8208, 1, N'JACINTO ARAUZ', 16)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8300, 1, N'NEUQUEN', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8301, 1, N'PLANICIE BANDERITA', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8303, 1, N'CINCO SALTOS', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8305, 1, N'EL CHA¥AR', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8307, 1, N'CATRIEL / 25 DE MAYO', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8309, 1, N'CENTENARIO', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8311, 1, N'EL CHOCON', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8313, 1, N'PICUN LEUFU', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8315, 1, N'PIEDRA DEL AGUILA', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8316, 1, N'SENILLOSA / PLOTTIER', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8318, 1, N'PLAZA HUINCUL', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8319, 1, N'RINCOS DE LOS SAUCES', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8322, 1, N'CUTRAL-CO', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8324, 1, N'CIPOLLETI / LOS MENUCOS', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8326, 1, N'CHICHINALES / CERVANTES', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8328, 1, N'VILLA MANZANO / ALLEN', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8332, 1, N'GENERAL ROCA', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8334, 1, N'INGENIERO HUERGO', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8336, 1, N'VILLA REGINA', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8340, 1, N'ZAPALA', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8345, 1, N'ALUMINE', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8347, 1, N'LAS LAJAS / SALQUICO', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8349, 1, N'LONCOPUE', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8353, 1, N'CHOS MALAL', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8360, 1, N'CHOELE-CHOEL', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8361, 1, N'LUIS BELTRAN', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8363, 1, N'LAMARQUE', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8364, 1, N'CHIMPAY', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8370, 1, N'SAN MARTIN DE LOS ANDES', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8371, 1, N'JUNIN DE LOS ANDES', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8400, 1, N'SAN CARLOS DE BARILOCHE', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8403, 1, N'ALICURA', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8407, 1, N'VILLA LA ANGOSTURA', 17)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8418, 1, N'INGENIERO JACOBACCI', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8422, 1, N'MAQUINCHAO', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8424, 1, N'LOS MENUCOS', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8430, 1, N'EL BOLSON', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8431, 1, N'EL HOYO / LAGO PUELO', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8500, 1, N'VIEDMA', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8503, 1, N'GENERAL CONESA', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8504, 1, N'CARMEN DE PATAGONES', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8508, 1, N'STROEDER', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8512, 1, N'VILLALONGA', 2)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8520, 1, N'SAN ANTONIO OESTE', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8532, 1, N'SIERRA GRANDE', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (8536, 1, N'VALCHETA', 18)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9000, 1, N'BARRIO OESTE -LA LOMA / COMODO', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9001, 1, N'RADA TILLY', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9005, 1, N'GENERAL MOSCONI', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9011, 1, N'CALETA OLIVIA', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9015, 1, N'PICO TRUNCADO', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9017, 1, N'LAS HERAS', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9020, 1, N'SARMIENTO / RIO MAYO', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9033, 1, N'ALTO RIO SENGUER', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9040, 1, N'PERITO MORENO', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9050, 1, N'PUERTO DESEADO', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9100, 1, N'TRELEW / GOBERNADOR FONTANA', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9103, 1, N'RAWSON', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9105, 1, N'GAIMAN', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9107, 1, N'DOLAVON', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9111, 1, N'CAMARONES', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9120, 1, N'PUERTO MADRYN', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9200, 1, N'ESQUEL', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9203, 1, N'TREVELIN', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9210, 1, N'EL MAITEN', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9223, 1, N'GOBERNADOR COSTA', 19)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9300, 1, N'PUERTO SANTA CRUZ', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9303, 1, N'COMANDANTE LUIS PIEDRABUENA', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9310, 1, N'PUERTO SAN JULIAN', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9311, 1, N'GOBERNADOR GREGORES', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9400, 1, N'RIO GALLEGOS', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9405, 1, N'CALAFATE', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9407, 1, N'RIO TURBIO', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9408, 1, N'VEINTIOCHO DE NOVIEMBRE', 20)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9410, 1, N'USUHAIA', 21)
INSERT [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal], [Localidad], [IdProvincia]) VALUES (9420, 1, N'RIO GRANDE', 21)
GO
SET IDENTITY_INSERT [dbo].[Empresa] ON 

INSERT [dbo].[Empresa] ([IdEmpresa], [RazonSocial], [NFantasia], [InicioActividades], [CUIT], [Logo], [Direccion], [Telefono], [Correo], [IIBB], [CondicionIva], [CodigoPostal], [SubCodigoPostal], [RutaCertificado], [SerialCertificado]) VALUES (1, N'Cesar S.R.L', N'Cosme Fulanito', CAST(N'2022-01-01T00:00:00' AS SmallDateTime), N'123213123213', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Empresa] OFF
GO
SET IDENTITY_INSERT [dbo].[EmpTarjetas] ON 

INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (1, N'Visa')
INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (2, N'Mastercard')
INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (3, N'American Express')
INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (4, N'Tarjeta Naranja')
INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (5, N'Argencard')
INSERT [dbo].[EmpTarjetas] ([IdEmpTarjeta], [Empresa]) VALUES (6, N'Cabal Union')
SET IDENTITY_INSERT [dbo].[EmpTarjetas] OFF
GO
SET IDENTITY_INSERT [dbo].[Estados] ON 

INSERT [dbo].[Estados] ([EstadoId], [Descripcion]) VALUES (1, N'Activo')
INSERT [dbo].[Estados] ([EstadoId], [Descripcion]) VALUES (2, N'Baja')
INSERT [dbo].[Estados] ([EstadoId], [Descripcion]) VALUES (1002, N'Suspendido')
SET IDENTITY_INSERT [dbo].[Estados] OFF
GO
INSERT [dbo].[EstadosCaja] ([IdEstadoCaja], [Estado]) VALUES (1, N'Inactiva')
INSERT [dbo].[EstadosCaja] ([IdEstadoCaja], [Estado]) VALUES (2, N'Activa')
INSERT [dbo].[EstadosCaja] ([IdEstadoCaja], [Estado]) VALUES (3, N'Suspendida')
INSERT [dbo].[EstadosCaja] ([IdEstadoCaja], [Estado]) VALUES (4, N'Cerrada')
GO
SET IDENTITY_INSERT [dbo].[FacturasVenta] ON 

INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (23, 1, 2, NULL, N'1', CAST(N'2022-05-31T16:00:00' AS SmallDateTime), 1, NULL, 1002, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:23.7916718' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:23.7916718' AS DateTime2), 0, 0, NULL, 1)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (24, 1, 2, NULL, N'2', CAST(N'2022-05-31T16:00:00' AS SmallDateTime), 1, NULL, 1004, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:23.9693034' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:23.9693034' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (25, 1, 2, NULL, N'3', CAST(N'2022-05-31T16:00:00' AS SmallDateTime), 1, NULL, 1005, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:23.9780871' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:23.9780871' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (26, 1, 2, NULL, N'4', CAST(N'2022-05-31T16:00:00' AS SmallDateTime), 1, NULL, 1006, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:23.9868711' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:23.9868711' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (27, 1, 2, NULL, N'5', CAST(N'2022-05-31T16:01:00' AS SmallDateTime), 1, NULL, 1002, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:43.2600881' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:43.2600881' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (28, 1, 2, NULL, N'6', CAST(N'2022-05-31T16:01:00' AS SmallDateTime), 1, NULL, 1004, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:43.4308881' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:43.4308881' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (29, 1, 2, NULL, N'7', CAST(N'2022-05-31T16:01:00' AS SmallDateTime), 1, NULL, 1005, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:43.4455281' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:43.4455281' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (30, 1, 2, NULL, N'8', CAST(N'2022-05-31T16:01:00' AS SmallDateTime), 1, NULL, 1006, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:00:43.4611441' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:00:43.4611441' AS DateTime2), 0, 0, NULL, 0)
INSERT [dbo].[FacturasVenta] ([IdFacturaVenta], [IdTipoDocumento], [IdTipoFactura], [BVFact], [NCompFact], [FechaEmision], [IdFormaPago], [IdCondicionPago], [ClienteCajaDistribucionServicioId], [Impresa], [Observaciones], [Subtotal105], [Subtotal21], [SubTotal], [Descuento], [TotalDescuento105], [TotalDescuento21], [TotalDescuento], [TotalIva105], [TotalIva21], [Total], [FechaVencimiento], [FechaAnulacion], [TotalSaldado], [TotalInteres], [TotalSaldadoInteres], [IdEmpresa], [UsrAcceso], [FechaAcceso], [BVReferencia], [NroCompFactReferencia], [IdConceptoFactura], [FechaAlta], [Cobrador], [MoverStock], [NombreMaquina], [Pagado]) VALUES (31, 1, 2, NULL, N'9', CAST(N'2022-05-31T16:20:00' AS SmallDateTime), 1, NULL, 1002, 0, NULL, CAST(0.00 AS Decimal(12, 2)), CAST(210.00 AS Decimal(12, 2)), CAST(1210.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(13, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(8, 2)), CAST(1210.00 AS Decimal(14, 2)), CAST(N'2022-06-10T00:00:00.0000000' AS DateTime2), NULL, CAST(1210.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(8, 2)), CAST(0.00 AS Decimal(8, 2)), 1, N'', CAST(N'2022-05-31T16:19:31.0299380' AS DateTime2), NULL, NULL, 2, CAST(N'2022-05-31T16:19:31.0299380' AS DateTime2), 0, 0, NULL, 0)
SET IDENTITY_INSERT [dbo].[FacturasVenta] OFF
GO
SET IDENTITY_INSERT [dbo].[FacturasVentaDetalle] ON 

INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (21, 23, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:23.9566153' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (22, 24, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:23.9751596' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (23, 25, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:23.9839433' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (24, 26, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:23.9927272' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (25, 27, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:43.4152721' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (26, 28, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:43.4396715' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (27, 29, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:43.4543120' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (28, 30, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:00:43.4699276' AS DateTime2), NULL, NULL)
INSERT [dbo].[FacturasVentaDetalle] ([IdFacturaVentaDetalle], [IdFacturaVenta], [IdServicio], [Servicio], [UMedida], [Cantidad], [PrecioUnitario], [IdTipoIva], [TotalArt], [DesdeRemito], [UsrAcceso], [FechaAcceso], [MueveStock], [PrecioManual]) VALUES (29, 31, 1, N'Internet 1 MG', N'unidades', CAST(1.00 AS Decimal(9, 2)), CAST(1000.0000 AS Decimal(14, 4)), 1, CAST(1000.00 AS Decimal(14, 2)), 0, N'', CAST(N'2022-05-31T16:19:31.0738577' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[FacturasVentaDetalle] OFF
GO
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (1, N'Contado')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (2, N'Cuenta Corriente')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (3, N'Tarjeta de Debito')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (4, N'Tarjeta de Credito')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (5, N'Transferencia')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (6, N'Online')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (7, N'Mercado Pago')
INSERT [dbo].[FormasPago] ([IdFormaPago], [Descripcion]) VALUES (8, N'Sin Especificar')
GO
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (1, N'Artículos')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (2, N'Clientes')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (3, N'Proveedores')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (4, N'Ventas')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (5, N'Compras')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (6, N'Cobranza')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (7, N'Pagos')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (8, N'Cuentas Corrientes')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (9, N'Auxiliares')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (10, N'Configuración')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (11, N'Presupuestos')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (12, N'Ordenes')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (13, N'Depositos')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (14, N'Vendedores')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (15, N'Contabilidad')
INSERT [dbo].[Modulos] ([IdModulo], [Modulo]) VALUES (16, N'Todos')
GO
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (1, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (2, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (3, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (4, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (5, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (6, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (7, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (8, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (9, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (10, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (11, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (12, 1)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (13, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (14, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (15, 2)
INSERT [dbo].[ModulosTiposUsuarios] ([IdModulo], [IdTipoUsuario]) VALUES (16, 2)
GO
SET IDENTITY_INSERT [dbo].[ObservacionesCliente] ON 

INSERT [dbo].[ObservacionesCliente] ([IdObservacion], [Descripción]) VALUES (1, N'Normal')
INSERT [dbo].[ObservacionesCliente] ([IdObservacion], [Descripción]) VALUES (2, N'Mensaje de Cuenta')
INSERT [dbo].[ObservacionesCliente] ([IdObservacion], [Descripción]) VALUES (3, N'Saldo Permitido')
INSERT [dbo].[ObservacionesCliente] ([IdObservacion], [Descripción]) VALUES (4, N'Cuenta Cerrada')
SET IDENTITY_INSERT [dbo].[ObservacionesCliente] OFF
GO
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (1, N'SANTA FE')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (2, N'BUENOS AIRES')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (3, N'CORDOBA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (4, N'ENTRE RIOS')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (5, N'CORRIENTES')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (6, N'MISIONES')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (7, N'CHACO')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (8, N'FORMOSA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (9, N'JUJUY')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (10, N'SALTA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (11, N'SANTIAGO DEL ESTERO')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (12, N'TUCUMAN')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (13, N'CATAMARCA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (14, N'LA RIOJA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (15, N'SAN JUAN')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (16, N'LA PAMPA')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (17, N'NEUQUEN')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (18, N'RIO NEGRO')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (19, N'CHUBUT')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (20, N'SANTA CRUZ')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (21, N'TIERRA DEL FUEGO')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (22, N'SAN LUIS')
INSERT [dbo].[Provincias] ([IdProvincia], [Provincia]) VALUES (23, N'MENDOZA')
GO
SET IDENTITY_INSERT [dbo].[RegimenesImpositivos] ON 

INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (1, N'Responsable Inscripto')
INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (2, N'Responsable No Inscripto')
INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (3, N'Responsable Excento')
INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (4, N'Consumidor Final')
INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (5, N'Monotributista')
INSERT [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo], [Descripcion]) VALUES (6, N'No Categorizado')
SET IDENTITY_INSERT [dbo].[RegimenesImpositivos] OFF
GO
SET IDENTITY_INSERT [dbo].[Servicios] ON 

INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (1, N'Internet 1 MG', CAST(N'2022-04-25T00:00:00.000' AS DateTime), 1, CAST(1000 AS Decimal(18, 0)), 1)
INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (2, N'Internet 3 MG', CAST(N'2022-05-02T00:00:00.000' AS DateTime), 1, CAST(3000 AS Decimal(18, 0)), 1)
INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (3, N'Internet 10 MG', CAST(N'2022-05-02T00:00:00.000' AS DateTime), 1, CAST(3800 AS Decimal(18, 0)), 1)
SET IDENTITY_INSERT [dbo].[Servicios] OFF
GO
INSERT [dbo].[Seteos] ([IdSeteo], [UsarCF], [DiasVtoFact], [PathBackUp], [PorcentajeGcia], [PorcentajeFiado], [UsarCaja], [UsarPrecioIVAPres], [UsarCajaRegistradora], [DuplicadoRecibo], [UsarMultiEmpresa], [MostrarArtBajas], [MostrarCliBajas], [MostarArtLoad], [MostarArtPreciosLoad], [FacturacionRapida], [Usar4DigitosPrecios], [UsarIntereses], [PorcentajeInteres], [PreciosSoloAdmin], [UsarRemitoX], [ImprimirRecCtdoCajas], [UsarDetalleCajas], [UsarUpdater], [UsarCB], [UsarDolar], [CotizacionDolar], [UsarLogo], [DuplicadoRemitoX], [Hollistor], [Flete], [Descarga], [PorcentajeFlete], [PorcentajeDescarga], [Impuesto], [HabilitarUserPorIntentos], [MaxIntentosFallidos], [LapsoTiempoBloqueo], [PermitirFacturar], [UltimaHoraZ]) VALUES (1, 1, 0, N'C:\BackUp Sistema', CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(4, 2)), 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, CAST(0.00 AS Decimal(4, 2)), 0, 1, 0, 0, 0, 0, 0, CAST(0.00 AS Decimal(4, 2)), 1, 0, 0, 0, 0, CAST(0.00 AS Decimal(4, 2)), CAST(0.00 AS Decimal(4, 2)), 0, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[TiposCF] ([IdTipoCF], [TipoCF]) VALUES (1, N'Tiquets Factura')
INSERT [dbo].[TiposCF] ([IdTipoCF], [TipoCF]) VALUES (2, N'Facturas')
INSERT [dbo].[TiposCF] ([IdTipoCF], [TipoCF]) VALUES (3, N'Formulario Pre-Impreso')
INSERT [dbo].[TiposCF] ([IdTipoCF], [TipoCF]) VALUES (4, N'Facturación Electrónica')
GO
SET IDENTITY_INSERT [dbo].[TiposCheques] ON 

INSERT [dbo].[TiposCheques] ([IdTipoCheque], [Descripcion]) VALUES (1, N'Al cobro')
INSERT [dbo].[TiposCheques] ([IdTipoCheque], [Descripcion]) VALUES (2, N'Cruzado')
INSERT [dbo].[TiposCheques] ([IdTipoCheque], [Descripcion]) VALUES (3, N'Cobro diferido')
SET IDENTITY_INSERT [dbo].[TiposCheques] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposConceptoFactura] ON 

INSERT [dbo].[TiposConceptoFactura] ([IdConceptoFactura], [Descripcion]) VALUES (1, N'Productos')
INSERT [dbo].[TiposConceptoFactura] ([IdConceptoFactura], [Descripcion]) VALUES (2, N'Servicios')
INSERT [dbo].[TiposConceptoFactura] ([IdConceptoFactura], [Descripcion]) VALUES (3, N'Productos y Servicios')
SET IDENTITY_INSERT [dbo].[TiposConceptoFactura] OFF
GO
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (1, N'Factura de Venta')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (2, N'Nota de Crédito')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (3, N'Nota de Débito')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (4, N'Factura de Compra')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (5, N'Recibo')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (6, N'Recibo de Pago')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (7, N'Nota de Crédito de Compra')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (8, N'Remito X')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (9, N'Saldo Inicial CC')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (10, N'Remito X Compra')
INSERT [dbo].[TiposDocFact] ([IdTipoDocumento], [Descripcion]) VALUES (11, N'Nota de Débito de Compra')
GO
INSERT [dbo].[TiposDocumento] ([TipoDocumento], [Descripcion]) VALUES (N'CUIL', N'Clave única de Identificación Laboral')
INSERT [dbo].[TiposDocumento] ([TipoDocumento], [Descripcion]) VALUES (N'CUIT', N'Clave única de Identificación Tributaria')
INSERT [dbo].[TiposDocumento] ([TipoDocumento], [Descripcion]) VALUES (N'DNI', N'Documento Nacional De Identidad')
INSERT [dbo].[TiposDocumento] ([TipoDocumento], [Descripcion]) VALUES (N'LC', N'Libreta Cívica')
INSERT [dbo].[TiposDocumento] ([TipoDocumento], [Descripcion]) VALUES (N'LE', N'Libreta de Enrolamiento')
GO
INSERT [dbo].[TiposFactura] ([IdTipoFactura], [Descripcion]) VALUES (1, N'A')
INSERT [dbo].[TiposFactura] ([IdTipoFactura], [Descripcion]) VALUES (2, N'B')
INSERT [dbo].[TiposFactura] ([IdTipoFactura], [Descripcion]) VALUES (3, N'C')
INSERT [dbo].[TiposFactura] ([IdTipoFactura], [Descripcion]) VALUES (4, N'X')
GO
SET IDENTITY_INSERT [dbo].[TiposImpuestos] ON 

INSERT [dbo].[TiposImpuestos] ([IdTipoImpuesto], [Descripcion]) VALUES (1, N'Ingresos Brutos')
INSERT [dbo].[TiposImpuestos] ([IdTipoImpuesto], [Descripcion]) VALUES (2, N'Ganancias')
SET IDENTITY_INSERT [dbo].[TiposImpuestos] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposIva] ON 

INSERT [dbo].[TiposIva] ([IdTipoIva], [PorcentajeIVA]) VALUES (1, 21)
INSERT [dbo].[TiposIva] ([IdTipoIva], [PorcentajeIVA]) VALUES (2, 10.5)
INSERT [dbo].[TiposIva] ([IdTipoIva], [PorcentajeIVA]) VALUES (3, 0)
INSERT [dbo].[TiposIva] ([IdTipoIva], [PorcentajeIVA]) VALUES (4, 27)
SET IDENTITY_INSERT [dbo].[TiposIva] OFF
GO
INSERT [dbo].[TiposMovimientosCaja] ([IdTipoMovCaja], [Descripcion]) VALUES (1, N'Ingreso')
INSERT [dbo].[TiposMovimientosCaja] ([IdTipoMovCaja], [Descripcion]) VALUES (2, N'Egreso')
GO
SET IDENTITY_INSERT [dbo].[TiposMovimientosDepositos] ON 

INSERT [dbo].[TiposMovimientosDepositos] ([IdTipoMovDeposito], [Descripcion]) VALUES (1, N'Ingreso')
INSERT [dbo].[TiposMovimientosDepositos] ([IdTipoMovDeposito], [Descripcion]) VALUES (2, N'Egreso')
INSERT [dbo].[TiposMovimientosDepositos] ([IdTipoMovDeposito], [Descripcion]) VALUES (3, N'Traslado a Otro Deposito')
SET IDENTITY_INSERT [dbo].[TiposMovimientosDepositos] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposPagos] ON 

INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (1, N'Dinero')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (2, N'Cheque')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (3, N'Tarjeta de Crédito')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (4, N'Tarjeta de Débito')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (5, N'Transferencia Bancaria')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (6, N'Descuento de Cta.Cte')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (7, N'Retenciones Gcia.')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (8, N'Retenciones IIBB')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (9, N'Retenciones IVA')
INSERT [dbo].[TiposPagos] ([IdTipoPago], [Descripcion]) VALUES (10, N'Retenciones de SUS')
SET IDENTITY_INSERT [dbo].[TiposPagos] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposRetenciones] ON 

INSERT [dbo].[TiposRetenciones] ([IdTipoRetencion], [MontoMinimo], [Alicuota]) VALUES (1, CAST(12000.00 AS Numeric(18, 2)), CAST(0.0200 AS Numeric(8, 4)))
INSERT [dbo].[TiposRetenciones] ([IdTipoRetencion], [MontoMinimo], [Alicuota]) VALUES (2, CAST(100000.00 AS Numeric(18, 2)), CAST(0.0200 AS Numeric(8, 4)))
INSERT [dbo].[TiposRetenciones] ([IdTipoRetencion], [MontoMinimo], [Alicuota]) VALUES (3, CAST(142400.00 AS Numeric(18, 2)), CAST(0.0200 AS Numeric(8, 4)))
SET IDENTITY_INSERT [dbo].[TiposRetenciones] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposUsuarios] ON 

INSERT [dbo].[TiposUsuarios] ([IdTipoUser], [Tipo]) VALUES (1, N'Root')
INSERT [dbo].[TiposUsuarios] ([IdTipoUser], [Tipo]) VALUES (2, N'Administrador')
INSERT [dbo].[TiposUsuarios] ([IdTipoUser], [Tipo]) VALUES (3, N'Vendedor')
INSERT [dbo].[TiposUsuarios] ([IdTipoUser], [Tipo]) VALUES (4, N'Cajero')
SET IDENTITY_INSERT [dbo].[TiposUsuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposVendedores] ON 

INSERT [dbo].[TiposVendedores] ([IdTipoVendedor], [Descripcion]) VALUES (1, N'Local')
INSERT [dbo].[TiposVendedores] ([IdTipoVendedor], [Descripcion]) VALUES (2, N'Externo')
SET IDENTITY_INSERT [dbo].[TiposVendedores] OFF
GO
SET IDENTITY_INSERT [dbo].[TiposVendedoresExternos] ON 

INSERT [dbo].[TiposVendedoresExternos] ([IdTipoVendedorExt], [Descripcion]) VALUES (1, N'Electricista')
INSERT [dbo].[TiposVendedoresExternos] ([IdTipoVendedorExt], [Descripcion]) VALUES (2, N'Plomero')
SET IDENTITY_INSERT [dbo].[TiposVendedoresExternos] OFF
GO
SET IDENTITY_INSERT [dbo].[UnidadesMedida] ON 

INSERT [dbo].[UnidadesMedida] ([IdUnidadMedida], [Descripcion]) VALUES (1, N'-')
SET IDENTITY_INSERT [dbo].[UnidadesMedida] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([IdUser], [NombreUser], [IdTipoUser], [FechaBaja], [PassUser], [FechaDeBloqueo], [NumeroDeIntentos]) VALUES (1, N'root', 1, NULL, 0x0DBC34611A04603DD8B067251CB87364C15A1B38, NULL, NULL)
INSERT [dbo].[Usuarios] ([IdUser], [NombreUser], [IdTipoUser], [FechaBaja], [PassUser], [FechaDeBloqueo], [NumeroDeIntentos]) VALUES (2, N'admin', 2, NULL, 0xD033E22AE348AEB5660FC2140AEC35850C4DA997, NULL, NULL)
INSERT [dbo].[Usuarios] ([IdUser], [NombreUser], [IdTipoUser], [FechaBaja], [PassUser], [FechaDeBloqueo], [NumeroDeIntentos]) VALUES (3, N'vend', 3, NULL, 0x3B568924873BFD4B5D8C051E9A754E760AACC215, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Vendedores] ON 

INSERT [dbo].[Vendedores] ([NroVendedor], [TipoDocumento], [NroDocumento], [ApellidoyNombre], [Direccion], [CodigoPostal], [SubCodigoPostal], [Telefono], [Email1], [Email2], [PaginaWeb], [PorcComision], [IdTipoVendedor], [IdTipoVendedorExt], [FechaBaja]) VALUES (1, N'DNI', 0, N'ADMINISTRADOR', N'Av. Belgrano 556', 2322, 1, NULL, NULL, NULL, NULL, CAST(0.00 AS Numeric(15, 2)), 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Vendedores] OFF
GO
ALTER TABLE [dbo].[AjustesStock] ADD  CONSTRAINT [DF_AjustesStock_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[AjustesStock] ADD  CONSTRAINT [DF_AjustesStock_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Articulos] ADD  CONSTRAINT [DF_Articulos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Articulos] ADD  CONSTRAINT [DF_Articulos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[AsientosContables] ADD  CONSTRAINT [DF_AsientosContables_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[CajasAperturas] ADD  CONSTRAINT [DF_CajasAperturas_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[CajasMovimientos] ADD  CONSTRAINT [DF_CajasMovimientos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle] ADD  CONSTRAINT [DF_CajasMovimientosDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Cheques] ADD  CONSTRAINT [DF_Cheques_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Cheques] ADD  CONSTRAINT [DF_Cheques_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[CuentasContables] ADD  CONSTRAINT [DF_CuentasContables_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[DatosImpositivos] ADD  CONSTRAINT [DF_DatosImpositivos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[DatosImpositivos] ADD  CONSTRAINT [DF_DatosImpositivos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Errores] ADD  CONSTRAINT [DF_Errores_FechaError]  DEFAULT (getdate()) FOR [FechaError]
GO
ALTER TABLE [dbo].[FacturasCompra] ADD  CONSTRAINT [DF_FacturasCompra_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[FacturasCompra] ADD  CONSTRAINT [DF_FacturasCompra_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[FacturasCompraDetalle] ADD  CONSTRAINT [DF_FacturasCompraDetalle_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[FacturasCompraDetalle] ADD  CONSTRAINT [DF_FacturasCompraDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[FacturasVenta] ADD  CONSTRAINT [DF_Facturas_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[FacturasVenta] ADD  CONSTRAINT [DF_Facturas_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[FacturasVentaDetalle] ADD  CONSTRAINT [DF_FacturasDetalle_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[FacturasVentaDetalle] ADD  CONSTRAINT [DF_FacturasDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Pagos] ADD  CONSTRAINT [DF_Pagos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Pagos] ADD  CONSTRAINT [DF_Pagos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[PagosDetalle] ADD  CONSTRAINT [DF_PagosDetalle_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[PagosDetalle] ADD  CONSTRAINT [DF_PagosDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[PreciosVenta] ADD  CONSTRAINT [DF_PreciosVenta_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[PreciosVenta] ADD  CONSTRAINT [DF_PreciosVenta_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Presupuestos] ADD  CONSTRAINT [DF_Presupuestos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Presupuestos] ADD  CONSTRAINT [DF_Presupuestos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[PresupuestosDetalles] ADD  CONSTRAINT [DF_PresupuestosDetalles_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[PresupuestosDetalles] ADD  CONSTRAINT [DF_PresupuestosDetalles_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Proveedores] ADD  CONSTRAINT [DF_Proveedores_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Proveedores] ADD  CONSTRAINT [DF_Proveedores_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Recibos] ADD  CONSTRAINT [DF_Recibos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Recibos] ADD  CONSTRAINT [DF_Recibos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[RecibosDetalle] ADD  CONSTRAINT [DF_RecibosDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[RecibosDetalle] ADD  CONSTRAINT [DF_RecibosDetalle_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Remitos] ADD  CONSTRAINT [DF_Remitos_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[Remitos] ADD  CONSTRAINT [DF_Remitos_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[RemitosCompra] ADD  CONSTRAINT [DF_RemitosCompra_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[RemitosCompra] ADD  CONSTRAINT [DF_RemitosCompra_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[RemitosDetalle] ADD  CONSTRAINT [DF_RemitosDetalle_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[RemitosDetalle] ADD  CONSTRAINT [DF_RemitosDetalle_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[RemitosDetalleCompra] ADD  CONSTRAINT [DF_RemitosDetalleCompra_FechaAcceso]  DEFAULT (getdate()) FOR [FechaAcceso]
GO
ALTER TABLE [dbo].[RemitosDetalleCompra] ADD  CONSTRAINT [DF_RemitosDetalleCompra_UsrAcceso]  DEFAULT (user_name()) FOR [UsrAcceso]
GO
ALTER TABLE [dbo].[Seteos] ADD  DEFAULT ((0)) FOR [PermitirFacturar]
GO
ALTER TABLE [dbo].[AjustesStock]  WITH CHECK ADD  CONSTRAINT [FK_AjustesStock_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[AjustesStock] CHECK CONSTRAINT [FK_AjustesStock_Articulos]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Rubros] FOREIGN KEY([IdRubro])
REFERENCES [dbo].[Rubros] ([IdRubro])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Rubros]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_SubRubros] FOREIGN KEY([IdSubRubro])
REFERENCES [dbo].[SubRubros] ([IdSubRubro])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_SubRubros]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_UnidadesMedida] FOREIGN KEY([IdUnidadMedida])
REFERENCES [dbo].[UnidadesMedida] ([IdUnidadMedida])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_UnidadesMedida]
GO
ALTER TABLE [dbo].[AsientosContables]  WITH CHECK ADD  CONSTRAINT [FK_AsientosContables_AsientosContables] FOREIGN KEY([IdCuentaContable])
REFERENCES [dbo].[CuentasContables] ([IdCuentaContable])
GO
ALTER TABLE [dbo].[AsientosContables] CHECK CONSTRAINT [FK_AsientosContables_AsientosContables]
GO
ALTER TABLE [dbo].[AsientosContables]  WITH CHECK ADD  CONSTRAINT [FK_AsientosContables_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[AsientosContables] CHECK CONSTRAINT [FK_AsientosContables_Empresa]
GO
ALTER TABLE [dbo].[AsientosContables]  WITH CHECK ADD  CONSTRAINT [FK_AsientosContables_PeriodosContables] FOREIGN KEY([Periodo])
REFERENCES [dbo].[PeriodosContables] ([Periodo])
GO
ALTER TABLE [dbo].[AsientosContables] CHECK CONSTRAINT [FK_AsientosContables_PeriodosContables]
GO
ALTER TABLE [dbo].[CajasAperturas]  WITH CHECK ADD  CONSTRAINT [FK_CajasAperturas_Cajas] FOREIGN KEY([IdCaja])
REFERENCES [dbo].[Cajas] ([IdCaja])
GO
ALTER TABLE [dbo].[CajasAperturas] CHECK CONSTRAINT [FK_CajasAperturas_Cajas]
GO
ALTER TABLE [dbo].[CajasMovimientos]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientos_CajasAperturas] FOREIGN KEY([IdAperturaCaja])
REFERENCES [dbo].[CajasAperturas] ([IdAperturaCaja])
GO
ALTER TABLE [dbo].[CajasMovimientos] CHECK CONSTRAINT [FK_CajasMovimientos_CajasAperturas]
GO
ALTER TABLE [dbo].[CajasMovimientos]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientos_TiposMovimientosCaja] FOREIGN KEY([IdTipoMovCaja])
REFERENCES [dbo].[TiposMovimientosCaja] ([IdTipoMovCaja])
GO
ALTER TABLE [dbo].[CajasMovimientos] CHECK CONSTRAINT [FK_CajasMovimientos_TiposMovimientosCaja]
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientosDetalle_CajasMovimientosDetalle] FOREIGN KEY([IdMovimientoCaja])
REFERENCES [dbo].[CajasMovimientos] ([IdMovimientoCaja])
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle] CHECK CONSTRAINT [FK_CajasMovimientosDetalle_CajasMovimientosDetalle]
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientosDetalle_Cheques] FOREIGN KEY([IdCheque])
REFERENCES [dbo].[Cheques] ([IdCheque])
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle] CHECK CONSTRAINT [FK_CajasMovimientosDetalle_Cheques]
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientosDetalle_EmpTarjetas] FOREIGN KEY([IdEmpTarjeta])
REFERENCES [dbo].[EmpTarjetas] ([IdEmpTarjeta])
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle] CHECK CONSTRAINT [FK_CajasMovimientosDetalle_EmpTarjetas]
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CajasMovimientosDetalle_TiposPagos] FOREIGN KEY([IdTipoPago])
REFERENCES [dbo].[TiposPagos] ([IdTipoPago])
GO
ALTER TABLE [dbo].[CajasMovimientosDetalle] CHECK CONSTRAINT [FK_CajasMovimientosDetalle_TiposPagos]
GO
ALTER TABLE [dbo].[CancelacionFacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_CancelacionFacturasCompra_MovimientosBancos] FOREIGN KEY([IdMovBanco])
REFERENCES [dbo].[MovimientosBancos] ([IdMovBanco])
GO
ALTER TABLE [dbo].[CancelacionFacturasCompra] CHECK CONSTRAINT [FK_CancelacionFacturasCompra_MovimientosBancos]
GO
ALTER TABLE [dbo].[Cheques]  WITH CHECK ADD  CONSTRAINT [FK_Cheques_Bancos] FOREIGN KEY([IdBanco])
REFERENCES [dbo].[Bancos] ([IdBanco])
GO
ALTER TABLE [dbo].[Cheques] CHECK CONSTRAINT [FK_Cheques_Bancos]
GO
ALTER TABLE [dbo].[Cheques]  WITH CHECK ADD  CONSTRAINT [FK_Cheques_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[Cheques] CHECK CONSTRAINT [FK_Cheques_Empresa]
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_CPostales] FOREIGN KEY([CodigoPostal], [SubCodigoPostal])
REFERENCES [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal])
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_CPostales]
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_RegimenesImpositivos] FOREIGN KEY([IdRegimenImpositivo])
REFERENCES [dbo].[RegimenesImpositivos] ([IdRegimenImpositivo])
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_RegimenesImpositivos]
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_TiposDocumento] FOREIGN KEY([TipoDocumento])
REFERENCES [dbo].[TiposDocumento] ([TipoDocumento])
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_TiposDocumento]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_CajasDistribuciones] FOREIGN KEY([UsuarioUltimaModificacion])
REFERENCES [dbo].[Usuarios] ([IdUser])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_CajasDistribuciones]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Clientes] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Clientes] ([NroCliente])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Clientes]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Servicios] FOREIGN KEY([ServicioId])
REFERENCES [dbo].[Servicios] ([ServicioId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Servicios]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Usuarios] FOREIGN KEY([UsuarioUltimaModificacion])
REFERENCES [dbo].[Usuarios] ([IdUser])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Usuarios]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_ClientesCajasDistribucionesServicios] FOREIGN KEY([ClienteCajaDistribucionServicioId])
REFERENCES [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_ClientesCajasDistribucionesServicios]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_Estados] FOREIGN KEY([EstadoId])
REFERENCES [dbo].[Estados] ([EstadoId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_Estados]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_Usuarios] FOREIGN KEY([UsuarioUltimaModificacion])
REFERENCES [dbo].[Usuarios] ([IdUser])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServiciosEstados_Usuarios]
GO
ALTER TABLE [dbo].[ControladoresFiscales]  WITH CHECK ADD  CONSTRAINT [FK_ControladoresFiscales_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[ControladoresFiscales] CHECK CONSTRAINT [FK_ControladoresFiscales_Empresa]
GO
ALTER TABLE [dbo].[CPostales]  WITH CHECK ADD  CONSTRAINT [FK_CPOSTALES_PROVINCIAS] FOREIGN KEY([IdProvincia])
REFERENCES [dbo].[Provincias] ([IdProvincia])
GO
ALTER TABLE [dbo].[CPostales] CHECK CONSTRAINT [FK_CPOSTALES_PROVINCIAS]
GO
ALTER TABLE [dbo].[DatosImpositivos]  WITH CHECK ADD  CONSTRAINT [FK_DatosImpositivos_Clientes] FOREIGN KEY([NroCliente])
REFERENCES [dbo].[Clientes] ([NroCliente])
GO
ALTER TABLE [dbo].[DatosImpositivos] CHECK CONSTRAINT [FK_DatosImpositivos_Clientes]
GO
ALTER TABLE [dbo].[DatosImpositivos]  WITH CHECK ADD  CONSTRAINT [FK_DatosImpositivos_Provincias] FOREIGN KEY([IdProvincia])
REFERENCES [dbo].[Provincias] ([IdProvincia])
GO
ALTER TABLE [dbo].[DatosImpositivos] CHECK CONSTRAINT [FK_DatosImpositivos_Provincias]
GO
ALTER TABLE [dbo].[DatosImpositivos]  WITH CHECK ADD  CONSTRAINT [FK_DatosImpositivos_TiposImpuestos] FOREIGN KEY([IdTipoImpuesto])
REFERENCES [dbo].[TiposImpuestos] ([IdTipoImpuesto])
GO
ALTER TABLE [dbo].[DatosImpositivos] CHECK CONSTRAINT [FK_DatosImpositivos_TiposImpuestos]
GO
ALTER TABLE [dbo].[Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Empresa_Empresa] FOREIGN KEY([CodigoPostal], [SubCodigoPostal])
REFERENCES [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal])
GO
ALTER TABLE [dbo].[Empresa] CHECK CONSTRAINT [FK_Empresa_Empresa]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_CondicionesPago] FOREIGN KEY([IdCondicionPago])
REFERENCES [dbo].[CondicionesPago] ([IdCondicionPago])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_CondicionesPago]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_Empresa]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_FormasPago] FOREIGN KEY([IdFormaPago])
REFERENCES [dbo].[FormasPago] ([IdFormaPago])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_FormasPago]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_Proveedores] FOREIGN KEY([NroProveedor])
REFERENCES [dbo].[Proveedores] ([NroProveedor])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_Proveedores]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_TiposDocFact] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TiposDocFact] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_TiposDocFact]
GO
ALTER TABLE [dbo].[FacturasCompra]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompra_TiposFactura] FOREIGN KEY([IdTipoFactura])
REFERENCES [dbo].[TiposFactura] ([IdTipoFactura])
GO
ALTER TABLE [dbo].[FacturasCompra] CHECK CONSTRAINT [FK_FacturasCompra_TiposFactura]
GO
ALTER TABLE [dbo].[FacturasCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompraDetalle_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[FacturasCompraDetalle] CHECK CONSTRAINT [FK_FacturasCompraDetalle_Articulos]
GO
ALTER TABLE [dbo].[FacturasCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompraDetalle_FacturasCompra] FOREIGN KEY([IdFacturaCompra])
REFERENCES [dbo].[FacturasCompra] ([IdFacturaCompra])
GO
ALTER TABLE [dbo].[FacturasCompraDetalle] CHECK CONSTRAINT [FK_FacturasCompraDetalle_FacturasCompra]
GO
ALTER TABLE [dbo].[FacturasCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasCompraDetalle_TiposIva] FOREIGN KEY([IdTipoIva])
REFERENCES [dbo].[TiposIva] ([IdTipoIva])
GO
ALTER TABLE [dbo].[FacturasCompraDetalle] CHECK CONSTRAINT [FK_FacturasCompraDetalle_TiposIva]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Concepto_Factura] FOREIGN KEY([IdConceptoFactura])
REFERENCES [dbo].[TiposConceptoFactura] ([IdConceptoFactura])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Concepto_Factura]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_Clientes] FOREIGN KEY([ClienteCajaDistribucionServicioId])
REFERENCES [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Facturas_Clientes]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_CondicionesPago] FOREIGN KEY([IdCondicionPago])
REFERENCES [dbo].[CondicionesPago] ([IdCondicionPago])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Facturas_CondicionesPago]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_FormasPago] FOREIGN KEY([IdFormaPago])
REFERENCES [dbo].[FormasPago] ([IdFormaPago])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Facturas_FormasPago]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_TiposDocFact] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TiposDocFact] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Facturas_TiposDocFact]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_Facturas_TiposFactura] FOREIGN KEY([IdTipoFactura])
REFERENCES [dbo].[TiposFactura] ([IdTipoFactura])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_Facturas_TiposFactura]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVenta_ConceptosFactura] FOREIGN KEY([IdConceptoFactura])
REFERENCES [dbo].[TiposConceptoFactura] ([IdConceptoFactura])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_FacturasVenta_ConceptosFactura]
GO
ALTER TABLE [dbo].[FacturasVenta]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVenta_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[FacturasVenta] CHECK CONSTRAINT [FK_FacturasVenta_Empresa]
GO
ALTER TABLE [dbo].[FacturasVentaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVentaDetalle_FacturasVenta] FOREIGN KEY([IdFacturaVenta])
REFERENCES [dbo].[FacturasVenta] ([IdFacturaVenta])
GO
ALTER TABLE [dbo].[FacturasVentaDetalle] CHECK CONSTRAINT [FK_FacturasVentaDetalle_FacturasVenta]
GO
ALTER TABLE [dbo].[FacturasVentaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVentaDetalle_Servicios] FOREIGN KEY([IdServicio])
REFERENCES [dbo].[Servicios] ([ServicioId])
GO
ALTER TABLE [dbo].[FacturasVentaDetalle] CHECK CONSTRAINT [FK_FacturasVentaDetalle_Servicios]
GO
ALTER TABLE [dbo].[FacturasVentaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_FacturasVentaDetalle_TiposIva] FOREIGN KEY([IdTipoIva])
REFERENCES [dbo].[TiposIva] ([IdTipoIva])
GO
ALTER TABLE [dbo].[FacturasVentaDetalle] CHECK CONSTRAINT [FK_FacturasVentaDetalle_TiposIva]
GO
ALTER TABLE [dbo].[GeneracionInteres]  WITH CHECK ADD  CONSTRAINT [FK_GeneracionInteres_DiaGeneracionInteres] FOREIGN KEY([IdDiaGeneracion])
REFERENCES [dbo].[DiaGeneracionInteres] ([IdDiaGeneracion])
GO
ALTER TABLE [dbo].[GeneracionInteres] CHECK CONSTRAINT [FK_GeneracionInteres_DiaGeneracionInteres]
GO
ALTER TABLE [dbo].[GeneracionInteres]  WITH CHECK ADD  CONSTRAINT [FK_GeneracionInteres_FacturasVenta] FOREIGN KEY([IdFacturaVenta])
REFERENCES [dbo].[FacturasVenta] ([IdFacturaVenta])
GO
ALTER TABLE [dbo].[GeneracionInteres] CHECK CONSTRAINT [FK_GeneracionInteres_FacturasVenta]
GO
ALTER TABLE [dbo].[LiquidacionesFacturas]  WITH CHECK ADD  CONSTRAINT [FK_LiquidacionesFacturas_Liquidaciones] FOREIGN KEY([IdLiquidacion])
REFERENCES [dbo].[Liquidaciones] ([IdLiquidacion])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LiquidacionesFacturas] CHECK CONSTRAINT [FK_LiquidacionesFacturas_Liquidaciones]
GO
ALTER TABLE [dbo].[ModulosTiposUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_ModulosTiposUsuarios_Modulos] FOREIGN KEY([IdModulo])
REFERENCES [dbo].[Modulos] ([IdModulo])
GO
ALTER TABLE [dbo].[ModulosTiposUsuarios] CHECK CONSTRAINT [FK_ModulosTiposUsuarios_Modulos]
GO
ALTER TABLE [dbo].[ModulosTiposUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_ModulosTiposUsuarios_TiposUsuarios] FOREIGN KEY([IdTipoUsuario])
REFERENCES [dbo].[TiposUsuarios] ([IdTipoUser])
GO
ALTER TABLE [dbo].[ModulosTiposUsuarios] CHECK CONSTRAINT [FK_ModulosTiposUsuarios_TiposUsuarios]
GO
ALTER TABLE [dbo].[MovimientosBancos]  WITH CHECK ADD  CONSTRAINT [FK_MovimientosBancos_TiposMovimientosBanco] FOREIGN KEY([IdTipoMovBanco])
REFERENCES [dbo].[TiposMovimientosBanco] ([IdTipoMovBanco])
GO
ALTER TABLE [dbo].[MovimientosBancos] CHECK CONSTRAINT [FK_MovimientosBancos_TiposMovimientosBanco]
GO
ALTER TABLE [dbo].[MovimientosBancos]  WITH CHECK ADD  CONSTRAINT [FK_MovimientosBancos_TiposPersona] FOREIGN KEY([IdTipoPersona])
REFERENCES [dbo].[TiposPersona] ([IdTipoPersona])
GO
ALTER TABLE [dbo].[MovimientosBancos] CHECK CONSTRAINT [FK_MovimientosBancos_TiposPersona]
GO
ALTER TABLE [dbo].[OrdenesPedidos]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesPedidos_Clientes] FOREIGN KEY([NroProveedor])
REFERENCES [dbo].[Proveedores] ([NroProveedor])
GO
ALTER TABLE [dbo].[OrdenesPedidos] CHECK CONSTRAINT [FK_OrdenesPedidos_Clientes]
GO
ALTER TABLE [dbo].[OrdenesPedidosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_OrdenesPedidosDetalle_OrdenesPedidos] FOREIGN KEY([IdOrdenPedido])
REFERENCES [dbo].[OrdenesPedidos] ([IdOrdenPedido])
GO
ALTER TABLE [dbo].[OrdenesPedidosDetalle] CHECK CONSTRAINT [FK_OrdenesPedidosDetalle_OrdenesPedidos]
GO
ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD  CONSTRAINT [FK_Pagos_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[Pagos] CHECK CONSTRAINT [FK_Pagos_Empresa]
GO
ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD  CONSTRAINT [FK_Pagos_Proveedores] FOREIGN KEY([NroProveedor])
REFERENCES [dbo].[Proveedores] ([NroProveedor])
GO
ALTER TABLE [dbo].[Pagos] CHECK CONSTRAINT [FK_Pagos_Proveedores]
GO
ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD  CONSTRAINT [FK_Pagos_TiposDocFact] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TiposDocFact] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[Pagos] CHECK CONSTRAINT [FK_Pagos_TiposDocFact]
GO
ALTER TABLE [dbo].[PagosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_PagosDetalle_Cheques] FOREIGN KEY([IdCheque])
REFERENCES [dbo].[Cheques] ([IdCheque])
GO
ALTER TABLE [dbo].[PagosDetalle] CHECK CONSTRAINT [FK_PagosDetalle_Cheques]
GO
ALTER TABLE [dbo].[PagosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_PagosDetalle_Pagos] FOREIGN KEY([IdPago])
REFERENCES [dbo].[Pagos] ([IdPago])
GO
ALTER TABLE [dbo].[PagosDetalle] CHECK CONSTRAINT [FK_PagosDetalle_Pagos]
GO
ALTER TABLE [dbo].[PagosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_PagosDetalle_TiposPagos] FOREIGN KEY([IdTipoPago])
REFERENCES [dbo].[TiposPagos] ([IdTipoPago])
GO
ALTER TABLE [dbo].[PagosDetalle] CHECK CONSTRAINT [FK_PagosDetalle_TiposPagos]
GO
ALTER TABLE [dbo].[PreciosVenta]  WITH CHECK ADD  CONSTRAINT [FK_PreciosVenta_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[PreciosVenta] CHECK CONSTRAINT [FK_PreciosVenta_Articulos]
GO
ALTER TABLE [dbo].[Presupuestos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuestos_Clientes] FOREIGN KEY([NroCliente])
REFERENCES [dbo].[Clientes] ([NroCliente])
GO
ALTER TABLE [dbo].[Presupuestos] CHECK CONSTRAINT [FK_Presupuestos_Clientes]
GO
ALTER TABLE [dbo].[Presupuestos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuestos_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[Presupuestos] CHECK CONSTRAINT [FK_Presupuestos_Empresa]
GO
ALTER TABLE [dbo].[PresupuestosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_PresupuestosDetalles_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[PresupuestosDetalles] CHECK CONSTRAINT [FK_PresupuestosDetalles_Articulos]
GO
ALTER TABLE [dbo].[PresupuestosDetalles]  WITH CHECK ADD  CONSTRAINT [FK_PresupuestosDetalles_Presupuestos] FOREIGN KEY([IdPresupuesto])
REFERENCES [dbo].[Presupuestos] ([IdPresupuesto])
GO
ALTER TABLE [dbo].[PresupuestosDetalles] CHECK CONSTRAINT [FK_PresupuestosDetalles_Presupuestos]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_CPostales] FOREIGN KEY([CodigoPostal], [SubCodigoPostal])
REFERENCES [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_CPostales]
GO
ALTER TABLE [dbo].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_TiposDocumento] FOREIGN KEY([TipoDocumento])
REFERENCES [dbo].[TiposDocumento] ([TipoDocumento])
GO
ALTER TABLE [dbo].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_TiposDocumento]
GO
ALTER TABLE [dbo].[Recibos]  WITH CHECK ADD  CONSTRAINT [FK_Recibos_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[Recibos] CHECK CONSTRAINT [FK_Recibos_Empresa]
GO
ALTER TABLE [dbo].[Recibos]  WITH CHECK ADD  CONSTRAINT [FK_Recibos_TiposDocFact] FOREIGN KEY([IdTipoDocumento])
REFERENCES [dbo].[TiposDocFact] ([IdTipoDocumento])
GO
ALTER TABLE [dbo].[Recibos] CHECK CONSTRAINT [FK_Recibos_TiposDocFact]
GO
ALTER TABLE [dbo].[RecibosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RecibosDetalle_Cheques] FOREIGN KEY([IdCheque])
REFERENCES [dbo].[Cheques] ([IdCheque])
GO
ALTER TABLE [dbo].[RecibosDetalle] CHECK CONSTRAINT [FK_RecibosDetalle_Cheques]
GO
ALTER TABLE [dbo].[RecibosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RecibosDetalle_EmpTarjetas] FOREIGN KEY([IdEmpTarjeta])
REFERENCES [dbo].[EmpTarjetas] ([IdEmpTarjeta])
GO
ALTER TABLE [dbo].[RecibosDetalle] CHECK CONSTRAINT [FK_RecibosDetalle_EmpTarjetas]
GO
ALTER TABLE [dbo].[RecibosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RecibosDetalle_Recibos] FOREIGN KEY([IdRecibo])
REFERENCES [dbo].[Recibos] ([IdRecibo])
GO
ALTER TABLE [dbo].[RecibosDetalle] CHECK CONSTRAINT [FK_RecibosDetalle_Recibos]
GO
ALTER TABLE [dbo].[RecibosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RecibosDetalle_TiposPagos] FOREIGN KEY([IdTipoPago])
REFERENCES [dbo].[TiposPagos] ([IdTipoPago])
GO
ALTER TABLE [dbo].[RecibosDetalle] CHECK CONSTRAINT [FK_RecibosDetalle_TiposPagos]
GO
ALTER TABLE [dbo].[ReferentesProveedores]  WITH CHECK ADD  CONSTRAINT [FK_ReferentesProveedores_Proveedores] FOREIGN KEY([NroProveedor])
REFERENCES [dbo].[Proveedores] ([NroProveedor])
GO
ALTER TABLE [dbo].[ReferentesProveedores] CHECK CONSTRAINT [FK_ReferentesProveedores_Proveedores]
GO
ALTER TABLE [dbo].[Remitos]  WITH CHECK ADD  CONSTRAINT [FK_Remitos_Clientes] FOREIGN KEY([NroCliente])
REFERENCES [dbo].[Clientes] ([NroCliente])
GO
ALTER TABLE [dbo].[Remitos] CHECK CONSTRAINT [FK_Remitos_Clientes]
GO
ALTER TABLE [dbo].[Remitos]  WITH CHECK ADD  CONSTRAINT [FK_Remitos_FacturasVenta] FOREIGN KEY([IdFactura])
REFERENCES [dbo].[FacturasVenta] ([IdFacturaVenta])
GO
ALTER TABLE [dbo].[Remitos] CHECK CONSTRAINT [FK_Remitos_FacturasVenta]
GO
ALTER TABLE [dbo].[Remitos]  WITH CHECK ADD  CONSTRAINT [FK_Remitos_Remitos] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[Remitos] CHECK CONSTRAINT [FK_Remitos_Remitos]
GO
ALTER TABLE [dbo].[RemitosCompra]  WITH CHECK ADD  CONSTRAINT [FK_RemitosCompra_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [dbo].[RemitosCompra] CHECK CONSTRAINT [FK_RemitosCompra_Empresa]
GO
ALTER TABLE [dbo].[RemitosCompra]  WITH CHECK ADD  CONSTRAINT [FK_RemitosCompra_Proveedores] FOREIGN KEY([NroProveedor])
REFERENCES [dbo].[Proveedores] ([NroProveedor])
GO
ALTER TABLE [dbo].[RemitosCompra] CHECK CONSTRAINT [FK_RemitosCompra_Proveedores]
GO
ALTER TABLE [dbo].[RemitosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RemitosDetalle_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[RemitosDetalle] CHECK CONSTRAINT [FK_RemitosDetalle_Articulos]
GO
ALTER TABLE [dbo].[RemitosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_RemitosDetalle_Remitos] FOREIGN KEY([IdRemito])
REFERENCES [dbo].[Remitos] ([IdRemito])
GO
ALTER TABLE [dbo].[RemitosDetalle] CHECK CONSTRAINT [FK_RemitosDetalle_Remitos]
GO
ALTER TABLE [dbo].[RemitosDetalleCompra]  WITH CHECK ADD  CONSTRAINT [FK_RemitosDetalleCompra_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulo])
GO
ALTER TABLE [dbo].[RemitosDetalleCompra] CHECK CONSTRAINT [FK_RemitosDetalleCompra_Articulos]
GO
ALTER TABLE [dbo].[RemitosDetalleCompra]  WITH CHECK ADD  CONSTRAINT [FK_RemitosDetalleCompra_RemitosCompra] FOREIGN KEY([IdRemitoCompra])
REFERENCES [dbo].[RemitosCompra] ([IdRemitoCompra])
GO
ALTER TABLE [dbo].[RemitosDetalleCompra] CHECK CONSTRAINT [FK_RemitosDetalleCompra_RemitosCompra]
GO
ALTER TABLE [dbo].[Servicios]  WITH CHECK ADD  CONSTRAINT [FK_Servicios_Servicios] FOREIGN KEY([UsuarioUltimaModificacion])
REFERENCES [dbo].[Usuarios] ([IdUser])
GO
ALTER TABLE [dbo].[Servicios] CHECK CONSTRAINT [FK_Servicios_Servicios]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_TiposUsuarios] FOREIGN KEY([IdTipoUser])
REFERENCES [dbo].[TiposUsuarios] ([IdTipoUser])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_TiposUsuarios]
GO
ALTER TABLE [dbo].[Vendedores]  WITH CHECK ADD  CONSTRAINT [FK_TiposVendedores_Vendedores] FOREIGN KEY([IdTipoVendedor])
REFERENCES [dbo].[TiposVendedores] ([IdTipoVendedor])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Vendedores] CHECK CONSTRAINT [FK_TiposVendedores_Vendedores]
GO
ALTER TABLE [dbo].[Vendedores]  WITH CHECK ADD  CONSTRAINT [FK_TiposVendedoresExternos_Vendedores] FOREIGN KEY([IdTipoVendedorExt])
REFERENCES [dbo].[TiposVendedoresExternos] ([IdTipoVendedorExt])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Vendedores] CHECK CONSTRAINT [FK_TiposVendedoresExternos_Vendedores]
GO
ALTER TABLE [dbo].[Vendedores]  WITH CHECK ADD  CONSTRAINT [FK_Vendedores_CPostales] FOREIGN KEY([CodigoPostal], [SubCodigoPostal])
REFERENCES [dbo].[CPostales] ([CodigoPostal], [SubCodigoPostal])
GO
ALTER TABLE [dbo].[Vendedores] CHECK CONSTRAINT [FK_Vendedores_CPostales]
GO
ALTER TABLE [dbo].[Vendedores]  WITH CHECK ADD  CONSTRAINT [FK_Vendedores_TiposDocumento] FOREIGN KEY([TipoDocumento])
REFERENCES [dbo].[TiposDocumento] ([TipoDocumento])
GO
ALTER TABLE [dbo].[Vendedores] CHECK CONSTRAINT [FK_Vendedores_TiposDocumento]
GO
/****** Object:  StoredProcedure [dbo].[SeleccionarEstadoCCClientesPorFechas]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[SeleccionarEstadoCCClientesPorFechas]  
   @IdEmpresa as smallint,  
   @Desde as DateTime2,  
   @Hasta as DateTime2
  
AS  
  
SELECT     aux.NroCliente, aux.Cliente, SUM(aux.Debe) AS Debe, SUM(aux.Haber) AS Haber, SUM(aux.Debe - aux.Haber) AS Saldo, aux.IdEmpresa, C.FechaBaja  
FROM         (SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, ISNULL(SUM(FV.Total), 0) AS Debe, 0 AS Haber, FV.IdEmpresa  
                       FROM          dbo.Clientes AS C LEFT OUTER JOIN  
                                              dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente  
                       WHERE      (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 1) AND (FV.FechaAnulacion IS NULL) and (FV.FechaEmision >= @Desde and FV.FechaEmision <= @Hasta)  
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa  
                       UNION  
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, ISNULL(SUM(FV.Total), 0) AS Haber, FV.IdEmpresa  
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN  
                                             dbo.FacturasVenta AS FV ON FV.NroCliente = C.NroCliente  
                       WHERE     (FV.IdFormaPago = 2) AND (FV.IdTipoDocumento = 2) AND (FV.FechaAnulacion IS NULL) and (FV.FechaEmision >= @Desde and FV.FechaEmision <= @Hasta)  
                       GROUP BY C.NroCliente, C.ApellidoyNombre, FV.IdEmpresa  
                       UNION  
                       SELECT     C.NroCliente, C.ApellidoyNombre AS Cliente, 0 AS Debe, SUM(ISNULL(R.MontoTotal, 0)) AS Haber, R.IdEmpresa  
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN  
                                             dbo.Recibos AS R ON C.NroCliente = R.NroCliente AND R.FechaBaja IS NULL  
        WHERE R.FechaEmision >= @Desde and R.FechaEmision <= @Hasta  
                       GROUP BY C.NroCliente, C.ApellidoyNombre, R.IdEmpresa  
                       UNION  
                       SELECT     C.NroCliente, C.ApellidoyNombre, ISNULL(SUM(GI.TotalInteres), 0) AS Debe, 0 AS Haber, fv.IdEmpresa  
                       FROM         dbo.Clientes AS C LEFT OUTER JOIN  
                                             dbo.FacturasVenta AS fv ON fv.NroCliente = C.NroCliente AND fv.FechaAnulacion IS NULL AND fv.IdFormaPago = 2 LEFT OUTER JOIN  
                                                 (SELECT     MAX(IdDiaGeneracion) AS IdDia, IdFacturaVenta  
                                                   FROM          dbo.GeneracionInteres  
                                                   GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta INNER JOIN  
                                             dbo.GeneracionInteres AS GI ON GI.IdDiaGeneracion = AuxInt.IdDia AND AuxInt.IdFacturaVenta = GI.IdFacturaVenta  
                       WHERE (FV.FechaEmision >= @Desde and FV.FechaEmision <= @Hasta)                     
                       GROUP BY C.NroCliente, C.ApellidoyNombre, fv.IdEmpresa) AS aux INNER JOIN  
                      dbo.Clientes AS C ON C.NroCliente = aux.NroCliente  
WHERE     (aux.IdEmpresa IS NOT NULL) and aux.IdEmpresa = @IdEmpresa  
GROUP BY aux.NroCliente, aux.Cliente, aux.IdEmpresa, C.FechaBaja  
  
  
  
  
  
  
  








GO
/****** Object:  StoredProcedure [dbo].[sp_ListaDeudores]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListaDeudores]
@TipoDoc smallint,
@FechaDesde datetime,
@FechaHasta datetime
--@NroCliente bigint

AS

select NroCliente, ApellidoyNombre, NroDocumento, CUIT, SUM(PendienteCobro) as PendienteCobro
from VistaFacturasSinSaldar
WHERE (@TipoDoc = 0 or IdTipoDocumento = @TipoDoc)
and (@FechaDesde is null or FechaEmision >= @FechaDesde)
and (@FechaHasta is null or FechaEmision <= @FechaHasta)
--AND fss.NroCliente = CASE WHEN @NroCliente > 0 THEN fss.NroCliente ELSE @NroCliente END
group by NroCliente, ApellidoyNombre, NroDocumento, CUIT
order by ApellidoyNombre 

GO
/****** Object:  StoredProcedure [dbo].[sp_MovimientosStockPorFecha]    Script Date: 1/6/2022 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[sp_MovimientosStockPorFecha]
 @FechaDesde datetime,
 @FechaHasta datetime
 as
 select aux.IdArticulo, A.DescCorta as Articulo, SUM(aux.ingreso) as TotalIngreso, SUM(aux.Egreso) as TotalEgreso, Round(SUM(aux.ingreso) - SUM(aux.Egreso), 2) as Total
 from (
		Select MD.IdArticulo, SUM(MD.Ingreso) as Ingreso, SUM(MD.Egreso) as Egreso
		from VistaDetalleMovimientosDepositos MD inner join
			Articulos A on A.IdArticulo = MD.IdArticulo
		where MD.IdDeposito = 1 and MD.FechaMovimiento >= @FechaDesde and MD.FechaMovimiento <= @FechaHasta
		group by MD.IdArticulo, A.DescCorta) as aux inner join
Articulos A on aux.IdArticulo = A.IdArticulo
group by aux.IdArticulo, A.DescCorta



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
            TopColumn = 0
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
         Begin Table = "FP"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 95
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RI"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 95
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TF"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 95
               Right = 1180
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
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CabeceraArchivoFact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CabeceraArchivoFact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CabeceraArchivoFact'
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
         Begin Table = "Aux"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CalculoStockInicial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CalculoStockInicial'
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
         Begin Table = "FVD"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UM"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 95
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 110
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TI"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 95
               Right = 1180
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
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DetalleArchivoFact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DetalleArchivoFact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DetalleArchivoFact'
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
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1950
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FechaServidor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FechaServidor'
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
         Begin Table = "ca"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaAperturasCajas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaAperturasCajas'
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
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Rubros"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 101
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubRubros"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnidadesMedida"
            Begin Extent = 
               Top = 0
               Left = 1046
               Bottom = 101
               Right = 1235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 102
               Left = 285
               Bottom = 191
               Right = 483
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
      Begin ColumnWidths = 14
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
      End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArticulos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArticulos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArticulos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[21] 3) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Aux2"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 413
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 12
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArticulosPV'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArticulosPV'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[21] 3) )"
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
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 125
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 95
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UM"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 95
               Right = 1180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 236
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
      Begin ColumnWidths = 10
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArtSinVentas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArtSinVentas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaArtSinVentas'
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
         Begin Table = "Remitos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "CPostales"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 135
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RegimenesImpositivos"
            Begin Extent = 
               Top = 6
               Left = 779
               Bottom = 101
               Right = 988
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabeceraRemImp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabeceraRemImp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[20] 2[21] 3) )"
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
         Begin Table = "FacturasCompra"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 31
         End
         Begin Table = "TiposDocFact"
            Begin Extent = 
               Top = 0
               Left = 272
               Bottom = 95
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposFactura"
            Begin Extent = 
               Top = 156
               Left = 38
               Bottom = 251
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CondicionesPago"
            Begin Extent = 
               Top = 198
               Left = 533
               Bottom = 310
               Right = 742
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FormasPago"
            Begin Extent = 
               Top = 252
               Left = 38
               Bottom = 347
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 6
               Left = 538
               Bottom = 134
               Right = 728
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 766
               Bottom = 125
               Right = 964
            End
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactCompra'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         DisplayFlags = 280
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactCompra'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactCompra'
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
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCabFactVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'          DisplayFlags = 280
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
         Begin Table = "Cajas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EstadosCaja"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCajas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCajas'
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
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "FVD"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 542
               Bottom = 125
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 6
               Left = 794
               Bottom = 95
               Right = 1008
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 96
               Left = 794
               Bottom = 185
               Right = 1008
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
         Outpu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N't = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubro'
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
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "FVD"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 542
               Bottom = 125
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 6
               Left = 794
               Bottom = 95
               Right = 1008
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 96
               Left = 794
               Bottom = 185
               Right = 1008
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
         Outpu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubroSubRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N't = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubroSubRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporRubroSubRubro'
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
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "FVD"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 542
               Bottom = 125
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 6
               Left = 794
               Bottom = 95
               Right = 1008
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S"
            Begin Extent = 
               Top = 96
               Left = 794
               Bottom = 185
               Right = 1008
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
         Outpu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporSubRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N't = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporSubRubro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCantFactporSubRubro'
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 6
               Left = 542
               Bottom = 95
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux2"
            Begin Extent = 
               Top = 6
               Left = 794
               Bottom = 95
               Right = 1008
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux3"
            Begin Extent = 
               Top = 198
               Left = 38
               Bottom = 287
               Right = 252
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
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCCClientesME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Output = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCCClientesME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCCClientesME'
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
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux2"
            Begin Extent = 
               Top = 6
               Left = 794
               Bottom = 95
               Right = 1008
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 6
               Left = 542
               Bottom = 95
               Right = 756
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCCProveedoresME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCCProveedoresME'
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
         Begin Table = "ControladoresFiscales"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "TiposCF"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Usuarios"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 125
               Right = 708
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
         Width = 2430
         Width = 1500
         Width = 3930
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCFs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCFs'
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
         Begin Table = "Cheques"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "RecibosDetalle"
            Begin Extent = 
               Top = 13
               Left = 433
               Bottom = 135
               Right = 620
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Recibos"
            Begin Extent = 
               Top = 6
               Left = 658
               Bottom = 135
               Right = 867
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 6
               Left = 905
               Bottom = 135
               Right = 1114
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Bancos"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 233
               Right = 247
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
      Begin ColumnWidths = 12
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
      End
   End
   Begin CriteriaPane = 
      Begi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCheques'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'n ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCheques'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCheques'
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
         Begin Table = "Cheques"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Bancos"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PagosDetalle"
            Begin Extent = 
               Top = 96
               Left = 274
               Bottom = 215
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Pagos"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 216
               Left = 274
               Bottom = 335
               Right = 472
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
      Begin ColumnWidths = 12
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
      End
   End
   Begin CriteriaPane = 
      Begin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaChequesPropios'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaChequesPropios'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaChequesPropios'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[22] 2[21] 3) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 37
               Left = 106
               Bottom = 166
               Right = 315
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "RegimenesImpositivos"
            Begin Extent = 
               Top = 0
               Left = 457
               Bottom = 95
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CPostales"
            Begin Extent = 
               Top = 130
               Left = 458
               Bottom = 259
               Right = 667
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Provincias"
            Begin Extent = 
               Top = 6
               Left = 951
               Bottom = 101
               Right = 1160
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ClientesCajasDistribucionesServicios"
            Begin Extent = 
               Top = 102
               Left = 705
               Bottom = 232
               Right = 969
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CajasDistribuciones"
            Begin Extent = 
               Top = 168
               Left = 38
               Bottom = 298
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 234
               Left = 705
               Bottom = 364
               Rig' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ht = 939
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
      Begin ColumnWidths = 16
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2700
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaClientes'
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
         Begin Table = "RecibosDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Recibos"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "TiposPagos"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 95
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 125
               Right = 944
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
         Width = 1785
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
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCobranzaxTP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCobranzaxTP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCobranzaxTP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[20] 3) )"
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
         Begin Table = "CP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 101
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCPostales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCPostales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[21] 3) )"
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
         Top = -1632
         Left = 0
      End
      Begin Tables = 
         Begin Table = "C"
            Begin Extent = 
               Top = 870
               Left = 290
               Bottom = 989
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 1638
               Left = 38
               Bottom = 1757
               Right = 252
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
         Width = 3105
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCtaCteClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCtaCteClientes'
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
         Top = -1056
         Left = -1213
      End
      Begin Tables = 
         Begin Table = "aux"
            Begin Extent = 
               Top = 1062
               Left = 1251
               Bottom = 1181
               Right = 1465
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCtaCteProveedores'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaCtaCteProveedores'
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
         Begin Table = "DatosImpositivos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposImpuestos"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Provincias"
            Begin Extent = 
               Top = 6
               Left = 1026
               Bottom = 101
               Right = 1235
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
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDatosImpositivos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDatosImpositivos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[20] 3) )"
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
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
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
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleCCClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleCCClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[20] 3) )"
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
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Aux"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleCCProv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleCCProv'
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
         Begin Table = "FacturasCompraDetalle"
            Begin Extent = 
               Top = 0
               Left = 54
               Bottom = 129
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposIva"
            Begin Extent = 
               Top = 6
               Left = 606
               Bottom = 95
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 36
               Left = 359
               Bottom = 165
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnidadesMedida"
            Begin Extent = 
               Top = 132
               Left = 38
               Bottom = 227
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FC"
            Begin Extent = 
               Top = 102
               Left = 606
               Bottom = 221
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
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
      End
   End
   Begin CriteriaPane = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactCompra'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactCompra'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactCompra'
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
         Begin Table = "FacturasVentaDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnidadesMedida"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposIva"
            Begin Extent = 
               Top = 6
               Left = 779
               Bottom = 95
               Right = 977
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
      Begin ColumnWidths = 10
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
         O' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'r = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleFactVenta'
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CA"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAD"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 125
               Right = 709
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dinero"
            Begin Extent = 
               Top = 6
               Left = 747
               Bottom = 95
               Right = 945
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cheque"
            Begin Extent = 
               Top = 6
               Left = 983
               Bottom = 95
               Right = 1181
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TC"
            Begin Extent = 
               Top = 96
               Left = 747
               Bottom = 185
               Right = 945
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TD"
            Begin Extent = 
               Top = 96
               Left = 983
               Bottom = 185
               Right = 1181
            End
            DisplayFlags = 280
            TopColumn = 0
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleMovimientosCajaySencillo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      End
         Begin Table = "TB"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 215
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TDC"
            Begin Extent = 
               Top = 126
               Left = 274
               Bottom = 215
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux"
            Begin Extent = 
               Top = 126
               Left = 510
               Bottom = 215
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aux2"
            Begin Extent = 
               Top = 186
               Left = 746
               Bottom = 275
               Right = 944
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleMovimientosCajaySencillo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDetalleMovimientosCajaySencillo'
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
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 95
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDiaGeneracionIntereses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaDiaGeneracionIntereses'
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
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CPostales"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaEmpresa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaEmpresa'
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
         Begin Table = "fv"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "cf"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaFacturasSinSaldar'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaFacturasSinSaldar'
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
         Begin Table = "g"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fv"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 125
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 95
               Right = 944
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaInteresesGenerados'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaInteresesGenerados'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLibroIvaVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ortOrder = 1410
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaLibroIvaVenta'
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
         Begin Table = "CM"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "TMC"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fv"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 125
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cmd"
            Begin Extent = 
               Top = 6
               Left = 746
               Bottom = 125
               Right = 954
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tp"
            Begin Extent = 
               Top = 96
               Left = 274
               Bottom = 185
               Right = 472
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
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2235
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
         Tab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaMovimientosCaja'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'le = 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaMovimientosCaja'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaMovimientosCaja'
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
         Top = -1440
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Aux"
            Begin Extent = 
               Top = 870
               Left = 38
               Bottom = 989
               Right = 236
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaMovStock'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaMovStock'
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
         Begin Table = "Pagos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 8
               Left = 359
               Bottom = 137
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 606
               Bottom = 125
               Right = 804
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagos'
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
         Begin Table = "PagosDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TiposPagos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 101
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cheques"
            Begin Extent = 
               Top = 102
               Left = 285
               Bottom = 231
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 7
         End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagosDetalle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagosDetalle'
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
         Begin Table = "PagosDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Pagos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "TiposPagos"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 233
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 138
               Left = 285
               Bottom = 267
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagosxTP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPagosxTP'
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
         Begin Table = "PreciosVenta"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "TiposIva"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPreciosVenta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPreciosVenta'
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
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
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
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1755
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
         Output = 1110
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPresupuestos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPresupuestos'
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
         Begin Table = "PresupuestosDetalles"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UM"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 95
               Right = 730
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPresupuestosDetalles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaPresupuestosDetalles'
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
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "CPostales"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Provincias"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaProveedores'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaProveedores'
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
         Begin Table = "Aux"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaProvVSArt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaProvVSArt'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingArticulos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingArticulos'
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
         Begin Table = "Aux"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 605
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingClientes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingClientes'
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
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FV"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 504
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingClientesconFechas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRankingClientesconFechas'
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
         Begin Table = "Recibos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 6
               Left = 395
               Bottom = 135
               Right = 604
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Empresa"
            Begin Extent = 
               Top = 6
               Left = 642
               Bottom = 125
               Right = 840
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRecibos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRecibos'
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
         Begin Table = "RecibosDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "TiposPagos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 101
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmpTarjetas"
            Begin Extent = 
               Top = 6
               Left = 779
               Bottom = 101
               Right = 988
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cheques"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 135
               Right = 741
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
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRecibosDetalle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRecibosDetalle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRecibosDetalle'
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
         Begin Table = "Remitos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Clientes"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "CPostales"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 135
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RegimenesImpositivos"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 233
               Right = 247
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
      Begin ColumnWidths = 13
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
         GroupB' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'y = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCab'
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
         Begin Table = "RemitosCompra"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Proveedores"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FacturasCompra"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 135
               Right = 741
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
         Width = 1770
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCompraCab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCompraCab'
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
         Top = -2150
         Left = -1143
      End
      Begin Tables = 
         Begin Table = "RemitosDetalleCompra"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 292
               Bottom = 135
               Right = 501
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnidadesMedida"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 233
               Right = 247
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCompraDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosCompraDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[21] 3) )"
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
         Begin Table = "RemitosDetalle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Articulos"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 135
               Right = 494
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnidadesMedida"
            Begin Extent = 
               Top = 6
               Left = 532
               Bottom = 101
               Right = 741
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosDet'
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
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 125
               Right = 472
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosnofactdeProv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaRemitosnofactdeProv'
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
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UM"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaStockArticulos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaStockArticulos'
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
         Begin Table = "aux2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fv"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 125
               Right = 512
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaTotalesDiscriminadosFactB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaTotalesDiscriminadosFactB'
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
         Begin Table = "cmd"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "cm"
            Begin Extent = 
               Top = 6
               Left = 299
               Bottom = 125
               Right = 514
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "TiposPagos"
            Begin Extent = 
               Top = 6
               Left = 552
               Bottom = 95
               Right = 766
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FacturasVenta"
            Begin Extent = 
               Top = 6
               Left = 804
               Bottom = 125
               Right = 1018
            End
            DisplayFlags = 280
            TopColumn = 1
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
      Begin ColumnWidths = 11
         Column = 6270
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
   En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaTotalFPagosCaja'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaTotalFPagosCaja'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaTotalFPagosCaja'
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
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Tu"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaUsuarios'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VistaUsuarios'
GO
USE [master]
GO
ALTER DATABASE [SgPymeBase] SET  READ_WRITE 
GO
