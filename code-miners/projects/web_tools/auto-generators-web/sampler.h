#ifndef AUTO_GENERATORS_WEB_SAMPLER_H_
#define AUTO_GENERATORS_WEB_SAMPLER_H_

// C

// C++
#include <string>
#include <map>

// Other

// https://bitbucket.org/gangsofmart/tmitter-web-service-win/src/66b3a20e03c2bf73dda5170661c3ed4af1783c6b/sln/tests_service/tests_service.cpp?at=master
// App

namespace test_generator {
class Sampler;
typedef std::string LocalStr;
typedef LocalStr (Sampler::*AjaxRunnerCallback) (LocalStr) ;
typedef std::pair<LocalStr, AjaxRunnerCallback> AjaxCallbackPair; 
typedef std::map<LocalStr, AjaxRunnerCallback> CallbackTbl;

class Sampler {
 public:
  LocalStr log_all_(LocalStr rw);
  LocalStr get_bn1_(LocalStr rw);

};

}
#endif  // AUTO_GENERATORS_WEB_SAMPLER_H_
