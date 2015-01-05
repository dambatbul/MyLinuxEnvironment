#!/usr/bin/env ruby

def is_fname(line,cname)
	line.sub(/^( )*[a-zA-Z][a-zA-Z0-9_]* ( )*#{cname}::[a-zA-Z][a-zA-Z0-9_]*( )*\(/) {return true}
	return false
end
def is_construct(line,cname)
	line.sub(/^( )*#{cname}::#{cname}/){return true}
	return false
end
def is_deconstruct(line,cname)
	line.sub(/^( )*#{cname}::\~#{cname}/){return true}
	return false
end

def grep_cpp(fio,cname,str)
	fname = ""
	is_changed = false;
	result = ""

	fio.each_line do |line|
		if is_fname(line,cname) or is_construct(line,cname) or is_deconstruct(line,cname)
			fname = line
			is_changed = true;
#result += "[1;32m"
#result +=  fname
#result += "[0m"
			next
		end

		new = line.sub(/(#{str})/,'[1;31m\1[0m')

		if new != line
			if is_changed
				result += fname
			end
			result += new
				
			is_changed = false;
		end
	end
	result
end


#===========================================================
# main
#===========================================================

$Str= ARGV[0]
Len = ARGV.length - 1

Len.times do |i|
	$File  	= ARGV[i+1]
	$Class 	= $File.sub(/.cpp/,'')

	result = ""
	File.open($File,"r"){ |fio|
		content = grep_cpp(fio,$Class,$Str)
		if content != ""
			result += "#{$Class} ------------------------------------\n"
			result +=  "#{$File}\n"
			result += content
			result += "\n"
		end
	}
	print result
end


