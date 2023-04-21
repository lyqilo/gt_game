// dnSpy decompiler from Assembly-CSharp.dll class: Yielders
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions.Comparers;

public static class Yielders
{
	public static WaitForEndOfFrame EndOfFrame
	{
		get
		{
			Yielders._internalCounter++;
			return (!Yielders.Enabled) ? new WaitForEndOfFrame() : Yielders._endOfFrame;
		}
	}

	public static WaitForFixedUpdate FixedUpdate
	{
		get
		{
			Yielders._internalCounter++;
			return (!Yielders.Enabled) ? new WaitForFixedUpdate() : Yielders._fixedUpdate;
		}
	}

	public static WaitForSeconds GetWaitForSeconds(float seconds)
	{
		Yielders._internalCounter++;
		if (!Yielders.Enabled)
		{
			return new WaitForSeconds(seconds);
		}
		WaitForSeconds result;
		if (!Yielders._waitForSecondsYielders.TryGetValue(seconds, out result))
		{
			Yielders._waitForSecondsYielders.Add(seconds, result = new WaitForSeconds(seconds));
		}
		return result;
	}

	public static WaitForSeconds GetWaitForSeconds(int seconds)
	{
		Yielders._internalCounter++;
		if (!Yielders.Enabled)
		{
			return new WaitForSeconds((float)seconds);
		}
		WaitForSeconds result;
		if (!Yielders._waitForSecondsYielders_int.TryGetValue(seconds, out result))
		{
			Yielders._waitForSecondsYielders_int.Add(seconds, result = new WaitForSeconds((float)seconds));
		}
		return result;
	}

	public static void ClearWaitForSeconds()
	{
		Yielders._waitForSecondsYielders.Clear();
		Yielders._waitForSecondsYielders_int.Clear();
	}

	public static bool Enabled = true;

	public static int _internalCounter;

	private static WaitForEndOfFrame _endOfFrame = new WaitForEndOfFrame();

	private static WaitForFixedUpdate _fixedUpdate = new WaitForFixedUpdate();

	private static Dictionary<float, WaitForSeconds> _waitForSecondsYielders = new Dictionary<float, WaitForSeconds>(100, new FloatComparer());

	private static Dictionary<int, WaitForSeconds> _waitForSecondsYielders_int = new Dictionary<int, WaitForSeconds>(100);
}
