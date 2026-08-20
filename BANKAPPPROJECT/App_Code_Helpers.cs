using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;

namespace BANKAPPPROJECT
{
    public static class Security
    {
        public static string Hash(string input)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(input ?? ""));
                StringBuilder sb = new StringBuilder();
                foreach (var b in bytes) sb.Append(b.ToString("X2"));
                return sb.ToString();
            }
        }
    }
}