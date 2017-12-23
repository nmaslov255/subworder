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