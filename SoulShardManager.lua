if UnitClass('player') ~= 'Warlock' then return end

MAX_SOUL_SHARDS = MAX_SOUL_SHARDS or 28

local function isShard(bag, slot)
    local link = GetContainerItemLink(bag, slot)
    return link and string.find(link, 'Soul Shard') == 31
end

local function deleteItem(bag, slot)
    PickupContainerItem(bag, slot)
    DeleteCursorItem()
end

local function findShards()
    local Shards = {}
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            if isShard(bag, slot) then
                table.insert(Shards, {bag, slot})
            end
        end
    end
    for i = 1, table.getn(Shards) - MAX_SOUL_SHARDS do
        deleteItem(Shards[i][1], Shards[i][2])
    end
end

local function SSM_Main(n)
    findShards()
    if tonumber(n) then
        MAX_SOUL_SHARDS = tonumber(n)
    elseif n ~= '' then
        DEFAULT_CHAT_FRAME:AddMessage('Requires integer argument.')
        return
    end
    DEFAULT_CHAT_FRAME:AddMessage('Set to keep ' .. MAX_SOUL_SHARDS .. ' soul shards.')
    findShards()
end

SSM_UpdateFrame = CreateFrame('frame')
SSM_UpdateFrame:SetScript('OnEvent', findShards)

-- Only get soul shards when something gives XP/Honor anyway :^)
-- Also has the nifty side effect of keeping the extra soul shard you get when you lose your pet
SSM_UpdateFrame:RegisterEvent('PLAYER_XP_UPDATE')
SSM_UpdateFrame:RegisterEvent('PLAYER_PVP_KILLS_CHANGED')

SLASH_SSM1, SLASH_SSM2 = '/soulshardmanager', '/ssm'
SlashCmdList['SSM'] = SSM_Main