using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ParticleUIMask : Mask {

    List<Renderer> list = new List<Renderer>();
    /// <summary>
    /// 剪裁区域
    /// </summary>
    [SerializeField] Vector4 corners;


    protected override void Start()
    {
        base.Start();
        UpdateCorners();
        if (Application.isPlaying) {
            list.AddRange(GetComponentsInChildren<Renderer>());
            SetMask();
        }
    }

    /// <summary>
    /// 设置遮罩
    /// </summary>
    /// <param name="mask"></param>
    public void SetMask()
    {
        Material material = null;
        for (int i = 0; i < list.Count; i++)
        {
            material = list[i].material;
            material.SetFloat("_MinX", corners.x);
            material.SetFloat("_MinY", corners.y);
            material.SetFloat("_MaxX", corners.z);
            material.SetFloat("_MaxY", corners.w);
        }
    }

    protected override void OnRectTransformDimensionsChange()
    {
        base.OnRectTransformDimensionsChange();
        UpdateCorners();
        if (Application.isPlaying)
        {
            SetMask();
        }
    }

    /// <summary>
    /// 更新Corners
    /// </summary>
    void UpdateCorners()
    {
        Vector3[] tmpCorners = new Vector3[4];
        corners = Vector4.one;
        RectTransform rectTransform = transform as RectTransform;
        rectTransform.GetWorldCorners(tmpCorners);
        corners.x = tmpCorners[0].x;
        corners.y = tmpCorners[0].y;
        corners.z = tmpCorners[2].x;
        corners.w = tmpCorners[2].y;
    }

}
