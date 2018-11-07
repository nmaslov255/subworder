# config constants
__translate__ = 'ru-en'

__yaApi__ = 'https://translate.yandex.net/api/v1.5/tr.json/translate'
__apiKey__ = ''

__sentenceRegr__ = /([А-ЯЁ].*?[\.\!\?\:])/g
__wordsReg__ = /([а-яёА-ЯЁ]{4,})/g 
__wordDensity__ = 0.1 # means that we take every ?th word

__valideTags__ = 
    isWhiteList: false
    tags: ['NOSCRIPT', 'SCRIPT', 'STYLE', 'A']

# main
$(document).ready ->
    elems = []
    subTextIn document, (elem) -> 
        if elem.textContent.match(__sentenceRegr__)?
            elems.push elem 

    sentences = (sentence.textContent for sentence in elems)

    words = [] # may be duplicate words
    for sentence, n in sentences
        console.log sentence
        for word in getRandomWords sentence.match(__wordsReg__), __wordDensity__
            words.push word

    getTranslate words.join('\n'), (resp) ->
        engWords = resp.text[0].split('\n')

        for sentence, n in sentences
            for word, i in engWords
                if sentence.match(words[i])?
                    pattern = /(?<=[^а-яёА-ЯЁ]|^)/.source + words[i] + /(?=[^а-яёА-ЯЁ]|$)/.source
                    sentences[n] = sentence.replace(new RegExp(pattern, 'g'), word)
        
        for sentence, n in sentences
            console.log elems[n]
            elems[n].textContent = sentence
            console.log elems
            # wrapNode(elems[n], 'b')


wrapNode = (textNode, tagName) ->
    wrapper = document.createElement(tagName)
    textNode.parentNode.insertBefore(wrapper, textNode)
    wrapper.appendChild(textNode)
    return wrapper


###*
 * Finds text elements in DOM
 * @param  {Object}   DOM   
 * @param  {Function} handler callback, take string
 * @return {Boolean}
###
subTextIn = (DOM, handler) ->
    validateTag = (tag) -> 
        isIncludes = tag in __valideTags__.tags
        if __valideTags__.isWhiteList then isIncludes else not isIncludes
    
    elems = DOM.getElementsByTagName('*');
    for elem in elems when validateTag elem.tagName 
        do (elem) -> for child in elem.childNodes
            do (child) -> if child.nodeType is 3
                handler child

###*
 * @param  {Array}   words   
 * @param  {Integer} density 
 * @return {Array}
###
getRandomWords = (words, density) ->
    console.log words
    words[n] for n in getRandomIntegers 0, words.length - 1, density

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
    getRandomInteger min, max for [0..length]

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
