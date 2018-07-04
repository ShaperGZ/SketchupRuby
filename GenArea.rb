#英寸转米 系数
$convertion=39.3700787
$convertionSQ=1550.0031
$genName="SCRIPTGENERATEDOBJECTS"
$enableOnEntityAdded = true


module Arch
  class AreaUpdater
    def initialize()
      @cuts=nil
    end

    def invalidate(entity,ftfh=3)

      removeCuts()
      return if entity == nil or entity.deleted?
      floors = cutFloor(entity,ftfh)
      floors.name='flr'
      @cuts=floors.intersect(entity.copy)
      if @cuts == nil
        #floors.erase!
        return
      elsif @cuts.entities.size == 0
        @cuts.erase!
        return
      end
      @cuts.name='cuts'

      ttArea=calAreas(@cuts)
      p "area=#{ttArea}"

    end

    # subject:组
    # ftfh:层高
    # foffset=0.6:一般面积是从离地600mm开始算
    def cutFloor(subject ,ftfh, foffset=1)

      modelEnts=Sketchup.active_model.entities
      cutter=modelEnts.add_group
      cutEnts=cutter.entities
      cutTrans=cutter.transformation
      #p subject.class
      subjectBound=subject.bounds
      subjectH = (subjectBound.max.z - subjectBound.min.z)
      #p "(", subjectH
      subjectH =  subjectH / $m2inch
      #p subjectH, ")"

      flrCount = (subjectH / ftfh).floor

      #按逆时针顺序提取boundingbox底部的四个点
      basePts=[
        subjectBound.corner(0)+(subjectBound.corner(0)-subjectBound.corner(3)),
        subjectBound.corner(1)+(subjectBound.corner(1)-subjectBound.corner(2)),
        subjectBound.corner(3)+(subjectBound.corner(3)-subjectBound.corner(0)),
        subjectBound.corner(2)+(subjectBound.corner(2)-subjectBound.corner(1))
        ]

      for i in 0..flrCount
        if basePts[0].z<subjectBound.max.z and (basePts[0].z+(1* $m2inch))<subjectBound.max.z
          f=cutter.entities.add_face(basePts)
          #sketchup 会把在0高度的面自动向下，所以要反过来
          f.reverse! if basePts[0].z==0
          ext=f.pushpull(foffset* $m2inch)
          basePts.each{|p| p.z=p.z+(ftfh * $m2inch )}
        end
      end

      return cutter
    end

    def intersectFloors(subject,floors)
      #modelEnts=Sketchup.active_model.entities
      dup=subject.copy
      dup.name='itsflr.dup'
      p "dup= #{dup},cuts= #{floors}"
      cuts=floors.intersect(dup)
      if cuts==nil
        dup.erase!
        floors.erase!
      end
      return cuts
    end

    def calAreas(cuts)
      ttArea=0
      cuts.entities.each{|e| ttArea += e.area if e.class == Sketchup::Face and e.normal.z==1 }
      ttArea = ttArea / $m2inchsq
      return ttArea
    end

    def removeCuts()
      return if @cuts == nil or @cuts.deleted?
      @cuts.locked=false
      @cuts.erase!
      @cuts.nil
    end
  end
end

 


