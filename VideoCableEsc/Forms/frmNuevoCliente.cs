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

namespace VideoCableEsc.Forms
{
    public partial class frmNuevoCliente : Form
    {
        public string Accion;
        public Int32 NroCliente;
        public bool VienedeFact;

        ClienteNegocio clienteNegocio = new ClienteNegocio();
        public frmNuevoCliente()
        {
            InitializeComponent();
        }

        private void frmNuevoCliente_Load(object sender, EventArgs e)
        {
            try
            {
                var neg = new AuxiliaresNegocio();

                cmbRegimenImp.DataSource = neg.ObtenerRegimenes();
                cmbRegimenImp.DisplayMember = "Descripcion";
                cmbRegimenImp.ValueMember = "IdRegimenImpositivo";

                cmbTipoDoc.DataSource = neg.ObtenerTipoDoc();
                cmbTipoDoc.DisplayMember = "Descipcion";
                cmbTipoDoc.ValueMember = "TipoDocumento";
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Validaciones())
                {
                    
                    if (cmbTipoDoc.SelectedValue.ToString() == "CUIT")
                    {
                        List<Clientes> cuit = clienteNegocio.ObtenerClientesCargadosCUIT(Convert.ToInt64(txtNroDoc.Text), cmbTipoDoc.SelectedValue.ToString());
                        if (cuit.Count > 1)
                        {
                            if (Accion.ToUpper() == "ALTA")
                                if (MessageBox.Show("Se ha encontroado un cliente con el mismo número de CUIT, ¿Desea cargarlo de todas formas?",
                                    "CUIT ENCONTRADO", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                                {
                                    MessageBox.Show("Esta registando un Cliente con un mismo CUIT");
                                    return;
                                }
                        }
                        else
                        {
                            if (MessageBox.Show("Se ha encontrado un Cliente con el mismo número de CUIT, ¿Desea editarlo de todas formas?",
                                "CUIT ENCONTRADO", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                            {
                                MessageBox.Show("Esta registando un Cliente con un mismo CUIT");
                                return;
                            }
                        }
                    }
                    var cli = new Clientes
                    {
                        ApellidoyNombre = txtNombreApellido.Text,
                        Direccion = txtDireccion.Text,
                        Email1 = txtEmail.Text,
                        Telefono = txtTelefono.Text,
                        CodigoPostal = 3531,
                        SubCodigoPostal = 1
                    };
                    cli.IdRegimenImpositivo = Convert.ToInt16(cmbRegimenImp.SelectedValue);
                    switch (cmbTipoDoc.SelectedValue.ToString())
                    {
                        case "CUIT":
                            cli.Cuit0 = txtCuit0.Text;
                            cli.Cuit1 = txtCuit1.Text;
                            cli.Cuit2 = txtCuit2.Text;
                            cli.TipoDocumento = "CUIT";
                            cli.NroDocumento = null;
                            break;
                        case "-":
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = null;
                            cli.NroDocumento = null;
                            break;
                        case "DNI":
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = cmbTipoDoc.SelectedValue.ToString();
                            cli.NroDocumento = Convert.ToInt32(txtNroDoc.Text);
                            break;
                        default:
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = cmbTipoDoc.SelectedValue.ToString();
                            cli.NroDocumento = Convert.ToInt32(txtNroDoc.Text);
                            break;
                    }
                    if (Accion == "ALTA")
                    {
                        cli.UsrAcceso = Users.Usr;
                        Int32 NroCli = clienteNegocio.NuevoCli(cli);
                        if (NroCli > 0)
                        {
                            MessageBox.Show("El cliente se ingresó correctamente." + Environment.NewLine +
                            "Nro.Cliente: " + NroCli, "ALTA CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            this.Close();
                            if (VienedeFact)
                            {
                                NroCliente = NroCli;
                                DialogResult = DialogResult.OK;
                            }

                        }
                    }
                    else if (Accion == "MOD")
                    {
                        clienteNegocio.EditarCli(cli, NroCliente);
                        MessageBox.Show("El cliente se editó correctamente.", "EDICIÓN CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        DeshabControls();
                        NroCliente = 0;
                        if (txtNroCli.Visible == false)
                        {
                            this.Close();
                        }
                    }
                }
                FuncionesForms.BlanquearGroupBox(groupBox1);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private bool Validaciones()
        {
            return true;
        }
        private void DeshabControls()
        {
            foreach (Control x in groupBox1.Controls)
            {
                if (x is TextBox || x is ComboBox || x is CheckBox || x is DateTimePicker)
                {
                    x.Enabled = false;
                }
            }

            txtNroCli.Enabled = true;
        }
    }
}
