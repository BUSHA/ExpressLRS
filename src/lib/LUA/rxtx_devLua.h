#pragma once

#include "common.h"
#include "device.h"
#include "lua.h"
#include "config.h"
#include "POWERMGNT.h"

#ifdef MAFIA_FRQ

#if defined(RADIO_SX128X)
#define DOMAIN_STRING "ISM2G4;M-2.1;M-2.2;M-2.3;M-2.5;M-2.6"
#else
#define DOMAIN_STRING "AU915;FCC915;EU868;IN866;AU433;EU433;US433;US433W;M-433;M-485;M-500;M-730;M-750;M-780;M-800;M-830;M-960;M-1000;P-750;P-960;S-730-830;S-830-930;S-900-1000;V-735;V-750"
// #elif defined(RADIO_LR1121)
// #define DOMAIN_STRING "ISM-2.4;M-2.2;M-2.6"
#endif

#endif


// Common functions
void luadevGeneratePowerOpts(luaItem_selection *luaPower);

// Common Lua storage (mutable)
extern char strPowerLevels[];

// Common Lua storate (constant)
extern const char STR_EMPTYSPACE[];
extern const char STR_LUA_PACKETRATES[];
