using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ServicioNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();
        public string ConsultaDescripcion(string descripcion)
        {
            var mensaje = string.Empty;

            Servicios descrip = db.Servicios.FirstOrDefault(x => x.Descripcion == descripcion);

            if (descrip != null)
            {

                mensaje = "Ya existe en un Servicio con el mismo nombre";
            }

            return mensaje;
        }

        public int CreateService(Servicios servicio)
        {
            try
            {
                if (servicio.ServicioId == 0)
                {
                    db.Servicios.Add(servicio);
                }
                else
                {
                    db.Entry(servicio).State = EntityState.Modified;

                }

                db.SaveChanges();

                return servicio.ServicioId;

            }
            catch (Exception ex)
            {
                return 0;
                throw ex;
            }
        }

        public bool EditarServicio(Servicios servicio, int numServicio)
        {
            try
            {
                var serv = ObtenerServicioPorNroPro(numServicio);
                serv.Descripcion = servicio.Descripcion;
                serv.Costo = servicio.Costo;
                serv.UsuarioUltimaModificacion = servicio.UsuarioUltimaModificacion;
                serv.FechaUltimaModificacion = servicio.FechaUltimaModificacion;
                serv.Activo = servicio.Activo;
                serv.TipoServicio = servicio.TipoServicio;

                db.SaveChanges();
                return true;
            }
            catch (Exception)
            {

                throw;
            }
            
        }

        public Servicios ObtenerServicioPorNroPro(int numServicio)
        {
            return db.Servicios.SingleOrDefault(c => c.ServicioId == numServicio);
        }

        public List<Servicios> ObtenerServicios()
        {
            return db.Servicios.Where(s => s.Activo == true).ToList();
        }
    }
}
