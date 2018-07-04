

def setApt()
  sel=Sketchup.active_model.selection
  sel.each{|e| printe(e) }
  def printe(entity)
    p entity.guid
  end
end