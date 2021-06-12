import cpp

from MacroAccess ma, MacroInvocation mi
where 
  ma.getMacroName() in ["ntohs", "ntohl", "ntohll"] or
  mi.getMacroName() in ["ntohs", "ntohl", "ntohll"]
select ma, "a ntoh* macros' invokation"