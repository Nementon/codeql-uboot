/**
* @kind path-problem
*/

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph
 
class NetworkByteSwap extends Expr {
  NetworkByteSwap() {
    exists( MacroInvocation mi | mi.getMacroName().regexpMatch("^ntoh.+") | this = mi.getExpr() )
  }
}
 
class MemcpyLengthArg extends Expr {
  MemcpyLengthArg() {
    exists(
      Call c, Function f | 
      f.getName() = "memcpy" and c = f.getACallToThisFunction() | 
      this = c.getArgument(2)
    )	  
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof NetworkByteSwap
  }
  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() instanceof MemcpyLengthArg
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"