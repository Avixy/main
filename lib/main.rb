require 'funky-simplehttp'

class Main < Device  
  include Device::Helper

  RET_OK            = 0

  def self.call
    Cloudwalk.boot
    Device::Display.clear

    Device.app_loop do
      time = Time.now
      # Device::Display.print_bitmap("./shared/walk.bmp",0,0)
      # Device::Display.print("#{rjust(time.day.to_s, 2, "0")}/#{rjust(time.month.to_s, 2, "0")}/#{time.year} #{rjust(time.hour.to_s, 2, "0")}:#{rjust(time.min.to_s, 2, "0")}", 6, 0)

      # menu
      Device::Display.print("-Press F1 to Admin Cfg",2,0)
      Device::Display.print("-Press F2 to unload app",3,0)
      Device::Display.print("-Press 1 to test printer",4,0)
      Device::Display.print("-Press 2 to test ethernet",5,0)
      Device::Display.print("-Press 3 to test wifi",6,0)

      case getc(2000)
      when Device::IO::ENTER
        Cloudwalk.start
      when Device::IO::F1
        AdminConfiguration.perform
      when Device::IO::F2
        break
      when Device::IO::ONE_NUMBER          
        if Device::Printer.paper?
          Device::Printer.print_line("Printer test going on")
        else
          Device::Display.clear
          Device::Display.print("Out of paper",5,0)
          getc(5000)
        end      
      when Device::IO::TWO_NUMBER        
        p "========>>>> da phuck: #{Device::Network::Ethernet._connected?}"
        if Device::Network::Ethernet._connected? == RET_OK
          # if Device::Network.ethernet?
            media = Device::Network.config[0]
            p "===>>> Network already connected. Media: #{media}"
            Device::Display.clear
            
            unless media.empty?
              Device::Display.print("Connected using #{media}",5,0)
              key = getc
            else
              Device::Display.print("Connected using unknown",5,0)
              key = getc
            end
          # else
            # Device::Display.clear          
            # Device::Display.print("Connected but its not eth",5,0)              
            # key = getc  
          # end
        else
          Device::Display.clear          
          Device::Display.print("Press key to configure ethernet")
          key = getc
        end
      when Device::IO::THREE_NUMBER
        if Device::Network.connected? # está retornando verdadeiro mesmo sem configurar nda
          # if Device::Network.wifi?
            media = Device::Network.config[0]
            p "===>>> Network already connected. Media: #{media}"
            Device::Display.clear
            
            unless media.empty?
              Device::Display.print("Connected using #{media}",5,0)
              key = getc
            else
              Device::Display.print("Connected using unknown",5,0)
              key = getc
            end
          # else
            # Device::Display.clear          
            # Device::Display.print("Connected but its not eth",5,0)              
            # key = getc  
          # end
        else
          Device::Display.clear          
          Device::Display.print("Press key to configure wifi")
          key = getc
        end
      end
    end
  end

  def self.version
    "1.0.3"
  end
end

