using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{   
    public class LoginNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();
        public Usuarios ConsultarNombreUsuario(string _nombre)
        {
            return db.Usuarios.SingleOrDefault(x => x.NombreUser == _nombre);
        }

        public bool AutenticacionUsuario(string _usuario, string _password)
        {
            var pass = HashearPassword(_password);
            Usuarios usr = db.Usuarios.SingleOrDefault(x => x.NombreUser == _usuario && x.PassUser == pass);
            if (usr != null)
            {
                Users.Usr = usr.NombreUser;
                Users.IdTipo = usr.IdTipoUser;
                Users.Rol = (TiposUsers)usr.IdTipoUser;
                return true;
            }
            return false;
        }

        private static object HashearPassword(string password)
        {
            return SHA1.Create().ComputeHash(Encoding.UTF8.GetBytes(password));
        }
    }
}
