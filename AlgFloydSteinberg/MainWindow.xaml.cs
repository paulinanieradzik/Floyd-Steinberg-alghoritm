using System;
using System.Windows;
using System.IO;
using System.Runtime.InteropServices;
using System.Drawing;
using AlgFloydSteingergCs;

namespace AlgFloydSteinberg
{
    public partial class MainWindow : Window
    {
        [DllImport("../../../../x64/Debug/AlgFloydSteinbergAsm.dll")]
        private static extern int MyProc1(int a, int b);

        private ImageIOHandler imageIOHandler;
        private Image orginalImage;
        private Image convertedImage;
        private ExecuteAlghoritm executeAlghoritm;
        private int numberOfBits;

        public MainWindow()
        {
            InitializeComponent();
            WindowStartupLocation = WindowStartupLocation.CenterScreen;
            imageIOHandler = new ImageIOHandler();
            if (File.Exists("./gory.png"))
            {
                orginalImage = new Bitmap("./gory.png");
                convertedImage = new Bitmap("./gory.png");
            }
            executeAlghoritm = new ExecuteAlghoritm();
            radioButtonCpp.IsChecked = true;
            executeAlghoritm.SetAlghoritmType(true);
            numberOfBits = (int)Slider.Value;

            //int x = 1;
            //int y = 1;
            //int z = MyProc1(x, y);
        }

        private void ExecuteAlghoritm(object sender, RoutedEventArgs e)
        {
            if (orginalImage != null)
            {
                convertedImage = executeAlghoritm.Dithering(orginalImage, numberOfBits);
                convertedImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)convertedImage);
            }
        }

        private void ChooseImage_Click(object sender, RoutedEventArgs e)
        {
            orginalImage = imageIOHandler.OpenImage();
            if (orginalImage != null)
            {
                orginalImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)orginalImage);
                convertedImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)orginalImage);
            }
        }

        private void SaveImage_Click(object sender, RoutedEventArgs e)
        {
            //convertedImage.Source
            orginalImage = imageIOHandler.ConvertImage(orginalImage, numberOfBits);
            orginalImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)orginalImage);
        }

        private void RadioButtonASM_Checked(object sender, RoutedEventArgs e)
        {
            executeAlghoritm.SetAlghoritmType(false);
        }

        private void RadioButtonCpp_Checked(object sender, RoutedEventArgs e)
        {
            executeAlghoritm.SetAlghoritmType(true);
        }

        private void Slider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            numberOfBits = (int)Slider.Value;
            numberBits.Content = numberOfBits.ToString();
        }
    }
}