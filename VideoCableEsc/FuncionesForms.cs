using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc
{
    public static class FuncionesForms
    {
        public static bool VerificarCuit(string Cuit1, string Cuit2, string Cuit3, ref Int32 v)
        {
            try
            {
                if (Cuit2.Length < 8)
                {
                    Cuit2 = Cuit2.PadLeft(8, '0');
                }
                Int32 d1 = Convert.ToInt16(Cuit1.Substring(0, 1)) * 5;
                Int32 d2 = Convert.ToInt16(Cuit1.Substring(1, 1)) * 4;
                Int32 d3 = Convert.ToInt16(Cuit2.Substring(0, 1)) * 3;
                Int32 d4 = Convert.ToInt16(Cuit2.Substring(1, 1)) * 2;
                Int32 d5 = Convert.ToInt16(Cuit2.Substring(2, 1)) * 7;
                Int32 d6 = Convert.ToInt16(Cuit2.Substring(3, 1)) * 6;
                Int32 d7 = Convert.ToInt16(Cuit2.Substring(4, 1)) * 5;
                Int32 d8 = Convert.ToInt16(Cuit2.Substring(5, 1)) * 4;
                Int32 d9 = Convert.ToInt16(Cuit2.Substring(6, 1)) * 3;
                Int32 d10 = Convert.ToInt16(Cuit2.Substring(7, 1)) * 2;
                Int32 Suma = d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8 + d9 + d10;
                Int32 mod11 = Suma % 11;
                Int32 restaMody11 = 11 - mod11;
                switch (restaMody11)
                {
                    case 11:
                        v = 0;
                        if (Convert.ToInt32(Cuit3) == 0)
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }

                    case 10:
                        v = 9;
                        if (Convert.ToInt32(Cuit3) == 9)
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }

                    default:
                        v = restaMody11;
                        if (Convert.ToInt32(Cuit3) == restaMody11)
                        {

                            return true;
                        }
                        else
                        {
                            return false;
                        }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void BlanquearGroupBox(GroupBox grp)
        {
            foreach (Control c in grp.Controls)
            {
                if (c.GetType().Name == "TextBox")
                {
                    c.Text = "";
                }
            }
        }
        // SI EL NRO ES ENTERO
        public static bool SiesInt32(string valor)
        {
            Int32 i;
            if (Int32.TryParse(valor, out i) == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool SiesInt64(string valor)
        {
            Int64 i;
            if (Int64.TryParse(valor, out i) == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        // SI EL NRO ES DECIMAL
        public static bool SiesDecimal(object valor)
        {
            decimal i;
            if (decimal.TryParse(valor.ToString(), out i) == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        // SI EL NRO ES DOUBLE
        public static bool SiesDoble(object valor)
        {
            double i;
            if (double.TryParse(valor.ToString(), out i) == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        // SI LA FECHA ES VALIDA
        public static bool SiesFecha(string pFecha)
        {
            DateTime i;
            if (DateTime.TryParse(pFecha, out i) == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        //// SI EL CBOX ESTA VACIO
        //public static bool SiesComboNoVacio( pCombo)
        //{
        //    if (pCombo.SelectedIndex == -1)
        //    {
        //        return false;
        //    }
        //    else
        //    {
        //        return true;
        //    }
        //}

        // CORREO VALIDO
        public static bool SiesCorreo(string pCorreo)
        {
            if (pCorreo.Length > 0)
            {
                return System.Text.RegularExpressions.Regex.IsMatch(pCorreo, "\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");
            }
            else
            {
                return false;
            }

        }

        //HORA Y MINUTOS VALIDOS
        public static bool SiesHoraMinutos(string pHora)
        {
            if (pHora.Length > 0)
            {
                return System.Text.RegularExpressions.Regex.IsMatch(pHora, "([0-1][0-9]|2[0-3]):[0-5][0-9]");
            }
            else
            {
                return false;
            }
        }
    }
}
