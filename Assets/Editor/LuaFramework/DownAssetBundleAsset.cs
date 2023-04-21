using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using System.IO;
using System;
using UnityEngine.SceneManagement;

public class DownAssetBundleAsset : Editor
{
    [MenuItem("Tools/GetAsset")]
    static void DownAsset()
    {
        AssetBundle.UnloadAllAssetBundles(true);
        string path = Application.dataPath + "/Res";
        Stream str = null;
        UnityEngine.Object[] selects = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        int count = 0;
        for (int i = 0; i < selects.Length; i++)
        {
            DebugTool.LogError(Path.GetExtension(AssetDatabase.GetAssetPath(selects[i])));
            DebugTool.Log(AssetDatabase.GetAssetPath(selects[i]));
            if (Path.GetExtension(AssetDatabase.GetAssetPath(selects[i])) != ".unity3d") continue;
            AssetBundle asset = AssetBundle.LoadFromFile(AssetDatabase.GetAssetPath(selects[i]));
            if (asset == null) continue;
            DebugTool.LogError(asset == null);
            DebugTool.LogError(asset.name);
            SceneManager.LoadScene(asset.name);

            continue;
            var a = asset.LoadAllAssets();
            for (int j = 0; j < a.Length; j++)
            {
                DebugTool.LogError(a[j].name);
                SceneManager.LoadScene(a[j].name);
                //                 DebugTool.LogError(a[j].GetType());
                //                 GameObject go = a[j] as GameObject;
                //                 if (go != null)
                //                 {
                //                     Instantiate<GameObject>(go);
                //                     continue;
                //                 }
                //                 continue;
                //                 Texture2D texture = a[j] as Texture2D;
                //                 if (texture != null)
                //                 {
                //                     if (!Directory.Exists(path + "/Image"))
                //                     {
                //                         Directory.CreateDirectory(path + "/Image");
                //                     }
                //                     File.WriteAllBytes(path + "/Image/" + texture.name + ".png", texture.EncodeToPNG());
                // #if UNITY_EDITOR
                //                     AssetDatabase.Refresh();
                // #endif
                //                     continue;
                //                 }
                //                 AudioClip audioClip = a[j] as AudioClip;
                //                 if (audioClip != null)
                //                 {
                //                     Save(audioClip, path + "/Audio/" + audioClip.name + ".mp3");
                // #if UNITY_EDITOR
                //                     AssetDatabase.Refresh();
                // #endif
                //                     continue;
                //                 }
                //                 //                Sprite _sprite = a[j] as Sprite;
                //                 //                Sprite sprite = _sprite;
                //                 //                if (sprite != null)
                //                 //                {
                //                 //                    if (!Directory.Exists(path + "/Resources/Sprite"))
                //                 //                    {
                //                 //                        Directory.CreateDirectory(path + "/Resources/Sprite");
                //                 //                    }
                //                 //                    Texture2D tex = new Texture2D((int)sprite.rect.width, (int)sprite.rect.height, sprite.texture.format, false);

                //                 //                    var pixels = sprite.texture.GetPixels32();
                //                 //                    DebugHelper.LogError(pixels);
                //                 //                    tex.SetPixels32(pixels);
                //                 //                    tex.Apply();
                //                 //                    count++;
                //                 //                    DebugHelper.LogError(tex.name);
                //                 //                    File.WriteAllBytes(path + "/Sprite/tex_" + count + ".png", tex.EncodeToPNG());
                //                 //#if UNITY_EDITOR
                //                 //                    AssetDatabase.Refresh();
                //                 //#endif
                //                 //                }
                //                 TextAsset textAsset = a[j] as TextAsset;
                //                 if (textAsset != null)
                //                 {
                //                     if (!Directory.Exists(path + "/Text"))
                //                     {
                //                         Directory.CreateDirectory(path + "/Text");
                //                     }
                //                     File.WriteAllBytes(path + "/Text/" + textAsset.name + ".bytes", textAsset.bytes);
                // #if UNITY_EDITOR
                //                     AssetDatabase.Refresh();
                // #endif
                //                 }
            }
            asset.Unload(false);
        }
    }

    public static void Save(AudioClip clip, string path)
    {
        string filePath = Path.GetDirectoryName(path);
        if (!Directory.Exists(filePath))
        {
            Directory.CreateDirectory(filePath);
        }
        using (FileStream fileStream = CreateEmpty(path))
        {
            ConvertAndWrite(fileStream, clip);
            WriteHeader(fileStream, clip);
        }
    }

    private static void ConvertAndWrite(FileStream fileStream, AudioClip clip)
    {

        float[] samples = new float[clip.samples];

        clip.GetData(samples, 0);

        System.Int16[] intData = new System.Int16[samples.Length];

        System.Byte[] bytesData = new Byte[samples.Length * 2];

        int rescaleFactor = 32767; //to convert float to Int16  

        for (int i = 0; i < samples.Length; i++)
        {
            intData[i] = (short)(samples[i] * rescaleFactor);
            Byte[] byteArr = new Byte[2];
            byteArr = BitConverter.GetBytes(intData[i]);
            byteArr.CopyTo(bytesData, i * 2);
        }
        fileStream.Write(bytesData, 0, bytesData.Length);
    }

    private static FileStream CreateEmpty(string filepath)
    {
        FileStream fileStream = new FileStream(filepath, FileMode.Create);
        byte emptyByte = new byte();

        for (int i = 0; i < 44; i++) //preparing the header  
        {
            fileStream.WriteByte(emptyByte);
        }

        return fileStream;
    }
    private static void WriteHeader(FileStream stream, AudioClip clip)
    {
        int hz = clip.frequency;
        int channels = clip.channels;
        int samples = clip.samples;

        stream.Seek(0, SeekOrigin.Begin);

        Byte[] riff = System.Text.Encoding.UTF8.GetBytes("RIFF");
        stream.Write(riff, 0, 4);

        Byte[] chunkSize = BitConverter.GetBytes(stream.Length - 8);
        stream.Write(chunkSize, 0, 4);

        Byte[] wave = System.Text.Encoding.UTF8.GetBytes("WAVE");
        stream.Write(wave, 0, 4);

        Byte[] fmt = System.Text.Encoding.UTF8.GetBytes("fmt ");
        stream.Write(fmt, 0, 4);

        Byte[] subChunk1 = BitConverter.GetBytes(16);
        stream.Write(subChunk1, 0, 4);

        UInt16 two = 2;
        UInt16 one = 1;

        Byte[] audioFormat = BitConverter.GetBytes(one);
        stream.Write(audioFormat, 0, 2);

        Byte[] numChannels = BitConverter.GetBytes(channels);
        stream.Write(numChannels, 0, 2);

        Byte[] sampleRate = BitConverter.GetBytes(hz);
        stream.Write(sampleRate, 0, 4);

        Byte[] byteRate = BitConverter.GetBytes(hz * channels * 2); // sampleRate * bytesPerSample*number of channels, here 44100*2*2  
        stream.Write(byteRate, 0, 4);

        UInt16 blockAlign = (ushort)(channels * 2);
        stream.Write(BitConverter.GetBytes(blockAlign), 0, 2);

        UInt16 bps = 16;
        Byte[] bitsPerSample = BitConverter.GetBytes(bps);
        stream.Write(bitsPerSample, 0, 2);

        Byte[] datastring = System.Text.Encoding.UTF8.GetBytes("data");
        stream.Write(datastring, 0, 4);

        Byte[] subChunk2 = BitConverter.GetBytes(samples * channels * 2);
        stream.Write(subChunk2, 0, 4);

    }
}
