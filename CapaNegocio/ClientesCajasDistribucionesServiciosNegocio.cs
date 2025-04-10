using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ClientesCajasDistribucionesServiciosNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();

        public int NuevoCliCaja(ClientesCajasDistribucionesServicios cli)
        {
            try
            {
                Agregar(cli);
                Grabar();
                return cli.ClienteCajaDistribucionServicioId;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void Agregar(ClientesCajasDistribucionesServicios cli)
        {
            db.ClientesCajasDistribucionesServicios.Add(cli);
        }

        public bool EditarClientesCajasDistribucionesServiciosPorClienteid(int _clienteId, int _servicioid)
        {
            try
            {
                var cliCDSPCliid = ObtenerCliporCDSPorNro(_clienteId);
                cliCDSPCliid.ServicioId = _servicioid;
                Grabar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }

        public ClientesCajasDistribucionesServicios ObtenerCliporCDSPorNro(int clienteId)
        {
            return db.ClientesCajasDistribucionesServicios.SingleOrDefault(c => c.ClienteId == clienteId);
        }

        private void Grabar()
        {
            db.SaveChanges();
        }
    }
}
