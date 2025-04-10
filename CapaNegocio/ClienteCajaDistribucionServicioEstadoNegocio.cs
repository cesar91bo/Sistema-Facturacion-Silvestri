using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ClienteCajaDistribucionServicioEstadoNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public ClientesCajasDistribucionesServiciosEstados GetById(int id)
        {
            return db.ClientesCajasDistribucionesServiciosEstados.FirstOrDefault(x => x.ClienteCajaDistribucionServicioEstadoId == id);
        }

        public List<ClientesCajasDistribucionesServiciosEstados> GetList()
        {
            return db.ClientesCajasDistribucionesServiciosEstados.ToList();
        }

        public ClientesCajasDistribucionesServiciosEstados Create(ClientesCajasDistribucionesServiciosEstados model, out string mensaje)
        {
            mensaje = string.Empty;

            try
            {

                //if (!SePuedeCrear(model.EstadoId, out mensaje))
                //{
                //    return model;
                //}

                db.ClientesCajasDistribucionesServiciosEstados.Add(model);


                db.SaveChanges();

                var clienteCajaDistribucionServicio = db.ClientesCajasDistribucionesServicios
                    .First(x => x.ClienteCajaDistribucionServicioId == model.ClienteCajaDistribucionServicioId);

                clienteCajaDistribucionServicio.UltimoEstadoId = model.EstadoId;

                db.Entry(model).State = EntityState.Modified;

                db.SaveChanges();

                return model;

            }
            catch (Exception ex)
            {
                mensaje = "Ha ocurrido un error al intentar crear la entidad.";
                throw ex;
            }
        }

        public ClientesCajasDistribucionesServiciosEstados GetUltimoEstado(int clienteCajaDistribucionServicioId) {

            var entidad = db.ClientesCajasDistribucionesServiciosEstados
                .Where(x => x.ClienteCajaDistribucionServicioId == clienteCajaDistribucionServicioId)
                .OrderByDescending(x => x.ClienteCajaDistribucionServicioEstadoId)
                .FirstOrDefault();

            return entidad; 
        }

        public List<FnBuscarEstadosPorClienteId_Result> BuscarEstadosPorClienteId(int clienteCajaDistribucionServicioId) {

            return db.FnBuscarEstadosPorClienteId(clienteCajaDistribucionServicioId).ToList();
        }

        public bool SePuedeCrear(int id, out string mensaje)
        {

            mensaje = string.Empty;

            ClientesCajasDistribucionesServiciosEstados ultimoEstado = db.ClientesCajasDistribucionesServiciosEstados
                .OrderByDescending(x => x.ClienteCajaDistribucionServicioEstadoId).FirstOrDefault();

            if (ultimoEstado == null)  return true;

            if (ultimoEstado.EstadoId == id) {

                mensaje = "El nuevo estado debe ser distinto del ultimo creado.";

                return false;
            }

            return true;

        }
    }
}
