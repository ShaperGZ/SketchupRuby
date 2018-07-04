$m2inch=39.3700787
$m2inchsq=1550.0031
$genName="SCRIPTGENERATEDOBJECTS"


module Testing
  def self.find_edges(face)
    valid_edges=[]
    sorted_vert_pairs=[]
    edges=face.edges

    edges.each{|e|
      v1,v2=_sort_direction(e,face)
      ve=v2.position.vector_to(v1.position).normalize
      ne=ve.cross(Geom::Vector3d.new(0,0,1))
      e.faces.each{|f|
        if f!= face
          if f.normal != ne
            valid_edges << e
            sorted_vert_pairs << [v1,v2]
            break
          end
        end
      }
    }
    return valid_edges,sorted_vert_pairs
  end

  def self.make_parapet(face)
    edges,pairs=find_edges(face)
    pairs.each{|prs|
      _extrude_edge(prs,nil,1.1,)
    }
  end

  def self._extrude_edge(vert_pair,ents,height=1.1)
    height *= $m2inch
    v1=vert_pair[0].position
    v2=vert_pair[1].position
    v3=v2+Geom::Vector3d.new(0,0,height)
    v4=v1+Geom::Vector3d.new(0,0,height)

    ents=Sketchup.active_model.entities if ents == nil
    f = ents.add_face([v1,v2,v3,v4])

  end

  def self._sort_direction(edge,face)
    v1=edge.vertices[0]
    v2=edge.vertices[1]
    i1=face.vertices.index(v1)
    i2=face.vertices.index(v2)
    diff = i2 - i1
    if diff == 1 or diff < -2
      return [v1,v2]
    else
      return [v2,v1]
    end
  end

end
