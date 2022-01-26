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
        private string newFileName;

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

        public void SaveImage(Image convertedImage)
        {
            if (convertedImage == null)
            {
                _ = MessageBox.Show("Unable to save image!\n", "Error!", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            SaveFileDialog saveFileDialog = new SaveFileDialog
            {
                Title = "Save Image As",
                Filter = "Image Files(*.png; *.jpg; *.jpeg)|*.png; *.jpg; *.jpeg"
            };
            bool? result = saveFileDialog.ShowDialog();

            if (result == true)
            {
                newFileName = saveFileDialog.FileName;
                convertedImage.Save(newFileName);
            }
            else
            {
                _ = MessageBox.Show("Unable to save image!\n", "Error!", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}