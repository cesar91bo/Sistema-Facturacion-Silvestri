using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

using Xceed.Document.NET;
using Xceed.Words.NET;
using ZXing;
using ZXing.Common;
using ZXing.Rendering;
using Paragraph = Xceed.Document.NET.Paragraph;
using Image = Xceed.Document.NET.Image;
using Spire.Doc.Fields;
using Spire.Doc;

namespace VideoCableEsc.Forms
{
    public partial class PruebaReporteFactura : Form
    {
        public PruebaReporteFactura()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            QrGenerator();


            CargarPdf();

        }

        private static void CargarPdf()
        {
            var original = @"C:\Users\OJEDA\source\repos\VideoCableEsc\VideoCableEsc\Template\FacturaVentaA.docx";

            var nuevoArchivo = @"C:\Users\OJEDA\source\repos\VideoCableEsc\VideoCableEsc\Template\FacturaVentaA Copia.docx";

            File.Copy(original, nuevoArchivo, true);


            //se crea primero el qr y se lo inserta al documento, de otra manera no aparece el qr
            var qrPath = "Qr.png";
            
            using (DocX doc = DocX.Load(nuevoArchivo))
            {

                // Add an image into the document.    
                Image image = doc.AddImage(qrPath);

                // Create a picture (A custom view of an Image).
                Picture picture = image.CreatePicture();

                picture.Height = 90;
                picture.Width = 120;


                foreach (var item in doc.GetBookmarks())
                {
                    if (item.Name == "Imagen")
                    {
                        item.Paragraph.AppendPicture(picture);
                    }
                }

                // Save this document.
                doc.Save();
            }

            Spire.License.LicenseProvider.SetLicenseKey("PUILu36Ih+JDtwEAr15df+E9OHwWC9pL54zFDJvFvQaW0gyLhw7Ynog/D53EWfx4AqgfkWxQxO8XR6vHzNtTnzemNPKTf4OMd/FVxzKPnIvOjuG0c1G5v1ZtlAZb5Uv1bwM9Ar+RjvXfQnylsQJwub+b9BZwnvNzOdWqDf8lqs6YcLDC5i3ObVJ24LVWpJI+Pxl0Mrg3ccRsSH7JraWEbvCfReHJyi5JJDG2KFxLH0cyx2TiRf4Sduan6+F3ZrjgPM5A2oCYfnDbHBLFv0oX9/oRKepuLb/PuASMMySZrjxoLMdCEEqc/mFB+BW0FzLKfgNIael5geTryiN5AGWEnB5K03Dsgo+o1k++02w1WQi4qD9n28rBQMvLrCyqreqacsRlUR2CjDgR1+Wor+ZG5GNVCoXYlY3MOY1oKbuAHy3VqgAeAwAdaHmHYrwXI/x4l+tIfnJWjiePqRa41je6KE2fDC4gboDMJlq1dk5Bdyzpe1HHe2IsZffg4eUvEfIPQTIIRtQdS4ynsUAirIBSGZGOD18vW/v1HJAUCkt/Dddxp+csS14i/OmUG4JddryhLRufFVkFk9wpQfiPjNXm/CI9eq22igO5I2Z3MNvAFV5EKvtJ9xy3eV4+w/1iZRtOU9OQYv7dSKXsfFflAVxjgDM0JjVQphsqHbarbs88LAO02P4G1wB36evbA8n/HAQTJvFtb6XpiI1mA9/XNnWS72rzVD69MBSZWelJWXvb6dnHI0CTdPVGpKDyZnI9fmpmvq+Yc7fjtC+P1rGtpLls3FiHR16s0fidh9uFJquJe0DXlFVR5Nk9oh5fMOpov9Bsy3G9UM3VpMS//UNx1LENKqz9lx7niE26gIM907h0ihSFiMgq8uU9s1+y44mNE2lNMD9ykQG5mK0WP8BzU2aoX9/T45ERldOSXm+dn6dTtHngaNfN7LgdXtcQYW0/2hLz3xJli9x7PL5R/iFTUufW0KgGMQOu4OBi/j8lTFROcR/lGI3rjhg5IWWy6cO+mGAXiJKdmtXWeWTdCfpu//RyBZtiGqFu1Z0m7bQzrFVGTB9MLuWJqVXM5UekXbEGK7ksxadKjx9cSwZapRHAh2gJp7eMvk160AAl3AleXyLC0f8fBSyzQFnvioAxwsATdbjxThZk/Pt1Zu/uOG1Dnul8wm90I9DYpcOaWW6okYEHQf37GmnkOYW2VVDOw/7YXw2nxTri1JrNlqw8E+9XXx779IzZcsX0XU71E7qqHWxP5JfRlSm4f2d+oS3alGhvduH7Y/PF08a8hhBSnznDziJeoYVjd+ZwT2uZ46ZGqcri2e10/x9OfjSoYDQn2JFG72dJLwmh/so0jkcjroDdWTLWqKZp5uTU3Xd0IoRCWyw7/k5cIBrV5qMaiNwtQWptH8KaeBbdqoxZqHWJdIjO+JMAIKTTAA8ZOHA1lEOkxjMYZnJtSVqxCGC+2fagkaANoZAv");

            //Load Document
            Spire.Doc.Document document = new Spire.Doc.Document();

            document.LoadFromFile(nuevoArchivo);

            foreach (FormField field in document.Sections[0].Body.FormFields)
            {
                switch (field.Name)
                {
                    //CAMPOS EMPRESA

                    case "RazonSocialEmpresa":
                        field.Text = "CESAR SRL";
                        break;

                    case "DomicilioComercialEm":
                        field.Text = "CESAR SRL";
                        break;

                    case "CondicionIvaEmp":
                        field.Text = "CESAR SRL";
                        break;

                    case "PuntoVenta":
                        field.Text = "CESAR SRL";
                        break;

                    case "ComprobanteNro":
                        field.Text = "CESAR SRL";
                        break;

                    case "FechaEmision":
                        field.Text = "CESAR SRL";
                        break;

                    case "CuitEmpresa":
                        field.Text = "CESAR SRL";
                        break;

                    case "IngresosBrutosEmp":
                        field.Text = "CESAR SRL";
                        break;

                    case "FechaInicioActividad":
                        field.Text = "CESAR SRL";
                        break;

                    //CAMPOS CLIENTE
                    case "CuitCliente":
                        field.Text = "CESAR SRL";
                        break;

                    case "RazonSocialCliente":
                        field.Text = "CESAR SRL";
                        break;

                    case "CondicionIvaCliente":
                        field.Text = "CESAR SRL";
                        break;

                    case "DomicilioCliente":
                        field.Text = "CESAR SRL";
                        break;

                    case "CondicionVenta":
                        field.Text = "CESAR SRL";
                        break;

                    //CAMPOS SERVICIOS

                    case "ServicioCodigoAfip":
                        field.Text = "CESAR SRL";
                        break;

                    case "ServicioDescripcion":
                        field.Text = "CESAR SRL";
                        break;

                    case "ServicioCantidad":
                        field.Text = "CESAR SRL";
                        break;

                    case "ServicioPrecio":
                        field.Text = "CESAR SRL";
                        break;

                    case "ServicioSubtotal":
                        field.Text = "CESAR SRL";
                        break;

                    case "PorcentajeIva":
                        field.Text = "CESAR SRL";
                        break;

                    case "SubtotalCIva":
                        field.Text = "CESAR SRL";
                        break;

                    //CAMPOS OTROS TRIBUTOS
                    case "ImpNetGra":
                        field.Text = "CESAR SRL";
                        break;

                    case "ImpIva21":
                        field.Text = "300,00";
                        break;

                    case "ImpTotal":
                        field.Text = "1.200,00";
                        break;


                    //CAMPOS FOOTHER

                    case "NumeroCae":
                        field.Text = "CESAR SRL";
                        break;

                    case "FechaVtoCae":
                        field.Text = "CESAR SRL";
                        break;

                }
            }



            document.SaveToFile("FacturaVentaA.pdf", FileFormat.PDF);

            //Launch Document
            System.Diagnostics.Process.Start("FacturaVentaA.pdf");
        }

        private void QrGenerator()
        {
            //Color barcodeColor = newKnownColor.Black;

            BarcodeWriter barcodeWriter = new BarcodeWriter
            {
                Format = BarcodeFormat.QR_CODE,
                Options = new EncodingOptions
                {
                    Width = 50,
                    Height = 50,
                    PureBarcode = true
                },
                Renderer = new BitmapRenderer
                {
                    // Foreground = barcodeColor
                }
            };

            Bitmap barCodeBitmap = barcodeWriter.Write("https://www.afip.gob.ar/fe/qr/?p=eyJ2ZXIiOjEsImZlY2hhIjoiMjAyMC0xMC0xMyIsImN1aXQiOjMwMDAwMDAwMDA3LCJwdG9WdGEiOjEwLCJ0aXBvQ21wIjoxLCJucm9DbXAiOjk0LCJpbXBvcnRlIjoxMjEwMCwibW9uZWRhIjoiRE9MIiwiY3R6Ijo2NSwidGlwb0RvY1JlYyI6ODAsIm5yb0RvY1JlYyI6MjAwMDAwMDAwMDEsInRpcG9Db2RBdXQiOiJFIiwiY29kQXV0Ijo3MDQxNzA1NDM2NzQ3Nn0=");
            var memoryStream = new MemoryStream();

            // save to stream as PNG
            barCodeBitmap.Save("Qr.png", System.Drawing.Imaging.ImageFormat.Png);

        }

    }
}