
// branch: access_settings
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_access_settings() {
  var correct = false;

  // checker
  var check_tconfirmation_pass = function(value) {
    return true;
  }
  correct = check_tconfirmation_pass(document.getElementById("tconfirmation_pass").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_pass = function(value) {
    return true;
  }
  correct = check_tcurrent_pass(document.getElementById("tcurrent_pass").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tnew_pass = function(value) {
    return true;
  }
  correct = check_tnew_pass(document.getElementById("tnew_pass").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_access_settings

// branch: snmp_settings
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_snmp_settings() {
  var correct = false;

  // checker
  var check_tip_accessed_0 = function(value) {
    return true;
  }
  correct = check_tip_accessed_0(document.getElementById("tip_accessed_0").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tip_accessed_1 = function(value) {
    return true;
  }
  correct = check_tip_accessed_1(document.getElementById("tip_accessed_1").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tsnmp_port_in = function(value) {
    return true;
  }
  correct = check_tsnmp_port_in(document.getElementById("tsnmp_port_in").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_snmp_settings

// branch: network_adaptor_system
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_network_adaptor_system() {
  var correct = false;

  // checker
  var check_tset_dns_prim = function(value) {
    return true;
  }
  correct = check_tset_dns_prim(document.getElementById("tset_dns_prim").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_gw = function(value) {
    return true;
  }
  correct = check_tcurrent_gw(document.getElementById("tcurrent_gw").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_ip = function(value) {
    return true;
  }
  correct = check_tcurrent_ip(document.getElementById("tcurrent_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tset_mask = function(value) {
    return true;
  }
  correct = check_tset_mask(document.getElementById("tset_mask").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tset_dns_second = function(value) {
    return true;
  }
  correct = check_tset_dns_second(document.getElementById("tset_dns_second").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_dns_ip = function(value) {
    return true;
  }
  correct = check_tcurrent_dns_ip(document.getElementById("tcurrent_dns_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_mask = function(value) {
    return true;
  }
  correct = check_tcurrent_mask(document.getElementById("tcurrent_mask").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_auto_dns = function(value) {
    return true;
  }
  correct = check_tcurrent_auto_dns(document.getElementById("tcurrent_auto_dns").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tcurrent_dhcp = function(value) {
    return true;
  }
  correct = check_tcurrent_dhcp(document.getElementById("tcurrent_dhcp").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tset_ip = function(value) {
    return true;
  }
  correct = check_tset_ip(document.getElementById("tset_ip").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_network_adaptor_system

// branch: settings_mon_system
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_settings_mon_system() {
  var correct = false;

  // checker
  var check_tfrw_low = function(value) {
    return true;
  }
  correct = check_tfrw_low(document.getElementById("tfrw_low").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tdevice_id_snmp = function(value) {
    return true;
  }
  correct = check_tdevice_id_snmp(document.getElementById("tdevice_id_snmp").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tdevice_type_snmp = function(value) {
    return true;
  }
  correct = check_tdevice_type_snmp(document.getElementById("tdevice_type_snmp").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tfrw_high = function(value) {
    return true;
  }
  correct = check_tfrw_high(document.getElementById("tfrw_high").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_trs_addr = function(value) {
    return true;
  }
  correct = check_trs_addr(document.getElementById("trs_addr").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tterm_low = function(value) {
    return true;
  }
  correct = check_tterm_low(document.getElementById("tterm_low").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tpower_high = function(value) {
    return true;
  }
  correct = check_tpower_high(document.getElementById("tpower_high").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tchannal_idx = function(value) {
    return true;
  }
  correct = check_tchannal_idx(document.getElementById("tchannal_idx").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tpower_low = function(value) {
    return true;
  }
  correct = check_tpower_low(document.getElementById("tpower_low").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tterm_high = function(value) {
    return true;
  }
  correct = check_tterm_high(document.getElementById("tterm_high").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tperiod_snmp = function(value) {
    return true;
  }
  correct = check_tperiod_snmp(document.getElementById("tperiod_snmp").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_settings_mon_system

// branch: coupled_sys_settings
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_coupled_sys_settings() {
  var correct = false;

  // checker
  var check_tetv1_port = function(value) {
    return true;
  }
  correct = check_tetv1_port(document.getElementById("tetv1_port").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tetv2_port = function(value) {
    return true;
  }
  correct = check_tetv2_port(document.getElementById("tetv2_port").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tetv2_ip = function(value) {
    return true;
  }
  correct = check_tetv2_ip(document.getElementById("tetv2_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_textern_ip = function(value) {
    return true;
  }
  correct = check_textern_ip(document.getElementById("textern_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_textern_port = function(value) {
    return true;
  }
  correct = check_textern_port(document.getElementById("textern_port").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tetv1_ip = function(value) {
    return true;
  }
  correct = check_tetv1_ip(document.getElementById("tetv1_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tsnmp_mgr_ip = function(value) {
    return true;
  }
  correct = check_tsnmp_mgr_ip(document.getElementById("tsnmp_mgr_ip").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tsnmp_mgr_port = function(value) {
    return true;
  }
  correct = check_tsnmp_mgr_port(document.getElementById("tsnmp_mgr_port").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_coupled_sys_settings

// branch: marker_need_delete
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_marker_need_delete() {
  var correct = false;
  return "";
}  // function check_marker_need_delete

// branch: light_settings
// Auto generate by: D:\home\lugansky-igor\tmitter-web-service-win\scripts\id_extractor.py
function check_light_settings() {
  var correct = false;

  // checker
  var check_tinf0 = function(value) {
    return true;
  }
  correct = check_tinf0(document.getElementById("tinf0").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_tinf1 = function(value) {
    return true;
  }
  correct = check_tinf1(document.getElementById("tinf1").value);
  if (!correct) {
    return "msg";
  }

  // checker
  var check_ttimestamp = function(value) {
    return true;
  }
  correct = check_ttimestamp(document.getElementById("ttimestamp").value);
  if (!correct) {
    return "msg";
  }
  return "";
}  // function check_light_settings