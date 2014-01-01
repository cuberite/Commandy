--[[
TODO:
-- Cheetah?
]]

-- Global variables
LogHackAttempts = false	-- not really logs hack attempts, but could point at players who start to play with TNT and lighter.

HANDY = {}
PLUGIN = {}	-- Reference to own plugin object
HandyRequiredVersion = 2

function Initialize( Plugin )
	Plugin:SetName( "Commandy" )
	Plugin:SetVersion( 1 )
	PLUGIN = Plugin
	HANDY = cRoot:Get():GetPluginManager():GetPlugin( "Handy" )
	local properHandy = HANDY:Call( "CheckForRequiedVersion", HandyRequiredVersion )
	if( not properHandy ) then
		LOGERROR( PLUGIN:GetName().." v"..PLUGIN:GetVersion().." needs Handy v"..HandyRequiredVersion..", shutting down" )
		return false
	end
	
	local pluginManager = cPluginManager:Get()
	pluginManager:BindCommand( "/commandblock", "commandy.get", HandleCommandBlock, " or /cblock - gives you one command block" )
	pluginManager:BindCommand( "/commandblocks", "commandy.get", HandleCommandBlocks, " [amount] or /cblocks [amount] - gives you 64 command blocks or specified amount" )
	pluginManager:BindCommand( "/cblock", "commandy.get", HandleCommandBlock, "" )
	pluginManager:BindCommand( "/cblocks", "commandy.get", HandleCommandBlocks, "" )
	
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnRightClick )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlacingBlock )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnBreakingBlock )
	
	
	LoadSettings()
	
	Plugin:AddWebTab( "Manage", HandleRequest_Manage )
	LOG( "Initialized "..PLUGIN:GetName().." v"..PLUGIN:GetVersion() )
	return true
end

function OnDisable()
	SaveSettings()
	LOG( PLUGIN:GetName().." v"..PLUGIN:GetVersion().." is shutting down..." )
end

function OnRightClick( inPlayer, inX, inY, inZ, inFace, inCursorX, inCursorY, inCursorZ )
	local blockType = inPlayer:GetWorld():GetBlock( inX, inY, inZ )
	if( blockType == E_BLOCK_COMMAND_BLOCK ) then
		if( not inPlayer:HasPermission( "commandy.modify" ) ) then
			inPlayer:SendMessage( "You don't have permission to interact with command blocks" )
			if( LogHackAttempts ) then
				LOGINFO( "Player "..inPlayer:GetName().." tried to modify command block @ x"..inX.." y"..inY.." z"..inZ )
			end
			return true
		end
	end
	return false
end

function OnPlacingBlock( inPlayer, inX, inY, inZ, inFace, inCursorX, inCursorY, inCursorZ, inType, inMeta )
	if( inType == E_BLOCK_COMMAND_BLOCK ) then
		if( not inPlayer:HasPermission( "commandy.place" ) ) then
			inPlayer:SendMessage( "You don't have permission to place command blocks" )
			if( LogHackAttempts ) then
				LOGINFO( "Player "..inPlayer:GetName().." tried to place command block @ x"..inX.." y"..inY.." z"..inZ )
			end
			return true
		end
	end
	return false
end

function OnBreakingBlock( inPlayer, inX, inY, inZ, inFace, inType, inMeta )
	if( inType == E_BLOCK_COMMAND_BLOCK ) then
		if( not inPlayer:HasPermission( "commandy.break" ) ) then
			inPlayer:SendMessage( "You don't have permission to break command blocks" )
			if( LogHackAttempts ) then
				LOGINFO( "Player "..inPlayer:GetName().." tried to break command block @ x"..inX.." y"..inY.." z"..inZ )
			end
			return true
		end
	end
	return false
end