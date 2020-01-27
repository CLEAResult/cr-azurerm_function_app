# cr-azurerm_function_app

This module is under development.  As a result, there is no automated testing and there are limitations to the modules (see below).

*Please only use this module for production resources if you are internal to CLEAResult and have discussed with the SRE team.*

## Limitations
Right now, the cr-azurerm_function_app module supports one function app per plan.  As a result, please be sure your count/num is set to '1'.  This will be fixed prior to a production release of the module.