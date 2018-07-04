load 'arch_util.rb'

sel=Sketchup.active_model.selection


def run(e1,e2)
  begin
    e1.intersect(e2)
  rescue
    p "rescue'"
  end
end

t1=Time.now

e1=sel[0]
e2=sel[1]
run(e1,e2)
p "e1=#{e1}, e2=#{e2}"


t2=Time.now
p "run time for genFlrs: #{t2-t1}"

