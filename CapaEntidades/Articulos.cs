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
    
    public partial class Articulos
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Articulos()
        {
            this.AjustesStock = new HashSet<AjustesStock>();
            this.FacturasCompraDetalle = new HashSet<FacturasCompraDetalle>();
            this.PreciosVenta = new HashSet<PreciosVenta>();
            this.PresupuestosDetalles = new HashSet<PresupuestosDetalles>();
            this.RemitosDetalle = new HashSet<RemitosDetalle>();
            this.RemitosDetalleCompra = new HashSet<RemitosDetalleCompra>();
        }
    
        public long IdArticulo { get; set; }
        public string CodigoBarra { get; set; }
        public string DescCorta { get; set; }
        public string DescLarga { get; set; }
        public int IdRubro { get; set; }
        public int IdSubRubro { get; set; }
        public bool LlevarStock { get; set; }
        public double StockActual { get; set; }
        public System.DateTime UltimaActStock { get; set; }
        public double CantidadMinima { get; set; }
        public short IdUnidadMedida { get; set; }
        public Nullable<System.DateTime> FechaBaja { get; set; }
        public string UsrBaja { get; set; }
        public string UsrAcceso { get; set; }
        public System.DateTime FechaAcceso { get; set; }
        public string CodigoProducto { get; set; }
        public Nullable<byte> Embalaje { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AjustesStock> AjustesStock { get; set; }
        public virtual Rubros Rubros { get; set; }
        public virtual SubRubros SubRubros { get; set; }
        public virtual UnidadesMedida UnidadesMedida { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FacturasCompraDetalle> FacturasCompraDetalle { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PreciosVenta> PreciosVenta { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PresupuestosDetalles> PresupuestosDetalles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RemitosDetalle> RemitosDetalle { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<RemitosDetalleCompra> RemitosDetalleCompra { get; set; }
    }
}
