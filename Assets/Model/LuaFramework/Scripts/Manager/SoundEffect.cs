using UnityEngine;

namespace LuaFramework
{
    public class SoundEffect : MonoBehaviour
    {
        [SerializeField]
        private AudioSource m_AudioSource;

        private float m_effectVolume;

        private bool m_effectSwitch;

        private float m_playTime;

        private bool m_isPlay;

        public float EffectVolume
        {
            set
            {
                m_effectVolume = value;
                m_AudioSource.volume = m_effectVolume;
            }
            get { return m_effectVolume; }
        }

        public bool EffectSwitch
        {
            set
            {
                m_effectSwitch = value;
                m_AudioSource.mute = !m_effectSwitch;
            }
            get { return m_effectSwitch; }
        }

        public float PlayTime { get { return m_playTime; } }
        public void Play(AudioClip clip,Vector3 pos,Transform parent = null)
        {
            transform.SetParent(parent);
            transform.localPosition = pos;
            m_AudioSource.clip = clip;
            m_playTime = clip.length;
            m_AudioSource.Play();
        }

        public void Release()
        {
            m_AudioSource.Stop();
            m_AudioSource.clip = null;
            gameObject.Release();
        }

        void Update()
        {
            if (m_playTime > 0)
            {
                m_playTime -= Time.deltaTime;
                if (m_playTime < 0)
                {
                    Release();
                }
            }
        }

    }

}
