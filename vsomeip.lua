bit={data32={}}
for i=1,32 do
    bit.data32[i]=2^(32-i)
end

function bit:d2b(arg)
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end   --bit:d2b

function    bit:b2d(arg)
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end   --bit:b2d

function    bit:_xor(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if op1[i]==op2[i] then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:xor

function    bit:_and(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if op1[i]==1 and op2[i]==1  then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
    
end --bit:_and

function    bit:_or(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if  op1[i]==1 or   op2[i]==1   then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
end --bit:_or

function    bit:_not(a)
    local   op1=self:d2b(a)
    local   r={}

    for i=1,32 do
        if  op1[i]==1   then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:_not

function    bit:_rshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n do
            for i=31,1,-1 do
                op1[i+1]=op1[i]
            end
            op1[1]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_rshift

function    bit:_lshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n   do
            for i=1,31 do
                op1[i]=op1[i+1]
            end
            op1[32]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_lshift


function    bit:print(ta)
    local   sr=""
    for i=1,32 do
        sr=sr..ta[i]
    end
    print(sr)
end
--------------------------------------------------------------------------------------


-- trivial postdissector example
-- declare some Fields to be read
ip_src_f = Field.new("ip.src")
ip_dst_f = Field.new("ip.dst")
tcp_src_f = Field.new("tcp.srcport")
tcp_dst_f = Field.new("tcp.dstport")
-- declare our (pseudo) protocol
trivial_proto = Proto("trivial","Trivial Postdissector")
-- create the fields for our "protocol"
src_F = ProtoField.string("trivial.src","Source")
dst_F = ProtoField.string("trivial.dst","Destination")
conv_F = ProtoField.string("trivial.conv","Conversation","A Conversation")
-- add the field to the protocol
trivial_proto.fields = {src_F, dst_F, conv_F}
-- create a function to "postdissect" each frame
function trivial_proto.dissector(buffer,pinfo,tree)
    -- obtain the current values the protocol fields
    local tcp_src = tcp_src_f()
    local tcp_dst = tcp_dst_f()
    local ip_src = ip_src_f()
    local ip_dst = ip_dst_f()
    if tcp_src then
       local subtree = tree:add(trivial_proto,"Trivial Protocol Data")
       local src = tostring(ip_src) .. ":" .. tostring(tcp_src)
       local dst = tostring(ip_dst) .. ":" .. tostring(tcp_dst)
       local conv = src  .. "->" .. dst
       subtree:add(src_F,src)
       subtree:add(dst_F,dst)
       subtree:add(conv_F,conv)
    end
end
-- register our protocol as a postdissector
register_postdissector(trivial_proto)
--------------------------------------------------------------------------------------

-- declare our protocol
someip_proto = Proto("SOMEIP","SOMEIP Protocol")
-- create a function to dissect it
function someip_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "SOMEIP"
end
-- load the udp.port table
udp_table = DissectorTable.get("udp.port")
-- register our protocol to handle udp port 30490
udp_table:add(30490,someip_proto)
udp_table:add(30509,someip_proto)

 





local ConfigOptionBaseMsg = {
	{ order = 0,  offset = 0, size = 2, field = someip_msg_sd_option_length},
	{ order = 0,  offset = 2, size = 1, field = someip_msg_sd_option_type},
	{ order = 0,  offset = 3, size = 1, field = someip_msg_sd_option_Reserved},
}


local someip_msg_sd_option_IPv4_Endpoint		= ProtoField.ipv4("someip.sd.option.ipv4.address", "IPv4 Address", base.None)
local someip_msg_sd_option_ipv4_reserved		= ProtoField.bytes("someip.sd.option.ipv4.Reserved", "Reserved", base.None)
local someip_msg_sd_option_ipv4_l4proto			= ProtoField.uint8("someip.sd.option.ipv4.proto", "proto", base.HEX, {[0x06] = "TCP", [0x11] = "UDP"})
local someip_msg_sd_option_ipv4_port			= ProtoField.uint16("someip.sd.option.ipv4.port", "port", base.None)

local IPv4EndpointOptionMsg = {
	{ order = 0,  offset = 0, size = 4, field = someip_msg_sd_option_IPv4_Endpoint},
	{ order = 1,  offset = 4, size = 1, field = someip_msg_sd_option_ipv4_reserved},
	{ order = 2,  offset = 5, size = 1, field = someip_msg_sd_option_ipv4_l4proto},
	{ order = 3,  offset = 6, size = 2, field = someip_msg_sd_option_ipv4_port},
}

 

--IPv4-Address [32 bit]
--Reserved (=0x00)	L4-Proto (TCP/UDP)	Port Number

 

local exfield_string = ProtoField.new("Extracted String Value", "extract.string", ftypes.STRING)
local exfield_hex    = ProtoField.new("Extracted Hex Value", "extract.hex", ftypes.STRING)


--local someip_service_id = ProtoField.uint16("someip.serviceid", "Service ID", base.HEX)
--local someip_service_type = ProtoField.uint8("someip.servicetype", "Type", base.HEX, {[1]="Event", [0]="Method"},0x80)
--local someip_method_id = ProtoField.uint16("someip.methodid", "Method ID", base.HEX)
--local someip_event_id = ProtoField.uint16("someip.eventid", "Event ID")
--
--local someip_msg_len = ProtoField.uint32("someip.msglen", "Length", base.DEC)
--local someip_msg_payload  = ProtoField.bytes("someip.msgcontent", "Content", base.NONE)
--local someip_msg_request_id =ProtoField.uint32("someip.requestid", "Request ID", base.HEX)
--local someip_msg_client_id =ProtoField.uint16("someip.clientid", "Client ID", base.HEX)
--local someip_msg_session_id =ProtoField.uint16("someip.sessionid", "Session ID", base.HEX)
--local someip_msg_ProtocolVersion =ProtoField.uint8("someip.ProtocolVersion", "ProtocolVersion", base.HEX)
--local someip_msg_InterfaceVersion =ProtoField.uint8("someip.InterfaceVersion", "InterfaceVersion", base.HEX)
--local someip_msg_MessageType =ProtoField.uint8("someip.MessageType", "MessageType", base.HEX, { 
--	[0x00] =  " REQUEST",
--	[0x01] =  "	REQUEST_NO_RETURN",
--	[0x02] =  "	NOTIFICATION",
--	[0x80] =  "	RESPONSE",
--	[0x81] =  "	ERROR",
--	[0x20] =  "	TP_REQUEST",
--	[0x21] =  "	TP_REQUEST_NO_RETURN",
--	[0x22] =  "	TP_NOTIFICATION",
--	[0x23] =  "	TP_RESPONSE",
--	[0x24] =  "	TP_ERROR",})
--local someip_msg_ReturnCode =ProtoField.uint8("someip.ReturnCode", "ReturnCode", base.HEX) 
 

local someip_msg_msgtype_info = { 
	[0x00] =  "REQUEST",
	[0x01] =  "REQUEST_NO_RETURN",
	[0x02] =  "NOTIFICATION",
	[0x80] =  "RESPONSE",
	[0x81] =  "ERROR",
	[0x20] =  "TP_REQUEST",
	[0x21] =  "TP_REQUEST_NO_RETURN",
	[0x22] =  "TP_NOTIFICATION",
	[0x23] =  "TP_RESPONSE",
	[0x24] =  "TP_ERROR",}

local servicetype_text_info = {[1]="EVENT", [0]="METHOD"}
 local SOMEIP_Msg_Hdr = {
	{ order = 0,  offset = 0,  size = 4,  field =  ProtoField.uint32("someip.messageid", "Message ID", base.HEX)},
	{ order = 1,  offset = 0,  size = 2,  field =  ProtoField.uint16("someip.serviceid", "Service ID", base.HEX) },
	{ order = 2,  offset = 2,  size = 1,  field = ProtoField.uint8("someip.servicetype", "Type", base.HEX, servicetype_text_info,0x80)},
	{ order = 3,  offset = 2,  size = 2,  field =  ProtoField.uint16("someip.methodid", "Method ID", base.HEX)},
	{ order = 4,  offset = 4,  size = 4,  field = ProtoField.uint32("someip.msglen", "Length", base.DEC)},
	{ order = 5,  offset = 8,  size = 4,  field = ProtoField.uint32("someip.requestid", "Request ID", base.HEX)},
	{ order = 6,  offset = 8,  size = 2,  field = ProtoField.uint16("someip.clientid", "Client ID" , base.HEX)},
	{ order = 7,  offset = 10, size = 2,  field = ProtoField.uint16("someip.sessionid", "Session ID" , base.HEX)},
	{ order = 8,  offset = 12, size = 1,  field = ProtoField.uint8("someip.ProtocolVersion", "ProtocolVersion", base.HEX)},
	{ order = 9,  offset = 13, size = 1,  field = ProtoField.uint8("someip.InterfaceVersion", "InterfaceVersion", base.HEX)},
	{ order = 10,  offset = 14, size = 1,  field = ProtoField.uint8("someip.MessageType", "MessageType", base.HEX, someip_msg_msgtype_info )},
	{ order = 11,  offset = 15, size = 1, field = ProtoField.uint8("someip.ReturnCode", "ReturnCode", base.HEX)},
}
 
  

local EntryFormatType_text_info = { [0] = "Find Service", [1]= "Offer Service", [0x06]= "SubscribeEventgroup", [0x07]="SubscribeEventgroupAck"}

 local EntryFormatBaseMsg = {
	{ order = 1,  offset = 0, size = 1,  field = ProtoField.uint8("someip.sd.EntryFormatType", "EntryFormatType",  base.HEX, EntryFormatType_text_info)},
	{ order = 2,  offset = 1, size = 1,  field = ProtoField.uint8("someip.Index1stoptions", "Index 1st options", base.HEX)},
	{ order = 3,  offset = 2, size = 1,  field = ProtoField.uint8("someip.Index2stoptions", "Index 2st options", base.HEX)},
	{ order = 4,  offset = 3, size = 1,  field = ProtoField.uint8("someip.sd.NumberofOptions1", "Number of Options 1", base.HEX , nil, 0xf0)},
	{ order = 5,  offset = 3, size = 1,  field = ProtoField.uint8("someip.sd.NumberofOptions2", "Number of Options 2", base.HEX , nil, 0x0f)}, 
	{ order = 6,  offset = 4, size = 2,  field = ProtoField.uint16("someip.sd.ServiceID", "Service ID", base.HEX)},
	{ order = 7,  offset = 6, size = 2, field = ProtoField.uint16("someip.sd.InstanceID", "Instance ID", base.HEX)},
	{ order = 8,  offset = 8, size = 1, field = ProtoField.uint8("someip.sd.MajorVersion", "Major Version", base.HEX)},
	{ order = 9,  offset = 9, size = 3, field = ProtoField.uint24("someip.sd.TTL", "TTL", base.HEX)},
}
 
 local Option_text_info = {[0x04] = "IPv4 Endpoint Option", [0x14] = "IPv4 Multicast Option"}
 
 local OptionBaseMsg = {
	{ order = 0,  offset = 0, size = 2,  field = ProtoField.uint16("someip.sd.option.length", "Option Length", base.None)},
	{ order = 1,  offset = 2, size = 1,  field = ProtoField.uint8("someip.sd.option.type", "Option Type", base.HEX, Option_text_info)},
	{ order = 2,  offset = 3, size = 1,  field = ProtoField.uint8("someip.sd.option.reserved", "Option Reserved", base.None)},
}
 
local EntryFormatType1Msg = {
	{ order = 0,  offset = 0, size = 4,field = ProtoField.uint24("someip.sd.MinorVersion", "Minor Version", base.HEX)},
}


local EntryFormatType2Msg = {
	{ order = 0,  offset = 0, size = 2,field = ProtoField.uint8("someip.sd.Reserved1", "Reserved", base.None, nil, 0xFFF0)},
	{ order = 2,  offset = 0, size = 2,field = ProtoField.uint8("someip.sd.Counter", "Counter", base.HEX ,nil, 0x000F)},
	{ order = 3,  offset = 2, size = 2,field = ProtoField.uint8("someip.sd.EventgroupID", "EventgroupID", base.HEX)},
}

--SD
 

 
 local SOMEIP_Msg_SD_Hdr = 
 {
	{ order = 0,  offset = 0, size = 1, field =  ProtoField.uint8("someip.sd.flag", "SOMEIP SD flag", base.HEX)},
	{ order = 1,  offset = 0, size = 1, field =  ProtoField.uint8("someip.rebootflag", "rebootflag", base.HEX, {[0]="No", [1]="Reboot"},0x80)},
	{ order = 2,  offset = 0, size = 1, field =  ProtoField.uint8("someip.unicastflag", "unicastflag", base.HEX, {[0]="No", [1]="Unicast"},0x40)},
	{ order = 3,  offset = 0, size = 1, field =  ProtoField.uint8("someip.ExplicitInitialDataFlag", "ExplicitInitialDataFlag", base.HEX, {[0]="No", [1]="Set"},0x20)},
	{ order = 4,  offset = 0, size = 1, field =  ProtoField.uint8("someip.UndefinedBits", "UndefinedBits", base.HEX, nil,0x1f)},
	{ order = 5,  offset = 1, size = 3, field =  ProtoField.bytes("someip.Reservedfield", "Reservedfield", base.HEX)},
	
	{ order = 6,  offset = 4, size = 4,  field = ProtoField.uint32("someip.sd.LengthofEntriesArray", "Length Of Entries Array",  base.None)},
	{ order = 7,  offset = 8, fieldc="someip.sd.LengthofEntriesArray",  size = 4,  field = ProtoField.uint32("someip.sd.LengthofOptionsArray", "Length Of Options Array",  base.None)},
 }



local pfields = {}
function inst(tablename)

 
	local field;
	for k, v in pairs(tablename) do
		
		field = v["field"]
	
		if field == nil then
		else
		 pfields[#pfields+1] = field
		--t[k] = field
		end
 
	end
	
end


function sorttable(tab)
table.sort(tab,function(a,b) return a.order<b.order end) --从小到大排序
end

 
 

function init()
 
 table.sort(EntryFormatType1Msg,function(a,b) return a.order<b.order end) --从小到大排序
 table.sort(ConfigOptionBaseMsg,function(a,b) return a.order<b.order end) --从小到大排序
 table.sort(SOMEIP_Msg_Hdr,function(a,b) return a.order<b.order end) --从小到大排序
 table.sort(SOMEIP_Msg_SD_Hdr,function(a,b) return a.order<b.order end) --从小到大排序
  
 inst(SOMEIP_Msg_Hdr)
 inst(SOMEIP_Msg_SD_Hdr)
 inst(EntryFormatBaseMsg)
 inst(EntryFormatType1Msg)
 inst(EntryFormatType2Msg)
 inst(OptionBaseMsg)
 inst(IPv4EndpointOptionMsg)
 
 someip_proto.fields = pfields;
 
end


 
 
function packet (pinfo, buffer, userdata)
	-- Fetch the UDP length
	local udp_len = someip_messageid_f()
	if udp_len and udp_len.value > 400 then
	-- Do something with big UDP packages
	end
end
 

--调用init, 动态加载 someip_proto.fields 这里不能使用someip_proto.init函数来初始化
init()

someip_messageid_f = Field.new ("someip.messageid")
someip_sd_entryFormatType_f =Field.new("someip.sd.EntryFormatType")


someip_msg_sd_option_type_f = Field.new("someip.sd.option.type")

someip_msg_sd_option_length_f = Field.new("someip.sd.option.length")

Someip_msg_servicetype_f = Field.new("someip.servicetype")

Someip_msg_sd_LengthofEntriesArray_f = Field.new("someip.sd.LengthofEntriesArray")

Someip_msg_sd_LengthofOptionsArray_f = Field.new("someip.sd.LengthofOptionsArray")

Someip_msg_sd_NumberofOptions1_f = Field.new("someip.sd.NumberofOptions1")


Someip_msg_MessageType_f = Field.new("someip.MessageType")

local fun_set = {
	["someip.sd.LengthofEntriesArray"] =  Field.new("someip.sd.LengthofEntriesArray"),
}


-- 将字段添加都协议中
--someip_proto.fields = {
--	--someip_message_id,
--    someip_service_id,
--	someip_method_id,
--	someip_event_id,
--    someip_service_type,
--    someip_msg_len,
--	someip_msg_request_id,
--	someip_msg_client_id,
--	someip_msg_session_id,
--	someip_msg_ProtocolVersion,
--	someip_msg_InterfaceVersion,
--	someip_msg_MessageType,
--	someip_msg_ReturnCode,
--	
-- 
--    someip_msg_payload,
--	
--	
--	someip_msg_reboot_flag,
--	someip_msg_unicast_flag,
--	someip_msg_ExplicitInitialDataFlag,
--	someip_msg_UndefinedBits,
--	
--	someip_msg_Reservedfield,
--	
--	
--	--SD
--	someip_msg_sd_LengthofEntriesArray,
--	someip_msg_sd_LengthofOptionsArray,
--	someip_msg_sd_EntryFormatType,
--	someip_msg_Index1stoptions 	 ,
--	someip_msg_Index2stoptions 	 ,
--	someip_msg_sd_NumberofOptions1 ,
--	someip_msg_sd_NumberofOptions2 ,
--	someip_msg_sd_ServiceID 		 ,
--	someip_msg_sd_InstanceID 		 ,
--	someip_msg_sd_MajorVersion 	 ,
--	someip_msg_sd_TTL 			 ,
--	someip_msg_sd_MinorVersion 	,
--	
--	someip_msg_sd_option_length,
--	someip_msg_sd_option_type,
--	someip_msg_sd_option_Reserved,
--	
--	--option
--	someip_msg_sd_option_IPv4_Endpoint,
--	someip_msg_sd_option_ipv4_reserved	,
--	someip_msg_sd_option_ipv4_l4proto	,
--	someip_msg_sd_option_ipv4_port      ,
--	
--	
--	exfield_string,
--	exfield_hex   ,
--}
   
 
function IS_EVENT(d)
	 
	return  bit:_and(d,0x8000)  == 0x8000
end

function serialize(obj)
	local lua = ""
	local t = type(obj)
	if t == "number" then
		lua = lua .. obj
	elseif t == "boolean" then
		lua = lua .. tostring(obj)
	elseif t == "string" then
		lua = lua .. string.format("%q", obj)
	elseif t == "table" then
		lua = lua .. "{\n"
	for k, v in pairs(obj) do
		lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
	end
	local metatable = getmetatable(obj)
	if metatable ~= nil and type(metatable.__index) == "table" then
		for k, v in pairs(metatable.__index) do
		lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
		end
	end
		lua = lua .. "}"
	elseif t == "nil" then
		return nil
	else
		error("can not serialize a " .. t .. " type.".. obj)
	end
	return lua
end

  
function serialize23(obj,tvb, pinfo, treeitem)
	local lua = ""
	local offset = 0;
	local size = 0;
	local t = type(obj)
	local protocol_type;
	local sub_tree = treeitem;
  
	if t == "number" then
		lua =  obj
	 
		
	elseif t == "boolean" then
		lua =    tostring(obj)
		--pinfo.cols.info:append("boolean"..lua)
	elseif t == "string" then
		lua =    string.format("%q", obj)
		--pinfo.cols.info:append("string"..lua)
	elseif t == "table" then
	 
		 
		
		for k, v in pairs(obj) do
			serialize2(k, tvb, pinfo, treeitem)
			serialize2(v, tvb, pinfo, treeitem)
			--lua =    "--->[" .. serialize2(k, tvb, pinfo, treeitem) .. "]=" .. serialize2(v, tvb, pinfo, treeitem) .. ",\n"
		end
		
			local toffset = obj["offset"]
			if( toffset == nil) then
				return ""
			else
			lua = lua .."offset ="..toffset
			end
			
			  
			local tsize = obj["size"]
			if( tsize == nil) then
				return ""
			else
			lua = lua .."size ="..tsize
			end
			
			local ttvb = tvb:range(toffset, tsize);
			 
			local field = obj["field"]
			
			if field == nil then
			return ""
			end
			
		
			
			treeitem:add(field, ttvb)
			
		  
			--protocol_type = tvb:range(toffset,tsize)
			--sub_tree:add(protocol_type, "Data: " .. protocol_type)
		
		 
		local metatable = getmetatable(obj)
		if metatable ~= nil and type(metatable.__index) == "table" then
			for k, v in pairs(metatable.__index) do
			--lua =   "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
			
			--pinfo.cols.info:append('bbb'..lua)
			
		
			
			end
		end
		 
	elseif t == "nil" then
		return nil
	else
		--error("can not serialize a " .. t .. " type.")
		 
		return nil
		 
	end
 
	return lua
end


function add_info(obj,tvb, pinfo, treeitem)
	local toffset = obj["offset"]
	if( toffset == nil) then
		return 
	end
	
	local tsize = obj["size"]
	if( tsize == nil) then
		return 
	end
	

	 
	local field = obj["field"]
	
	if field == nil then
		return
	end
	local fieldc = obj["fieldc"]
		if (fieldc == nil) then
		 
			else
			 
				fieldcc = obj["fieldc"]
				local fu =  fun_set["someip.sd.LengthofEntriesArray"];
				if (fu == nil) then
			    error("not found !!!")
				else
				local va = fu()
				if(va ~=nil) then
				toffset = toffset + va.value
				end
				end
				
			end
	local ttvb = tvb:range(toffset, tsize);
	treeitem:add(field, ttvb)
end

function serialize2(obj,tvb, pinfo, treeitem)
 
	local t = type(obj)
 
	if t == "table" then
	 
		for k, v in pairs(obj) do
			add_info(v,tvb,pinfo,treeitem)
		end
	else
		add_info(obj,tvb,pinfo,treeitem)
	end
end

function unserialize(lua)
	local t = type(lua)
	if t == "nil" or lua == "" then
	return nil
	elseif t == "number" or t == "string" or t == "boolean" then
	lua = tostring(lua)
	else
	error("can not unserialize a " .. t .. " type.")
	end
	lua = "return " .. lua local func = loadstring(lua)
	if func == nil then return nil end
	return func()
end



function test(fields, tree)
	for i, field in ipairs(fields) do
		error(field.name)
          -- extract the field into a table of FieldInfos
          finfos = { field() }
  
          if #finfos > 0 then
              -- add our proto if we haven't already
              if not tree then
                  tree = root:add(exproto)
              end
  
              for _, finfo in ipairs(finfos) do
                  -- get a TvbRange of the FieldInfo
                  local ftvbr = finfo.tvb
                  tree:add(exfield_string, ftvbr:string(ENC_UTF_8))
                  tree:add(exfield_hex,tostring(ftvbr:bytes()))
              end
          end
      end
 end

function someip_proto_entry_format_type_1_dissector(tvb, pinfo, treeitem)
	local offset = 0
	local size = 1
	local protocol_type = tvb:range(offset)
  
    --local sub_tree = treeitem:add(tvb:range(offset), "Entry Format Type 1 : " .. protocol_type)
	
	local sub_tree = treeitem:add(someip_msg_sd_EntryFormatType, tvb:range(offset,size ))
 
  
	
	local c = {obj,obj1}
	
	
	--local lua = serialize(b)
	 
 
	
	serialize2(EntryFormatType1Msg, tvb, pinfo, treeitem)
	
end

--local EntryFormatType_f = Field.new ("someip.sd.EntryFormatType")


function someip_proto_msg_sd_entries_array_dissector(payload_range, pinfo, treeitem)
	
	local sub_tree = treeitem:add(payload_range, "Entries: ")
	
	serialize2(EntryFormatBaseMsg, payload_range, pinfo, sub_tree)
	payload_range = payload_range:range(12)
	
	if EntryFormatType == 0x00  or EntryFormatType == 0x01 then 
		serialize2(EntryFormatType1Msg, payload_range, pinfo, sub_tree)
	else 
	serialize2(EntryFormatType2Msg, payload_range, pinfo, sub_tree)
	
	end
end

function someip_proto_msg_sd_options_array_dissector(payload_range, pinfo, treeitem)
	
	local sub_tree = treeitem:add(payload_range, "Options: ")
	
	serialize2(ConfigOptionBaseMsg, payload_range, pinfo, sub_tree)
 
	local optiontype = payload_range(2,1):uint();
	pinfo.cols.info:append('optiontype'.. optiontype)
	
	if optiontype == 0x04 or optiontype == 0x14 then
		serialize2(IPv4EndpointOptionMsg, payload_range(4), pinfo, sub_tree)
		
		pinfo.cols.info:append(' '..Option_text_info[optiontype]..' ')
			
	end
 
 
end

function someip_proto_msg_sd_entry(tvb, pinfo, treeitem)

	local payload_range = tvb
	serialize2(EntryFormatBaseMsg,payload_range,pinfo,treeitem)
	payload_range = tvb:range(12)
	local someip_sd_entryFormatType = someip_sd_entryFormatType_f()
	
	if someip_sd_entryFormatType and  someip_sd_entryFormatType.value == 0x01  or someip_sd_entryFormatType.value == 0x00 then
		serialize2(EntryFormatType1Msg,payload_range,pinfo,subtree)
	else
	serialize2(EntryFormatType2Msg, payload_range, pinfo, treeitem)
	end
	pinfo.cols.info:append(' '.. EntryFormatType_text_info[someip_sd_entryFormatType.value]..' ')
end

function someip_proto_msg_sd_option(tvb, pinfo, treeitem)

	local payload_range = tvb
	serialize2(OptionBaseMsg,payload_range,pinfo,treeitem)
	 
	
	local someip_msg_sd_option_type  = someip_msg_sd_option_type_f()
	
	if(someip_msg_sd_option_type == nil) then
		return;
	end
	
	payload_range = tvb:range(4)
	if (someip_msg_sd_option_type.value == 0x04 or someip_msg_sd_option_type.value == 0x14) then 
		serialize2(IPv4EndpointOptionMsg, payload_range, pinfo, treeitem)
		 
		
		pinfo.cols.info:append(' '..Option_text_info[someip_msg_sd_option_type.value]..' ')
			
	end
		
	 
end


function someip_proto_msg_sd_dissector(tvb, pinfo, treeitem)
	serialize2(SOMEIP_Msg_SD_Hdr,tvb,pinfo,treeitem) 
	payload_range = tvb:range(8)
	local someip_sd_entryFormatType = someip_sd_entryFormatType_f()
	local Someip_msg_sd_LengthofEntriesArray = Someip_msg_sd_LengthofEntriesArray_f()
	if( Someip_msg_sd_LengthofEntriesArray == nil) then 
	error("Someip_msg_sd_LengthofEntriesArray == nil")
	return 
	end
	
	local entry1len = 16;
	local entries = 0;
	
	local init = 0;
	while(init < Someip_msg_sd_LengthofEntriesArray.value)
	do
	    subtree = treeitem:add(payload_range(init, entry1len), "Entries:"..entries)
		someip_proto_msg_sd_entry(payload_range(init, entry1len),pinfo,subtree)
		 
		entries = entries +1
		init = init + entry1len
	end
	
	  
	local Someip_msg_sd_LengthofOptionsArray = Someip_msg_sd_LengthofOptionsArray_f();
	if(Someip_msg_sd_LengthofOptionsArray == nil) then 
	return
	end
	
	if(Someip_msg_sd_LengthofOptionsArray.value ==0) then
	return
	end
	
	local Someip_msg_sd_NumberofOptions1 = Someip_msg_sd_NumberofOptions1_f()
	if (Someip_msg_sd_NumberofOptions1 ~= nil and Someip_msg_sd_NumberofOptions1.value > 0) then 
	
	payload_range = payload_range(4+Someip_msg_sd_LengthofEntriesArray.value )
	local option_l
	init = 0
	local options = 0
	while(init < Someip_msg_sd_LengthofOptionsArray.value)
	do
		subtree = treeitem:add(payload_range(init), "Options:"..options)
	    
		someip_proto_msg_sd_option(payload_range(init), pinfo,subtree)
		option_l = someip_msg_sd_option_length_f()
		subtree:set_len(option_l.value+3)
		init = init + option_l.value + 3
		options = options + 1
      
		
	end
	
	end
	
	 
	
	
--	local offset  =0;
--	local size = 1;
--	local protocol_type = tvb:range(offset, size):uint()
--
--	local sub_tree = treeitem:add(tvb:range(offset, size), "Flags: " .. protocol_type)
--	
--	sub_tree:add(someip_msg_reboot_flag, tvb:range(offset, size) )
--	sub_tree:add(someip_msg_unicast_flag, tvb:range(offset, size) )
--	sub_tree:add(someip_msg_ExplicitInitialDataFlag, tvb:range(offset, size) )
--	sub_tree:add(someip_msg_UndefinedBits, tvb:range(offset, size) )
--	 
--	offset = offset + size
--	
--	size = 3
--	
--	treeitem:add(someip_msg_Reservedfield, tvb:range(offset, size))
--	
--	offset = offset + size
--	size = 4
--	local  LengthofEntriesArray= tvb:range(offset, size):uint()
--	
--	treeitem:add(someip_msg_sd_LengthofEntriesArray, tvb:range(offset, size) )
--	
--	offset = offset + size
--	
--
--	size = 1
--	local EntryFormatType = tvb:range(offset, size):uint()
--	 
--	local payload_range = tvb:range(offset)
--	
--	someip_proto_msg_sd_entries_array_dissector(payload_range, pinfo, treeitem)
--	
--
--	--OptionArrary
--	size = 4
--	offset = offset + LengthofEntriesArray
--	payload_range = tvb:range(offset)
--	treeitem:add(someip_msg_sd_LengthofOptionsArray, tvb:range(offset, size) )
--	
--	local  LengthofOptionArray= tvb:range(offset, size):uint()
--	if LengthofOptionArray >0 then 
--		offset = offset + 4
--		payload_range = tvb:range(offset)
--		someip_proto_msg_sd_options_array_dissector(payload_range, pinfo, treeitem)
--	end
 
	 
end

function someip_proto.dissector(tvb, pinfo, treeitem)

     pinfo.cols.protocol:set("SOMEIP")
     pinfo.cols.info:set("")
	 
 
    local offset = 0
	local size = 0 
    local tvb_len = tvb:len()
    local subtree
    -- 在上一级解析树上创建 someip 的根节点
	

	
    local someip_tree = treeitem:add(someip_proto, tvb:range(offset))
	
	serialize2(SOMEIP_Msg_Hdr,tvb,pinfo,someip_tree)
	
	

 
	-- 下面是想该根节点上添加子节点，也就是自定义协议的各个字段
	-- 注意 range 这个方法的两个参数的意义，第一个表示此时的偏移量
	-- 第二个参数代表的是字段占用数据的长度
--	subtree = someip_tree:add(someip_message_id, tvb:range(offset, 4))
--	local msgid = tvb:range(offset, 4):uint()
--	size = 2
--	subtree:add(someip_service_id, tvb:range(offset, size))
--	offset = offset+size 
--
--	local em = tvb:range(offset, size):uint()
--	local bEvent = IS_EVENT(em)
--	subtree:add(someip_service_type,  tvb:range(offset, 1))
--	if (bEvent) then
--	   
--		subtree:add(someip_event_id,   tvb:range(offset, size))
--		pinfo.cols.info:append("Event ")
--	else
--	   
--		subtree:add(someip_method_id,   tvb:range(offset, size))
--		pinfo.cols.info:append("Method")
--	end
--	
--	offset = offset+size
--	size = 4
--	someip_tree:add(someip_msg_len, tvb:range(offset, size))
--	offset = offset+size
--	 
--	subtree = someip_tree:add(someip_msg_request_id, tvb:range(offset, size))
--	subtree:add(someip_msg_client_id, tvb:range(offset, 2))
--	subtree:add(someip_msg_session_id, tvb:range(offset+2, 2))
--	
--	offset = offset+size
--	
--	size = 1
--	
--	someip_tree:add(someip_msg_ProtocolVersion, tvb:range(offset, size))
--	offset = offset + size
--	someip_tree:add(someip_msg_InterfaceVersion, tvb:range(offset, size))
--	offset = offset + size
--	
--	subtree = someip_tree:add(someip_msg_MessageType,   tvb:range(offset, size))
-- 
--	offset = offset + size
--	someip_tree:add(someip_msg_ReturnCode,   tvb:range(offset, size))
--	offset = offset + size
--	
--	-- 计算消息内容的长度
--	local someip_content_len = tvb_len-offset
--	local payload_range = tvb:range(offset, someip_content_len)
--	someip_tree:add(someip_msg_payload , payload_range)
--	offset = offset+someip_content_len
	
	local payload_range = tvb:range(16)
	local Someip_msg_servicetype = Someip_msg_servicetype_f()
	local bMethod = false
	local messagetypeText
	local Someip_msg_MessageType = Someip_msg_MessageType_f()
		if (Someip_msg_MessageType == nil) then
			error("Someip_msg_MessageType")
		return
		
		else
		messagetypeText = someip_msg_msgtype_info[Someip_msg_MessageType.value];
	
	end
	
	local servicetypetext = servicetype_text_info[Someip_msg_servicetype.value]
	if Someip_msg_servicetype == nil then 
		return
		else
		bMethod = Someip_msg_servicetype.value == 0
	end
	local someip_messageid = someip_messageid_f()
	if (someip_messageid == nil) then
	error(11)
	return
	end
 

	if (bMethod == false) then
	
		if (someip_messageid.value == 0xffff8100) then 
			pinfo.cols.info:set('SOMEIP SD ')
			
			someip_proto_msg_sd_dissector(payload_range, pinfo, someip_tree);
			
			return
		else
			pinfo.cols.info:set('SOMEIP '.. servicetypetext..' ')
			someip_tree:add(payload_range,"Payload:" , payload_range)
		end
	else

		pinfo.cols.info:set('SOMEIP '..servicetypetext..' ')
	
		someip_tree:add(payload_range,"Payload:" , payload_range)
		
	end
	
		pinfo.cols.info:append(" "..messagetypeText.." ")
	
	--test(someip_proto.fields, someip_tree)
	
	
end

-- trivial postdissector example
-- declare some Fields to be read
ip_src_f = Field.new("ip.src")
ip_dst_f = Field.new("ip.dst")
tcp_src_f = Field.new("tcp.srcport")
tcp_dst_f = Field.new("tcp.dstport")
-- declare our (pseudo) protocol
--trivial_proto = Proto("trivial","Trivial Postdissector")
-- create the fields for our "protocol"
src_F = ProtoField.string("trivial.src","Source")
dst_F = ProtoField.string("trivial.dst","Destination")
conv_F = ProtoField.string("trivial.conv","Conversation","A Conversation")
-- add the field to the protocol
--trivial_proto.fields = {src_F, dst_F, conv_F}
-- create a function to "postdissect" each frame
function trivial_proto.dissector(buffer,pinfo,tree)
    -- obtain the current values the protocol fields
    local tcp_src = tcp_src_f()
    local tcp_dst = tcp_dst_f()
    local ip_src = ip_src_f()
    local ip_dst = ip_dst_f()
    if tcp_src then
       local subtree = tree:add(trivial_proto,"Trivial Protocol Data")
       local src = tostring(ip_src) .. ":" .. tostring(tcp_src)
       local dst = tostring(ip_dst) .. ":" .. tostring(tcp_dst)
       local conv = src  .. "->" .. dst
       subtree:add(src_F,src)
       subtree:add(dst_F,dst)
       subtree:add(conv_F,conv)
    end
end
-- register our protocol as a postdissector
--register_postdissector(someip_proto, ture)



 
 