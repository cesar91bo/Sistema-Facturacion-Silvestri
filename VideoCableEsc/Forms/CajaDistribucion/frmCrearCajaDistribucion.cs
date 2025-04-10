using CapaEntidades;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.CajaDistribucion
{
    public partial class frmCrearCajaDistribucion : Form
    {
        public string Accion;
        public Int32 NroCliente, NroCaja;
        public bool VienedeFact;

        CajasDistribucionesNegocio cajaDistNegocio = new CajasDistribucionesNegocio();


        public frmCrearCajaDistribucion()
        {
            InitializeComponent();
        }

        private void frmCrearCajaDistribucion_Load(object sender, EventArgs e)
        {
            if (Accion == "MOD")
            {
                if (NroCaja > 0) BuscarCajaDist(NroCaja);
                else
                {

                    lblNro.Visible = true;
                    txtNroCaja.Visible = true;
                    txtNroCaja.Enabled = false;
                }
            }
        }

        private void BuscarCajaDist(int nroCaja)
        {
            try
            {               

                CajasDistribuciones cajasDistribuciones = cajaDistNegocio.GetById(NroCaja);

                if (cajasDistribuciones != null)
                {
                    txtDescripcion.Text = cajasDistribuciones.Descipcion.ToString();
                    txtDireccion.Text = cajasDistribuciones.Longitud.ToString();
                    txtNroCaja.Text = cajasDistribuciones.CajaDistribucionId.ToString();
                }
                else MessageBox.Show("No se encontró la Caja de Distribución", "Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            catch (Exception ex) { throw ex; }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (Validaciones())
            {
                var caja = new CajasDistribuciones
                {
                    Descipcion = txtDescripcion.Text,
                    Longitud = txtDireccion.Text,
                    FechaUltimaModificacion = DateTime.Now
                };

                if (Accion == "ALTA")
                {
                    var cajaDistNegocio = new CajasDistribucionesNegocio();
                  
                    caja = cajaDistNegocio.Create(caja);

                    if (caja != null)
                    {
                        MessageBox.Show("La caja se ingresó correctamente." + Environment.NewLine +
                                "Caja de Distribición Nro: " + caja.CajaDistribucionId, "ALTA CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);

                        limpiar();
                    }
                    else
                    {
                        MessageBox.Show("Error al crear la caja de distribuciones, corroborar los datos y volver a intentar");
                    }
                }
                else
                {
                    cajaDistNegocio.EditarCaja(caja, NroCaja);

                    MessageBox.Show("La Caja de Distribución se editó correctamente.", "EDICIÓN CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);

                    NroCliente = 0;
                    this.Close();
                }

            }
        }

        private void limpiar()
        {
            txtDireccion.Text = "";
            txtDescripcion.Text = "";
        }

        private bool Validaciones()
        {
            bool Correcto = true;
            var cajaDistNegocio = new CajasDistribucionesNegocio();

            if (txtDescripcion.Text.All(char.IsWhiteSpace))
            {
                MessageBox.Show(txtDescripcion, "Ingrese la Descripción");
                Correcto = false;
            }
            else 
            {
                var consultaDescripcion = cajaDistNegocio.ConsultaDescripcion(txtDescripcion.Text);
               if (consultaDescripcion != string.Empty)
               {
                    MessageBox.Show(txtDescripcion, consultaDescripcion.ToString());
                    Correcto = false;
                }
            }

            if (txtDireccion.Text.All(char.IsWhiteSpace))
            {
                MessageBox.Show(txtDireccion, "Ingrese la Dirección");
                Correcto = false;
            }
            else 
            {
                //var consultaDireccion = cajaDistNegocio.ConsultaDireccion(txtDireccion.Text);
                //if (consultaDireccion != string.Empty)
                //{
                //    MessageBox.Show(txtDireccion, consultaDireccion.ToString());
                //    Correcto = false;
                //}
            }

            return Correcto;
        }
    }
}
