if UnitClass('player') ~= 'Warlock' then return end

MAX_SOUL_SHARDS = MAX_SOUL_SHARDS or 28

local function isShard(bag, slot)
    itemID = GetContainerItemID(bag, slot)
    return itemID == 6265
end

local function deleteItem(bag, slot)
    PickupContainerItem(bag, slot)
    DeleteCursorItem()
end

local function findShards()
    local shards = {}
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            if isShard(bag, slot) then
                table.insert(shards, {bag, slot})
            end
        end
    end
    for i = 1, table.getn(shards) - MAX_SOUL_SHARDS do
        deleteItem(shards[i][1], shards[i][2])
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
end

SSM_UpdateFrame = CreateFrame('Frame', 'SSMUpdateFrame')
SSM_UpdateFrame:SetScript('OnEvent', findShards)

-- Only get soul shards when something gives XP/Honor anyway :^)
-- Also has the nifty side effect of keeping the extra soul shard you get when you lose your pet
SSM_UpdateFrame:RegisterEvent('PLAYER_XP_UPDATE')
SSM_UpdateFrame:RegisterEvent('PLAYER_PVP_KILLS_CHANGED')

SLASH_SSM1, SLASH_SSM2 = '/ssm', '/soulshardmanager'
SlashCmdList['SSM'] = SSM_Main
