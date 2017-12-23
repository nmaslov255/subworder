# config constants
TRANSLATE = 'ru-en'

TRANSLATE_URL = 'https://translate.yandex.net/api/v1.5/tr.json/translate'
API_KEY = 'trnsl.1.1.20171221T053807Z.13d50c58e726aebe.5d363c1f44bd833d28b8dd317c62b65af39c0b4d'

REGEXP_PATTERN = /.*[а-яА-Я]/g
ALLOW_NODE = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6',
              'p',  'a',  'b',  'i', 'li', 'span']

# main
$(document).ready ->
    nodes = ALLOW_NODE.join ', '
    
    $(nodes).each -> 
        if filterElement $(this)
            $node = $(this)
            oldString = $node.text()
            
            getTranslate $node.text(), (resp) -> 
                engString = resp.text[0]
                $node.text randReplaceWord oldString, engString

# library

###*
 * ajax query for yandex.translate
 * @param  {String}   str      translated
 * @param  {Function} callback 
 * @return {Undefined}
###
getTranslate = (str, callback) -> 
    $.get TRANSLATE_URL, {
        lang: TRANSLATE,
        text: str,
        key: API_KEY,
    }, callback

###*
 * becouse translate independet of contect, we take all string + translate
 * @param  {String} string    
 * @param  {String} translate 
 * @return {String}           string with one random replaced word
###
randReplaceWord = (string, translate) ->
    oldWords = string.split ' '
    newWords = translate.split ' '

    if oldWords.length == newWords.length
        rand  = getRandomInteger 0, newWords.length - 1
        oldWords[rand] = newWords[rand]
        oldWords.join ' '
    else string

###*d
 * @param  {Object} $elem JQuery node
 * @return {Boolean}      
###
filterElement = ($elem) -> 
    $child  = $elem.children()
    isWords = checkRegExp $elem.text(), REGEXP_PATTERN 

    if $child.length is 0 and isWords then true else false

###*
 * @param  {String} str     
 * @param  {String} pattern 
 * @return {Boolean}
###
checkRegExp = (str, pattern) ->
    reg = new RegExp(pattern)
    if reg.test(str) then true else false

###*
 * @param  {Integer} min 
 * @param  {Integer} max 
 * @return {Integer}
###
getRandomInteger = (min, max) ->
    rand = min - 0.5 + Math.random() * (max - min + 1)
    Math.round rand