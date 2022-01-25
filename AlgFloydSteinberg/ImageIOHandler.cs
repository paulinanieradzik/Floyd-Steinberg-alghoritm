using System;
using System.Windows.Media.Imaging;
using System.IO;
using System.Windows;
using Microsoft.Win32;
using System.Drawing;
using System.Drawing.Imaging;

namespace AlgFloydSteinberg
{
    public class ImageIOHandler
    {
        private Image orginal;

        public Image OpenImage()
        {
            OpenFileDialog openFileDialog = new OpenFileDialog
            {
                Title = "Select image",
                Filter = "All supported graphics|*.jpg;*.jpeg;*.bmp|" +
             "JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg"
            };
            bool? result = openFileDialog.ShowDialog();

            if (result == true)
            {
                orginal = new Bitmap(openFileDialog.OpenFile());
            }
            else
            {
                _ = MessageBox.Show("Unable to load choosen file!\n", "Error!", MessageBoxButton.OK, MessageBoxImage.Error);
            }

            return orginal;
        }

        //zapisywanie

        public BitmapImage BitmapToImageSource(Bitmap bitmap)
        {
            using (MemoryStream memory = new MemoryStream())
            {
                bitmap.Save(memory, System.Drawing.Imaging.ImageFormat.Bmp);
                memory.Position = 0;
                BitmapImage bitmapimage = new BitmapImage();
                bitmapimage.BeginInit();
                bitmapimage.StreamSource = memory;
                bitmapimage.CacheOption = BitmapCacheOption.OnLoad;
                bitmapimage.EndInit();

                return bitmapimage;
            }
        }

        private int Index(int x, int y, int width)
        {
            return x + (y * width);
        }

        public Image ConvertImage(Image image, int numberOfBits)
        {
            Bitmap bitmap = (Bitmap)image.Clone();
            //Pobierz wartosc wszystkich punktow obrazu
            //BitmapData bmpData = bitmap.LockBits(new Rectangle(0, 0, bitmap.Width, bitmap.Height), ImageLockMode.ReadWrite, bitmap.PixelFormat);
            //byte[] pixelValues = new byte[bmpData.Stride * bitmap.Height];
            //System.Runtime.InteropServices.Marshal.Copy(bmpData.Scan0, pixelValues, 0, pixelValues.Length);

            for (int y = 0; y < bitmap.Height - 1; y++)
            {
                for (int x = 1; x < bitmap.Width - 1; x++)
                {
                    //int idx = index(x, y, bitmap.Width);
                    Color oldC = bitmap.GetPixel(x, y);
                    float oldR = oldC.R;
                    float oldG = oldC.G;
                    float oldB = oldC.B;

                    int newR = (int)(numberOfBits * oldR / 255) * (255 / numberOfBits);
                    int newG = (int)(numberOfBits * oldG / 255) * (255 / numberOfBits);
                    int newB = (int)(numberOfBits * oldB / 255) * (255 / numberOfBits);

                    Color newColor = Color.FromArgb(newR, newG, newB);
                    bitmap.SetPixel(x, y, newColor);

                    float errR = oldR - newR;
                    float errG = oldG - newG;
                    float errB = oldB - newB;

                    Color c = bitmap.GetPixel(x + 1, y);
                    int r = c.R;
                    int g = c.G;
                    int b = c.B;
                    r = (int)(r + errR * 7 / 16.0);
                    g = (int)(g + errG * 7 / 16.0);
                    b = (int)(b + errB * 7 / 16.0);
                    r = r > 255 ? 255 : r;
                    g = g > 255 ? 255 : g;
                    b = b > 255 ? 255 : b;
                    r = r < 0 ? 0 : r;
                    g = g < 0 ? 0 : g;
                    b = b < 0 ? 0 : b;
                    newColor = Color.FromArgb(r, g, b);
                    bitmap.SetPixel(x + 1, y, newColor);

                    c = bitmap.GetPixel(x - 1, y + 1);
                    r = c.R;
                    g = c.G;
                    b = c.B;
                    r = (int)(r + errR * 3 / 16.0);
                    g = (int)(g + errG * 3 / 16.0);
                    b = (int)(b + errB * 3 / 16.0);
                    r = r > 255 ? 255 : r;
                    g = g > 255 ? 255 : g;
                    b = b > 255 ? 255 : b;
                    r = r < 0 ? 0 : r;
                    g = g < 0 ? 0 : g;
                    b = b < 0 ? 0 : b;
                    newColor = Color.FromArgb(r, g, b);
                    bitmap.SetPixel(x - 1, y + 1, newColor);

                    c = bitmap.GetPixel(x, y + 1);
                    r = c.R;
                    g = c.G;
                    b = c.B;
                    r = (int)(r + errR * 5 / 16.0);
                    g = (int)(g + errG * 5 / 16.0);
                    b = (int)(b + errB * 5 / 16.0);
                    r = r > 255 ? 255 : r;
                    g = g > 255 ? 255 : g;
                    b = b > 255 ? 255 : b;
                    r = r < 0 ? 0 : r;
                    g = g < 0 ? 0 : g;
                    b = b < 0 ? 0 : b;
                    newColor = Color.FromArgb(r, g, b);
                    bitmap.SetPixel(x, y + 1, newColor);

                    c = bitmap.GetPixel(x + 1, y + 1);
                    r = c.R;
                    g = c.G;
                    b = c.B;
                    r = (int)(r + errR * 1 / 16.0);
                    g = (int)(g + errG * 1 / 16.0);
                    b = (int)(b + errB * 1 / 16.0);
                    r = r > 255 ? 255 : r;
                    g = g > 255 ? 255 : g;
                    b = b > 255 ? 255 : b;
                    r = r < 0 ? 0 : r;
                    g = g < 0 ? 0 : g;
                    b = b < 0 ? 0 : b;
                    newColor = Color.FromArgb(r, g, b);
                    bitmap.SetPixel(x + 1, y + 1, newColor);
                }
            }
            //Utworz tablice bledow

            //System.Runtime.InteropServices.Marshal.Copy(pixelValues, 0, bmpData.Scan0, pixelValues.Length);
            //bitmap.UnlockBits(bmpData);
            return bitmap;
        }
    }
}