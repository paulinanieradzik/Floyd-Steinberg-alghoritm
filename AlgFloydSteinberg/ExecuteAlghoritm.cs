using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;

namespace AlgFloydSteinberg
{
    internal class ExecuteAlghoritm
    {
        private Bitmap bitmap;
        private BitmapData bmpData;
        private Alghoritm alghoritm;

        private Image ArrayToBitmap(byte[] pixelValues)
        {
            //Set values of all image points
            //Copy the RGB values back to the bitmap
            System.Runtime.InteropServices.Marshal.Copy(pixelValues, 0, bmpData.Scan0, pixelValues.Length);
            // Unlock the bits.
            bitmap.UnlockBits(bmpData);
            return bitmap;
        }

        private byte[] BitmapToArray(Image sourceImage)
        {
            //copy source image
            bitmap = (Bitmap)sourceImage.Clone();

            //Get values of all image points
            bmpData = bitmap.LockBits(new Rectangle(0, 0, bitmap.Width, bitmap.Height), ImageLockMode.ReadWrite, bitmap.PixelFormat);
            //Declare an array to hold the bytes of the bitmap
            byte[] pixelValues = new byte[Math.Abs(bmpData.Stride) * bitmap.Height];
            // Copy the RGB values into the array
            System.Runtime.InteropServices.Marshal.Copy(bmpData.Scan0, pixelValues, 0, pixelValues.Length);

            return pixelValues;
        }

        public Image Dithering(Image sourceImag, int numberOfBits)
        {
            byte[] array = BitmapToArray(sourceImag);
            //wywołanie dll
            alghoritm.ConvertImage(ref array, numberOfBits, sourceImag.Width, sourceImag.Height);
            //Bitmap bitmap = (Bitmap)sourceImag.Clone();
            int w = sourceImag.Width;
            int h = sourceImag.Height;
            return ArrayToBitmap(array);
        }

        public void SetAlghoritmType(bool isCs)
        {
            alghoritm = isCs ? new AlghoritmCs() : (Alghoritm)new AlghoritmAsm();
        }
    }
}