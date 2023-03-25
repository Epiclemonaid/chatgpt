" chatgpt.vim
if !has('vim9script')
    echoerr 'ChatGPT plugin requires Vim 9.0 or later.'
    finish
endif

vim9script

const apiKey = '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'

def SendChatGPTMessage(prompt: string): string
    const apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions'
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' .. apiKey
    }

    const data = {
        'prompt': prompt,
        'max_tokens': 150,
        'n': 1,
        'stop': null,
        'temperature': 0.8
    }

    try
        const response = ch_evalraw(['curl', '-X', 'POST', apiUrl, '-H', 'Content-Type: application/json', '-H', 'Authorization: Bearer ' .. apiKey, '-d', json_encode(data)])
        const jsonResponse = json_decode(response)

        if has_key(jsonResponse, 'choices') && len(jsonResponse.choices) > 0
            return jsonResponse.choices[0].text
        else
            return '
        const response = ch_evalraw(['curl', '-X', 'POST', apiUrl, '-H', 'Content-Type: application/json', '-H', 'Authorization: Bearer ' .. apiKey, '-d', json_encode(data)])
        const jsonResponse = json_decode(response)

        if has_key(jsonResponse, 'choices') && len(jsonResponse.choices) > 0
            return jsonResponse.choices[0].text
        else
            return 'Error: No response from ChatGPT.'
        endif
    catch
        return 'Error: An error occurred while connecting to the ChatGPT API.'
    endtry
enddef

export def ChatGPTPrompt(): void
    let prompt = input('Enter your question for ChatGPT: ')

    let response = SendChatGPTMessage(prompt)

    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nowrap
    setlocal nonumber

    call append(0, ['', 'ChatGPT Response:', ''])
    call append(line('$'), response)
    execute 'normal! G'
    setlocal nomodifiable

    nnoremap <buffer> q :bd<CR>
enddef

