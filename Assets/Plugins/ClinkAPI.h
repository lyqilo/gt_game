// ���� ifdef ���Ǵ���ʹ�� DLL �������򵥵�
// ��ı�׼�������� DLL �е������ļ��������������϶���� CLINKAPI_EXPORTS
// ���ű���ġ���ʹ�ô� DLL ��
// �κ�������Ŀ�ϲ�Ӧ����˷��š�������Դ�ļ��а������ļ����κ�������Ŀ���Ὣ
// CLINKAPI_API ������Ϊ�Ǵ� DLL ����ģ����� DLL ���ô˺궨���
// ������Ϊ�Ǳ������ġ�
#ifdef CLINKAPI_EXPORTS
#define CLINKAPI_API __declspec(dllexport)
#else
#define CLINKAPI_API __declspec(dllimport)
#endif


/*
���������˿ڳ�ͻʱ�Ƿ���ʾ(һ�㲻��Ҫ���ã�Ĭ���� 1����ʾ)���Ҫ���ñ�����Ӧ�ڵ���clinkStartǰ�ȵ���
portConflictAlert:�����˿ڳ�ͻʱ�Ƿ���ʾ 0������ʾ��1����ʾ
*/
extern "C" CLINKAPI_API void setPortConflictAlert(int portConflictAlert);

/*
�����ͻ��˰�ȫ�������(ֻ��Ҫ����һ�Σ���ò�Ҫ�ظ�����)
key��sdk������Կ
����150��ʾ�ɹ���������Ϊʧ�ܡ�����0�п��������粻ͨ����Կ���󣬷���170�п�����ʵ�����ڻ򲻴��ڡ�����ظ�����clinkStart()�п��ܻ᷵��150Ҳ���ܷ���1000����ȡ���ڵ�ʱ���ӵ�״̬��������ò�Ҫ�ظ�����
*/
extern "C" CLINKAPI_API int clinkStart(const char * key);

/*ֹͣ�ͻ��˰�ȫ�������(һ�㲻��Ҫ����) ע�⣺ֹͣ��ֻ�н���������ſ��������µ���clinkStart����������������µ�����clinkStartӦ��Ҳ�޷����ӣ����δ����clinkStart��ֱ�ӵ��ñ������������*/
extern "C" CLINKAPI_API void clinkStop();