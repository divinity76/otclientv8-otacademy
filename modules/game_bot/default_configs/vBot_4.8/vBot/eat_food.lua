setDefaultTab("HP")

local function persistBotStorage()
  if type(save) == "function" then
    save()
  end
end

local function defaultFoodItemsForVocation()
  local items = {3582, 3577}
  if voc() ~= 1 and voc() ~= 11 then
    table.insert(items, 3607)
    table.insert(items, 3585)
    table.insert(items, 3592)
    table.insert(items, 3600)
    table.insert(items, 3601)
  end
  return items
end

-- Initialize once (no merge): keep user edits intact across restarts.
if type(storage.foodItems) ~= "table" or (storage.foodItemsInitialized ~= true and not storage.foodItems[1]) then
  storage.foodItems = defaultFoodItemsForVocation()
  storage.foodItemsInitialized = true
  persistBotStorage()
end

if voc() ~= 1 and voc() ~= 11 then
  macro(500, "Cast Food", function()
    if player:getRegenerationTime() <= 400 then
      cast("exevo pan", 5000)
    end
  end)
end

UI.Label("Eatable items:")

local foodContainer = UI.Container(function(widget, items)
  storage.foodItems = items
  storage.foodItemsInitialized = true
  persistBotStorage()
end, true)
foodContainer:setHeight(35)
foodContainer:setItems(storage.foodItems)

local function getFoodId(foodItem)
  if type(foodItem) == "table" then return foodItem.id end
  return foodItem
end

macro(500, "Eat Food", function()
  if player:getRegenerationTime() > 400 or not storage.foodItems[1] then return end
  -- search for food in containers
  for _, container in pairs(g_game.getContainers()) do
    for __, item in ipairs(container:getItems()) do
      for i, foodItem in ipairs(storage.foodItems) do
        local foodId = getFoodId(foodItem)
        if foodId and item:getId() == foodId then
          return g_game.use(item)
        end
      end
    end
  end
end)
UI.Separator()
