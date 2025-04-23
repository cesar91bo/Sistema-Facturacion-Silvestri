using CapaEntidades;
using CapaEntidades.Entidades;
using CapaEntidades.Enum;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class FacturasVentaNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();
        private readonly ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio = new ClienteCajaDistribucionServicioEstadoNegocio();
        private readonly FacturasVentaDetalleNegocio facturasVentaDetalleNegocio = new FacturasVentaDetalleNegocio();

        public FacturasVenta GetByNumeroComprobante(string facturaId)
        {

            return db.FacturasVenta.FirstOrDefault(x => x.NCompFact == facturaId);
        }

        public FacturasVenta GetById(long facturaVentaId)
        {
            return db.FacturasVenta.FirstOrDefault(x => x.IdFacturaVenta == facturaVentaId);
        }

        public void Generarfacturas(out int cantidadFacturasGeneradas)
        {
            cantidadFacturasGeneradas = 0;

            string mensaje;
            //1. obtener los clientes activos
            var clientesActivos = db.ClientesCajasDistribucionesServicios.Where(x => x.UltimoEstadoId == (int)EstadoEnum.Activo).ToList();


            //2. Verificamos para suspender en caso de tenes 2 facturas impagas
            clientesActivos = SuspenderCliente(clientesActivos, out mensaje);

            //si el mensaje es distinto de null, ocurrio un error.
            if (!string.IsNullOrEmpty(mensaje))
            {

                throw new Exception(mensaje);
            }

            //2. generar facturas por cada cliente activo y vericamos que la factura ya no este generada para la fecha actual
            var fechaActual = DateTime.Now;

            foreach (var cliente in clientesActivos.Where(x => x.UltimoEstadoId == (int)EstadoEnum.Activo).ToList())
            {
                var facturaYaGenerada = db.FacturasVenta
                    .Any(x => x.ClienteCajaDistribucionServicioId == cliente.ClienteCajaDistribucionServicioId &&
                    x.FechaEmision.Year == fechaActual.Year && x.FechaEmision.Month == fechaActual.Month);

                if (facturaYaGenerada)
                {
                    continue;
                }



                var servicio = clientesActivos.Where(x =>
                                                        x.ClienteId == cliente.ClienteId &&
                                                        x.CajaDistribucionId == cliente.CajaDistribucionId)
                                                .Select(x => x.Servicios).First();

                var clienteActivo = clientesActivos.Where(x =>
                                                        x.ClienteId == cliente.ClienteId &&
                                                        x.CajaDistribucionId == cliente.CajaDistribucionId)
                                                    .Select(x => x.Clientes).First();

                var tipoFactura = 0;

                var ultimaFactura = db.FacturasVenta.OrderByDescending(x => x.FechaAlta).FirstOrDefault();

                long numeroComprobaten = 0;

                if (ultimaFactura != null)
                {
                    numeroComprobaten = Convert.ToInt64(ultimaFactura.NCompFact) + 1;
                }
                else
                {
                    numeroComprobaten = 1;
                }

                switch (clienteActivo.IdRegimenImpositivo)
                {
                    case (int)RegimenImpositivoEnum.ResponsableInscripto:
                        tipoFactura = (int)TipoFactura.A;
                        break;
                    case (int)RegimenImpositivoEnum.ResponsableNoInscripto:
                        tipoFactura = (int)TipoFactura.B;
                        break;
                    case (int)RegimenImpositivoEnum.ResponsableExcento:
                        tipoFactura = (int)TipoFactura.B;
                        break;
                    case (int)RegimenImpositivoEnum.ConsumidorFinal:
                        tipoFactura = (int)TipoFactura.B;
                        break;
                    case (int)RegimenImpositivoEnum.Monotributista:
                        tipoFactura = (int)TipoFactura.B;
                        break;
                    case (int)RegimenImpositivoEnum.NoCategorizado:
                        tipoFactura = (int)TipoFactura.B;
                        break;

                    default:
                        tipoFactura = (int)TipoFactura.X;
                        break;
                }

                var subtotal = clientesActivos.Where(x =>
                                                        x.ClienteId == cliente.ClienteId &&
                                                        x.CajaDistribucionId == cliente.CajaDistribucionId)
                                                .Sum(x => x.Servicios.Costo);

                var montoIva = (subtotal * 21) / 100;
                var subtotalConIva = montoIva;

                CultureInfo ci = new CultureInfo("es-ES");
                var mesAbono = DateTime.Now.AddMonths(-1).ToString("MMMM", ci).ToUpper();

                var nuevaFacturaVenta = new FacturasVenta
                {
                    IdTipoDocumento = (int)TipoDocumentoFactura.FacturaVenta,
                    IdTipoFactura = (Int16)tipoFactura,
                    FechaEmision = DateTime.Now,
                    IdFormaPago = (int)FormaPagoEnum.Contado,
                    NCompFact = numeroComprobaten.ToString(),
                    ClienteCajaDistribucionServicioId = cliente.ClienteCajaDistribucionServicioId,
                    Impresa = false,
                    Subtotal105 = 0,
                    Subtotal21 = subtotalConIva,
                    SubTotal = subtotal,
                    Descuento = 0,
                    TotalDescuento105 = 0,
                    TotalDescuento21 = 0,
                    TotalDescuento = 0,
                    TotalIva105 = 0,
                    TotalIva21 = subtotalConIva,
                    Total = subtotal, // esto es asi porque solo se factura un servicio, en el caso que sean mas se debe multiplicar por la cantidad
                    FechaVencimiento = new DateTime(DateTime.Now.Year, DateTime.Now.AddMonths(+1).Month, 10), // validar con el cliente la fecha de vencimiento
                    TotalSaldado = subtotal,
                    TotalInteres = 0,
                    TotalSaldadoInteres = 0,
                    IdEmpresa = db.Empresa.First().IdEmpresa, // hay que crear la empresa
                    UsrAcceso = string.Empty,
                    FechaAcceso = DateTime.Now,
                    IdConceptoFactura = (int)TipoConceptoFactura.Servicios,
                    FechaAlta = DateTime.Now,
                    Cobrador = false,
                    MoverStock = false,
                    Pagado = false,
                    MesAbonado = mesAbono
                };


                var nuevaFactura = Create(nuevaFacturaVenta, out mensaje);

                //si el mensaje es distinto de null, ocurrio un error.
                if (!string.IsNullOrEmpty(mensaje))
                {

                    throw new Exception(mensaje);
                }


                //3.1 CREAR EL DETALLE

                var nuevaFacturaDetalle = new FacturasVentaDetalle
                {
                    IdFacturaVenta = nuevaFactura.IdFacturaVenta,
                    IdServicio = servicio.ServicioId,
                    Servicio = servicio.Descripcion,
                    UMedida = "unidades",
                    Cantidad = 1,
                    PrecioUnitario = servicio.Costo,
                    IdTipoIva = (int)TipoIvaEnum.Iva21,
                    TotalArt = servicio.Costo,
                    DesdeRemito = false,
                    UsrAcceso = String.Empty,
                    FechaAcceso = DateTime.Now,
                };

                var nuevoDetalle = facturasVentaDetalleNegocio.Create(nuevaFacturaDetalle, out mensaje);

                //si el mensaje es distinto de null, ocurrio un error.
                if (!string.IsNullOrEmpty(mensaje))
                {

                    throw new Exception(mensaje);
                }


                cantidadFacturasGeneradas++;

            }
            //3. agregar logs de errores
        }

        public List<VistaCabFactVenta> ObtenerListFactura()
        {
            return db.VistaCabFactVenta.OrderBy(o => o.Cliente).ToList();
        }

        public CobrosViewModel ObtenerCobros(DateTime fechaDesde, DateTime fechaHasta)
        {

            var desde = fechaDesde.Date;
            var cobrosViewModel = new CobrosViewModel();
            var mesActua = DateTime.Now.Month;

            try
            {
                //OBTENES LAS FACTURAS DE VENTAS QUE ESTEN DENTRO DEL RANGO DE FECHAS Y ESTEN COBRADAS
                var facturasCobradas = db.FacturasVenta.Where(x =>
                        (x.FechaEmision >= desde && x.FechaEmision <= fechaHasta)
                        && (x.Pagado != null && x.Pagado.Value == true)).ToList();

                var facturasPendienteCobros = db.FacturasVenta.Where(x =>
                         (x.FechaEmision >= desde && x.FechaEmision <= fechaHasta)
                         && (x.Pagado == null || x.Pagado.Value == false)).ToList();

                var facturasPorCliente = facturasPendienteCobros
                    .GroupBy(x => x.ClienteCajaDistribucionServicioId)
                    .Select(group => new { ClienteId = group.Key, Facturas = group.ToList() })
                    .Where(a => a.Facturas.Where(b => (b.Pagado == null || b.Pagado.Value == false) && b.FechaEmision.Month < mesActua).Count() >= 2)
                    .ToList();


                var facturasElectronicas = db.FacturasElectronicas.Where(x =>
                        x.Fecha >= desde && x.Fecha <= fechaHasta).ToList();

                decimal totalFacturasElectronicas = 0;

                foreach (var fe in facturasElectronicas)
                {
                    var factura = db.FacturasVenta.FirstOrDefault(x => x.IdFacturaVenta == fe.IdFacturaVenta);

                    if (factura != null)
                    {
                        totalFacturasElectronicas += factura.Total;
                    }

                }


                cobrosViewModel.TotalCobrado = facturasCobradas.Sum(x => x.Total);
                cobrosViewModel.TotalDeclarado = totalFacturasElectronicas;
                cobrosViewModel.TotalIva = ((totalFacturasElectronicas * 21) / 100);
                cobrosViewModel.TotalOtros = cobrosViewModel.TotalCobrado - cobrosViewModel.TotalDeclarado;
                cobrosViewModel.TotalPendienteCobro = facturasPendienteCobros.Sum(x => x.Total);
                cobrosViewModel.MorososMas2Meses = facturasPorCliente.Sum(x => x.Facturas.Sum(a => a.Total));
                cobrosViewModel.RestoMorosos = cobrosViewModel.TotalPendienteCobro - cobrosViewModel.MorososMas2Meses;
            }
            catch (Exception)
            {

                throw;
            }

            return cobrosViewModel;
        }

        public FacturasVenta Create(FacturasVenta model, out string mensaje)
        {
            mensaje = string.Empty;

            try
            {

                if (model.IdFacturaVenta == 0)
                {
                    db.FacturasVenta.Add(model);
                }
                else
                {
                    db.Entry(model).State = EntityState.Modified;
                }


                db.SaveChanges();

                return model;

            }
            catch (Exception ex)
            {
                mensaje = "Ha ocurrido un error al intentar crear la entidad.";
                throw ex;
            }
        }

        public List<ClientesCajasDistribucionesServicios> SuspenderCliente(List<ClientesCajasDistribucionesServicios> clientesActivos, out string mensaje)
        {

            var fechaActual = DateTime.Now;

            mensaje = string.Empty;

            foreach (var cliente in clientesActivos)
            {
                //1. Por cada cliente, buscamos la cantidad de facturas adeudadas de los meses anteriores a la fecha actual
                var cantidadFacturasImpagas = db.FacturasVenta
                    .Where(x => x.ClienteCajaDistribucionServicioId == cliente.ClienteCajaDistribucionServicioId &&
                            (x.Pagado == null || !x.Pagado.Value) &&

                            //validacion por año igual y mes menor a la fecha actual
                            //fecha emision = 2021-02-01 y fecha actual 2021-03-02
                            ((x.FechaEmision.Year == fechaActual.Year) && (x.FechaEmision.Month < fechaActual.Month)) ||

                            //validacion por año de emision anterior al actual y mes mayor por ejemplo
                            //fecha emision = 2020-12-01 y fecha actual 2021-01-02
                            ((x.FechaEmision.Year < fechaActual.Year) && (x.FechaEmision.Month > fechaActual.Month))
                            )
                    .Count();

                //si es igual a 2, suspendemos al cliente.
                if (cantidadFacturasImpagas == 2)
                {
                    try
                    {

                        var nuevoClienteEstado = clienteCajaDistribucionServicioEstadoNegocio.Create(new ClientesCajasDistribucionesServiciosEstados
                        {
                            ClienteCajaDistribucionServicioId = cliente.ClienteCajaDistribucionServicioId,
                            EstadoId = (int)EstadoEnum.Suspendido,
                            FechaUltimaModificacion = DateTime.Now,
                            UsuarioUltimaModificacion = 1,
                            Observaciones = "Cliente Suspendido por falta de pago. Adeuda 2 facturas."
                        }, out mensaje);

                        //actualizamos el estado del cliente actual del listado, con el estado suspendido, asi lo obviamos para generarle
                        //la factura
                        cliente.UltimoEstadoId = clienteCajaDistribucionServicioEstadoNegocio
                            .GetUltimoEstado(cliente.ClienteCajaDistribucionServicioId).EstadoId;
                    }
                    catch (Exception ex)
                    {
                        mensaje = "Ha ocurrido un error al intentar verificar las facturas impagas de los clientes.";
                        throw ex;
                    }

                }
            }

            return clientesActivos;
        }

        public List<FacturasVenta> BuscarFacturasPorClienteCajaDistribucionServicioId(int clienteCajaDistribucionServicioId)
        {

            var listado = db.FacturasVenta.Where(x => x.ClienteCajaDistribucionServicioId == clienteCajaDistribucionServicioId).ToList();

            return listado;
        }

        public List<VistaCabFactVenta> BuscarFacturasPorClienteIdFechaDesdeFechaHasta(string cliente, DateTime? fechaDesde, DateTime? fechaHasta)
        {
            //if(fechaDesde == DateTime.Now.Date)
            //{
            //    fechaDesde = null;
            //}

            var listado = db.VistaCabFactVenta
                .Where(x => (string.IsNullOrEmpty(cliente) || x.Cliente.Contains(cliente))
                    && (fechaDesde == null || x.FechaEmision >= fechaDesde.Value)
                    && (fechaHasta == null || x.FechaEmision <= fechaHasta.Value))
                .ToList();

            return listado.OrderByDescending(o => o.FechaVencimiento).ToList();

        }

        public List<VistaCabFactVenta> BuscarFacturasPorClienteId(int idCliente)
        {

            var listado = db.VistaCabFactVenta
                .Where(x => x.NroCliente == idCliente)
                .ToList();

            return listado.OrderByDescending(o => o.IdFacturaVenta).ToList();

        }

        public List<VistaCabFactVenta> BuscarFacturasFechaDesdeFechaHasta(DateTime? fechaDesde, DateTime? fechaHasta)
        {
            if (fechaDesde.HasValue && fechaHasta.HasValue && fechaDesde.Value.Date == fechaHasta.Value.Date)
            {
                fechaHasta = fechaHasta.Value.Date.AddDays(1).AddMilliseconds(-1);
                // .Date elimina la parte de la hora, dejando solo la fecha a medianoche
            }

            var listado = db.VistaCabFactVenta
                .Where(x => (fechaDesde == null || x.FechaPago >= fechaDesde.Value)
                    && (fechaHasta == null || x.FechaPago <= fechaHasta.Value))
                .ToList();

            return listado.OrderBy(o => o.Cliente).ToList();
        }

        public bool ObtenerFacturaSinPagarPorCliente(int nroCliente)
        {
            // Obtener la fecha actual menos 6 meses
            DateTime fechaLimite = DateTime.Now.AddMonths(-6);

            // Consulta LINQ para verificar si existe alguna factura sin pagar en los últimos 6 meses
            bool tieneDeuda = db.VistaCabFactVenta
                .Any(x => x.NroCliente == nroCliente
                       && x.Pagado == "NO"
                       && x.FechaEmision >= fechaLimite);

            return tieneDeuda;
        }

        public VistaCabFactVenta BuscarVistaCabFacturaVentaPorId(int idFactura)
        {
            VistaCabFactVenta factura = db.VistaCabFactVenta
                .Where(x => x.IdFacturaVenta == idFactura).SingleOrDefault();

            return factura;
        }

        public FacturasVenta BuscarFacturaVentaPorId(int idFactura)
        {
            FacturasVenta factura = db.FacturasVenta
                .Where(x => x.IdFacturaVenta == idFactura).SingleOrDefault();

            return factura;
        }

        public void EditarFacturaVenta(FacturasVenta facturaVenta)
        {
            var facturaExistente = db.FacturasVenta.Find(facturaVenta.IdFacturaVenta);

            facturaExistente.IdCondicionPago = facturaVenta.IdCondicionPago;
            facturaExistente.IdConceptoFactura = facturaVenta.IdConceptoFactura;
            facturaExistente.IdFormaPago = facturaVenta.IdFormaPago;
            facturaExistente.IdTipoDocumento = facturaVenta.IdTipoDocumento;
            facturaExistente.IdTipoFactura = facturaVenta.IdTipoFactura;
            facturaExistente.Impresa = facturaVenta.Impresa;
            facturaExistente.Pagado = facturaVenta.Pagado;
            facturaExistente.MesAbonado = facturaVenta.MesAbonado;
            facturaExistente.Observaciones = facturaVenta.Observaciones;
            facturaExistente.SubTotal = facturaVenta.SubTotal;
            facturaExistente.Subtotal105 = facturaVenta.Subtotal105;
            facturaExistente.Subtotal21 = facturaVenta.Subtotal21;
            facturaExistente.TotalDescuento105 = facturaVenta.TotalDescuento105;
            facturaExistente.TotalIva21 = facturaVenta.TotalIva21;
            facturaExistente.Total = facturaVenta.Total;

            db.SaveChanges();
        }

        public void GenerarfacturasPorIdCliente(int nroCliente)
        {
            string mensaje = "";
            var clienteCajaDistribucionServicio = db.ClientesCajasDistribucionesServicios
                .FirstOrDefault(x => x.ClienteId == nroCliente);

            if (clienteCajaDistribucionServicio == null)
            {
                throw new Exception("No se encontró la caja de distribución del cliente.");
            }

            DateTime fechaActual = DateTime.Now;

            var ultimaFacturaDelCliente = db.FacturasVenta
                .Where(f => f.ClienteCajaDistribucionServicioId == clienteCajaDistribucionServicio.ClienteCajaDistribucionServicioId)
                .OrderByDescending(x => x.FechaAlta)
                .FirstOrDefault();

            DateTime fechaInicio = ultimaFacturaDelCliente?.FechaAlta ?? clienteCajaDistribucionServicio.FechaUltimaModificacion;

            var clienteActivo = db.ClientesCajasDistribucionesServicios
                .Where(x => x.UltimoEstadoId == (int)EstadoEnum.Activo &&
                            x.ClienteId == clienteCajaDistribucionServicio.ClienteId &&
                            x.CajaDistribucionId == clienteCajaDistribucionServicio.CajaDistribucionId)
                .Select(x => x.Clientes)
                .FirstOrDefault();

            if (clienteActivo == null)
            {
                throw new Exception("No se encontró un cliente activo.");
            }

            var servicio = db.Servicios.SingleOrDefault(x => x.ServicioId == clienteCajaDistribucionServicio.ServicioId);

            if (servicio == null)
            {
                throw new Exception("No se encontró el servicio asociado al cliente.");
            }

            var ultimaFactura = db.FacturasVenta.OrderByDescending(x => x.FechaAlta).FirstOrDefault();
            long numeroComprobante = (ultimaFactura != null) ? Convert.ToInt64(ultimaFactura.NCompFact) + 1 : 1;

            int tipoFactura = 0;

            switch (clienteActivo.IdRegimenImpositivo)
            {
                case (int)RegimenImpositivoEnum.ResponsableInscripto:
                    tipoFactura = (int)TipoFactura.A;
                    break;
                case (int)RegimenImpositivoEnum.ResponsableNoInscripto:
                    tipoFactura = (int)TipoFactura.B;
                    break;
                case (int)RegimenImpositivoEnum.ResponsableExcento:
                    tipoFactura = (int)TipoFactura.B;
                    break;
                case (int)RegimenImpositivoEnum.ConsumidorFinal:
                    tipoFactura = (int)TipoFactura.B;
                    break;
                case (int)RegimenImpositivoEnum.Monotributista:
                    tipoFactura = (int)TipoFactura.B;
                    break;
                case (int)RegimenImpositivoEnum.NoCategorizado:
                    tipoFactura = (int)TipoFactura.B;
                    break;

                default:
                    tipoFactura = (int)TipoFactura.X;
                    break;
            }

            decimal subtotal = servicio.Costo;
            decimal montoIva = (subtotal * 21) / 100;
            decimal subtotalConIva = montoIva;

            CultureInfo ci = new CultureInfo("es-ES");

            // 🔹 Generar facturas desde la última fecha hasta el mes actual
            while (fechaInicio.Year < fechaActual.Year || (fechaInicio.Year == fechaActual.Year && fechaInicio.Month < fechaActual.Month))
            {
                var mesAbono = fechaInicio.ToString("MMMM", ci).ToUpper();

                var nuevaFacturaVenta = new FacturasVenta
                {
                    IdTipoDocumento = (int)TipoDocumentoFactura.FacturaVenta,
                    IdTipoFactura = (Int16)tipoFactura,
                    FechaEmision = new DateTime(fechaInicio.Year, fechaInicio.Month, 1),
                    IdFormaPago = (int)FormaPagoEnum.Contado,
                    NCompFact = numeroComprobante.ToString(),
                    ClienteCajaDistribucionServicioId = clienteCajaDistribucionServicio.ClienteCajaDistribucionServicioId,
                    Impresa = false,
                    Subtotal105 = 0,
                    Subtotal21 = subtotalConIva,
                    SubTotal = subtotal,
                    Descuento = 0,
                    TotalDescuento105 = 0,
                    TotalDescuento21 = 0,
                    TotalDescuento = 0,
                    TotalIva105 = 0,
                    TotalIva21 = subtotalConIva,
                    Total = subtotal,
                    FechaVencimiento = new DateTime(fechaInicio.Year, fechaInicio.Month, 10),
                    TotalSaldado = subtotal,
                    TotalInteres = 0,
                    TotalSaldadoInteres = 0,
                    IdEmpresa = db.Empresa.First().IdEmpresa,
                    UsrAcceso = string.Empty,
                    FechaAcceso = DateTime.Now,
                    IdConceptoFactura = (int)TipoConceptoFactura.Servicios,
                    FechaAlta = DateTime.Now,
                    Cobrador = false,
                    MoverStock = false,
                    Pagado = false,
                    MesAbonado = mesAbono
                };

                var nuevaFactura = Create(nuevaFacturaVenta, out mensaje);

                if (!string.IsNullOrEmpty(mensaje))
                {
                    throw new Exception(mensaje);
                }

                var nuevaFacturaDetalle = new FacturasVentaDetalle
                {
                    IdFacturaVenta = nuevaFactura.IdFacturaVenta,
                    IdServicio = servicio.ServicioId,
                    Servicio = servicio.Descripcion,
                    UMedida = "unidades",
                    Cantidad = 1,
                    PrecioUnitario = servicio.Costo,
                    IdTipoIva = (int)TipoIvaEnum.Iva21,
                    TotalArt = servicio.Costo,
                    DesdeRemito = false,
                    UsrAcceso = string.Empty,
                    FechaAcceso = DateTime.Now,
                };

                var nuevoDetalle = facturasVentaDetalleNegocio.Create(nuevaFacturaDetalle, out mensaje);

                if (!string.IsNullOrEmpty(mensaje))
                {
                    throw new Exception(mensaje);
                }

                // Avanzar al siguiente mes y actualizar el número de factura
                fechaInicio = fechaInicio.AddMonths(1);
                numeroComprobante++;
            }
        }

    }
}
