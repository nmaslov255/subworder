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

###*
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
