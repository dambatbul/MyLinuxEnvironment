#!/usr/bin/env ruby

print "URL: http://www.websequencediagrams.com/\n"

keys = ["SERVER_ROLE","METHOD_NAME","DIRECTION","From","To"]
headers = {}

sip_mode = false
pre_header = nil
line_n = 0

File.open(ARGV[0],"r"){|file|
  file.each_line do |line|
    line_n += 1
    if sip_mode == false
      line.sub(/^[ ]*([\w_]+)[ ]*=[ ]*([\w\-\:\@. ]+\w+)[ ]*\r?$/){
        if $1 == "SIP_MSG"
          sip_mode = true
        elsif keys.member?($1)
          headers[$1] = $2
        end}
    else
      new_line = true
      if pre_header != nil
        line.sub(/^       (.*)$/){
          pre = headers[pre_header]
          headers[pre_header] = pre + $1
          new_line = false
        }
      end

      if new_line
        line.sub(/^[ ]*([\w-]+)[ ]*:[ ]*(.*)[ ]*\r$/){
          if keys.member?($1)
            headers[$1] = $2
            pre_header = $1
          else
            pre_header = nil
          end}
      end
    end

    if headers.length == keys.length && pre_header == nil
      role   = headers["SERVER_ROLE"]
      method = headers["METHOD_NAME"]
      dir    = headers["DIRECTION"]
      from   = headers["From"]
      to     = headers["To"]

      isReq = true
      method.sub(/\w*-[0-9]*/){isReq = false}

      dir.sub(/^RE-(\w*)$/){
        dir=$1
        method="RE-"+method }

      from_tag = from.sub(/.*;tag=.*-([^.]*)/,'\1')
      to_tag   = to.sub(/.*;tag=.*-([^.]*)/,'\1')
      from     = from.sub(/^.*sip:/,'').sub(/[;>:].*$/,'')
      to       = to.sub(/^.*sip:/,'').sub(/[;>:].*$/,'')

      if isReq == false
        temp=from
        from=to
        to=temp

        temp=from_tag
        from_tag=to_tag
        to_tag=temp
      end

      method = "#{method}(#{line_n})"
      find = true
      if  role == "IM ORIGINATING PARTICIPANT"
        if  dir == "RECV"
          print "#{from}->OPF: #{method}"
        else
          print "OPF->#{to}: #{method}"
        end
      elsif  role == "IM CONTROLLING"
        if  dir == "RECV"
          print "TPF(#{from})->CF: #{method}"
        else
          print "CF->TPF(#{to}): #{method}"
        end
      elsif  role == "IM TERMINATING PARTICIPANT"
        if  dir == "RECV"
          if  from_tag == "cf"
            print "CF->TPF(#{to}): #{method}"
          else
            print "#{from}->TPF(#{from}): #{method}"
          end
        else
          if  to_tag == "cf"
            print "TPF(#{from})->CF: #{method}"
          else
            print "TPF(#{to})->#{to}: #{method}"
          end
        end
      elsif  role == "IM"
        if  dir == "RECV"
          print "#{from}->IM: #{method}"
        else
          print "IM->#{to}: #{method}"
        end
      else
        find = false
      end
      if find
        print "\n"
      end

      headers = {}
      sip_mode = false
      pre_header = nil
    end
  end
}

