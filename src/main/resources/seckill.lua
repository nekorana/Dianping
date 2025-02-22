-- 优惠卷id和用户id
local voucherId = ARGV[1]
local userId = ARGV[2]

-- 库存key和订单key
local stockKey = 'seckill:stock' .. voucherId
local voucherKey = 'seckill:order' .. voucherId

-- 判断库存是否充足
if tonumber(redis.call('get', stockKey)) <= 0 then
    -- 库存不足，返回1
    return 1
end
-- 判断用户是否下单
if redis.call('sismember', orderKey, userId) == 1 then
    -- 存在说明是重复下单，返回2
    return 2
end
-- 扣库存
redis.call('incrby', stockKey, -1)
-- 下单（保存用户）
redis.call('sadd', orderKey, userId)

return 0