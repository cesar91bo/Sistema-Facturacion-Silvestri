using CapaEntidades;
using CapaEntidades.Enum;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ClienteNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();
        private readonly ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio = new ClienteCajaDistribucionServicioEstadoNegocio();

        public List<VistaClientes> ObtenerClientes()
        {
            var clientes = from cli in ObtenerClis()
                           select cli;

            return clientes.OrderBy(o=>o.ApellidoyNombre).ToList();
        }

        public List<VistaClientes> ObtenerClientesTotales()
        {
            var clientes = from cli in ObtenerVistaClientes()
                           select cli;

            return clientes.OrderBy(o => o.ApellidoyNombre).ToList();
        }

        public List<VistaClientes> ObtenerVistaClientes()
        {
            var resultado = db.VistaClientes.ToList();

            return resultado;
        }

        public List<VistaClientes> ObtenerClientesActivos()
        {
            var clientes = from cli in ObtenerClis()
                           where cli.Estado == "Activo"
                           select cli;

            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerClis()
        {
            var resultado = db.Database.SqlQuery<VistaClientes>(
                "EXEC SP_CLIENTES_FIBRA_OPTICA"
            ).ToList();

            return resultado;
        }

        public List<VistaClientes> ObtenerClientesVideo()
        {
            var clientes = from cli in ObtenerClisVideo()
                           select cli;

            return clientes.OrderBy(o => o.ApellidoyNombre).ToList();
        }

        public List<VistaClientes> ObtenerClisVideo()
        {
            var resultado = db.Database.SqlQuery<VistaClientes>(
                "EXEC SP_CLIENTES_VIDEO"
            ).ToList();

            return resultado;
        }

        public List<Clientes> ObtenerClientesCargadosCUIT(Int64 _numDoc, string _tipoDoc)
        {
            var numDoc = _numDoc.ToString();
            var detalle = from c in db.Clientes
                          where c.Cuit1 == numDoc
                          select c;
            return detalle.ToList();
            //return (List<Clientes>)detalle.ToList()
            //                .Select(c => new Clientes()
            //                {
            //                    NroCliente = c.NroCliente,
            //                    TipoDocumento = c.TipoDocumento,
            //                    NroDocumento = c.NroDocumento,
            //                    ApellidoyNombre = c.ApellidoyNombre,
            //                    Direccion = c.Direccion,
            //                    CodigoPostal = c.CodigoPostal,
            //                    SubCodigoPostal = c.SubCodigoPostal,
            //                    FechaNacimiento = c.FechaNacimiento,
            //                    IdRegimenImpositivo = c.IdRegimenImpositivo,
            //                    Telefono = c.Telefono,
            //                    Email1 = c.Email1,
            //                    Email2 = c.Email2,
            //                    Cuit0 = c.Cuit0,
            //                    Cuit1 = c.Cuit1,
            //                    Cuit2 = c.Cuit2,
            //                    UsrBaja = c.UsrBaja,
            //                    FechaBaja = c.FechaBaja,
            //                    FechaAcceso = c.FechaAcceso,
            //                    UsrAcceso = c.UsrAcceso,
            //                    IdObservación = c.IdObservación,
            //                    MensajeCuenta = c.MensajeCuenta,
            //                    SaldoExcedido = c.SaldoExcedido,
            //                    CuentaCerrada = c.CuentaCerrada,
            //                    Comentario = c.Comentario
            //                });
        }

        public int NuevoCli(Clientes cli)
        {
            try
            {
                AgregarCliente(cli);
                Grabar();
                return cli.NroCliente;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void AgregarCliente(Clientes cliente)
        {
            db.Clientes.Add(cliente);
        }

        private void Grabar()
        {
            db.SaveChanges();
        }

        public bool EditarCli(Clientes cliente, int _nroCliente, bool _habilitarCliente = false)
        {
            try
            {
                var cli = ObtenerCliporNroCli(_nroCliente);
                cli.ApellidoyNombre = cliente.ApellidoyNombre;
                cli.CodigoPostal = cliente.CodigoPostal;
                cli.Direccion = cliente.Direccion;
                cli.Email1 = cliente.Email1;
                cli.Email2 = cliente.Email2;
                cli.FechaNacimiento = cliente.FechaNacimiento;
                cli.IdRegimenImpositivo = cliente.IdRegimenImpositivo;
                cli.NroDocumento = cliente.NroDocumento;
                cli.SubCodigoPostal = cliente.SubCodigoPostal;
                cli.Telefono = cliente.Telefono;
                cli.TipoDocumento = cliente.TipoDocumento;
                cli.Cuit0 = cliente.Cuit0;
                cli.Cuit1 = cliente.Cuit1;
                cli.Cuit2 = cliente.Cuit2;
                cli.MensajeCuenta = cliente.MensajeCuenta;
                cli.CuentaCerrada = cliente.CuentaCerrada;
                cli.SaldoExcedido = cliente.SaldoExcedido;
                cli.IdObservación = cliente.IdObservación;
                cli.Comentario = cliente.Comentario;
                cli.Precinto = cliente.Precinto;
                cli.Caja = cliente.Caja;
                if (_habilitarCliente) { cli.FechaBaja = cliente.FechaBaja; };
                Grabar();
                return true;
            }
            catch (Exception ex) { throw ex; }
        }

        public object ObtenerClientesCargadosDni(long numerodoc, string tipoDoc)
        {
            var listC = from c in db.VistaClientes
                        where Convert.ToInt64(c.Nro_Doc) == numerodoc && c.TipoDocumento == tipoDoc
                        select c;

            return listC.ToList();
        }

        public bool BajaCliente(Int32 IdCli, String Usr)
        {
            var cli = ObtenerCliporNroCli(IdCli);
            cli.FechaBaja = DateTime.Now;
            cli.UsrBaja = Usr;
            Grabar();
            return true;
        }

        public Clientes ObtenerCliporNroCli(int idCli)
        {
            return db.Clientes.SingleOrDefault(c => c.NroCliente == idCli);
        }

        public List<VistaClientes> ObtenerListClientesPorNomyAp(string _nomyAp)
        {
            var clientes = from cli in ObtenerVClis()
                           where cli.ApellidoyNombre.ToLower().Contains(_nomyAp.ToLower())
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerListClientesPorNomyApTotal(string _nomyAp)
        {
            var clientes = from cli in ObtenerVistaClientes()
                           where cli.ApellidoyNombre.ToLower().Contains(_nomyAp.ToLower())
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerVClis()
        {
            var resultado = db.Database.SqlQuery<VistaClientes>(
                "EXEC SP_CLIENTES_FIBRA_OPTICA"
            ).ToList();

            return resultado;
        }

        public List<VistaClientes> ObtenerListClientesPorNomyApVideo(string _nomyAp)
        {
            var clientes = from cli in ObtenerVClisVideo()
                           where cli.ApellidoyNombre.ToLower().Contains(_nomyAp.ToLower())
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerVClisVideo()
        {
            var resultado = db.Database.SqlQuery<VistaClientes>(
                "EXEC SP_CLIENTES_VIDEO"
            ).ToList();

            return resultado;
        }

        public VistaClientes ObtenerVCliporNroCli(int clienteCajaDistribucionServicioId)
        {
            return db.VistaClientes.SingleOrDefault(c => c.ClienteCajaDistribucionServicioId == clienteCajaDistribucionServicioId);
        }

        public List<VistaClientes> ObtenerListClientesPorEstado(string estado)
        {
            var clientes = from cli in ObtenerVClis()
                           where cli.Estado.Contains(estado)
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerListClientesPorEstadoTotal(string estado)
        {
            var clientes = from cli in ObtenerClientesTotales()
                           where cli.Estado.Contains(estado)
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerListClientesPorEstadoVideo(string estado)
        {
            var clientes = from cli in ObtenerVClisVideo()
                           where cli.Estado.Contains(estado)
                           select cli;
            return clientes.ToList();
        }

        public List<VistaClientes> ObtenerListClientesPorTipo(string tipoFibra)
        {
            List<int> idsParaFiltrar = new List<int>();
            if (tipoFibra == "Todo")
            {
                return ObtenerVClis();
            }
            else if (tipoFibra == "Internet")
            {
                idsParaFiltrar = new List<int> { 5, 6, 7 };
            }
            else if (tipoFibra == "Internet + TV")
            {
                idsParaFiltrar = new List<int> { 8, 9, 10, 1006, 1007, 1008 };
            }
            else 
            {
                return ObtenerVClis();
            }

            var clientes = from cli in ObtenerVClis()
                           join CCDS in db.ClientesCajasDistribucionesServicios on cli.NroCliente equals CCDS.ClienteId
                           join s in db.Servicios on CCDS.ServicioId equals s.ServicioId
                           where idsParaFiltrar.Contains(s.ServicioId)
                           orderby cli.ApellidoyNombre
                           select cli;
            return clientes.ToList();
        }

        public int CalculaTotalVideo()
        {
            var parametro = new SqlParameter("@Servicio", "VIDEO");

            var resultado = db.Database.SqlQuery<int>(
                "EXEC SP_CLIENTES_TOTALES_ACTIVOS @Servicio", parametro
            ).SingleOrDefault();

            return resultado;
        }

        public int CalculaTotalFibra()
        {
            var parametro = new SqlParameter("@Servicio", "FIBRA");

            var resultado = db.Database.SqlQuery<int>(
                "EXEC SP_CLIENTES_TOTALES_ACTIVOS @Servicio", parametro
            ).SingleOrDefault();

            return resultado;
        }

        public ClientesCajasDistribucionesServicios ObtieneClienteCajaDistribucionServicioIdPorCliente(int nroCliente)
        {
            return db.ClientesCajasDistribucionesServicios.Where(x => x.ClienteId == nroCliente).FirstOrDefault();
        }

        public List<int> SuspenderDeudores()
        {
            try
            {
                var clientesActivos = db.ClientesCajasDistribucionesServicios.Where(x => x.UltimoEstadoId == (int)EstadoEnum.Activo).ToList();

                //Verificamos para suspender en caso de tenes 2 facturas impagas
                var clientesSuspendidos = SuspenderCliente(clientesActivos);

                return clientesSuspendidos;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            
        }

        public  List<int>  SuspenderCliente(List<ClientesCajasDistribucionesServicios> clientesActivos)
        {
            var fechaActual = DateTime.Now;
            string mensaje = "";
            List<int> clientesSuspendidosIds = new List<int>();

            foreach (var cliente in clientesActivos)
            {
                // 1. Contar facturas impagas de meses anteriores a la fecha actual
                var cantidadFacturasImpagas = db.FacturasVenta
                    .Where(x => x.ClienteCajaDistribucionServicioId == cliente.ClienteCajaDistribucionServicioId &&
                                (x.Pagado == null || !x.Pagado.Value) &&
                                ((x.FechaEmision.Year == fechaActual.Year && x.FechaEmision.Month < fechaActual.Month) ||
                                 (x.FechaEmision.Year < fechaActual.Year && x.FechaEmision.Month > fechaActual.Month)))
                    .Count();

                // 2. Si el cliente adeuda 2 facturas, se suspende
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

                        // 3. Actualizar estado del cliente en la lista
                        cliente.UltimoEstadoId = clienteCajaDistribucionServicioEstadoNegocio
                            .GetUltimoEstado(cliente.ClienteCajaDistribucionServicioId).EstadoId;

                        // 4. Agregar ID del cliente suspendido
                        clientesSuspendidosIds.Add(cliente.ClienteCajaDistribucionServicioId);
                    }
                    catch (Exception ex)
                    {
                        throw; // Mantiene la pila de errores original
                    }
                }
            }

            // Retorna la lista de clientes actualizados y los IDs de los clientes suspendidos
            return  clientesSuspendidosIds;
        }

    }
}
