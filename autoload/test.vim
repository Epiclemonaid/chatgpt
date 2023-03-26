" chatgpt.vim
function! SendChatGPTMessage(prompt)
    let apiKey = '< your api key >'

    "let apiUrl = 'https://api.openai.com/v1/engines/gpt-3.5-turbo-0301/completions'
    let apiUrl = 'https://api.openai.com/v1/completions'

    let headers = {
        \ 'Content-Type': 'application/json',
        \ 'Authorization': 'Bearer ' . apiKey
        \ }

    let data = {
        \ 'model': 'text-davinci-003',
        \ 'prompt': a:prompt,
        \ 'max_tokens': 150,
        \ 'temperature': 1.0
        \ }

    try
        let response = system('curl -sS --insecure -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ' . apiKey . '" -d "' . escape(json_encode(data), '"') . '" ' . apiUrl)
        let g:chatgpt_debug = response " Store raw response for debugging
        let jsonResponse = json_decode(response)

        if has_key(jsonResponse, 'choices') && len(jsonResponse.choices) > 0
            return jsonResponse.choices[0].text
        elseif has_key(jsonResponse, 'error')
            return 'Error: ' . jsonResponse.error.message
        else
            return 'Error: No response from ChatGPT.'
        endif
    catch
        return 'Error: An error occurred while connecting to the ChatGPT API.'
    endtry
endfunction

"function! ChatGPTPrompt()
"    let prompt = input('Enter your question for ChatGPT: ')
"
"    let response = SendChatGPTMessage(prompt)
"
"    new
"    setlocal buftype=nofile
"    setlocal bufhidden=wipe
"    setlocal noswapfile
"    setlocal nowrap
"    setlocal nonumber
"
"    call append(0, ['', 'ChatGPT Response:', ''])
"    call append(line('$'), response)
"    execute 'normal! G'
"    setlocal nomodifiable
"
"    nnoremap <buffer> q :bd<CR>
"endfunction

function! ChatGPTPrompt()
    let prompt = input('Enter your question for ChatGPT: ')

    let response = SendChatGPTMessage(prompt)

    let response = substitute(response, '^\s*\(.\{-}\)\s*\n*\s*$', '\1', '') " Trim leading and trailing whitespaces
    let formatted_response = split(response, '\n')

    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nowrap
    setlocal nonumber

    call append(0, ['', 'ChatGPT Response:', ''])
    call append(line('$'), formatted_response)
    execute 'normal! G'
    setlocal nomodifiable

     set filetype=go " Set filetype for syntax highlighting

    nnoremap <buffer> q :bd<CR>
endfunction

command! ChatGPTPrompt call ChatGPTPrompt()



