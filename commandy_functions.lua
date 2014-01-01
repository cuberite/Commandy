function HandleCommandBlock( inSplit, inPlayer )
	if( #inSplit == 1 ) then
		AddBlocksToPlayer( inPlayer, 1 )
	else
		inPlayer:SendMessage( "This command has no arguments, use just /"..inSplit[1] )
	end
end

function HandleCommandBlocks( inSplit, inPlayer )
	if( #inSplit == 1 ) then
		AddBlocksToPlayer( inPlayer, 64 )
	elseif( #inSplit == 2 ) then
		AddBlocksToPlayer( inPlayer, tonumber( inSplit[2] ) )
	else
		inPlayer:SendMessage( "Invalid arguments, use /"..inSplit[1].." [amount]" )
	end
end

-- / / / / / / / / / / / / / / / / / / / / / / /

function AddBlocksToPlayer( inPlayer, inAmount )
	local playerBlocks, freeSpace = HANDY:Call( "ReadPlayerForItem", inPlayer, E_BLOCK_COMMAND_BLOCK )
	if( freeSpace > 0 ) then
		local addedAmount = math.min( inAmount, freeSpace )
		HANDY:Call( "GiveItemsToPlayer", inPlayer, E_BLOCK_COMMAND_BLOCK, addedAmount )
		if( addedAmount == 1 ) then
			inPlayer:SendMessage( "1 command block was added to your inventory" )
		else
			inPlayer:SendMessage( addedAmount.." command blocks were added to your inventory" )
		end
		LOG( PLUGIN:GetName().." v"..PLUGIN:GetVersion().." reporting: player "..inPlayer:GetName().." +"..addedAmount.." command blocks" )
	else
		inPlayer:SendMessage( "You don't have enough space" )
	end
end

-- / / / / / / / / / / / / / / / / / / / / / / /

function SaveSettings()
	iniFile = cIniFile()
	iniFile:ReadFile( PLUGIN:GetLocalFolder().."/commandy_settings.ini" )
	iniFile:SetValueB( "Settings", "LogHackAttempts", LogHackAttempts, false )
	iniFile:WriteFile( PLUGIN:GetLocalFolder().."/commandy_settings.ini" )
end
function LoadSettings()
	iniFile = cIniFile()
	iniFile:ReadFile( PLUGIN:GetLocalFolder().."/commandy_settings.ini" )
	LogHackAttempts = iniFile:GetValueSetB( "Settings", "LogHackAttempts", false )
	iniFile:WriteFile( PLUGIN:GetLocalFolder().."/commandy_settings.ini" )
end