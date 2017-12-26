# config constants
__translate__ = 'ru-en'

__yaApi__ = 'https://translate.yandex.net/api/v1.5/tr.json/translate'
__apiKey__ = 'trnsl.1.1.20171221T053807Z.13d50c58e726aebe.5d363c1f44bd833d28b8dd317c62b65af39c0b4d'

__sentenceRegExp__ = /([А-ЯЕЁ].*?\.)/g
__wordsRegExp__ = /([а-яА-ЯеёЕЁ]{3,})/g # find russian word in text
__wordDensity__ = 1 # means that we take every ?th word

__valideTags__ = 
    isWhiteList: false
    tags: ['NOSCRIPT', 'SCRIPT', 'STYLE', 'A']

# main
$(document).ready ->
    words = []
    subWordsIn document, (text) -> 
        words.push text 

    density = words.length * __wordDensity__
    words = getRandomWords words, density

    rusWords = []
    for word in words
        if typeof word isnt 'undefined'
            rusWords.push word.textContent

    getTranslate rusWords.join("\n"), (resp) ->
        engWords = resp.text[0].split("\n")

        for word, n in words
            words[n].textContent = engWords[n]
# library

###*
 * Finds text elements in DOM
 * @param  {Object}   DOM   
 * @param  {Function} handler callback, take string
 * @return {Boolean}
###
subWordsIn = (DOM, handler) ->
    validateTag = (tag) -> 
        isIncludes = __valideTags__.tags.indexOf(tag) isnt -1
        if __valideTags__.isWhiteList then isIncludes else not isIncludes
    
    elems = DOM.getElementsByTagName('*');
    for elem in elems when validateTag elem.tagName 
        do (elem) -> for child in elem.childNodes
            do (child) -> if child.nodeType is 3
                handler child
                # console.log elem

getRandomWords = (words, density) ->
    words[n] for n in getRandomIntegers 0, words.length, density

###*
 * @param  {Integer} min 
 * @param  {Integer} max 
 * @return {Integer}
###
getRandomInteger = (min, max) ->
    Math.round min - 0.5 + Math.random() * (max - min + 1)

###*
 * generates array of random integers (with duplicate)
 * @param  {Integer} min     start range
 * @param  {Integer} max     finish range
 * @param  {Integer} length  length of array
 * @return {Array}           Array with random integers
###
getRandomIntegers = (min, max, length) -> 
    list = []
    while length >= 0
        list.push getRandomInteger min, max
        length--
    return list

###*
 * ajax query for yandex.translate
 * @param  {String}   str      translated
 * @param  {Function} callback 
 * @return {Undefined}
###
getTranslate = (str, callback) -> 
    $.get __yaApi__, {
        lang: __translate__,
        text: str,
        key: __apiKey__,
    }, callback

###*
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
    isWords = checkRegExp $elem.text(), __wordsRegExp__ 

    if $child.length is 0 and isWords then true else false

###*
 * @param  {String} str     
 * @param  {String} pattern 
 * @return {Boolean}
###
checkRegExp = (str, pattern) ->
    reg = new RegExp(pattern)
    if reg.test(str) then true else false