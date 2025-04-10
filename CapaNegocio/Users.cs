using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public enum TiposUsers : short
    {
        Root = 1,
        Administrador = 2,
        Vendedor = 3,
        Cajero = 4
    }
    public static class Users
    {
        public static string Usr { get; set; }
        public static TiposUsers Rol { get; set; }
        public static Int16 IdTipo { get; set; }

        public static bool ModArticulos, ModClientes, ModProveedores, ModVentas,
            ModCompras, ModCobranza, ModPagos, ModCuentasCorrientes, ModAuxiliares,
            ModConfiguracion, ModTodos, ModPresupuestos, ModDepositos, ModOrdenes, ModVendedores, ModContabilidad;
        public static bool PoseeElRol(TiposUsers _rol) { return _rol == Rol; }
    }
}
