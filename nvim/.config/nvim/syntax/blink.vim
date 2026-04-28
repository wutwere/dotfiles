if exists("b:current_syntax")
    finish
endif

syntax sync fromstart

syntax region blinkBlockComment
    \ start=/--\[\z(=*\)\[/
    \ end=/\]\z1\]/
    \ keepend
    \ extend
    \ containedin=ALL
syntax match blinkComment /--.*$/

syntax keyword blinkScopeKeyword scope
syntax match blinkScopeName /\<scope\>\s\+\zs[a-zA-Z_]\+\ze\s*{/
syntax region blinkScopeBlock
    \ start=/\<scope\>\s\+[a-zA-Z_]\+\s*{/
    \ end=/}/
    \ contains=blinkScopeKeyword,blinkScopeName
    \ keepend

syntax keyword blinkKeyword event option type function import export as

syntax keyword blinkTypeKeyword enum map struct set
syntax keyword blinkType 
    \ u8 
    \ u16 
	\ u32 
	\ i8 
	\ i16 
	\ i32 
	\ f16 
	\ f32 
	\ f64 
	\ boolean 
	\ string 
	\ buffer 
	\ unknown 
	\ Instance 
	\ Color3 
	\ vector 
	\ CFrame 
	\ BrickColor 
	\ DateTime 
	\ DateTimeMillis
syntax keyword blinkBoolean true false

syntax match blinkParen /[(){}[\]<>]/
syntax region blinkBraceBlock
    \ start=/{/
    \ end=/}/
    \ contains=
    \   blinkComment,
    \   blinkBlockComment,
    \   blinkBraceBlock,
    \   blinkType,
    \   blinkTypeKeyword,
    \   blinkParen,
    \   blinkBoolean,
    \   blinkOperator,
    \   blinkOperatorOptional,
    \   blinkSeparatorComma,
    \   blinkNumber,
    \   blinkString
    \ keepend

syntax match blinkOperator /[=:]|\\.\\.+/
syntax match blinkOperatorOptional /?/
syntax match blinkSeparatorComma /,/

syntax match blinkNumber /\<[0-9]\+\>/
syntax match blinkString /"[^"]*"/

highlight link blinkComment Comment
highlight link blinkBlockComment Comment
highlight link blinkKeyword Keyword
highlight link blinkScopeKeyword Keyword
highlight link blinkScopeName Type
highlight link blinkScopeBlock Delimiter
highlight link blinkParen Delimiter
highlight link blinkTypeKeyword Keyword
highlight link blinkType Type
highlight link blinkBoolean Operator
highlight link blinkOperator Operator
highlight link blinkOperatorOptional Operator
highlight link blinkSeparatorComma Operator
highlight link blinkNumber Number
highlight link blinkString String

let b:current_syntax = "blink"
