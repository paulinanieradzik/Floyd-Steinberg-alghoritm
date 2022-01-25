using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlgFloydSteingergCs
{
    public class Dithering
    {
        public void AlghoritmCalculator(ref byte[] image, int numberOfBits, int width, int height)
        {
            int i = 0;
            for (int y = 0; y < height - 1; y++)
            {
                float oldB = image[i];
                float oldG = image[i + 1];
                float oldR = image[i + 2];

                int newR = (int)(numberOfBits * oldR / 255) * (255 / numberOfBits);
                int newG = (int)(numberOfBits * oldG / 255) * (255 / numberOfBits);
                int newB = (int)(numberOfBits * oldB / 255) * (255 / numberOfBits);

                image[i] = (byte)newB;
                image[i + 1] = (byte)newG;
                image[i + 2] = (byte)newR;
                i += 3;
                for (int x = 1; x < width - 1; x++)
                {
                    oldB = image[i];
                    oldG = image[i + 1];
                    oldR = image[i + 2];

                    newR = (int)(numberOfBits * oldR / 255) * (255 / numberOfBits);
                    newG = (int)(numberOfBits * oldG / 255) * (255 / numberOfBits);
                    newB = (int)(numberOfBits * oldB / 255) * (255 / numberOfBits);

                    image[i] = (byte)newB;
                    image[i + 1] = (byte)newG;
                    image[i + 2] = (byte)newR;

                    //float errR = oldR - newR;
                    //float errG = oldG - newG;
                    //float errB = oldB - newB;

                    ////Pixel(x + 1, y);
                    //int b = image[i + 3];
                    //int g = image[i + 1 + 3];
                    //int r = image[i + 2 + 3];
                    //r = (int)(r + errR * 7 / 16.0);
                    //g = (int)(g + errG * 7 / 16.0);
                    //b = (int)(b + errB * 7 / 16.0);
                    //r = r > 255 ? 255 : r;
                    //g = g > 255 ? 255 : g;
                    //b = b > 255 ? 255 : b;
                    //r = r < 0 ? 0 : r;
                    //g = g < 0 ? 0 : g;
                    //b = b < 0 ? 0 : b;
                    //image[i + 3] = (byte)b;
                    //image[i + 1 + 3] = (byte)g;
                    //image[i + 2 + 3] = (byte)r;

                    ////Pixel(x - 1, y + 1);
                    //b = image[i + 3 * width - 3];
                    //g = image[i + 1 + 3 * width - 3];
                    //r = image[i + 2 + 3 * width - 3];
                    //r = (int)(r + errR * 3 / 16.0);
                    //g = (int)(g + errG * 3 / 16.0);
                    //b = (int)(b + errB * 3 / 16.0);
                    //r = r > 255 ? 255 : r;
                    //g = g > 255 ? 255 : g;
                    //b = b > 255 ? 255 : b;
                    //r = r < 0 ? 0 : r;
                    //g = g < 0 ? 0 : g;
                    //b = b < 0 ? 0 : b;
                    //image[i + 3 * width - 3] = (byte)b;
                    //image[i + 1 + 3 * width - 3] = (byte)g;
                    //image[i + 2 + 3 * width - 3] = (byte)r;

                    ////Pixel(x, y + 1);
                    //b = image[i + 3 * width];
                    //g = image[i + 1 + 3 * width];
                    //r = image[i + 2 + 3 * width];
                    //r = (int)(r + errR * 5 / 16.0);
                    //g = (int)(g + errG * 5 / 16.0);
                    //b = (int)(b + errB * 5 / 16.0);
                    //r = r > 255 ? 255 : r;
                    //g = g > 255 ? 255 : g;
                    //b = b > 255 ? 255 : b;
                    //r = r < 0 ? 0 : r;
                    //g = g < 0 ? 0 : g;
                    //b = b < 0 ? 0 : b;
                    //image[i + 3 * width] = (byte)b;
                    //image[i + 1 + 3 * width] = (byte)g;
                    //image[i + 2 + 3 * width] = (byte)r;

                    ////Pixel(x + 1, y + 1);
                    //b = image[i + 3 * width + 3];
                    //g = image[i + 1 + 3 * width + 3];
                    //r = image[i + 2 + 3 * width + 3];
                    //r = (int)(r + errR * 1 / 16.0);
                    //g = (int)(g + errG * 1 / 16.0);
                    //b = (int)(b + errB * 1 / 16.0);
                    //r = r > 255 ? 255 : r;
                    //g = g > 255 ? 255 : g;
                    //b = b > 255 ? 255 : b;
                    //r = r < 0 ? 0 : r;
                    //g = g < 0 ? 0 : g;
                    //b = b < 0 ? 0 : b;
                    //image[i + 3 * width + 3] = (byte)b;
                    //image[i + 1 + 3 * width + 3] = (byte)g;
                    //image[i + 2 + 3 * width + 3] = (byte)r;

                    i += 3;
                }
                oldB = image[i];
                oldG = image[i + 1];
                oldR = image[i + 2];

                newR = (int)(numberOfBits * oldR / 255) * (255 / numberOfBits);
                newG = (int)(numberOfBits * oldG / 255) * (255 / numberOfBits);
                newB = (int)(numberOfBits * oldB / 255) * (255 / numberOfBits);

                image[i] = (byte)newB;
                image[i + 1] = (byte)newG;
                image[i + 2] = (byte)newR;
                i += 3;
            }
            for (int x = 0; x < width; x++)
            {
                //for y = height-1
                float oldB = image[i];
                float oldG = image[i + 1];
                float oldR = image[i + 2];

                int newR = (int)(numberOfBits * oldR / 255) * (255 / numberOfBits);
                int newG = (int)(numberOfBits * oldG / 255) * (255 / numberOfBits);
                int newB = (int)(numberOfBits * oldB / 255) * (255 / numberOfBits);

                image[i] = (byte)newB;
                image[i + 1] = (byte)newG;
                image[i + 2] = (byte)newR;
                i += 3;
            }
        }
    }
}