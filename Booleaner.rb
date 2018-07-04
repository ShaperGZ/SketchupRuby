# Default code, use or delete...
mod = Sketchup.active_model # Open model
ent = mod.entities # All entities in model
sel = mod.selection # Current selection



class GpInstanceObserver < Sketchup::InstanceObserver
  def initialize(modular)
      @@host=modular
  end
  def onOpen(instance)
    puts "onOpen: #{instance}"
  end

  def onClose(instance)
    @@host.makeComposit()
  end
end

class MassingMaster
  def initialize(gp)
    @gp=gp
    @composit=Sketchup.active_model.entities.add_group
    gp.add_observer(GpInstanceObserver.new(self))
  end
  
  def makeComposit()
    gpEnts=@gp.entities
    gpsU=[] #possitive
    gpsS=[] #negative
    for i in 0..gpEnts.size
      if gpEnts[i].class == Sketchup::Group
        if gpEnts[i].name!='sub'
          gpsU<<gpEnts[i]
        else 
          gpsS<<gpEnts[i]
        end
      end#if
    end#for
    p "gpsU.size=#{gpsU.size}"
    @composit.erase! if @composit!=nil
    
    possitive=joinObjects(gpsU)
    negative=joinObjects(gpsU)
    composit=nil
    if negative !=nil
      composit=negative.subtract(possitive)
    else
      composit=possitive
    end
    @composit=Sketchup.active_model.entities.add_group composit
    @composit.transform! Geom::Transformation.new(Geom::Point3d.new(0,0,0))
  end
  
  def joinObjects(gps)
    return nil if gps==nil or gps.size==0
    return gps[0].copy if gps.size<2
    e0=gps[0].copy
    for i in 1..gps.size-1
      e1=gps[i].copy
      e0=e0.union e1
    end
    return e0
  end
end
