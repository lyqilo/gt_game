// 下列 ifdef 块是创建使从 DLL 导出更简单的
// 宏的标准方法。此 DLL 中的所有文件都是用命令行上定义的 CLINKAPI_EXPORTS
// 符号编译的。在使用此 DLL 的
// 任何其他项目上不应定义此符号。这样，源文件中包含此文件的任何其他项目都会将
// CLINKAPI_API 函数视为是从 DLL 导入的，而此 DLL 则将用此宏定义的
// 符号视为是被导出的。
#ifdef CLINKAPI_EXPORTS
#define CLINKAPI_API __declspec(dllexport)
#else
#define CLINKAPI_API __declspec(dllimport)
#endif


/*
设置侦听端口冲突时是否提示(一般不需要调用，默认是 1：提示)如果要调用本函数应在调用clinkStart前先调用
portConflictAlert:侦听端口冲突时是否提示 0：不提示、1：提示
*/
extern "C" CLINKAPI_API void setPortConflictAlert(int portConflictAlert);

/*
启动客户端安全接入组件(只需要调用一次，最好不要重复调用)
key：sdk配置密钥
返回150表示成功，其它的为失败。返回0有可能是网络不通或密钥错误，返回170有可能是实例到期或不存在。如果重复掉用clinkStart()有可能会返回150也可能返回1000，这取决于当时连接的状态，所以最好不要重复调用
*/
extern "C" CLINKAPI_API int clinkStart(const char * key);

/*停止客户端安全接入组件(一般不需要调用) 注意：停止后只有进程重启后才可以再重新调用clinkStart函数，否则就算重新调用了clinkStart应用也无法连接，如果未调用clinkStart就直接调用本函数将会出错*/
extern "C" CLINKAPI_API void clinkStop();