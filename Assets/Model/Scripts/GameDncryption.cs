using System;
using System.IO;

namespace YooAsset
{
    public class BundleDecryptionServices : IDecryptionServices
    {
        private byte KEY = 28;
        private byte OFFSETKEY = 44;
        public ulong LoadFromFileOffset(DecryptFileInfo fileInfo)
        {
            return OFFSETKEY;
        }

        public byte[] LoadFromMemory(DecryptFileInfo fileInfo)
        {
            string encryptKey = "DGFD";
            byte[] bytes = File.ReadAllBytes(fileInfo.FilePath);
            return AES.AESDecrypt(bytes, encryptKey);
        }

        public FileStream LoadFromStream(DecryptFileInfo fileInfo)
        {
            BundleStream bundleStream = new BundleStream(fileInfo.FilePath, FileMode.Open);
            return bundleStream;
        }

        public uint GetManagedReadBufferSize()
        {
            return 1024;
        }
    }
}