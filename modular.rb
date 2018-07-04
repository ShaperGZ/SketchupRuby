# Default code, use or delete...
mod = Sketchup.active_model # Open model
ent = mod.entities # All entities in model
sel = mod.selection # Current selection

$enableEntsObserver=true

class GpEntsObserver <Sketchup::EntitiesObserver
  def initialize(modular)
    host=modular
  end
  def onElementModified(entities, entity)
    if $enableEntsObserver
      p "modified:#{entity}"
      $enableEntsObserver = false
      host.adjFace(entity)
      $enableEntsObserver = true
    end
  end
end


class GpInstanceObserver < Sketchup::InstanceObserver
  def initialize(modular)
      host=modular
  end

  def onOpen(instance)
    puts "onOpen: #{instance}"
  end

  def onClose(instance)
    host.adjFaces(instance.entities)
  end
end


class Modular
  def initialize(gp)
    @@gp=gp
    @@ftfh=3
    @@width=1.5
    @entObservers=[]
    @entsObservers=[]
    add_entsObserver(GpEntsObserver.new(self))
    #add_observer(GpInstanceObserver.new(self))
    adjFaces(gp.entities)
  end

  def add_observer(observer)
    obs=@@gp.add_observer(observer)
    @entObservers<<obs
  end
  def add_entsObserver(observer)
    obs=@@gp.entities.add_observer(observer)
    @entsObservers<<obs
  end

  def adjFace(entity)
    e=entity
    if e.class == Sketchup::Face
      pt_array = []
      pt_array[0] = Geom::Point3d.new(3,0,0)
      pt_array[1] = Geom::Point3d.new(0,0,0)
      e.position_material(e.material, pt_array, true)
      if e.normal.z==1
        fixFaceZ(e)
      elsif e.normal.x.abs==1.0
        fixFaceX(e)
      elsif e.normal.y.abs==1.0
        fixFaceY(e)
      end
    end #end if
  end


  def adjFaces(entities)
    entsZ=[]
    entsX=[]
    entsY=[]
    for i in 0..entities.size
      e=entities[i]
      
      if e.class == Sketchup::Face
        pt_array = []
        pt_array[0] = Geom::Point3d.new(3,0,0)
        pt_array[1] = Geom::Point3d.new(0,0,0)
        e.position_material(e.material, pt_array, true) 
        entsZ<<e if e.normal.z==1 
        entsX<<e if e.normal.x.abs==1.0
        entsY<<e if e.normal.y.abs==1.0
      end
    end
    
    for i in 0..entsX.size
      fixFaceX(entsX[i])
    end
    for i in 0..entsY.size
      fixFaceY(entsY[i])
    end
    for i in 0..entsZ.size
      fixFaceZ(entsZ[i])
    end
  end
  
  def fixFaceZ(entity)
    return if entity.class != Sketchup::Face
    if entity.normal.z == 1
      p entity
      zv = entity.vertices[0].position.z
      zv = zv / 39.37
      ftfh=@@ftfh
      remain=zv%ftfh
      if remain >= (ftfh / 2)
        remain=ftfh-remain 
      else
        remain = -remain 
      end
      p "zv=#{zv} remain=#{remain} newh=#{zv+remain}"

      entity.pushpull(remain*39.37)

    end
  end
  def fixFaceX(entity)
    return if entity.class != Sketchup::Face
    if entity.normal.x.abs == 1
      sign=entity.normal.x
      p entity
      xv = entity.vertices[0].position.x
      xv = xv / 39.37
      mod=@@width
      remain=xv%mod
      if remain >= (mod / 2)
        remain=mod-remain 
      else
        remain = -remain 
      end

      entity.pushpull(remain*39.37*sign)
    end
  end
  def fixFaceY(entity)
    return if entity.class != Sketchup::Face
    if entity.normal.y.abs == 1
      sign=entity.normal.y
      p entity
      yv = entity.vertices[0].position.y
      yv = yv / 39.37
     mod=@@width
      remain=yv%mod
      if remain >= (mod / 2)
        remain=mod-remain 
      else
        remain = -remain 
      end

      entity.pushpull(remain*39.37*sign)
    end
  end
  
end

 
