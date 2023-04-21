using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace LuaFramework
{
	// Token: 0x02000251 RID: 593
	[AddComponentMenu("UI/Effects/Gradient")]
	public class UguiGradient : BaseMeshEffect
	{
		// Token: 0x060027DD RID: 10205 RVA: 0x00106830 File Offset: 0x00104A30
		public override void ModifyMesh(VertexHelper vh)
		{
			bool flag = !this.IsActive();
			if (!flag)
			{
				List<UIVertex> list = new List<UIVertex>();
				vh.GetUIVertexStream(list);
				this.ModifyVertices(list);
				vh.Clear();
				vh.AddUIVertexTriangleStream(list);
			}
		}

		// Token: 0x060027DE RID: 10206 RVA: 0x00106874 File Offset: 0x00104A74
		public void ModifyVertices(List<UIVertex> vertexList)
		{
			bool flag = !this.IsActive();
			if (!flag)
			{
				int count = vertexList.Count;
				bool flag2 = count > 0;
				if (flag2)
				{
					float num = vertexList[0].position.y;
					float num2 = vertexList[0].position.y;
					for (int i = 1; i < count; i++)
					{
						float y = vertexList[i].position.y;
						bool flag3 = y > num2;
						if (flag3)
						{
							num2 = y;
						}
						else
						{
							bool flag4 = y < num;
							if (flag4)
							{
								num = y;
							}
						}
					}
					float num3 = num2 - num;
					for (int j = 0; j < count; j++)
					{
						UIVertex uivertex = vertexList[j];
						uivertex.color = Color32.Lerp(this.bottomColor, this.topColor, (uivertex.position.y - num) / num3);
						vertexList[j] = uivertex;
					}
				}
			}
		}

		// Token: 0x040005D0 RID: 1488
		public Color topColor = Color.white;

		// Token: 0x040005D1 RID: 1489
		public Color bottomColor = Color.black;
	}
}
