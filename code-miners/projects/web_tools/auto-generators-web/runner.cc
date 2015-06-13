// runner.cc
using std::cout;
using std::endl;

using test_generator::Sampler;
using test_generator::AjaxRunnerCallback;
using test_generator::CallbackTbl;
using test_generator::AjaxCallbackPair;


CallbackTbl g_callTbl_;

void g_Init() {
	g_callTbl_.insert(AjaxCallbackPair("LOG_ALL", &Sampler::log_all_));
	g_callTbl_.insert(AjaxCallbackPair("GET_BN1", &Sampler::get_bn1_));

}