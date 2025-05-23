USE [master]
GO
/****** Object:  Database [VideoCableDB]    Script Date: 05/04/2022 22:11:46 ******/
CREATE DATABASE [VideoCableDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'VideoCableDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VideoCableDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'VideoCableDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VideoCableDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [VideoCableDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [VideoCableDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [VideoCableDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [VideoCableDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [VideoCableDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [VideoCableDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [VideoCableDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [VideoCableDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [VideoCableDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [VideoCableDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [VideoCableDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [VideoCableDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [VideoCableDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [VideoCableDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [VideoCableDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [VideoCableDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [VideoCableDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [VideoCableDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [VideoCableDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [VideoCableDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [VideoCableDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [VideoCableDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [VideoCableDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [VideoCableDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [VideoCableDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [VideoCableDB] SET  MULTI_USER 
GO
ALTER DATABASE [VideoCableDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [VideoCableDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [VideoCableDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [VideoCableDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [VideoCableDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [VideoCableDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [VideoCableDB] SET QUERY_STORE = OFF
GO
USE [VideoCableDB]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[PersonaId] [int] NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajasDistribuciones]    Script Date: 05/04/2022 22:11:46 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[ClienteId] [int] IDENTITY(1,1) NOT NULL,
	[PersonaId] [int] NOT NULL,
	[Direccion] [varchar](100) NOT NULL,
	[NumeroPrecinto] [varchar](100) NOT NULL,
	[FechaUltimaModificacion] [date] NOT NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientesCajasDistribucionesServicios]    Script Date: 05/04/2022 22:11:46 ******/
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
	[FechaUltimaModificacion] [date] NOT NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_ClientesCajasDistribucionesServicios] PRIMARY KEY CLUSTERED 
(
	[ClienteCajaDistribucionServicioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientesCajasDistribucionesServiciosEstados]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientesCajasDistribucionesServiciosEstados](
	[ClienteCajaDistribucionServicioEstadoId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteCajaDistribucionServicioId] [int] NOT NULL,
	[EstadoId] [int] NOT NULL,
	[FechaUltimaModificacion] [datetime] NOT NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_ClientesCajasDistribucionesServiciosEstados] PRIMARY KEY CLUSTERED 
(
	[ClienteCajaDistribucionServicioEstadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estados]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estados](
	[EstadoId] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Estados] PRIMARY KEY CLUSTERED 
(
	[EstadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personas]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personas](
	[PersonaId] [int] IDENTITY(1,1) NOT NULL,
	[RazonSocial] [nvarchar](100) NOT NULL,
	[Cuit] [nvarchar](50) NULL,
	[Direccion] [nvarchar](100) NULL,
	[Telefono] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[FechaUltimaModificacion] [date] NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NULL,
 CONSTRAINT [PK_Personas] PRIMARY KEY CLUSTERED 
(
	[PersonaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Servicios]    Script Date: 05/04/2022 22:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servicios](
	[ServicioId] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](100) NOT NULL,
	[FechaUltimaModificacion] [date] NOT NULL,
	[UsuarioUltimaModificacion] [nvarchar](150) NOT NULL,
	[Costo] [decimal](18, 0) NOT NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_Servicios] PRIMARY KEY CLUSTERED 
(
	[ServicioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'1', N'Administrador')
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', N'1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'87c593a8-fba7-46c9-94fc-a3c8ed2e0962', N'1')
GO
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [PersonaId]) VALUES (N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', N'administrador', 0, N'AMBD7SZpnkNI8nfsF3VMUQRGzG4hOCv7hbELnOhd6B2vRLHtzk2BR4fvAqDvTEE/2Q==', N'3d4205e0-f729-4dda-b273-56e0c07d53c7', NULL, 0, 0, NULL, 1, 0, N'administrador', 1)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [PersonaId]) VALUES (N'87c593a8-fba7-46c9-94fc-a3c8ed2e0962', N'34842849', 0, N'AMBD7SZpnkNI8nfsF3VMUQRGzG4hOCv7hbELnOhd6B2vRLHtzk2BR4fvAqDvTEE/2Q==', N'3d4205e0-f729-4dda-b273-56e0c07d53c7', NULL, 0, 0, NULL, 1, 0, N'34842849', 11)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [PersonaId]) VALUES (N'aa5ca7e5-0908-4fb5-affe-833ced4e5376', N'3242134', 0, N'ADY2RBMGDGU2GFNWhbvNCLMCDAiCC4ef+s94LAMejI2hMy+zrJZIIgIE/Kv/aiOKig==', N'20b61a64-8ac0-4640-926a-df14005cf945', NULL, 0, 0, NULL, 1, 0, N'3242134', NULL)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [PersonaId]) VALUES (N'cd750990-2853-4c73-938a-b4d800f3a354', N'jose@jose.com', 0, N'AMBD7SZpnkNI8nfsF3VMUQRGzG4hOCv7hbELnOhd6B2vRLHtzk2BR4fvAqDvTEE/2Q==', N'9f5170b3-24e0-4952-ac80-44a23ac6aa9e', NULL, 0, 0, NULL, 1, 0, N'jose@jose.com', NULL)
GO
SET IDENTITY_INSERT [dbo].[CajasDistribuciones] ON 

INSERT [dbo].[CajasDistribuciones] ([CajaDistribucionId], [Descipcion], [Longitud], [Latitud], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1, N'Caja 1', NULL, NULL, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[CajasDistribuciones] ([CajaDistribucionId], [Descipcion], [Longitud], [Latitud], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (2, N'Caja 2 - Calle principal - 123', NULL, NULL, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[CajasDistribuciones] ([CajaDistribucionId], [Descipcion], [Longitud], [Latitud], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (3, N'Caja 3 - calle avenida 25 de mayo - 230', NULL, NULL, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
SET IDENTITY_INSERT [dbo].[CajasDistribuciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Clientes] ON 

INSERT [dbo].[Clientes] ([ClienteId], [PersonaId], [Direccion], [NumeroPrecinto], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1, 12, N'sadadasd', N'1', CAST(N'2022-03-28' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[Clientes] ([ClienteId], [PersonaId], [Direccion], [NumeroPrecinto], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (2, 13, N'calle principal 234', N'2', CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
SET IDENTITY_INSERT [dbo].[Clientes] OFF
GO
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServicios] ON 

INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (4, 2, 2, 4, 1, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[ClientesCajasDistribucionesServicios] ([ClienteCajaDistribucionServicioId], [ClienteId], [CajaDistribucionId], [ServicioId], [UltimoEstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (5, 2, 3, 3, 1, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServicios] OFF
GO
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ON 

INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (4, 4, 1, CAST(N'2022-03-30T20:46:06.760' AS DateTime), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] ([ClienteCajaDistribucionServicioEstadoId], [ClienteCajaDistribucionServicioId], [EstadoId], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (5, 5, 1, CAST(N'2022-03-30T20:46:24.470' AS DateTime), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
SET IDENTITY_INSERT [dbo].[ClientesCajasDistribucionesServiciosEstados] OFF
GO
SET IDENTITY_INSERT [dbo].[Estados] ON 

INSERT [dbo].[Estados] ([EstadoId], [Descripcion]) VALUES (1, N'Creado')
INSERT [dbo].[Estados] ([EstadoId], [Descripcion]) VALUES (2, N'Activo')
SET IDENTITY_INSERT [dbo].[Estados] OFF
GO
SET IDENTITY_INSERT [dbo].[Personas] ON 

INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (1, N'Jose Ojeda', N'20356241496', N'adasd', N'fsdfsf', NULL, NULL, NULL)
INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (2, N'Ojeda Ignacio', N'2012343246', N'13424234', N'sdfkndfklsn', NULL, NULL, NULL)
INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (10, N'Jose Ojeda', N'3242134', N'', N'asdfasda', NULL, NULL, NULL)
INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (11, N'Daniela Paola Ojeda', N'34842849', N'', N'danielaojeda@gmail.com', NULL, NULL, NULL)
INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (12, N'Jose', N'23123123', N'sadadasd', N'2131231', NULL, CAST(N'2022-03-28' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
INSERT [dbo].[Personas] ([PersonaId], [RazonSocial], [Cuit], [Direccion], [Telefono], [Email], [FechaUltimaModificacion], [UsuarioUltimaModificacion]) VALUES (13, N'empresa s.r.l', N'54623133215', N'calle principal 234', N'546563256', NULL, CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961')
SET IDENTITY_INSERT [dbo].[Personas] OFF
GO
SET IDENTITY_INSERT [dbo].[Servicios] ON 

INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (1, N'Internet 3 MB', CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', CAST(2500 AS Decimal(18, 0)), 1)
INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (2, N'Internet 1 MB', CAST(N'2022-03-28' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', CAST(1000 AS Decimal(18, 0)), 0)
INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (3, N'Internet 10 MB', CAST(N'2022-03-28' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', CAST(4000 AS Decimal(18, 0)), 1)
INSERT [dbo].[Servicios] ([ServicioId], [Descripcion], [FechaUltimaModificacion], [UsuarioUltimaModificacion], [Costo], [Activo]) VALUES (4, N'cable basico + internet 3 MB', CAST(N'2022-03-30' AS Date), N'87c593a8-fba7-46c9-94fc-a3c8ed2e0961', CAST(3000 AS Decimal(18, 0)), 1)
SET IDENTITY_INSERT [dbo].[Servicios] OFF
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_Personas] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Personas] ([PersonaId])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_Personas]
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_Personas] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Personas] ([PersonaId])
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_Personas]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_CajasDistribuciones] FOREIGN KEY([CajaDistribucionId])
REFERENCES [dbo].[CajasDistribuciones] ([CajaDistribucionId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_CajasDistribuciones]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Clientes] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Clientes] ([ClienteId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Clientes]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Estados] FOREIGN KEY([UltimoEstadoId])
REFERENCES [dbo].[Estados] ([EstadoId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Estados]
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios]  WITH CHECK ADD  CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Servicios] FOREIGN KEY([ServicioId])
REFERENCES [dbo].[Servicios] ([ServicioId])
GO
ALTER TABLE [dbo].[ClientesCajasDistribucionesServicios] CHECK CONSTRAINT [FK_ClientesCajasDistribucionesServicios_Servicios]
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
USE [master]
GO
ALTER DATABASE [VideoCableDB] SET  READ_WRITE 
GO
