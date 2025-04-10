using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CajasDistribucionesNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public CajasDistribuciones GetById(int id)
        {
            return db.CajasDistribuciones.FirstOrDefault(x => x.CajaDistribucionId == id);
        }

        public List<CajasDistribuciones> GetList()
        {
            return db.CajasDistribuciones.ToList();
        }

        public List<VistaCajaDistribuciones> GetVistaCajaDistribuciones()
        {
            return db.VistaCajaDistribuciones.ToList();
        }

        public CajasDistribuciones Create(CajasDistribuciones model)
        {
            string mensaje = string.Empty;

            try
            {
                if (model.CajaDistribucionId == 0)
                {
                    db.CajasDistribuciones.Add(model);
                }
                else
                {
                    db.Entry(model).State = EntityState.Modified;

                }

                db.SaveChanges();

                return model;

            }
            catch (Exception)
            {
                mensaje = "Ha ocurrido un error al intentar crear la entidad.";
                return null;
            }

        }

        public bool EditarCaja(CajasDistribuciones _cajasDistribuciones, int _nroCaja)
        {
            try
            {
                var caja = GetById(_nroCaja);
                caja.Descipcion = _cajasDistribuciones.Descipcion;
                caja.FechaUltimaModificacion = _cajasDistribuciones.FechaUltimaModificacion;
                caja.Longitud = _cajasDistribuciones.Longitud;

                Grabar();
                return true;
            }
            catch (Exception ex) { throw ex; }
        }

        private void Grabar()
        {
            db.SaveChanges();
        }

        public bool Delete(int id)
        {

            var caja = GetById(id);
            caja.FechaBaja = DateTime.Now;
            Grabar();
            return true;

        }

        public string ConsultaDescripcion(string descripcion)
        {

            var mensaje = string.Empty;

            CajasDistribuciones descrip = db.CajasDistribuciones.FirstOrDefault(x => x.Descipcion == descripcion);

            if (descrip != null)
            {

                mensaje = "Ya existe en una caja con el mismo nombre";
            }

            return mensaje;

        }

        public string ConsultaDireccion(string direccion)
        {

            var mensaje = string.Empty;

            CajasDistribuciones descrip = db.CajasDistribuciones.FirstOrDefault(x => x.Longitud == direccion);

            if (descrip != null)
            {

                mensaje = "Ya existe en una caja en esa dirección";
            }

            return mensaje;

        }

        private bool SePuedeEliminar(int id, out string mensaje)
        {
            mensaje = string.Empty;

            //agregar validacion de relacion de entidades

            if (string.IsNullOrEmpty(mensaje))
            {
                return true;
            }

            return false;
        }

        public List<VistaCajaDistribuciones> ObtenerListCajasPorNom(string _caja)
        {
            var cajas = from caja in ObtenerCajas()
                        where caja.Descipcion.Contains(_caja)
                        select caja;
            return cajas.ToList();
        }

        public IQueryable<VistaCajaDistribuciones> ObtenerCajas()
        {
            return db.VistaCajaDistribuciones;
        }
    }
}
