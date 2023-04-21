using System.IO;

namespace YooAsset
{
    public class BundleStream : FileStream
    {
        private byte KEY = 28;
        private byte KEY1 = 67;
        private byte OFFSETKEY = 44;

        public BundleStream(string path, FileMode mode, FileAccess access, FileShare share, int bufferSize,
            bool useAsync) : base(path, mode, access, share, bufferSize, useAsync)
        {
        }

        public BundleStream(string path, FileMode mode) : base(path, mode)
        {
        }

        public override int Read(byte[] array, int offset, int count)
        {
            var index = base.Read(array, offset, count);
            for (int i = 0; i < array.Length; i++)
            {
                array[i] ^= KEY;
            }

            return index;
        }
    }

// 内置文件查询服务类
    public class QueryStreamingAssetsFileServices : IQueryServices
    {
        public bool QueryStreamingAssets(string fileName)
        {
            BetterStreamingAssets.Initialize();
            // 注意：使用了BetterStreamingAssets插件，使用前需要初始化该插件！
            string buildinFolderName = YooAssets.GetStreamingAssetBuildinFolderName();
            return BetterStreamingAssets.FileExists($"{buildinFolderName}/{fileName}");
        }
    }
}
