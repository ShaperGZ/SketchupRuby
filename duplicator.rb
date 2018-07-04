$enableEntsObserver=true

module Dup
  class GpEntsObserver <Sketchup::EntitiesObserver
    def initialize(host)
      @host=host
    end
    def onElementModified(entities, entity)
      if $enableEntsObserver
        p "modified:#{entity}"
        $enableEntsObserver = false
        @host.updateEntity(entity)
        $enableEntsObserver = true
      end
    end
  end

  class GpInstObserver < Sketchup::InstanceObserver
    def initialize(host)
      @host=host
    end
    def onOpen(instance)
      @host.shadow.hidden=false if @host.shadow != nil
    end
    def onClose(instance)
      @host.shadow.hidden=true if @host.shadow != nil
    end
  end

  class Duplicator
    def initialize(gp)
      @entObs=[]
      @entsObs=[]
      @gp=gp
      @shadow=nil
      add_entsObserver(GpEntsObserver.new(self))
      add_entObserver(GpInstObserver.new(self))
    end

    def gp
      @gp
    end

    def entsObs
      @entObs
    end

    def entObs
      @entObs
    end

    def shadow()
      @shadow
    end

    def updateEntity(entity)
      p "Dup::Duplicator.update entity:#{entity}"
      updateShadow()
    end
    def updateEntities(entities)

    end
    def updateShadow()
      @shadow.erase! if @shadow != nil
      @shadow=@gp.copy
      vector = Geom::Vector3d.new(0, 250, 0)
      tr = Geom::Transformation.translation(vector)
      @shadow.transform! tr
    end
    def add_entObserver(observer)
      obs=@gp.add_observer(observer)
      @entObs<<observer
    end
    def add_entsObserver(observer)

      obs=@gp.entities.add_observer(observer)
      @entsObs<<observer
    end
  end

end