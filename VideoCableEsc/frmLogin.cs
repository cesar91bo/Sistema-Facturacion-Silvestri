using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using CapaNegocio;
using CapaEntidades;
using VideoCableEsc.Forms.Caja;

namespace VideoCableEsc
{
    public partial class frmLogin : Form
    {
        private readonly FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();

        public frmLogin()
        {
            InitializeComponent();
        }

        #region Mover Formulario
        [DllImport("user32.dll", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.dll", EntryPoint = "SendMessage")]
        private static extern bool SendMessage(IntPtr hwnd, int wmsg, int wparam, int lparam);

        private void frmLogin_MouseDown(object sender, MouseEventArgs e)
        {
            MoveForm();
        }
        private void panel1_MouseDown(object sender, MouseEventArgs e)
        {
            MoveForm();
        }

        private void MoveForm()
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }
        #endregion

        #region User Pass
        private void txtBoxUser_Enter(object sender, EventArgs e)
        {
            if (txtBoxUser.Text == "USUARIO")
            {
                txtBoxUser.Text = "";
                txtBoxUser.ForeColor = Color.LightGray;
            }
        }

        private void txtBoxUser_Leave(object sender, EventArgs e)
        {
            if (txtBoxUser.Text == "")
            {
                txtBoxUser.Text = "USUARIO";
                txtBoxUser.ForeColor = Color.DimGray;
            }
        }

        private void txtBoxPass_Enter(object sender, EventArgs e)
        {
            if (txtBoxPass.Text == "CONTRASEÑA")
            {
                txtBoxPass.Text = "";
                txtBoxPass.ForeColor = Color.LightGray;
                txtBoxPass.UseSystemPasswordChar = true;
            }
        }

        private void txtBoxPass_Leave(object sender, EventArgs e)
        {
            if (txtBoxPass.Text == "")
            {
                txtBoxPass.Text = "CONTRASEÑA";
                txtBoxPass.ForeColor = Color.DimGray;
                txtBoxPass.UseSystemPasswordChar = false;
            }
        }

        private void msjError(string _error)
        {
            lblError.Text = "    " + _error;
            lblError.Visible = true;
        }
        #endregion

        #region btnClose btnMinimize
        private void btnClose_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnMinimize_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        #endregion

        #region Consultas
        private void btnAcceder_Click(object sender, EventArgs e)
        {
            if (txtBoxUser.Text != "USUARIO")
            {
                if (txtBoxPass.Text != "CONTRASEÑA")
                {
                    try
                    {
                        Ingresar();

                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
                else
                {
                    msjError("Por favor ingrese la Contraseña");
                }

            }
            else
            {
                msjError("Por favor ingrese el nombre de Usuario");
            }

        }

        private void Ingresar()
        {

            LoginNegocio loginNegocio = new LoginNegocio();
            var usuario = loginNegocio.ConsultarNombreUsuario(this.txtBoxUser.Text);

            if (usuario != null)
            {
                try
                {
                    if (loginNegocio.AutenticacionUsuario(this.txtBoxUser.Text, this.txtBoxPass.Text))
                    {
                        Hide();

                        CajaNegocio cajaNegocio = new CajaNegocio();

                        if (cajaNegocio.ExisteCajaAnteriorSinCerrar())
                        {
                            DialogResult result = MessageBox.Show(this,"Atención: la caja anterior no fue cerrada. ¿Desea cerrar ahora?", "Advertencia", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                            if (result == DialogResult.Yes)
                            {
                                var frmCerrarCaja = new frmCierreCaja();
                                frmCerrarCaja.ShowDialog();
                            }
                        }

                        CajasDiarias cajaActual = cajaNegocio.ObtenerCajaActual();
                        if (cajaActual == null)
                        {
                            DialogResult result = MessageBox.Show(this,"La caja no se ha abierto. ¿Desea abrirla ahora?", "ABRIR CAJA",
                                MessageBoxButtons.YesNo,
                                MessageBoxIcon.Question);
                            if (result == DialogResult.Yes)
                            {
                                var frmCaja = new frmAperturaCaja();
                                frmCaja.ShowDialog();
                            }
                        }
                        var frm = new frmPrincipal();
                        frm.ShowDialog();
                        Close();
                    }
                    else
                    {
                        msjError("Contraseña incorrecta");
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }

            }
            else
            {
                msjError("El Usuario no existe");
            }
        }
        #endregion

        private void btnAcceder_Enter(object sender, EventArgs e)
        {
            if (txtBoxUser.Text != "USUARIO")
            {
                if (txtBoxPass.Text != "CONTRASEÑA")
                {
                    try
                    {

                        Ingresar();

                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
                else
                {
                    msjError("Por favor ingrese la Contraseña");
                }

            }
            else
            {
                msjError("Por favor ingrese el nombre de Usuario");
            }
        }

        private void txtBoxPass_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (e.KeyCode == Keys.Enter)
                {
                    if (txtBoxUser.Text != "USUARIO")
                    {
                        if (txtBoxPass.Text != "CONTRASEÑA" && txtBoxPass.Text != "")
                        {
                            if (e.KeyCode == Keys.Enter)
                            {

                                Ingresar();

                            }
                            else
                            {
                                msjError("Por favor ingrese la Contraseña");
                            }
                        }
                    }
                    else
                    {
                        msjError("Por favor ingrese el nombre de Usuario");
                    }
                    e.SuppressKeyPress = true;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
