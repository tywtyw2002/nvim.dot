local M = {}

local utf8_ok, utf8 = pcall(require, 'lua-utf8')


local format_line = function(line, max_width)
    -- inserts linebreaks into line

    local formatted_line = "\n"
    if line == '' then
        formatted_line = formatted_line .. " "
        return formatted_line
    end

    -- split line by spaces into list of words
    words = {}
    target = "%S+"
    for word in utf8.gmatch(line, target) do
        --print(">> " .. word)
        table.insert(words, word)
    end

    bufstart = ""
    buffer = bufstart
    for i, word in ipairs(words) do
        if ((utf8.width(buffer) + utf8.width(word) + 1) < max_width) then
            buffer = buffer .. word .. " "
            if (i == #words) then
                formatted_line = formatted_line .. utf8.sub(buffer, 1,-2) .. "\n"
                -- table.insert(formatted_lines, buffer:sub(1,-2))
            end
        else
            formatted_line = formatted_line .. utf8.sub(buffer, 1,-2) .. "\n"
            -- table.insert(formatted_lines, buffer:sub(1,-2))
            buffer = bufstart .. word .. " "
        end
    end
    -- right-justify text if the line begins with -
    if utf8.sub(line, 1, 1) == '─' then
        local space = "\n" .. string.rep(" ", max_width - utf8.width(#formatted_line) - 2)
        formatted_line = space .. utf8.sub(formatted_line, 2,-1)
    end
    return formatted_line
end

local format_fortune = function(fortune, max_width)
    -- Converts list of strings to one formatted string (with linebreaks)
    formatted_fortune = " \n "  -- adds spacing between alpha-menu and footer
    for _, line in ipairs(fortune) do
        --print("I>" .. line .. "<")
        local formatted_line = format_line(line, max_width)
        --print("L>" .. formatted_line .. "<")
        formatted_fortune = formatted_fortune .. formatted_line
    end
    return formatted_fortune
end

local get_fortune = function(fortune_list)
    -- selects an entry from fortune_list randomly
    math.randomseed(os.time())
    local ind = math.random(1, #fortune_list-1)
    return fortune_list[ind]
end


M.today = function()

    if not utf8_ok then
        return ""
    end

    local max_width = 54
    local fortune_list = {
        {'One day when we were young.'},
        {'Four score and seven years ago...'},
        {'那么但是， 我想我唯一的办法， 就是我的声音要比它还高。 '},
        {'所有人， 不论长幼都必须说英语。 '},
        {'你们给我搞的这本东西啊， Excited！ '},
        {'很惭愧， 就做了一点微小的工作， 谢谢大家。 '},
        {'人呐就都不知道， 自己就不可以预料。 一个人的命运啊， 当然要靠自我奋斗， 但是也要考虑到历史的行程。 '},
        {'这个报告经过好几百个教授一致通过。 '},
        {'所以邓小平同志跟我讲话， 说“中央都决定啦， 你来当总书记”， 我说另请高明吧。 我实在我也不是谦虚。 '},
        {'所以后来我就念了两首诗， 叫“苟利国家生死以， 岂因祸福避趋之”'},
        {'到了北京我干了这十几年也没有什么别的， 大概三件事'},
        {'I think I speak very poor English, but anyway I dare to say. This is very important.'},
        {'我别的本事没有， 但是会终身学习， 去到哪儿学到哪儿， 我永远不会放弃学习， 虚心学习再学习！ '},
        {'人的生命是有限的， 知识是那么浩瀚， 即使你怎么尽全力地努力， 也只能得到一点点！ '},
        {'你们媒体千万要注意啊， 不要“见着风， 是得雨”啊。 接到这些消息， 你媒体本身也要判断， 明白意思吗？ 假使这些完全....无中生有的东西， 你再帮他说一遍， 你等于....你也等于....你也有责任吧？ '},
        {'刚才你问我啊， 我可以回答你一句“无可奉告”， 那你们又不高兴， 那怎么办？ '},
        {'我觉得你们啊， 你们....我感觉你们新闻界还要学习一个， 你们非常熟悉西方的这一套 value。 '},
        {'你们毕竟还 too young， 明白这意思吧。 '},
        {'我告诉你们我是身经百战了， 见得多了！ 啊， 西方的哪一个国家我没去过？ '},
        {'你们要知道， 美国的华莱士， 那比你们不知道高到哪里去了。 啊， 我跟他谈笑风生！ 所以说媒体啊， 要....还是要提高自己的知识水平！ 懂我的意思────识得唔识得啊？ '},
        {'唉， 我也给你们着急啊， 真的。 '},
        {'你们有一个好， 全世界跑到什么地方， 你们比其他的西方记者啊， 跑得还快。 但是呢， 问来问去的问题啊， 都 too simple， 啊， sometimes naïve! 懂了没有啊？ '},
        {'识得唔识得啊？ '},
        {'我很抱歉， 我今天是作为一个长者给你们讲的。 我不是新闻工作者， 但是我见得太多了， 我....我有这个必要告诉你们一点， 人生的经验。 '},
        {'我刚才我很想啊， 就是我每一次碰到你们我就讲中国有一句话叫“闷声大发财”， 我就什么话也不说。 这是最好的！ 但是我想， 我见到你们这样热情啊， 一句话不说也不好。 '},
        {'所以你刚才你一定要────在宣传上将来如果你们报道上有偏差， 你们要负责的。 '},
        {'你问我不支....支持不支持， 我是支持的。 我就明确地给你告诉这一点。 '},
        {'连任也要按照香港的法律啊， 对不对？ 要要....要按照香港的....当然我们的决定权也是很重要的。 '},
        {'你们啊， 不要想....喜欢....弄个大新闻， 说现在已经钦定了， 再把我批判一番。 '},
        {'你们啊， naïve!'},
        {'I\'m angry! 我跟你讲啊， 你们这样子啊， 是不行的！ '},
        {'我今天算是得罪了你们一下！ '},
        {"- 『你觉得董先生连任好不好啊？ 』", " - 『吼啊！ 』", "", "────长者"},
        {"『你们媒体千万要记着， 不要「见得风， 是得雨」。 』", "", "────长者"},
        {"『接到消息， 你们媒体本身也要判断。 』", "", "────长者"},
        {"『假设这些完全无中生有的东西， 你再帮他说一遍， 你等于....你也有责任吧？ 』", "", "────长者"},
        {"『刚才你问我啊， 我可以回答你一句「无可奉告」。 』", "", "────长者"},
        {"『你问我资瓷不资瓷， 我是资瓷的。 』", "", "────长者"},
        {"『我感觉你们新闻界还要学习一个。 』", "", "────长者"},
        {"『你们毕竟还 too young， 明白这意思吧？ 』", "", "────长者"},
        {"『我告诉你们我是身经百战了， 见得多了！ 』", "", "────长者"},
        {"『西方的哪一个国家我没去过？ 』", "", "────长者"},
        {"『美国的华莱士， 比你们不知要高到哪里去了， 我跟他谈笑风生。 』", "", "────长者"},
        {"『所以说媒体呀， 还是要提高自己的姿势水平， 识得唔识得啊？ 』", "", "────长者"},
        {"『你们有一个好， 全世界跑到什么地方， 你们比其他的西方记者跑得还快。 』", "", "────长者"},
        {"『问来问的问题呀， 都 too simple， sometimes naive。 』", "", "────长者"},
        {"『我不是新闻工作者， 但是我见得太多了。 』", "", "────长者"},
        {"『我有这个必要告诉你们一点， 人生的经验。 』", "", "────长者"},
        {"『我今天是作为一个长者跟你们讲。 ....我就讲中国有一句话叫「闷声大发财」。 』", "", "────长者"},
        {"『将来如果你们在报道上有偏差， 你们是要负责的。 』", "", "────长者"},
        {"『我没有说要钦定， 没有任何这个意思。 』", "", "────长者"},
        {"『当然我们的决定权也是很重要的。 ....到那个时候我们会表态的！ 』", "", "────长者"},
        {"『你们啊， 不要想喜欢弄个大新闻， 说现在已经钦定了， 就把我批判一番。 』", "", "────长者"},
        {"『你们啊， naive！ 』", "", "────长者"},
        {"『I am angry！ 你们这样子啊， 是不行的！ 我今天算是得罪了你们一下。 』", "", "────长者"},
        {"『一个人的命运啊， 当然要靠自我奋斗， 但是也要考虑历史的进程。 』", "", "────长者"},
        {"『我说另请高明吧， 我实在也不是谦虚。 』", "", "────长者"},
        {"『后来我念了两首诗， 叫「苟利国家生死以， 岂因祸福避趋之」。 』", "", "────长者"},
        {"『如果说还有一点成绩就是「军队一律不得经商」。 』", "", "────长者"},
        {"『很惭愧， 就做了一点微小的工作， 谢谢大家！ 』", "", "────长者"},
    }

    local fortune = get_fortune(fortune_list)
    local formatted_fortune = format_fortune(fortune, max_width)

    --print(formatted_fortune)
    return utf8.gsub(formatted_fortune, "%.%.%.%.", "… … ")
end

return M