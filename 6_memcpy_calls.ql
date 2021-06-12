import cpp

from Function f, Call c
where f.getName() = "memcpy" and c = f.getACallToThisFunction()
select c, "Called memcpy functions"
