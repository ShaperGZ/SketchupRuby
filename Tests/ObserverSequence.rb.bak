mod = Sketchup.active_model # Open model
ent = mod.entities # All entities in model
sel = mod.selection # Current selection

class InsObs < Sketchup::InstanceObserver
  def onOpen(instance)
    puts "onOpen: #{instance}"
  end

  def onClose(instance)
    puts "onClose: #{instance}"
  end
end


eob=InsObs.new
ent[0].add_observer(eob)
