#include <boost/shared_ptr.hpp>

#include <auto-generators-web/sampler.h>

//#include <auto-generators-web/sampler.cc>
//#include <auto-generators-web/runner.cc>


/*// sampler.cc
namespace test_generator {
LocalStr Sampler::log_all_(LocalStr rw) {
  return "log_all";
}
LocalStr Sampler::get_bn1_(LocalStr rw) {
  return "get_bn1";
}
}
*/


/*// runner.cc
using std::cout;
using std::endl;

using test_generator::Sampler;
using test_generator::AjaxRunnerCallback;
using test_generator::CallbackTbl;
using test_generator::AjaxCallbackPair;
using boost::shared_ptr;

CallbackTbl g_callTbl_;

void g_Init() {
	g_callTbl_.insert(AjaxCallbackPair("LOG_ALL", &Sampler::log_all_));
	g_callTbl_.insert(AjaxCallbackPair("GET_BN1", &Sampler::get_bn1_));

}
*/
using boost::shared_ptr;
int main() {

	//Sampler* pSampler = new Sampler();

	shared_ptr<Sampler> pSampler(new Sampler());

	// Init
	g_Init();

	CallbackTbl::iterator it = g_callTbl_.find("LOG_ALL");

	if (it != g_callTbl_.end())
	  cout << ((*pSampler).*(g_callTbl_["LOG_ALL"]))("LOG_ALL") << "\n";

	//delete pSampler;
	return 0;

}
