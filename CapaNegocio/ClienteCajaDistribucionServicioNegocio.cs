using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ClienteCajaDistribucionServicioNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();
        private readonly ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio =
            new ClienteCajaDistribucionServicioEstadoNegocio();

        public ClientesCajasDistribucionesServicios GetById(int id)
        {
            return db.ClientesCajasDistribucionesServicios.FirstOrDefault(x => x.ClienteCajaDistribucionServicioId == id);
        }

        public ClientesCajasDistribucionesServicios GetByIdCliente(int id)
        {
            return db.ClientesCajasDistribucionesServicios.FirstOrDefault(x => x.ClienteId == id);
        }

        public List<ClientesCajasDistribucionesServicios> GetList()
        {
            return db.ClientesCajasDistribucionesServicios.ToList();
        }

        public ClientesCajasDistribucionesServicios Create(ClientesCajasDistribucionesServicios model, int estadoId, out string mensaje)
        {

            mensaje = string.Empty;

            if (!SePuedeCrear(model.ClienteId, model.CajaDistribucionId, model.ServicioId, out mensaje))
            {
                return null;
            }

            try
            {
                if (model.ClienteCajaDistribucionServicioId == 0)
                {
                    db.ClientesCajasDistribucionesServicios.Add(model);
                }
                else
                {
                    db.Entry(model).State = EntityState.Modified;

                }

                db.SaveChanges();

                var estado = clienteCajaDistribucionServicioEstadoNegocio.Create(new ClientesCajasDistribucionesServiciosEstados
                {
                    ClienteCajaDistribucionServicioId = model.ClienteCajaDistribucionServicioId,
                    EstadoId = estadoId,
                    FechaUltimaModificacion = DateTime.Now,
                    UsuarioUltimaModificacion = 1
                }, out mensaje);


                db.SaveChanges();

                return model;

            }
            catch (Exception ex)
            {
                mensaje = "Ha ocurrido un error al intentar crear el registro.";
                throw ex;
            }
        }

        public bool SePuedeCrear(int clienteId, int cajaDistribucionId, int servicioId, out string mensaje)
        {

            mensaje = string.Empty;

            ClientesCajasDistribucionesServicios entidad = db.ClientesCajasDistribucionesServicios
                .FirstOrDefault(x => x.ClienteId == clienteId
                && x.CajaDistribucionId == cajaDistribucionId
                && x.ServicioId == servicioId);


            if (entidad == null)
            {

                return true;
            }

            mensaje = "Ya existe la entidad";

            return false;

        }
    }
}
