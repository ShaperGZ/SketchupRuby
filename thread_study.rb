$counter=0
Threads=[]

def printer()
  p $counter+=1
end

Threads << Thread.new{
  printer
  time.sleep(2)
}
Threads.each { |thr| thr.join }