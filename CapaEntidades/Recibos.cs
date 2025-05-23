//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CapaEntidades
{
    using System;
    using System.Collections.Generic;
    
    public partial class Recibos
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Recibos()
        {
            this.RecibosDetalle = new HashSet<RecibosDetalle>();
        }
    
        public int IdRecibo { get; set; }
        public short IdTipoDocumento { get; set; }
        public System.DateTime FechaEmision { get; set; }
        public int NroCliente { get; set; }
        public decimal MontoTotal { get; set; }
        public string Concepto { get; set; }
        public Nullable<System.DateTime> FechaBaja { get; set; }
        public short IdEmpresa { get; set; }
        public string UsrAcceso { get; set; }
        public System.DateTime FechaAcceso { get; set; }
    
        public virtual TiposDocFact TiposDocFact { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RecibosDetalle> RecibosDetalle { get; set; }
        public virtual Empresa Empresa { get; set; }
    }
}
