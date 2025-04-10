using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidades.Enum
{
    public enum FormaPagoEnum : int
    {
        Contado = 1,
        CuentaCorriente = 2,
        TarjetaDebito = 3,
        TarjetaCredito = 4,
        Transferencia = 5,
        Online = 6,
        MercadoPago = 7,
        SinEspecificar = 8
    }
}
