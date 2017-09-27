
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Text;
namespace TAWKI_TCPServer
{
    public class SockBuffer
    {
        public int Size = 20000;
        public byte[] BufferByte;
        public StringBuilder SB = new StringBuilder();

        public string OriginalData;
        public SockBuffer(int s)
        {
            Size = s;
            BufferByte = new byte[Size];
        }

        public string Decode(int byteSize)
        {
            if ((byteSize > 0))
            {
                char[] BufferChar = new char[Size];
                Decoder decoder = Encoding.UTF8.GetDecoder();
                int numChars = decoder.GetCharCount(BufferByte, 0, byteSize);
                decoder.GetChars(BufferByte, 0, byteSize, BufferChar, 0, false);
                StringBuilder msg = new StringBuilder();
                msg.Append(BufferChar, 0, numChars);
                return msg.ToString();
            }
            else
            {
                return "";
            }
        }

        public void Clear()
        {
            BufferByte = new byte[Size];
            OriginalData = "";
        }

        public void Encode(string msg)
        {
            BufferByte = System.Text.Encoding.UTF8.GetBytes(msg);
        }
    }
}

//=======================================================
//Service provided by Telerik (www.telerik.com)
//Conversion powered by NRefactory.
//Twitter: @telerik
//Facebook: facebook.com/telerik
//=======================================================
