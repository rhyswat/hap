# ----------------------------------------------------------------------
# Add in-repl support for 'include' and 'require_relative'
# which the sonic-pi REPL cannot seem to handle.
class REPLSupport

  @@BASEPATH = File.expand_path(File.dirname(__FILE__))

  # allow 'include' to be called at the class (not instance) level
  def self.inc(mod)
    include mod
  end

  # require the fully-qualified or installed module 'f'
  def self.req_rel(f)
    require File.join(@@BASEPATH, f)
  end
end

# Stub for the module-level function
def require_relative(x)
  REPLSupport.req_rel(x)
end

# Stub for the module-level function
def include(x)
  REPLSupport.inc(x)
end

# END repl-support 
# ----------------------------------------------------------------------
