local T = {}
local vet = {}

local function reader()
  local vect = {}
  local arq = io.open("brasileirao-2017.txt", "r")
  if not arq then
    error("Não foi possível abrir o arquivo")
  end
  
  for line in arq:lines() do
    local a, pa, pb, b = line:match("%s*(%D-)%s+(%d+)%s+-%s+(%d+)%s+(%D-)%s*$")
    
    if (a and pa and pb and b) then
      --io.write("'",a,"'", "'", pa,"'", "'",pb, "'", "'",b,"'\n")
      if not T[a] then
        T[a] = {p = 0, v = 0, s = 0, g = 0}
      end
      if not T[b] then
        T[b] = {p = 0, v = 0, s = 0, g = 0}
      end
      
      if pa > pb then
        T[a].p = T[a].p + 3
        T[a].v = T[a].v + 1
        T[a].s = T[a].s + (pa - pb)
        T[b].s = T[b].s + (pb - pa)
        T[a].g = T[a].g + pa
        T[b].g = T[b].g + pb
      elseif pb > pa then
        T[b].p = T[b].p + 3
        T[b].v = T[b].v + 1
        T[b].s = T[b].s + (pb - pa)
        T[a].s = T[a].s + (pa - pb)
        T[a].g = T[a].g + pa
        T[b].g = T[b].g + pb
      elseif pa == pb then
        T[a].p = T[a].p + 1
        T[b].p = T[b].p + 1
        T[a].g = T[a].g + pa
        T[b].g = T[b].g + pb
      end
    end
  end
  
  arq:close()

end
local function classificados()
--Ordena em ordem decrescente os classificados
table.sort(vet, function(a, b)
                  if a.score.p > b.score.p then
                    return true
                  elseif a.score.p < b.score.p then
                    return false
                  elseif a.score.p == b.score.p and a.score.v > b.score.v then
                    return true
                  elseif a.score.p == b.score.p and a.score.v < b.score.v then
                    return false
                  elseif a.score.p == b.score.p and a.score.v == b.score.v and a.score.s > b.score.s then
                    return true
                  elseif a.score.p == b.score.p and a.score.v == b.score.v and a.score.s < b.score.s then
                    return false
                  elseif a.score.p == b.score.p and a.score.v == b.score.v and a.score.s == b.score.s and a.score.g > b.score.g then
                    return true
                  elseif a.score.p == b.score.p and a.score.v == b.score.v and a.score.s == b.score.s and a.score.g < b.score.g then
                    return false
                  end
                end)
end





reader()

--Ordena a tabela em array
for k, v in pairs(T) do
  vet[#vet + 1] = {time = k, score = v}
end

--Classificados em ordem decrescente
classificados()

function love.load()
  w, h = love.graphics.getDimensions()
  love.window.setMode(w, h)
end

function love.update(dt)
  
end

function love.draw()
  --Tabela
  love.graphics.push()
    love.graphics.scale(1.5)
    
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.rectangle("line", 100, 50, 200, 300)
    love.graphics.rectangle("line", 100, 50, 200, 20)
    love.graphics.rectangle("line", 120, 50, 180, 300)
    love.graphics.rectangle("line", 180, 50, 120, 300)
    love.graphics.rectangle("line", 210, 50, 90, 300)
    love.graphics.rectangle("line", 240, 50, 60, 300)
    love.graphics.rectangle("line", 270, 50, 30, 300)
  love.graphics.pop()
  love.graphics.setColor(1.0, 0.0, 0.0)
  
  love.graphics.scale(1)
  
  font = love.graphics.newFont(10)
  love.graphics.setFont(font)
  
  --Preenche a tabela
  local t = 113
  local points = 50
  for i = 1, #vet do
    love.graphics.print("CLUBE               P             V            S              G", 210, 85 )
    love.graphics.print(i .. "       " .. vet[i].time, 160 , t)
    love.graphics.print(vet[i].score.p, 285, t)
    love.graphics.print(vet[i].score.v, 330, t)
    love.graphics.print(vet[i].score.s, 375, t)
    love.graphics.print(vet[i].score.g, 420, t)
    t = t + 21
  end
end
