using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlgFloydSteinberg
{
    public abstract class Alghoritm
    {
        public abstract void ConvertImage(ref byte[] array, int numberOfBits, int width, int height);
    }
}