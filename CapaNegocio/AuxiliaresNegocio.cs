using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class AuxiliaresNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();

        public List<RegimenesImpositivos> ListRegImp()
        {
            var regImp = from ri in ObtenerRegimenes()
                         select ri;
            return regImp.ToList();
        }

        public List<RegimenesImpositivos> ObtenerRegimenes()
        {
            return db.RegimenesImpositivos.ToList();
        }

        public RegimenesImpositivos ObtenerRIporId(Int16 _id)
        {
            return db.RegimenesImpositivos.SingleOrDefault(c => c.IdRegimenImpositivo == _id);
        }

        public UnidadesMedida ObtenerUMPorId (Int16 _id)
        {
            return db.UnidadesMedida.SingleOrDefault(u => u.IdUnidadMedida == _id);
        }

        public List<TiposDocumento> ObtenerTipoDoc()
        {
            return db.TiposDocumento.ToList();
        }

        public static Empresa ObtenenerEmpresa()
        {
            using (var db = new SgPymeBaseEntities()) return db.Empresa.SingleOrDefault(c => c.IdEmpresa == 1);
        }

        public DataTable DtCondPago()
        {
            DataTable dt = Converter<CondicionesPago>.Convert(ObtenerCondPago().ToList());
            return dt;
        }

        public IQueryable<CondicionesPago> ObtenerCondPago()
        {
            return db.CondicionesPago;
        }

        public DataTable DtTiposConceptosFactura()
        {
            DataTable dt = Converter<TiposConceptoFactura>.Convert(ObtenerTiposConceptosFactura().ToList());
            return dt;
        }

        public IQueryable<TiposConceptoFactura> ObtenerTiposConceptosFactura()
        {
            return db.TiposConceptoFactura;
        }

        public DataTable DtFormasPago()
        {
            DataTable dt = Converter<FormasPago>.Convert(ObtenerFormasPago().ToList());
            return dt;
        }

        public IQueryable<FormasPago> ObtenerFormasPago() { return db.FormasPago; }

        public DataTable DtTiposFact()
        {
            DataTable dt = Converter<TiposFactura>.Convert(ObtenerTiposFact().ToList());
            return dt;
        }

        public IQueryable<TiposFactura> ObtenerTiposFact()
        {
            return db.TiposFactura;
        }

        public Ultima_Revision_Deudores ObtenerFechaUltimaRevisionDeudores()
        {
            return db.Ultima_Revision_Deudores.OrderByDescending(r => r.Fecha_Revision).FirstOrDefault();
        }


        public void GuardarRevisionDeudores(List<int> clientesSuspendidos)
        {
            using (var transaction = db.Database.BeginTransaction())
            {
                try
                {
                    // 1. Insertar la nueva revisión
                    var nuevaRevision = new Ultima_Revision_Deudores
                    {
                        Fecha_Revision = DateTime.Now
                    };
                    db.Ultima_Revision_Deudores.Add(nuevaRevision);
                    db.SaveChanges();

                    // 2. Obtener el ID de la revisión insertada
                    int idUltimaRevision = nuevaRevision.Id_UltimaRevision;

                    // 3. Insertar cada cliente suspendido
                    foreach (var clienteId in clientesSuspendidos)
                    {
                        db.ClientesSuspendidos.Add(new ClientesSuspendidos
                        {
                            Id_UltimaRevision = idUltimaRevision,
                            ClienteCajaDistribucionServicioId = clienteId
                        });
                    }
                    db.SaveChanges();
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        public Seteos ObtenerSeteos()
        {
            return db.Seteos.OrderByDescending(s => s.IdSeteo).FirstOrDefault();
        }

        public void ActualizarSeteos(Seteos seteos)
        {
            var seteoExistente = db.Seteos.Find(seteos.IdSeteo);
            if (seteoExistente != null)
            {
                seteoExistente.ToleranciaDiferencia = seteos.ToleranciaDiferencia;
                db.SaveChanges();
            }
            else
            {
                throw new Exception("Seteo no encontrado.");
            }
        }

    }
}
