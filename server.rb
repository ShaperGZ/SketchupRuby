class Server
  @threads=[]
  @server = nil
  @client = nil
  @sender=nil



  def client()
    @client
  end

  def server()
    @server
  end

  def initialize()
    open_port("127.0.0.1", 8088)
    waitClient()
  end

  def kill()
    UI.stop_timer(@sender) if @sender!=nil
    @server.close
  end


  def open_port(ip, port) #pi:"127.0.0.1", port:8088
    @server= TCPServer.open(ip,port)
  end

  def waitClient()
    p 'waiting for connection'
    @client = @server.accept
    p 'client connected, waiter set to nil'
  end

  def autoSend()
    return if @client == nil
    @sender=UI.start_timer(3,true){
      begin
        p 'client='+@client.to_s
        send "time is "+Time.now.to_s
      rescue Exception => e
        p "!Exception: #{e.to_s}"
        p 'conection broken and stop @sender'
        UI.stop_timer(@sender)
      end
    }
  end

  def send(message)
    @client.puts message
  end


end