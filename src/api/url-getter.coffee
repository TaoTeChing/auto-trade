module.exports =
    host: 'vip.stock.finance.sina.com.cn'
    topList: (num=40, index=1)->
        return "/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=#{index}&num=#{num}&sort=changepercent&asc=0&node=hs_a&_s_r_a=init"
    fresh: ()->
        return "/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=1&num=500&sort=symbol&asc=1&node=new_stock&_s_r_a=init"